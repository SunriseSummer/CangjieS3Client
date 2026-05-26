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

package s3client.core

/*
 *
 * @author: wangwb
 * @date: 2023-11-28
 */
public interface S3Response <: ToString {
    prop responseMetadata: S3ResponseMetadata
}

public abstract class AbstractS3Response <: S3Response {
    private let _responseMetadata: S3ResponseMetadata

    public prop responseMetadata: S3ResponseMetadata {
        get() {
            return _responseMetadata
        }
    }

    protected init(responseMetadata: S3ResponseMetadata) {
        this._responseMetadata = responseMetadata
    }
}

public class S3ResponseMetadata <: ToString {
    public static let UNKNOWN = "UNKNOWN"

    // private static let CLOUD_FRONT_ID = "X-Amz-Cf-Id"
    public static let CLOUD_FRONT_ID = "x-amz-cf-id"
    public static let EXTENDED_REQUEST_ID = "x-amz-id-2"
    public static let REQUEST_ID = "x-amz-request-id"

    private let metadata: Map<String, String>

    public init(headers: HttpHeaders) {
        let metadata = HashMap<String, String>()
        for ((k, values) in headers) {
            // TODO aws原来的逻辑没有转小写, 但是感觉不好用, 因为这个map不是忽略大小写的,
            // 外面调用的人需要知道key的正确大小写
            let name = StringUtils.toLowerCase(k)
            let value = values.iterator().next().getOrDefault({=> ""}) // TODO 只取第一个, java版本也是这样, 不确定有没有问题
            metadata.add(name, value)
        }
        this.metadata = metadata
    }

    public init(metadata: Map<String, String>) {
        this.metadata = metadata
    }

    public func getValue(key: String): String {
        return metadata.get(key).getOrDefault({=> UNKNOWN})
    }

    public prop cloudFrontId: String {
        get() {
            return getValue(CLOUD_FRONT_ID)
        }
    }

    public prop extendedRequestId: String {
        get() {
            return getValue(EXTENDED_REQUEST_ID)
        }
    }

    public prop requestId: String {
        get() {
            return getValue(REQUEST_ID)
        }
    }

    public func toString(): String {
        let str = ToStringUtils.mapToString(metadata)
        return "S3ResponseMetadata(${str})"
    }
}
