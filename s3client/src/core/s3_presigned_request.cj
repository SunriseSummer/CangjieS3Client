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
 * 预签名后的请求
 *
 * @author: wangwb
 * @date: 2023-12-25
 */
public class S3PresignedRequest <: ToString {
    public let expiration: DateTime
    public let method: String
    public let url: URL
    public let headers: HttpHeaders
    public let body: ?S3Content

    public init(
        expiration!: DateTime,
        method!: String,
        url!: URL,
        headers!: HttpHeaders,
        body!: ?S3Content
    ) {
        this.expiration = expiration
        this.method = method
        this.url = url
        this.headers = headers
        this.body = body
    }

    public func toString(): String {
        return "PresignedRequest(" + //
            "expiration=${expiration}, method=${method}, url=${url}, headers=${S3HttpUtils.headersToString(headers)}, " +
            "body=${body}" + //
                ")"
    }
}
