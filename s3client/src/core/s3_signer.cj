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
 * @date: 2023-11-09
 */
public interface S3Signer <: ToString {
    // name 这个属性在 s3_action.cj 里有使用到
    prop name: String
    func sign(request: S3HttpRequestBuilder, signerProps: S3SignerProperties): S3HttpRequest

    static func v2(): S3Signer {
        return V2S3Signer()
    }

    static func v4(): S3Signer {
        return V4S3Signer()
    }
}
