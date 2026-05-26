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
public class LifecycleConfiguration <: ToString {
    public LifecycleConfiguration(public let rules!: ArrayList<LifecycleRule>) {
    }

    public func toString(): String {
        return "LifecycleConfiguration(rules=${rules})"
    }
}

public class LifecycleRule <: ToString {
    public LifecycleRule(
        public let expiration!: ?LifecycleExpiration = None,
        public let id!: ?String = None,
        public let prefix!: ?String = None,
        public let filter!: ?LifecycleRuleFilter = None,
        public let status!: String,
        public let transitions!: ?ArrayList<Transition> = None,
        public let noncurrentVersionTransitions!: ?ArrayList<NoncurrentVersionTransition> = None,
        public let noncurrentVersionExpiration!: ?NoncurrentVersionExpiration = None,
        public let abortIncompleteMultipartUpload!: ?AbortIncompleteMultipartUpload = None
    ) {
    }

    public func toString(): String {
        return "LifecycleRule(" +
            "expiration=${expiration}, id=${id}, prefix=${prefix}, filter=${filter}, status=${status}, " +
            "transitions=${transitions}, noncurrentVersionTransitions=${noncurrentVersionTransitions}, " +
            "noncurrentVersionExpiration=${noncurrentVersionExpiration}, abortIncompleteMultipartUpload=${abortIncompleteMultipartUpload}" +
            ")"
    }
}

public class LifecycleExpiration <: ToString {
    public LifecycleExpiration(
        public let date!: ?DateTime = None,
        public let days!: ?Int32 = None,
        public let expiredObjectDeleteMarker!: ?Bool = None
    ) {
    }

    public func toString(): String {
        return "LifecycleExpiration(date=${date}, days=${days}, expiredObjectDeleteMarker=${expiredObjectDeleteMarker})"
    }
}

public class LifecycleRuleFilter <: ToString {
    public LifecycleRuleFilter(
        public let prefix!: ?String = None,
        public let tag!: ?Tag = None,
        public let objectSizeGreaterThan!: ?Int64 = None,
        public let objectSizeLessThan!: ?Int64 = None,
        public let and!: ?LifecycleRuleAndOperator = None
    ) {
    }

    public func toString(): String {
        return "LifecycleRuleFilter(" +
            "prefix=${prefix}, tag=${tag}, objectSizeGreaterThan=${objectSizeGreaterThan}, objectSizeLessThan=${objectSizeLessThan}, " +
            "and=${and}" + ")"
    }
}

public class LifecycleRuleAndOperator <: ToString {
    public LifecycleRuleAndOperator(
        public let prefix!: ?String = None,
        public let tags!: ?ArrayList<Tag> = None,
        public let objectSizeGreaterThan!: ?Int64 = None,
        public let objectSizeLessThan!: ?Int64 = None
    ) {
    }

    public func toString(): String {
        return "LifecycleRuleAndOperator(" +
            "prefix=${prefix}, tags=${tags}, objectSizeGreaterThan=${objectSizeGreaterThan}, objectSizeLessThan=${objectSizeLessThan}, " +
            ")"
    }
}

public class Transition <: ToString {
    public Transition(
        public let date!: ?DateTime = None,
        public let days!: ?Int32 = None,
        public let storageClass!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Transition(date=${date}, days=${days}, storageClass=${storageClass})"
    }
}

public class NoncurrentVersionTransition <: ToString {
    public NoncurrentVersionTransition(
        public let noncurrentDays!: ?Int32 = None,
        public let storageClass!: ?String = None,
        public let newerNoncurrentVersions!: ?Int32 = None
    ) {
    }

    public func toString(): String {
        return "NoncurrentVersionTransition(" +
            "noncurrentDays=${noncurrentDays}, storageClass=${storageClass}, newerNoncurrentVersions=${newerNoncurrentVersions}" +
            ")"
    }
}

public class NoncurrentVersionExpiration <: ToString {
    public NoncurrentVersionExpiration(
        public let noncurrentDays!: ?Int32 = None,
        public let newerNoncurrentVersions!: ?Int32 = None
    ) {
    }

    public func toString(): String {
        return "NoncurrentVersionExpiration(" +
            "noncurrentDays=${noncurrentDays}, newerNoncurrentVersions=${newerNoncurrentVersions}" + ")"
    }
}

public class AbortIncompleteMultipartUpload <: ToString {
    public AbortIncompleteMultipartUpload(public let daysAfterInitiation!: ?Int32 = None) {
    }

    public func toString(): String {
        return "AbortIncompleteMultipartUpload(daysAfterInitiation=${daysAfterInitiation})"
    }
}

// -----
//
// -----

extend LifecycleConfiguration <: S3XmlObject<LifecycleConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "LifecycleConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let rules = this.rules |> map<LifecycleRule, String> {rule => rule.toXml(LifecycleRule.ELE_NAME)} |>
            collectString<String>()
        return "<${eleName} ${namespace(isRoot)}>${rules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LifecycleConfiguration {
        return LifecycleConfiguration(rules: ele.childs(LifecycleRule.ELE_NAME, LifecycleRule.fromXml))
    }
}

extend LifecycleRule <: S3XmlObject<LifecycleRule> {
    public static prop ELE_NAME: String {
        get() {
            "Rule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("ID") ?? ""
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let status = this.status.toXml("Status")
        let expiration = this.expiration?.toXml(LifecycleExpiration.ELE_NAME) ?? ""
        let noncurrentVersionExpiration = this.noncurrentVersionExpiration?.toXml(NoncurrentVersionExpiration.ELE_NAME) ??
            ""
        let abortIncompleteMultipartUpload = this.abortIncompleteMultipartUpload?.toXml(
            AbortIncompleteMultipartUpload.ELE_NAME) ?? ""
        let transitions = match (this.transitions) {
            case Some(v) => v |> map<Transition, String> {transition => transition.toXml(Transition.ELE_NAME)} |>
                collectString<String>()
            case None => ""
        }
        let noncurrentVersionTransitions = match (this.noncurrentVersionTransitions) {
            case Some(v) => v |>
                map<NoncurrentVersionTransition, String> {
                transition => transition.toXml(NoncurrentVersionTransition.ELE_NAME)
            } |> collectString<String>()
            case None => ""
        }
        let filter = this.filter?.toXml(LifecycleRuleFilter.ELE_NAME) ?? ""
        return "<${eleName}>${id}${prefix}${status}${expiration}${noncurrentVersionExpiration}" +
            "${abortIncompleteMultipartUpload}${transitions}${noncurrentVersionTransitions}${filter}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LifecycleRule {
        return LifecycleRule(
            id: ele.childContent("ID"),
            prefix: ele.childContent("Prefix"),
            status: ele.childContentRequired("Status"),
            expiration: ele.child(LifecycleExpiration.ELE_NAME, LifecycleExpiration.fromXml),
            noncurrentVersionExpiration: ele.child(
                NoncurrentVersionExpiration.ELE_NAME,
                NoncurrentVersionExpiration.fromXml
            ),
            abortIncompleteMultipartUpload: ele.child(
                AbortIncompleteMultipartUpload.ELE_NAME,
                AbortIncompleteMultipartUpload.fromXml
            ),
            transitions: ele.childs(Transition.ELE_NAME, Transition.fromXml),
            noncurrentVersionTransitions: ele.childs(
                NoncurrentVersionTransition.ELE_NAME,
                NoncurrentVersionTransition.fromXml
            ),
            filter: ele.child(LifecycleRuleFilter.ELE_NAME, LifecycleRuleFilter.fromXml)
        )
    }
}

extend LifecycleExpiration <: S3XmlObject<LifecycleExpiration> {
    public static prop ELE_NAME: String {
        get() {
            "Expiration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let date = DateUtils.toStringMidnight(this.date)?.toXml("Date") ?? ""
        let days = this.days?.toString().toXml("Days") ?? ""
        let expiredObjectDeleteMarker = this.expiredObjectDeleteMarker?.toString().toXml("ExpiredObjectDeleteMarker") ??
            ""
        return "<${eleName}>${date}${days}${expiredObjectDeleteMarker}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LifecycleExpiration {
        return LifecycleExpiration(
            date: DateUtils.toDateMidnight(ele.childContent("Date")),
            days: ele.childContent("Days")?.toInt32(),
            expiredObjectDeleteMarker: ele.childContent("ExpiredObjectDeleteMarker")?.toBool()
        )
    }
}

extend LifecycleRuleFilter <: S3XmlObject<LifecycleRuleFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tag = this.tag?.toXml(Tag.ELE_NAME) ?? ""
        let objectSizeGreaterThan = this.objectSizeGreaterThan?.toString().toXml("ObjectSizeGreaterThan") ?? ""
        let objectSizeLessThan = this.objectSizeLessThan?.toString().toXml("ObjectSizeLessThan") ?? ""
        let and = this.and?.toXml(LifecycleRuleAndOperator.ELE_NAME) ?? ""
        return "<${eleName}>${prefix}${tag}${objectSizeGreaterThan}${objectSizeLessThan}${and}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LifecycleRuleFilter {
        return LifecycleRuleFilter(
            prefix: ele.childContent("Prefix"),
            tag: ele.child(Tag.ELE_NAME, Tag.fromXml),
            objectSizeGreaterThan: ele.childContent("ObjectSizeGreaterThan")?.toInt64(),
            objectSizeLessThan: ele.childContent("ObjectSizeLessThan")?.toInt64(),
            and: ele.child(LifecycleRuleAndOperator.ELE_NAME, LifecycleRuleAndOperator.fromXml)
        )
    }
}

extend LifecycleRuleAndOperator <: S3XmlObject<LifecycleRuleAndOperator> {
    public static prop ELE_NAME: String {
        get() {
            "And"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tags = match (this.tags) {
            case Some(v) => v |> map<Tag, String> {tag => tag.toXml(Tag.ELE_NAME)} |> collectString<String>()
            case None => ""
        }
        let objectSizeGreaterThan = this.objectSizeGreaterThan?.toString().toXml("ObjectSizeGreaterThan") ?? ""
        let objectSizeLessThan = this.objectSizeLessThan?.toString().toXml("ObjectSizeLessThan") ?? ""
        return "<${eleName}>${prefix}${objectSizeGreaterThan}${objectSizeLessThan}${tags}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LifecycleRuleAndOperator {
        return LifecycleRuleAndOperator(
            prefix: ele.childContent("Prefix"),
            objectSizeGreaterThan: ele.childContent("ObjectSizeGreaterThan")?.toInt64(),
            objectSizeLessThan: ele.childContent("ObjectSizeLessThan")?.toInt64(),
            tags: ele.childs(Tag.ELE_NAME, Tag.fromXml)
        )
    }
}

extend Transition <: S3XmlObject<Transition> {
    public static prop ELE_NAME: String {
        get() {
            "Transition"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let date = DateUtils.toStringMidnight(this.date)?.toXml("Date") ?? ""
        let days = this.days?.toString().toXml("Days") ?? ""
        let storageClass = this.storageClass?.toXml("StorageClass") ?? ""
        return "<${eleName}>${date}${days}${storageClass}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Transition {
        return Transition(
            date: DateUtils.toDateMidnight(ele.childContent("Date")),
            days: ele.childContent("Days")?.toInt32(),
            storageClass: ele.childContent("StorageClass")
        )
    }
}

extend NoncurrentVersionTransition <: S3XmlObject<NoncurrentVersionTransition> {
    public static prop ELE_NAME: String {
        get() {
            "NoncurrentVersionTransition"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let noncurrentDays = this.noncurrentDays?.toString().toXml("NoncurrentDays") ?? ""
        let newerNoncurrentVersions = this.newerNoncurrentVersions?.toString().toXml("NewerNoncurrentVersions") ?? ""
        let storageClass = this.storageClass?.toXml("StorageClass") ?? ""
        return "<${eleName}>${noncurrentDays}${newerNoncurrentVersions}${storageClass}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): NoncurrentVersionTransition {
        return NoncurrentVersionTransition(
            noncurrentDays: ele.childContent("NoncurrentDays")?.toInt32(),
            storageClass: ele.childContent("StorageClass"),
            newerNoncurrentVersions: ele.childContent("NewerNoncurrentVersions")?.toInt32()
        )
    }
}

extend NoncurrentVersionExpiration <: S3XmlObject<NoncurrentVersionExpiration> {
    public static prop ELE_NAME: String {
        get() {
            "NoncurrentVersionExpiration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let noncurrentDays = this.noncurrentDays?.toString().toXml("NoncurrentDays") ?? ""
        let newerNoncurrentVersions = this.newerNoncurrentVersions?.toString().toXml("NewerNoncurrentVersions") ?? ""
        return "<${eleName}>${noncurrentDays}${newerNoncurrentVersions}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): NoncurrentVersionExpiration {
        return NoncurrentVersionExpiration(
            noncurrentDays: ele.childContent("NoncurrentDays")?.toInt32(),
            newerNoncurrentVersions: ele.childContent("NewerNoncurrentVersions")?.toInt32()
        )
    }
}

extend AbortIncompleteMultipartUpload <: S3XmlObject<AbortIncompleteMultipartUpload> {
    public static prop ELE_NAME: String {
        get() {
            "AbortIncompleteMultipartUpload"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let daysAfterInitiation = this.daysAfterInitiation?.toString().toXml("DaysAfterInitiation") ?? ""
        return "<${eleName}>${daysAfterInitiation}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AbortIncompleteMultipartUpload {
        return AbortIncompleteMultipartUpload(daysAfterInitiation: ele.childContent("DaysAfterInitiation")?.toInt32())
    }
}
