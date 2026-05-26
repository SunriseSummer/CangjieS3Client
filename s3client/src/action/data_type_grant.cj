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
 * @date: 2023-11-30
 */
public class Grant <: ToString {
    public Grant(
        public let grantee!: Grantee,
        public let permission!: String
    ) {
    }

    public func toString(): String {
        return "Grant(grantee=${grantee}, permission=${permission})"
    }
}

// -----
//
// -----

extend Grant <: S3XmlObject<Grant> {
    public static prop ELE_NAME: String {
        get() {
            "Grant"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let grantee = this.grantee.toXml(Grantee.ELE_NAME)
        let permission = this.permission.toXml("Permission")
        return "<${eleName}>${grantee}${permission}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Grant {
        return Grant(
            grantee: ele.childRequired(Grantee.ELE_NAME, Grantee.fromXml),
            permission: ele.childContentRequired("Permission")
        )
    }
}
