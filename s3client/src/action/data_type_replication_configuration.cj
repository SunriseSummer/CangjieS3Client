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
 * @date: 2023-12-05
 */
public class ReplicationConfiguration <: ToString {
    public ReplicationConfiguration(
        public let role!: String,
        public let rules!: ArrayList<ReplicationRule>
    ) {
    }

    public func toString(): String {
        return "ReplicationConfiguration(role=${role}, rules=${rules})"
    }
}

public class ReplicationRule <: ToString {
    public ReplicationRule(
        public let id!: ?String = None,
        public let priority!: ?Int32 = None,
        public let prefix!: ?String = None,
        public let filter!: ?ReplicationRuleFilter = None,
        public let status!: String,
        public let sourceSelectionCriteria!: ?SourceSelectionCriteria = None,
        public let existingObjectReplication!: ?ExistingObjectReplication = None,
        public let destination!: Destination,
        public let deleteMarkerReplication!: ?DeleteMarkerReplication = None
    ) {
    }

    public func toString(): String {
        return "ReplicationRule(" +
            "id=${id}, priority=${priority}, prefix=${prefix}, filter=${filter}, status=${status}, " +
            "sourceSelectionCriteria=${sourceSelectionCriteria}, existingObjectReplication=${existingObjectReplication}, " +
            "destination=${destination}, deleteMarkerReplication=${deleteMarkerReplication}" + ")"
    }
}

public class ReplicationRuleFilter <: ToString {
    public ReplicationRuleFilter(
        public let prefix!: ?String = None,
        public let tag!: ?Tag = None,
        public let and!: ?ReplicationRuleAndOperator = None
    ) {
    }

    public func toString(): String {
        return "ReplicationRuleFilter(prefix=${prefix}, tag=${tag}, and=${and})"
    }
}

public class ReplicationRuleAndOperator <: ToString {
    public ReplicationRuleAndOperator(
        public let prefix!: ?String = None,
        public let tags!: ?ArrayList<Tag> = None
    ) {
    }

    public func toString(): String {
        return "ReplicationRuleAndOperator(prefix=${prefix}, tags=${tags})"
    }
}

public class SourceSelectionCriteria <: ToString {
    public SourceSelectionCriteria(
        public let sseKmsEncryptedObjects!: ?SseKmsEncryptedObjects = None,
        public let replicaModifications!: ?ReplicaModifications = None
    ) {
    }

    public func toString(): String {
        return "SourceSelectionCriteria(sseKmsEncryptedObjects=${sseKmsEncryptedObjects}, replicaModifications=${replicaModifications})"
    }
}

public class SseKmsEncryptedObjects <: ToString {
    public SseKmsEncryptedObjects(public let status!: String) {
    }

    public func toString(): String {
        return "SseKmsEncryptedObjects(status=${status})"
    }
}

public class ReplicaModifications <: ToString {
    public ReplicaModifications(public let status!: String) {
    }

    public func toString(): String {
        return "ReplicaModifications(status=${status})"
    }
}

public class ExistingObjectReplication <: ToString {
    public ExistingObjectReplication(public let status!: String) {
    }

    public func toString(): String {
        return "ExistingObjectReplication(status=${status})"
    }
}

public class Destination <: ToString {
    public Destination(
        public let bucket!: String,
        public let account!: ?String = None,
        public let storageClass!: ?String = None,
        public let accessControlTranslation!: ?AccessControlTranslation = None,
        public let encryptionConfiguration!: ?EncryptionConfiguration = None,
        public let replicationTime!: ?ReplicationTime = None,
        public let metrics!: ?Metrics = None
    ) {
    }

    public func toString(): String {
        return "Destination(" +
            "bucket=${bucket}, account=${account}, storageClass=${storageClass}, accessControlTranslation=${accessControlTranslation}, " +
            "encryptionConfiguration=${encryptionConfiguration}, replicationTime=${replicationTime}, metrics=${metrics}" +
            ")"
    }
}

public class AccessControlTranslation <: ToString {
    public AccessControlTranslation(public let owner!: String) {
    }

    public func toString(): String {
        return "AccessControlTranslation(owner=${owner})"
    }
}

public class EncryptionConfiguration <: ToString {
    public EncryptionConfiguration(public let replicaKmsKeyID!: String) {
    }

    public func toString(): String {
        return "EncryptionConfiguration(replicaKmsKeyID=${replicaKmsKeyID})"
    }
}

public class ReplicationTime <: ToString {
    public ReplicationTime(
        public let status!: String,
        public let time!: ReplicationTimeValue
    ) {
    }

    public func toString(): String {
        return "ReplicationTime(status=${status}, time=${time})"
    }
}

public class ReplicationTimeValue <: ToString {
    public ReplicationTimeValue(public let minutes!: Int32) {
    }

    public func toString(): String {
        return "ReplicationTimeValue(minutes=${minutes})"
    }
}

public class Metrics <: ToString {
    public Metrics(
        public let status!: String,
        public let eventThreshold!: ?ReplicationTimeValue = None
    ) {
    }

    public func toString(): String {
        return "Metrics(status=${status}, eventThreshold=${eventThreshold})"
    }
}

public class DeleteMarkerReplication <: ToString {
    public DeleteMarkerReplication(public let status!: String) {
    }

    public func toString(): String {
        return "DeleteMarkerReplication(status=${status})"
    }
}

// -----
//
// -----

extend ReplicationConfiguration <: S3XmlObject<ReplicationConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "ReplicationConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let role = this.role.toXml("Role")
        let rules = this.rules |> map<ReplicationRule, String> {rule => rule.toXml(ReplicationRule.ELE_NAME)} |>
            collectString<String>()
        return "<${eleName} ${namespace(isRoot)}>${role}${rules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationConfiguration {
        return ReplicationConfiguration(
            role: ele.childContentRequired("Role"),
            rules: ele.childs(ReplicationRule.ELE_NAME, ReplicationRule.fromXml)
        )
    }
}

extend ReplicationRule <: S3XmlObject<ReplicationRule> {
    public static prop ELE_NAME: String {
        get() {
            "Rule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("ID") ?? ""
        let priority = this.priority?.toString().toXml("Priority") ?? ""
        let prefixt = this.prefix?.toXml("Prefix") ?? ""
        let filter = this.filter?.toXml(ReplicationRuleFilter.ELE_NAME) ?? ""
        let status = this.status.toXml("Status")
        let sourceSelectionCriteria = this.sourceSelectionCriteria?.toXml(SourceSelectionCriteria.ELE_NAME) ?? ""
        let destination = this.destination.toXml(Destination.ELE_NAME)
        let existingObjectReplication = this.existingObjectReplication?.toXml(ExistingObjectReplication.ELE_NAME) ?? ""
        let deleteMarkerReplication = this.deleteMarkerReplication?.toXml(DeleteMarkerReplication.ELE_NAME) ?? ""
        return "<${eleName}>${id}${priority}${prefixt}${filter}${status}${sourceSelectionCriteria}" +
            "${destination}${existingObjectReplication}${deleteMarkerReplication}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationRule {
        return ReplicationRule(
            id: ele.childContent("ID"),
            priority: ele.childContent("Priority")?.toInt32(),
            prefix: ele.childContent("Prefix"),
            filter: ele.child(ReplicationRuleFilter.ELE_NAME, ReplicationRuleFilter.fromXml),
            status: ele.childContentRequired("Status"),
            sourceSelectionCriteria: ele.child(SourceSelectionCriteria.ELE_NAME, SourceSelectionCriteria.fromXml),
            existingObjectReplication: ele.child(
                ExistingObjectReplication.ELE_NAME,
                ExistingObjectReplication.fromXml
            ),
            destination: ele.childRequired(Destination.ELE_NAME, Destination.fromXml),
            deleteMarkerReplication: ele.child(DeleteMarkerReplication.ELE_NAME, DeleteMarkerReplication.fromXml)
        )
    }
}

extend ReplicationRuleFilter <: S3XmlObject<ReplicationRuleFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefixt") ?? ""
        let tag = this.tag?.toXml(Tag.ELE_NAME) ?? ""
        let and = this.and?.toXml(ReplicationRuleAndOperator.ELE_NAME) ?? ""
        return "<${eleName}>${prefix}${tag}${and}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationRuleFilter {
        return ReplicationRuleFilter(
            prefix: ele.childContent("Prefix"),
            tag: ele.child(Tag.ELE_NAME, Tag.fromXml),
            and: ele.child(ReplicationRuleAndOperator.ELE_NAME, ReplicationRuleAndOperator.fromXml)
        )
    }
}

extend ReplicationRuleAndOperator <: S3XmlObject<ReplicationRuleAndOperator> {
    public static prop ELE_NAME: String {
        get() {
            "And"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tags = match (this.tags) {
            case Some(v) => v |> map<Tag, String> {tag => tag.toXml()} |> collectString<String>()
            case None => ""
        }
        return "<${eleName}>${prefix}${tags}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationRuleAndOperator {
        return ReplicationRuleAndOperator(
            prefix: ele.childContent("Prefix"),
            tags: ele.childs(Tag.ELE_NAME, Tag.fromXml)
        )
    }
}

extend SourceSelectionCriteria <: S3XmlObject<SourceSelectionCriteria> {
    public static prop ELE_NAME: String {
        get() {
            "SourceSelectionCriteria"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let sseKmsEncryptedObjects = this.sseKmsEncryptedObjects?.toXml(SseKmsEncryptedObjects.ELE_NAME) ?? ""
        let replicaModifications = this.replicaModifications?.toXml(ReplicaModifications.ELE_NAME) ?? ""
        return "<${eleName}>${sseKmsEncryptedObjects}${replicaModifications}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): SourceSelectionCriteria {
        return SourceSelectionCriteria(
            sseKmsEncryptedObjects: ele.child(SseKmsEncryptedObjects.ELE_NAME, SseKmsEncryptedObjects.fromXml),
            replicaModifications: ele.child(ReplicaModifications.ELE_NAME, ReplicaModifications.fromXml)
        )
    }
}

extend SseKmsEncryptedObjects <: S3XmlObject<SseKmsEncryptedObjects> {
    public static prop ELE_NAME: String {
        get() {
            "SseKmsEncryptedObjects"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        return "<${eleName}>${status}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): SseKmsEncryptedObjects {
        return SseKmsEncryptedObjects(status: ele.childContentRequired("Status"))
    }
}

extend ReplicaModifications <: S3XmlObject<ReplicaModifications> {
    public static prop ELE_NAME: String {
        get() {
            "ReplicaModifications"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        return "<${eleName}>${status}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicaModifications {
        return ReplicaModifications(status: ele.childContentRequired("Status"))
    }
}

extend ExistingObjectReplication <: S3XmlObject<ExistingObjectReplication> {
    public static prop ELE_NAME: String {
        get() {
            "ExistingObjectReplication"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        return "<${eleName}>${status}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ExistingObjectReplication {
        return ExistingObjectReplication(status: ele.childContentRequired("Status"))
    }
}

extend Destination <: S3XmlObject<Destination> {
    public static prop ELE_NAME: String {
        get() {
            "Destination"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let bucket = this.bucket.toXml("Bucket")
        let account = this.account?.toXml("Account") ?? ""
        let storageClass = this.storageClass?.toXml("StorageClass") ?? ""
        let accessControlTranslation = this.accessControlTranslation?.toXml(AccessControlTranslation.ELE_NAME) ?? ""
        let encryptionConfiguration = this.encryptionConfiguration?.toXml(EncryptionConfiguration.ELE_NAME) ?? ""
        let replicationTime = this.replicationTime?.toXml(ReplicationTime.ELE_NAME) ?? ""
        let metrics = this.metrics?.toXml(Metrics.ELE_NAME) ?? ""
        return "<${eleName}>${bucket}${account}${storageClass}${accessControlTranslation}" +
            "${encryptionConfiguration}${replicationTime}${metrics}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Destination {
        return Destination(
            bucket: ele.childContentRequired("Bucket"),
            account: ele.childContent("Account"),
            storageClass: ele.childContent("StorageClass"),
            accessControlTranslation: ele.child(
                AccessControlTranslation.ELE_NAME,
                AccessControlTranslation.fromXml
            ),
            encryptionConfiguration: ele.child(EncryptionConfiguration.ELE_NAME, EncryptionConfiguration.fromXml),
            replicationTime: ele.child(ReplicationTime.ELE_NAME, ReplicationTime.fromXml),
            metrics: ele.child(Metrics.ELE_NAME, Metrics.fromXml)
        )
    }
}

extend AccessControlTranslation <: S3XmlObject<AccessControlTranslation> {
    public static prop ELE_NAME: String {
        get() {
            "AccessControlTranslation"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let owner = this.owner.toXml("Owner")
        return "<${eleName}>${owner}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AccessControlTranslation {
        return AccessControlTranslation(owner: ele.childContentRequired("Owner"))
    }
}

extend EncryptionConfiguration <: S3XmlObject<EncryptionConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "EncryptionConfiguration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let replicaKmsKeyID = this.replicaKmsKeyID.toXml("ReplicaKmsKeyID")
        return "<${eleName}>${replicaKmsKeyID}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): EncryptionConfiguration {
        return EncryptionConfiguration(replicaKmsKeyID: ele.childContentRequired("ReplicaKmsKeyID"))
    }
}

extend ReplicationTime <: S3XmlObject<ReplicationTime> {
    public static prop ELE_NAME: String {
        get() {
            "ReplicationTime"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        let time = this.time.toXml("Time")
        return "<${eleName}>${status}${time}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationTime {
        return ReplicationTime(
            status: ele.childContentRequired("Status"),
            time: ele.childRequired("Time", ReplicationTimeValue.fromXml)
        )
    }
}

extend Metrics <: S3XmlObject<Metrics> {
    public static prop ELE_NAME: String {
        get() {
            "Metrics"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        let eventThreshold = this.eventThreshold?.toXml("EventThreshold") ?? ""
        return "<${eleName}>${status}${eventThreshold}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Metrics {
        return Metrics(
            status: ele.childContentRequired("Status"),
            eventThreshold: ele.child("EventThreshold", ReplicationTimeValue.fromXml)
        )
    }
}

extend ReplicationTimeValue <: S3XmlObject<ReplicationTimeValue> {
    public static prop ELE_NAME: String {
        get() {
            "Time"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let minutes = this.minutes.toString().toXml("Minutes")
        return "<${eleName}>${minutes}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ReplicationTimeValue {
        return ReplicationTimeValue(minutes: ele.childContentRequired("Minutes").toInt32())
    }
}

extend DeleteMarkerReplication <: S3XmlObject<DeleteMarkerReplication> {
    public static prop ELE_NAME: String {
        get() {
            "DeleteMarkerReplication"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let status = this.status.toXml("Status")
        return "<${eleName}>${status}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): DeleteMarkerReplication {
        return DeleteMarkerReplication(status: ele.childContentRequired("Status"))
    }
}
