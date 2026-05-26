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
public interface S3Identity <: ToString {
    prop expirationTime: ?DateTime {
        get() {
            return None
        }
    }
}

public interface S3Credentials <: S3Identity {
    prop accessKeyId: String
    prop secretAccessKey: String

    prop isAnonymous: Bool {
        get() {
            return false
        }
    }
}
