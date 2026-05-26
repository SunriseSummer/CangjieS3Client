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
public class IntelligentTieringConfiguration <: ToString {
    public IntelligentTieringConfiguration(
        public let id!: String,
        public let filter!: ?IntelligentTieringFilter = None,
        public let status!: String,
        public let tierings!: ArrayList<Tiering>
    ) {
    }

    public func toString(): String {
        return "IntelligentTieringConfiguration(id=${id}, filter=${filter}, status=${status}, tierings=${tierings})"
    }
}

public class IntelligentTieringFilter <: ToString {
    public IntelligentTieringFilter(
        public let prefix!: ?String = None,
        public let tag!: ?Tag = None,
        public let and!: ?IntelligentTieringAndOperator = None
    ) {
    }

    public func toString(): String {
        return "IntelligentTieringFilter(prefix=${prefix}, tag=${tag}, and=${and})"
    }
}

public class IntelligentTieringAndOperator <: ToString {
    public IntelligentTieringAndOperator(
        public let prefix!: ?String = None,
        public let tags!: ?ArrayList<Tag> = None
    ) {
    }

    public func toString(): String {
        return "IntelligentTieringAndOperator(prefix=${prefix}, tags=${tags})"
    }
}

// -----
//
// -----

extend IntelligentTieringConfiguration <: S3XmlObject<IntelligentTieringConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "IntelligentTieringConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let id = this.id.toXml("Id")
        let filter = this.filter?.toXml(IntelligentTieringFilter.ELE_NAME) ?? ""
        let status = this.status.toXml("Status")
        let tierings = this.tierings |> map<Tiering, String> {tiering => tiering.toXml(Tiering.ELE_NAME)} |>
            collectString<String>()
        return "<${eleName} ${namespace(isRoot)}>${id}${status}${filter}${tierings}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): IntelligentTieringConfiguration {
        return IntelligentTieringConfiguration(
            id: ele.childContentRequired("Id"),
            filter: ele.child(IntelligentTieringFilter.ELE_NAME, IntelligentTieringFilter.fromXml),
            status: ele.childContentRequired("Status"),
            tierings: ele.childs(Tiering.ELE_NAME, Tiering.fromXml)
        )
    }
}

extend IntelligentTieringFilter <: S3XmlObject<IntelligentTieringFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tag = this.tag?.toXml(Tag.ELE_NAME) ?? ""
        let and = this.and?.toXml(IntelligentTieringAndOperator.ELE_NAME) ?? ""
        return "<${eleName}>${prefix}${tag}${and}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): IntelligentTieringFilter {
        return IntelligentTieringFilter(
            prefix: ele.childContent("Prefix"),
            tag: ele.child(Tag.ELE_NAME, Tag.fromXml),
            and: ele.child(IntelligentTieringAndOperator.ELE_NAME, IntelligentTieringAndOperator.fromXml)
        )
    }
}

extend IntelligentTieringAndOperator <: S3XmlObject<IntelligentTieringAndOperator> {
    public static prop ELE_NAME: String {
        get() {
            "And"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tags = match (this.tags) {
            case Some(v) => v |> map({tag: Tag => tag.toXml(Tag.ELE_NAME)}) |> collectString<String>()
            case None => ""
        }
        return "<${eleName}>${prefix}${tags}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): IntelligentTieringAndOperator {
        return IntelligentTieringAndOperator(
            prefix: ele.childContent("Prefix"),
            tags: ele.childs(Tag.ELE_NAME, Tag.fromXml)
        )
    }
}
