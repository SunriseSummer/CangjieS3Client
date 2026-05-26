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
public class NotificationConfiguration <: ToString {
    public NotificationConfiguration(
        public let topicConfigurations!: ?ArrayList<TopicConfiguration> = None,
        public let queueConfigurations!: ?ArrayList<QueueConfiguration> = None,
        public let lambdaFunctionConfigurations!: ?ArrayList<LambdaFunctionConfiguration> = None,
        public let eventBridgeConfiguration!: ?EventBridgeConfiguration = None
    ) {
    }

    public func toString(): String {
        return "NotificationConfiguration(" +
            "topicConfigurations=${topicConfigurations}, queueConfigurations=${queueConfigurations}, " +
            "lambdaFunctionConfigurations=${lambdaFunctionConfigurations}, eventBridgeConfiguration=${eventBridgeConfiguration}" +
            ")"
    }
}

public class TopicConfiguration <: ToString {
    public TopicConfiguration(
        public let id!: ?String = None,
        public let topicArn!: String,
        public let events!: ArrayList<String>,
        public let filter!: ?NotificationConfigurationFilter = None
    ) {
    }

    public func toString(): String {
        return "TopicConfiguration(id=${id}, topicArn=${topicArn}, events=${events}, filter=${filter})"
    }
}

public class QueueConfiguration <: ToString {
    public QueueConfiguration(
        public let id!: ?String = None,
        public let queueArn!: String,
        public let events!: ArrayList<String>,
        public let filter!: ?NotificationConfigurationFilter = None
    ) {
    }

    public func toString(): String {
        return "QueueConfiguration(id=${id}, queueArn=${queueArn}, events=${events}, filter=${filter})"
    }
}

public class LambdaFunctionConfiguration <: ToString {
    public LambdaFunctionConfiguration(
        public let id!: ?String = None,
        public let lambdaFunctionArn!: String,
        public let events!: ArrayList<String>,
        public let filter!: ?NotificationConfigurationFilter = None
    ) {
    }

    public func toString(): String {
        return "LambdaFunctionConfiguration(" +
            "id=${id}, lambdaFunctionArn=${lambdaFunctionArn}, events=${events}, filter=${filter})"
    }
}

public class EventBridgeConfiguration <: ToString {
    public EventBridgeConfiguration() {}

    public func toString(): String {
        return "EventBridgeConfiguration()"
    }
}

public class NotificationConfigurationFilter <: ToString {
    public NotificationConfigurationFilter(public let key!: S3KeyFilter) {
    }

    public func toString(): String {
        return "NotificationConfigurationFilter(key=${key})"
    }
}

public class S3KeyFilter <: ToString {
    public S3KeyFilter(public let filterRules!: ArrayList<FilterRule>) {
    }

    public func toString(): String {
        return "S3KeyFilter(filterRules=${filterRules})"
    }
}

public class FilterRule <: ToString {
    public FilterRule(
        public let name!: String,
        public let value!: String
    ) {
    }

    public func toString(): String {
        return "FilterRule(name=${name}, value=${value})"
    }
}

// -----
//
// -----
extend NotificationConfiguration <: S3XmlObject<NotificationConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "NotificationConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let topicConfigurations = match (this.topicConfigurations) {
            case Some(v) => v |> map<TopicConfiguration, String> {config => config.toXml(TopicConfiguration.ELE_NAME)} |>
                collectString<String>()
            case None => ""
        }
        let queueConfigurations = match (this.queueConfigurations) {
            case Some(v) => v |> map<QueueConfiguration, String> {config => config.toXml(QueueConfiguration.ELE_NAME)} |>
                collectString<String>()
            case None => ""
        }
        let lambdaFunctionConfigurations = match (this.lambdaFunctionConfigurations) {
            case Some(v) => v |>
                map<LambdaFunctionConfiguration, String> {
                config => config.toXml(LambdaFunctionConfiguration.ELE_NAME)
            } |> collectString<String>()
            case None => ""
        }
        let eventBridgeConfiguration = this.eventBridgeConfiguration?.toXml(EventBridgeConfiguration.ELE_NAME) ?? ""

        return "<${eleName} ${namespace(isRoot)}>${topicConfigurations}${queueConfigurations}" +
            "${lambdaFunctionConfigurations}${eventBridgeConfiguration}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): NotificationConfiguration {
        return NotificationConfiguration(
            topicConfigurations: ele.childs(TopicConfiguration.ELE_NAME, TopicConfiguration.fromXml),
            queueConfigurations: ele.childs(QueueConfiguration.ELE_NAME, QueueConfiguration.fromXml),
            lambdaFunctionConfigurations: ele.childs(
                LambdaFunctionConfiguration.ELE_NAME,
                LambdaFunctionConfiguration.fromXml
            ),
            eventBridgeConfiguration: ele.child(
                EventBridgeConfiguration.ELE_NAME,
                EventBridgeConfiguration.fromXml
            )
        )
    }
}

extend TopicConfiguration <: S3XmlObject<TopicConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "TopicConfiguration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("Id") ?? ""
        let topicArn = this.topicArn.toXml("Topic")
        let events = this.events.toXml("Event")
        let filter = this.filter?.toXml(NotificationConfigurationFilter.ELE_NAME) ?? ""
        return "<${eleName}>${id}${topicArn}${events}${filter}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): TopicConfiguration {
        return TopicConfiguration(
            id: ele.childContent("Id"),
            topicArn: ele.childContentRequired("Topic"),
            events: ele.childsContents("Event"),
            filter: ele.child(NotificationConfigurationFilter.ELE_NAME, NotificationConfigurationFilter.fromXml)
        )
    }
}

extend QueueConfiguration <: S3XmlObject<QueueConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "QueueConfiguration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("Id") ?? ""
        let queueArn = this.queueArn.toXml("Queue")
        let events = this.events.toXml("Event")
        let filter = this.filter?.toXml(NotificationConfigurationFilter.ELE_NAME) ?? ""
        return "<${eleName}>${id}${queueArn}${events}${filter}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): QueueConfiguration {
        return QueueConfiguration(
            id: ele.childContent("Id"),
            queueArn: ele.childContentRequired("Queue"),
            events: ele.childsContents("Event"),
            filter: ele.child(NotificationConfigurationFilter.ELE_NAME, NotificationConfigurationFilter.fromXml)
        )
    }
}

extend LambdaFunctionConfiguration <: S3XmlObject<LambdaFunctionConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "CloudFunctionConfiguration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("Id") ?? ""
        let lambdaFunctionArn = this.lambdaFunctionArn.toXml("CloudFunction")
        let events = this.events.toXml("Event")
        let filter = this.filter?.toXml(NotificationConfigurationFilter.ELE_NAME) ?? ""
        return "<${eleName}>${id}${lambdaFunctionArn}${events}${filter}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LambdaFunctionConfiguration {
        return LambdaFunctionConfiguration(
            id: ele.childContent("Id"),
            lambdaFunctionArn: ele.childContentRequired("CloudFunction"),
            events: ele.childsContents("Event"),
            filter: ele.child(NotificationConfigurationFilter.ELE_NAME, NotificationConfigurationFilter.fromXml)
        )
    }
}

extend EventBridgeConfiguration <: S3XmlObject<EventBridgeConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "EventBridgeConfiguration"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        return "<${eleName}></${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): EventBridgeConfiguration {
        return EventBridgeConfiguration()
    }
}

extend NotificationConfigurationFilter <: S3XmlObject<NotificationConfigurationFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let key = this.key.toXml(S3KeyFilter.ELE_NAME)
        return "<${eleName}>${key}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): NotificationConfigurationFilter {
        return NotificationConfigurationFilter(key: ele.childRequired(S3KeyFilter.ELE_NAME, S3KeyFilter.fromXml))
    }
}

extend S3KeyFilter <: S3XmlObject<S3KeyFilter> {
    public static prop ELE_NAME: String {
        get() {
            "S3Key"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let rules = this.filterRules |> map<FilterRule, String> {rule => rule.toXml(FilterRule.ELE_NAME)} |>
            collectString<String>()
        return "<${eleName}>${rules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): S3KeyFilter {
        return S3KeyFilter(filterRules: ele.childs(FilterRule.ELE_NAME, FilterRule.fromXml))
    }
}

extend FilterRule <: S3XmlObject<FilterRule> {
    public static prop ELE_NAME: String {
        get() {
            "FilterRule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let name = this.name.toXml("Name")
        let value = this.value.toXml("Value")
        return "<${eleName}>${name}${value}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): FilterRule {
        return FilterRule(
            name: ele.childContentRequired("Name"),
            value: ele.childContentRequired("Value")
        )
    }
}
