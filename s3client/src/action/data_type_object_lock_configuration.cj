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
 * @date: 2023-12-13
 */
public class ObjectLockConfiguration <: ToString {
    public ObjectLockConfiguration(
        public let objectLockEnabled!: ?String = None,
        public let rule!: ?ObjectLockRule = None
    ) {
    }

    public func toString(): String {
        return "ObjectLockConfiguration(objectLockEnabled=${objectLockEnabled}, rule=${rule})"
    }
}

public class ObjectLockRule <: ToString {
    public ObjectLockRule(public let defaultRetention!: ?DefaultRetention = None) {
    }

    public func toString(): String {
        return "ObjectLockRule(defaultRetention=${defaultRetention})"
    }
}

public class DefaultRetention <: ToString {
    public DefaultRetention(
        public let mode!: ?String = None,
        public let days!: ?Int32 = None,
        public let years!: ?Int32 = None
    ) {
    }

    public func toString(): String {
        return "DefaultRetention(mode=${mode}, days=${days}, years=${years})"
    }
}

// -----
//
// -----

extend ObjectLockConfiguration <: S3XmlObject<ObjectLockConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "ObjectLockConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let objectLockEnabled = this.objectLockEnabled?.toXml("ObjectLockEnabled") ?? ""
        let rule = this.rule?.toXml(ObjectLockRule.ELE_NAME) ?? ""
        return "<${eleName} ${namespace(isRoot)}>${objectLockEnabled}${rule}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ObjectLockConfiguration {
        return ObjectLockConfiguration(
            objectLockEnabled: ele.childContent("ObjectLockEnabled"),
            rule: ele.child(ObjectLockRule.ELE_NAME, ObjectLockRule.fromXml)
        )
    }
}

extend ObjectLockRule <: S3XmlObject<ObjectLockRule> {
    public static prop ELE_NAME: String {
        get() {
            "Rule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let defaultRetention = this.defaultRetention?.toXml(DefaultRetention.ELE_NAME) ?? ""
        return "<${eleName}>${defaultRetention}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ObjectLockRule {
        return ObjectLockRule(defaultRetention: ele.child(DefaultRetention.ELE_NAME, DefaultRetention.fromXml))
    }
}

extend DefaultRetention <: S3XmlObject<DefaultRetention> {
    public static prop ELE_NAME: String {
        get() {
            "DefaultRetention"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let mode = this.mode?.toXml("Mode") ?? ""
        let days = this.days?.toString().toXml("Days") ?? ""
        let years = this.years?.toString().toXml("Years") ?? ""
        return "<${eleName}>${mode}${days}${years}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): DefaultRetention {
        return DefaultRetention(
            mode: ele.childContent("Mode"),
            days: ele.childContent("Days")?.toInt32(),
            years: ele.childContent("Years")?.toInt32()
        )
    }
}
