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
public class Tagging <: ToString {
    public Tagging(public let tagSet!: ArrayList<Tag>) {
    }

    public func toString(): String {
        return "Tagging(tagSet=${tagSet})"
    }
}

// -----
//
// -----

extend Tagging <: S3XmlObject<Tagging> {
    public static prop ELE_NAME: String {
        get() {
            "Tagging"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let tagSet = this.tagSet |> map<Tag, String> {tag => tag.toXml(Tag.ELE_NAME)} |> collectString<String>()
        return "<${eleName} ${namespace(isRoot)}><TagSet>${tagSet}</TagSet></${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Tagging {
        return Tagging(tagSet: ele.childRequired("TagSet").childs(Tag.ELE_NAME, Tag.fromXml))
    }
}
