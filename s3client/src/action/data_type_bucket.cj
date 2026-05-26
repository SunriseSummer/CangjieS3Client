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
 * @date: 2023-11-21
 */
public class Bucket <: ToString {
    public Bucket(
        public let name!: String,
        public let creationDate!: DateTime
    ) {
    }

    public func toString(): String {
        return "Bucket(name=${name}, creationDate=${creationDate})"
    }
}

// -----
//
// -----

extend Bucket <: S3XmlObject<Bucket> {
    public static prop ELE_NAME: String {
        get() {
            "Bucket"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): Bucket {
        return Bucket(
            name: ele.childContentRequired("Name"),
            creationDate: ele.childContentRequired("CreationDate").toDateIso8601()
        )
    }
}
