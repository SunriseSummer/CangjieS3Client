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
public class WebsiteConfiguration <: ToString {
    public WebsiteConfiguration(
        public let errorDocument!: ?ErrorDocument = None,
        public let indexDocument!: ?IndexDocument = None,
        public let redirectAllRequestsTo!: ?RedirectAllRequestsTo = None,
        public let routingRules!: ?ArrayList<RoutingRule> = None
    ) {
    }

    public func toString(): String {
        return "WebsiteConfiguration(" +
            "errorDocument=${errorDocument}, indexDocument=${indexDocument}, redirectAllRequestsTo=${redirectAllRequestsTo}, " +
            "routingRules=${routingRules}" + ")"
    }
}

public class ErrorDocument <: ToString {
    public ErrorDocument(public let key!: String) {
    }

    public func toString(): String {
        return "ErrorDocument(key=${key})"
    }
}

public class IndexDocument <: ToString {
    public IndexDocument(public let suffix!: String) {
    }

    public func toString(): String {
        return "IndexDocument(suffix=${suffix})"
    }
}

public class RedirectAllRequestsTo <: ToString {
    public RedirectAllRequestsTo(
        public let hostName!: String,
        public let protocol!: ?String = None
    ) {
    }

    public func toString(): String {
        return "RedirectAllRequestsTo(hostName=${hostName}, protocol=${protocol})"
    }
}

public class RoutingRule <: ToString {
    public RoutingRule(
        public let condition!: ?Condition = None,
        public let redirect!: Redirect
    ) {
    }

    public func toString(): String {
        return "RoutingRule(condition=${condition}, redirect=${redirect})"
    }
}

public class Condition <: ToString {
    public Condition(
        public let httpErrorCodeReturnedEquals!: ?String = None,
        public let keyPrefixEquals!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Condition(httpErrorCodeReturnedEquals=${httpErrorCodeReturnedEquals}, keyPrefixEquals=${keyPrefixEquals})"
    }
}

public class Redirect <: ToString {
    public Redirect(
        public let hostName!: ?String = None,
        public let httpRedirectCode!: ?String = None,
        public let protocol!: ?String = None,
        public let replaceKeyPrefixWith!: ?String = None,
        public let replaceKeyWith!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Redirect(" + "hostName=${hostName}, httpRedirectCode=${httpRedirectCode}, protocol=${protocol}, " +
            "replaceKeyPrefixWith=${replaceKeyPrefixWith}, replaceKeyWith=${replaceKeyWith}" + ")"
    }
}

// -----
//
// -----

extend WebsiteConfiguration <: S3XmlObject<WebsiteConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "WebsiteConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let errorDocument = this.errorDocument?.toXml(ErrorDocument.ELE_NAME) ?? ""
        let indexDocument = this.indexDocument?.toXml(IndexDocument.ELE_NAME) ?? ""
        let redirectAllRequestsTo = this.redirectAllRequestsTo?.toXml(RedirectAllRequestsTo.ELE_NAME) ?? ""
        let routingRules = match (this.routingRules) {
            case Some(v) =>
                let rules = v |> map<RoutingRule, String> {rule => rule.toXml(RoutingRule.ELE_NAME)} |>
                    collectString<String>(delimiter: "")
                "<RoutingRules>${rules}</RoutingRules>"
            case None => ""
        }
        return "<${eleName} ${namespace(isRoot)}>${errorDocument}${indexDocument}" +
            "${redirectAllRequestsTo}${routingRules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): WebsiteConfiguration {
        return WebsiteConfiguration(
            errorDocument: ele.child(ErrorDocument.ELE_NAME, ErrorDocument.fromXml),
            indexDocument: ele.child(IndexDocument.ELE_NAME, IndexDocument.fromXml),
            redirectAllRequestsTo: ele.child(RedirectAllRequestsTo.ELE_NAME, RedirectAllRequestsTo.fromXml),
            routingRules: ele.child("RoutingRules")?.childs(RoutingRule.ELE_NAME, RoutingRule.fromXml)
        )
    }
}

extend ErrorDocument <: S3XmlObject<ErrorDocument> {
    public static prop ELE_NAME: String {
        get() {
            "ErrorDocument"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let key = this.key.toXml("Key")
        return "<${eleName}>${key}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ErrorDocument {
        return ErrorDocument(key: ele.childContentRequired("Key"))
    }
}

extend IndexDocument <: S3XmlObject<IndexDocument> {
    public static prop ELE_NAME: String {
        get() {
            "IndexDocument"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let suffix = this.suffix.toXml("Suffix")
        return "<${eleName}>${suffix}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): IndexDocument {
        return IndexDocument(suffix: ele.childContentRequired("Suffix"))
    }
}

extend RedirectAllRequestsTo <: S3XmlObject<RedirectAllRequestsTo> {
    public static prop ELE_NAME: String {
        get() {
            "RedirectAllRequestsTo"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let hostName = this.hostName.toXml("HostName")
        let protocol = this.protocol?.toXml("Protocol") ?? ""
        return "<${eleName}>${hostName}${protocol}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): RedirectAllRequestsTo {
        return RedirectAllRequestsTo(
            hostName: ele.childContentRequired("HostName"),
            protocol: ele.childContent("Protocol")
        )
    }
}

extend RoutingRule <: S3XmlObject<RoutingRule> {
    public static prop ELE_NAME: String {
        get() {
            "RoutingRule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let condition = this.condition?.toXml(Condition.ELE_NAME) ?? ""
        let redirect = this.redirect.toXml(Redirect.ELE_NAME)
        return "<${eleName}>${condition}${redirect}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): RoutingRule {
        return RoutingRule(
            condition: ele.child(Condition.ELE_NAME, Condition.fromXml),
            redirect: ele.childRequired(Redirect.ELE_NAME, Redirect.fromXml)
        )
    }
}

extend Condition <: S3XmlObject<Condition> {
    public static prop ELE_NAME: String {
        get() {
            "Condition"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let httpErrorCodeReturnedEquals = this.httpErrorCodeReturnedEquals?.toXml("HttpErrorCodeReturnedEquals") ?? ""
        let keyPrefixEquals = this.keyPrefixEquals?.toXml("KeyPrefixEquals") ?? ""
        return "<${eleName}>${httpErrorCodeReturnedEquals}${keyPrefixEquals}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Condition {
        return Condition(
            httpErrorCodeReturnedEquals: ele.childContent("HttpErrorCodeReturnedEquals"),
            keyPrefixEquals: ele.childContent("KeyPrefixEquals")
        )
    }
}

extend Redirect <: S3XmlObject<Redirect> {
    public static prop ELE_NAME: String {
        get() {
            "Redirect"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let hostName = this.hostName?.toXml("HostName") ?? ""
        let httpRedirectCode = this.httpRedirectCode?.toXml("HttpRedirectCode") ?? ""
        let protocol = this.protocol?.toXml("Protocol") ?? ""
        let replaceKeyPrefixWith = this.replaceKeyPrefixWith?.toXml("ReplaceKeyPrefixWith") ?? ""
        let replaceKeyWith = this.replaceKeyWith?.toXml("ReplaceKeyWith") ?? ""
        return "<${eleName}>${hostName}${httpRedirectCode}${protocol}${replaceKeyPrefixWith}${replaceKeyWith}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Redirect {
        return Redirect(
            hostName: ele.childContent("HostName"),
            httpRedirectCode: ele.childContent("HttpRedirectCode"),
            protocol: ele.childContent("Protocol"),
            replaceKeyPrefixWith: ele.childContent("ReplaceKeyPrefixWith"),
            replaceKeyWith: ele.childContent("ReplaceKeyWith")
        )
    }
}
