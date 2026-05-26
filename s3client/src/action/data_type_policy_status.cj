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
 * @date: 2023-12-11
 */
public class PolicyStatus <: ToString {
    public PolicyStatus(public let isPublic!: Bool) {
    }

    public func toString(): String {
        return "PolicyStatus(isPublic=${isPublic})"
    }
}

// -----
//
// -----

extend PolicyStatus <: S3XmlObject<PolicyStatus> {
    public static prop ELE_NAME: String {
        get() {
            "PolicyStatus"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException("")
    }

    public static func fromXml(ele: S3XmlElement): PolicyStatus {
        return PolicyStatus(isPublic: ele.childContentRequired("IsPublic").toBool())
    }
}
