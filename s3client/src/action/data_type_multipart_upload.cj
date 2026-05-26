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
 * @date: 2023-12-18
 */
public class MultipartUpload <: ToString {
    public MultipartUpload(
        public let uploadId!: String,
        public let key!: String,
        public let initiated!: ?DateTime = None,
        public let storageClass!: ?String = None,
        public let owner!: ?Owner = None,
        public let initiator!: ?Initiator = None
    ) {
    }

    public func toString(): String {
        return "MultipartUpload(" + //
            "uploadId=${uploadId}, key=${key}, initiated=${initiated}, storageClass=${storageClass}, " +
            "owner=${owner}, initiator=${initiator}" + //
                ")"
    }
}

public class Initiator <: ToString {
    public Initiator(
        public let id!: ?String = None,
        public let displayName!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Initiator(id=${id}, displayName=${displayName})"
    }
}

// -----
//
// -----

extend MultipartUpload <: S3XmlObject<MultipartUpload> {
    public static prop ELE_NAME: String {
        get() {
            "Upload"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): MultipartUpload {
        return MultipartUpload(
            uploadId: ele.childContentRequired("UploadId"),
            key: ele.childContentRequired("Key"),
            initiated: ele.childContent("Initiated")?.toDateIso8601(),
            storageClass: ele.childContent("StorageClass"),
            owner: ele.child(Owner.ELE_NAME, Owner.fromXml),
            initiator: ele.child(Initiator.ELE_NAME, Initiator.fromXml)
        )
    }
}

extend Initiator <: S3XmlObject<Initiator> {
    public static prop ELE_NAME: String {
        get() {
            "Initiator"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): Initiator {
        return Initiator(
            id: ele.childContent("ID"),
            displayName: ele.childContent("DisplayName")
        )
    }
}
