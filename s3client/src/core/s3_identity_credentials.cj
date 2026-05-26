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
 * @date: 2023-11-08
 */
public class BasicS3Credentials <: S3Credentials {
    private let _accessKeyId: String
    private let _secretAccessKey: String

    public init(accessKeyId: String, secretAccessKey: String) {
        this._accessKeyId = accessKeyId
        this._secretAccessKey = secretAccessKey
    }

    public prop accessKeyId: String {
        get() {
            return this._accessKeyId
        }
    }

    public prop secretAccessKey: String {
        get() {
            return this._secretAccessKey
        }
    }

    public func toString(): String {
        return "BasicS3Credentials(accessKeyId=${_accessKeyId}, secretAccessKey=******)"
    }
}

public class AnonymousS3Credentials <: S3Credentials {
    public prop accessKeyId: String {
        get() {
            return ""
        }
    }

    public prop secretAccessKey: String {
        get() {
            return ""
        }
    }

    public prop isAnonymous: Bool {
        get() {
            return true
        }
    }

    public func toString(): String {
        return "AnonymousS3Credentials"
    }
}
