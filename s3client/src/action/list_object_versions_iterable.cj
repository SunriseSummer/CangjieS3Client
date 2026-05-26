/*
 * Copyright 2024 Primeton Information Technologies, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package s3client.action

/*
 *
 * @author: wangwb
 * @date: 2023-12-19
 */
public class ListObjectVersionsIterable <: Iterable<ListObjectVersionsResponse> {
    private let s3ClientConfigMap: S3ConfigMap
    private let firstRequest: ListObjectVersionsRequest

    public init(s3ClientConfigMap: S3ConfigMap, firstRequest: ListObjectVersionsRequest) {
        this.s3ClientConfigMap = s3ClientConfigMap
        this.firstRequest = firstRequest
    }

    public func iterator(): ListObjectVersionsIterator {
        return ListObjectVersionsIterator(s3ClientConfigMap, firstRequest)
    }
}

public class ListObjectVersionsIterator <: Iterator<ListObjectVersionsResponse> {
    private let s3ClientConfigMap: S3ConfigMap
    private let firstReq: ListObjectVersionsRequest
    private var prevRsp: ?ListObjectVersionsResponse = None
    private var hasNext: Bool = true

    public init(s3ClientConfigMap: S3ConfigMap, firstReq: ListObjectVersionsRequest) {
        this.s3ClientConfigMap = s3ClientConfigMap
        this.firstReq = firstReq
    }

    // public func iterator(): Iterator<ListObjectVersionsResponse> {
    //     return this
    // }

    public func next(): ?ListObjectVersionsResponse {
        if (!hasNext) {
            return None
        }
        let nextReq: ListObjectVersionsRequest = match (prevRsp) {
            case Some(v) => firstReq.nextRequest(v)
            case None => firstReq
        }
        let nextRsp = ListObjectVersions(s3ClientConfigMap, nextReq).execute1()
        hasNext = nextRsp.isTruncated
        prevRsp = nextRsp
        return nextRsp
    }

    public func subscribe(subscriber: (?ListObjectVersionsResponse, ?Exception) -> Bool): Unit {
        if (!hasNext) {
            return
        }
        let nextReq: ListObjectVersionsRequest = match (prevRsp) {
            case Some(v) => firstReq.nextRequest(v)
            case None => firstReq
        }
        ListObjectVersions(s3ClientConfigMap, nextReq).executeAsync1().thenAsync<Unit>() {
            nextRsp, ex =>
            match (nextRsp) {
                case Some(v) =>
                    hasNext = v.isTruncated
                    prevRsp = v
                case None => ()
            }
            if (subscriber(nextRsp, ex)) {
                // 可以通过返回值控制是否继续下一页查询
                // 最常用的是 subscriber 里发现有 Exception 就返回 false
                subscribe(subscriber)
            }
        }
    }
}
