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
public class Grantee <: ToString {
    public Grantee(
        public let id!: ?String = None, // ownerId
        public let _type!: String, // type 是关键字
        public let uri!: ?String = None,
        public let displayName!: ?String = None,
        public let emailAddress!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Grantee(id=${id}, _type=${_type}, uri=${uri}, displayName=${displayName}, emailAddress=${emailAddress})"
    }
}

// -----
//
// -----

extend Grantee <: S3XmlObject<Grantee> {
    public static prop ELE_NAME: String {
        get() {
            "Grantee"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let _type = "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"${this._type}\""
        let id = this.id?.toXml("ID") ?? ""
        let uri = this.uri?.toXml("URI") ?? ""
        let displayName = this.displayName?.toXml("DisplayName") ?? ""
        let emailAddress = this.emailAddress?.toXml("EmailAddress") ?? ""
        return "<${eleName} ${_type}>${id}${displayName}${uri}${emailAddress}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Grantee {
        return Grantee(
            id: ele.childContent("ID"),
            _type: ele.attrContentRequired("xsi:type"),
            uri: ele.childContent("URI"),
            displayName: ele.childContent("DisplayName"),
            emailAddress: ele.childContent("EmailAddress")
        )
    }
}
