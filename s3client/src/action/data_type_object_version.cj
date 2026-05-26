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
public class ObjectVersion <: ToString {
    public ObjectVersion(
        public let etag!: ?String = None,
        public let checksumAlgorithm!: ?ArrayList<String> = None,
        public let size!: ?Int64 = None,
        public let storageClass!: ?String = None,
        public let key!: ?String = None,
        public let versionId!: ?String = None,
        public let isLatest!: ?Bool = None,
        public let lastModified!: ?DateTime = None,
        public let owner!: ?Owner = None,
        public let restoreStatus!: ?RestoreStatus = None
    ) {
    }

    public func toString(): String {
        return "ObjectVersion(" +
            "etag=${etag}, checksumAlgorithm=${checksumAlgorithm}, size=${size}, storageClass=${storageClass}, " +
            "key=${key}, versionId=${versionId}, isLatest=${isLatest}, lastModified=${lastModified}, " +
            "owner=${owner}, restoreStatus=${restoreStatus}" + ")"
    }
}

// -----
//
// -----

extend ObjectVersion <: S3XmlObject<ObjectVersion> {
    public static prop ELE_NAME: String {
        get() {
            "Version"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): ObjectVersion {
        return ObjectVersion(
            etag: ele.childContent("ETag"),
            checksumAlgorithm: ele.childsContents("ChecksumAlgorithm"),
            size: ele.childContent("Size")?.toInt64(),
            storageClass: ele.childContent("StorageClass"),
            key: ele.childContent("Key"),
            versionId: ele.childContent("VersionId"),
            isLatest: ele.childContent("IsLatest")?.toBool(),
            lastModified: ele.childContent("LastModified")?.toDateIso8601(),
            owner: ele.child(Owner.ELE_NAME, Owner.fromXml),
            restoreStatus: ele.child(RestoreStatus.ELE_NAME, RestoreStatus.fromXml)
        )
    }
}
