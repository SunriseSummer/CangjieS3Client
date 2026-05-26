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
 * @date: 2023-12-04
 */
public class InventoryConfiguration <: ToString {
    public InventoryConfiguration(
        public let destination!: InventoryDestination,
        public let isEnabled!: Bool,
        public let filter!: ?InventoryFilter = None,
        public let id!: String,
        public let includedObjectVersions!: String,
        public let optionalFields!: ?ArrayList<String> = None,
        public let schedule!: InventorySchedule
    ) {
    }

    public func toString(): String {
        return "InventoryConfiguration(" +
            "destination=${destination}, isEnabled=${isEnabled}, filter=${filter}, id=${id}, " +
            "includedObjectVersions=${includedObjectVersions}, optionalFields=${optionalFields}, " +
            "schedule=${schedule})"
    }
}

public class InventoryDestination <: ToString {
    public InventoryDestination(public let s3BucketDestination!: InventoryS3BucketDestination) {
    }

    public func toString(): String {
        return "InventoryDestination(s3BucketDestination=${s3BucketDestination})"
    }
}

public class InventoryS3BucketDestination <: ToString {
    public InventoryS3BucketDestination(
        public let accountId!: ?String = None,
        public let bucket!: String,
        public let format!: String,
        public let prefix!: ?String = None,
        public let encryption!: ?InventoryEncryption = None
    ) {
    }

    public func toString(): String {
        return "InventoryS3BucketDestination(" +
            "accountId=${accountId}, bucket=${bucket}, format=${format}, prefix=${prefix}, encryption=${encryption}" +
            ")"
    }
}

public class InventoryEncryption <: ToString {
    public InventoryEncryption(
        public let sses3!: ?SSES3 = None,
        public let ssekms!: ?SSEKMS = None
    ) {
    }

    public func toString(): String {
        return "InventoryEncryption(sses3=${sses3}, ssekms=${ssekms})"
    }
}

public class SSES3 <: ToString {
    public SSES3() {
    }

    public func toString(): String {
        return "SSES3()"
    }
}

public class SSEKMS <: ToString {
    public SSEKMS(public let keyId!: String) {
    }

    public func toString(): String {
        return "SSEKMS(keyId=${keyId})"
    }
}

public class InventoryFilter <: ToString {
    public InventoryFilter(public let prefix!: String) {
    }

    public func toString(): String {
        return "InventoryFilter(prefix=${prefix})"
    }
}

public class InventorySchedule <: ToString {
    public InventorySchedule(public let frequency!: String) {
    }

    public func toString(): String {
        return "InventorySchedule(frequency=${frequency})"
    }
}

// -----
//
// -----

extend InventoryConfiguration <: S3XmlObject<InventoryConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "InventoryConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let id = this.id.toXml("Id")
        let isEnabled = this.isEnabled.toString().toXml("IsEnabled")
        let includedObjectVersions = this.includedObjectVersions.toXml("IncludedObjectVersions")
        let destination = "<Destination>${this.destination.s3BucketDestination.toXml()}</Destination>"
        let schedule = "<Schedule><Frequency>${this.schedule.frequency}</Frequency></Schedule>"
        let filter = match (this.filter) {
            case Some(v) => "<Filter><Prefix>${v.prefix}</Prefix></Filter>"
            case None => ""
        }
        let optionalFields = this.optionalFields?.toXml("Field").toXml("OptionalFields") ?? ""

        return "<${eleName} ${namespace(isRoot)}>${id}${isEnabled}${includedObjectVersions}" +
            "${destination}${schedule}${filter}${optionalFields}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): InventoryConfiguration {
        return InventoryConfiguration(
            id: ele.childContentRequired("Id"),
            isEnabled: ele.childContentRequired("IsEnabled").toBool(),
            includedObjectVersions: ele.childContentRequired("IncludedObjectVersions"),
            destination: ele.childRequired(
                "Destination",
                {
                    child => InventoryDestination(
                        s3BucketDestination: child.childRequired(
                            "S3BucketDestination",
                            InventoryS3BucketDestination.fromXml
                        )
                    )
                }
            ),
            schedule: ele.childRequired(
                "Schedule",
                {
                    child => InventorySchedule(frequency: child.childContentRequired("Frequency"))
                }
            ),
            filter: ele.child("Filter", {
                child => InventoryFilter(prefix: child.childContentRequired("Prefix"))
            }),
            optionalFields: ele.child("OptionalFields")?.childsContents("Field")
        )
    }
}

extend InventoryS3BucketDestination <: S3XmlObject<InventoryS3BucketDestination> {
    public static prop ELE_NAME: String {
        get() {
            "S3BucketDestination"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let accountId = this.accountId?.toXml("AccountId") ?? ""
        let bucket = this.bucket.toXml("Bucket")
        let format = this.format.toXml("Format")
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let encryption = this.encryption?.toXml(InventoryEncryption.ELE_NAME) ?? ""
        return "<${eleName}>${accountId}${bucket}${format}${prefix}${encryption}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): InventoryS3BucketDestination {
        return InventoryS3BucketDestination(
            accountId: ele.childContent("AccountId"),
            bucket: ele.childContent("Bucket").getOrThrow(),
            format: ele.childContent("Format").getOrThrow(),
            prefix: ele.childContent("Prefix"),
            encryption: ele.child(InventoryEncryption.ELE_NAME, InventoryEncryption.fromXml)
        )
    }
}

extend InventoryEncryption <: S3XmlObject<InventoryEncryption> {
    public static prop ELE_NAME: String {
        get() {
            "Encryption"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let sses3 = match (this.sses3) {
            case Some(_) => "<SSE-S3></SSE-S3>"
            case None => ""
        }
        let ssekms = match (this.ssekms) {
            case Some(v) => "<SSE-KMS><KeyId>${v.keyId}</KeyId></SSE-KMS>"
            case None => ""
        }
        return "<${eleName}>${sses3}${ssekms}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): InventoryEncryption {
        return InventoryEncryption(
            sses3: ele.child("SSE-S3", {_ => SSES3()}),
            ssekms: ele.child("SSE-KMS", {child => SSEKMS(keyId: child.childContent("KeyId").getOrThrow())})
        )
    }
}
