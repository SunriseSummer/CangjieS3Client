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
 * @date: 2023-12-14
 */
public class S3Error <: ToString {
    public S3Error(
        public let key!: ?String = None,
        public let versionId!: ?String = None,
        public let code!: ?String = None,
        public let message!: ?String = None
    ) {
    }

    public func toString(): String {
        return "S3Error(key=${key}, versionId=${versionId}, code=${code}, message=${message})"
    }
}

// -----
//
// -----

extend S3Error <: S3XmlObject<S3Error> {
    public static prop ELE_NAME: String {
        get() {
            "Error"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): S3Error {
        return S3Error(
            key: ele.childContent("Key"),
            versionId: ele.childContent("VersionId"),
            code: ele.childContent("Code"),
            message: ele.childContent("Message")
        )
    }
}
