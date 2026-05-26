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
 * @date: 2023-11-29
 */
public class S3Object <: ToString {
    public S3Object(
        public let key!: ?String = None,
        public let lastModified!: ?DateTime = None,
        public let etag!: ?String = None,
        public let checksumAlgorithm!: ?ArrayList<String> = None,
        public let size!: ?Int64 = None,
        public let storageClass!: ?String = None,
        public let owner!: ?Owner,
        public let restoreStatus!: ?RestoreStatus = None
    ) {
    }

    public func toString(): String {
        return "S3Object(" +
            "key=${key}, lastModified=${lastModified}, etag=${etag}, checksumAlgorithm=${checksumAlgorithm}, " +
            "size=${size}, storageClass=${storageClass}, owner=${owner}, restoreStatus=${restoreStatus}" + ")"
    }
}

// -----
//
// -----

extend S3Object <: S3XmlObject<S3Object> {
    public static prop ELE_NAME: String {
        get() {
            "Contents"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): S3Object {
        return S3Object(
            key: ele.childContent("Key"),
            lastModified: ele.childContent("LastModified")?.toDateIso8601(),
            etag: ele.childContent("ETag"),
            checksumAlgorithm: ele.childsContents("ChecksumAlgorithm"),
            size: ele.childContent("Size")?.toInt64(),
            storageClass: ele.childContent("StorageClass"),
            owner: ele.child(Owner.ELE_NAME, Owner.fromXml),
            restoreStatus: ele.child(RestoreStatus.ELE_NAME, RestoreStatus.fromXml)
        )
    }
}
