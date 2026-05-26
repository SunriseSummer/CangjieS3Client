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
 * @date: 2023-12-01
 */
public class AccessControlPolicy <: ToString {
    public AccessControlPolicy(
        public let owner!: ?Owner = None,
        public let grants!: ?ArrayList<Grant> = None
    ) {
    }

    public func toString(): String {
        return "AccessControlPolicy(owner=${owner}, grants=${grants})"
    }
}

// -----
//
// -----

extend AccessControlPolicy <: S3XmlObject<AccessControlPolicy> {
    public static prop ELE_NAME: String {
        get() {
            "AccessControlPolicy"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let owner = this.owner?.toXml(Owner.ELE_NAME) ?? ""
        let grants = match (this.grants) {
            case Some(v) => v |> map<Grant, String> {grant => grant.toXml(Grant.ELE_NAME)} |> collectString<String>()
            case None => ""
        }
        return "<${eleName} ${namespace(isRoot)}>${owner}<AccessControlList>${grants}</AccessControlList></${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AccessControlPolicy {
        return AccessControlPolicy(
            owner: ele.child(Owner.ELE_NAME, Owner.fromXml),
            grants: ele.child("AccessControlList")?.childs(Grant.ELE_NAME, Grant.fromXml)
        )
    }
}
