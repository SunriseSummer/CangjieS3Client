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
public class OwnershipControls <: ToString {
    public OwnershipControls(public let rules!: ArrayList<OwnershipControlsRule>) {
    }

    public func toString(): String {
        return "OwnershipControls(rules=${rules})"
    }
}

public class OwnershipControlsRule <: ToString {
    public OwnershipControlsRule(public let objectOwnership!: String) {
    }

    public func toString(): String {
        return "OwnershipControlsRule(objectOwnership=${objectOwnership})"
    }
}

// -----
//
// -----

extend OwnershipControls <: S3XmlObject<OwnershipControls> {
    public static prop ELE_NAME: String {
        get() {
            "OwnershipControls"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let rules = this.rules |> map<OwnershipControlsRule, String> {rule => rule.toXml(OwnershipControlsRule.ELE_NAME)} |>
            collectString<String>()
        return "<${eleName} ${namespace(isRoot)}>${rules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): OwnershipControls {
        return OwnershipControls(rules: ele.childs(OwnershipControlsRule.ELE_NAME, OwnershipControlsRule.fromXml))
    }
}

extend OwnershipControlsRule <: S3XmlObject<OwnershipControlsRule> {
    public static prop ELE_NAME: String {
        get() {
            "Rule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let objectOwnership = this.objectOwnership.toXml("ObjectOwnership")
        return "<${eleName}>${objectOwnership}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): OwnershipControlsRule {
        return OwnershipControlsRule(objectOwnership: ele.childContentRequired("ObjectOwnership"))
    }
}
