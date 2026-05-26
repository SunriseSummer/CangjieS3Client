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
 * @date: 2023-11-22
 */
public class Owner <: ToString {
    public Owner(
        public let id!: String,
        public let displayName!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Owner(id=${id}, displayName=${displayName})"
    }
}

// -----
//
// -----

extend Owner <: S3XmlObject<Owner> {
    public static prop ELE_NAME: String {
        get() {
            "Owner"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id.toXml("ID")
        let displayName = this.displayName?.toXml("DisplayName") ?? ""
        return "<${eleName}>${id}${displayName}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Owner {
        return Owner(
            id: ele.childContentRequired("ID"),
            displayName: ele.childContent("DisplayName")
        )
    }
}
