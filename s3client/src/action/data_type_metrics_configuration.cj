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
public class MetricsConfiguration <: ToString {
    public MetricsConfiguration(
        public let id!: String,
        public let filter!: ?MetricsFilter = None
    ) {
    }

    public func toString(): String {
        return "MetricsConfiguration(id=${id}, filter=${filter})"
    }
}

public class MetricsFilter <: ToString {
    public MetricsFilter(
        public let prefix!: ?String = None,
        public let tag!: ?Tag = None,
        public let accessPointArn!: ?String = None,
        public let and!: ?MetricsAndOperator = None
    ) {
    }

    public func toString(): String {
        return "MetricsFilter(prefix=${prefix}, tag=${tag}, accessPointArn=${accessPointArn}, and=${and})"
    }
}

public class MetricsAndOperator <: ToString {
    public MetricsAndOperator(
        public let prefix!: ?String = None,
        public let tags!: ?ArrayList<Tag> = None,
        public let accessPointArn!: ?String = None
    ) {
    }

    public func toString(): String {
        return "MetricsAndOperator(prefix=${prefix}, tags=${tags}, accessPointArn=${accessPointArn})"
    }
}

// -----
//
// -----
extend MetricsConfiguration <: S3XmlObject<MetricsConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "MetricsConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let id = this.id.toXml("Id")
        let filter = this.filter?.toXml(MetricsFilter.ELE_NAME) ?? ""
        return "<${eleName} ${namespace(isRoot)}>${id}${filter}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): MetricsConfiguration {
        return MetricsConfiguration(
            id: ele.childContentRequired("Id"),
            filter: ele.child(MetricsFilter.ELE_NAME, MetricsFilter.fromXml)
        )
    }
}

extend MetricsFilter <: S3XmlObject<MetricsFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let accessPointArn = this.accessPointArn?.toXml("AccessPointArn") ?? ""
        let tag = this.tag?.toXml(Tag.ELE_NAME) ?? ""
        let and = this.and?.toXml(MetricsAndOperator.ELE_NAME) ?? ""
        return "<${eleName}>${prefix}${accessPointArn}${tag}${and}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): MetricsFilter {
        return MetricsFilter(
            prefix: ele.childContent("Prefix"),
            accessPointArn: ele.childContent("AccessPointArn"),
            tag: ele.child(Tag.ELE_NAME, Tag.fromXml),
            and: ele.child(MetricsAndOperator.ELE_NAME, MetricsAndOperator.fromXml)
        )
    }
}

extend MetricsAndOperator <: S3XmlObject<MetricsAndOperator> {
    public static prop ELE_NAME: String {
        get() {
            "And"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let accessPointArn = this.accessPointArn?.toXml("AccessPointArn") ?? ""
        let tags = match (this.tags) {
            case Some(v) => v |> map<Tag, String> {tag => tag.toXml(Tag.ELE_NAME)} |> collectString<String>()
            case None => ""
        }
        return "<${eleName}>${prefix}${accessPointArn}${tags}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): MetricsAndOperator {
        return MetricsAndOperator(
            prefix: ele.childContentRequired("Prefix"),
            accessPointArn: ele.childContent("AccessPointArn"),
            tags: ele.childs(Tag.ELE_NAME, Tag.fromXml)
        )
    }
}
