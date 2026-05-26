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
public class ListObjectsV2Iterable <: Iterable<ListObjectsV2Response> {
    private let s3ClientConfigMap: S3ConfigMap
    private let firstRequest: ListObjectsV2Request

    public init(s3ClientConfigMap: S3ConfigMap, firstRequest: ListObjectsV2Request) {
        this.s3ClientConfigMap = s3ClientConfigMap
        this.firstRequest = firstRequest
    }

    public func iterator(): ListObjectsV2Iterator {
        return ListObjectsV2Iterator(s3ClientConfigMap, firstRequest)
    }
}

public class ListObjectsV2Iterator <: Iterator<ListObjectsV2Response> {
    private let s3ClientConfigMap: S3ConfigMap
    private let firstReq: ListObjectsV2Request
    private var prevRsp: ?ListObjectsV2Response = None
    private var hasNext: Bool = true

    public init(s3ClientConfigMap: S3ConfigMap, firstReq: ListObjectsV2Request) {
        this.s3ClientConfigMap = s3ClientConfigMap
        this.firstReq = firstReq
    }

    // public func iterator(): Iterator<ListObjectsV2Response> {
    //     return this
    // }

    public func next(): ?ListObjectsV2Response {
        if (!hasNext) {
            return None
        }
        let nextReq: ListObjectsV2Request = match (prevRsp) {
            case Some(v) => firstReq.nextRequest(v)
            case None => firstReq
        }
        let nextRsp = ListObjectsV2(s3ClientConfigMap, nextReq).execute1()
        hasNext = nextRsp.isTruncated
        prevRsp = nextRsp
        return nextRsp
    }

    public func subscribe(subscriber: (?ListObjectsV2Response, ?Exception) -> Bool): Unit {
        if (!hasNext) {
            return
        }
        let nextReq: ListObjectsV2Request = match (prevRsp) {
            case Some(v) => firstReq.nextRequest(v)
            case None => firstReq
        }
        ListObjectsV2(s3ClientConfigMap, nextReq).executeAsync1().thenAsync<Unit>() {
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
