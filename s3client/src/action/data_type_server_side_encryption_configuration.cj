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
public class ServerSideEncryptionConfiguration <: ToString {
    public ServerSideEncryptionConfiguration(public let rules!: ArrayList<ServerSideEncryptionRule>) {
    }

    public func toString(): String {
        return "ServerSideEncryptionConfiguration(rules=${rules})"
    }
}

public class ServerSideEncryptionRule <: ToString {
    public ServerSideEncryptionRule(
        public let applyServerSideEncryptionByDefault!: ?ServerSideEncryptionByDefault = None,
        public let bucketKeyEnabled!: ?Bool = None
    ) {
    }

    public func toString(): String {
        return "ServerSideEncryptionRule(applyServerSideEncryptionByDefault=${applyServerSideEncryptionByDefault}, bucketKeyEnabled=${bucketKeyEnabled})"
    }
}

public class ServerSideEncryptionByDefault <: ToString {
    public ServerSideEncryptionByDefault(
        public let sseAlgorithm!: String,
        public let kmsMasterKeyID!: ?String = None
    ) {
    }

    public func toString(): String {
        return "ServerSideEncryptionByDefault(sseAlgorithm=${sseAlgorithm}, kmsMasterKeyID=${kmsMasterKeyID})"
    }
}

// -----
//
// -----

extend ServerSideEncryptionConfiguration <: S3XmlObject<ServerSideEncryptionConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "ServerSideEncryptionConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let rules = this.rules |>
            map<ServerSideEncryptionRule, String> {rule => rule.toXml(ServerSideEncryptionRule.ELE_NAME)} |>
            collectString<String>()

        return "<${eleName} ${namespace(isRoot)}>${rules}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ServerSideEncryptionConfiguration {
        return ServerSideEncryptionConfiguration(
            rules: ele.childs(ServerSideEncryptionRule.ELE_NAME, ServerSideEncryptionRule.fromXml))
    }
}

extend ServerSideEncryptionRule <: S3XmlObject<ServerSideEncryptionRule> {
    public static prop ELE_NAME: String {
        get() {
            "Rule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let bucketKeyEnabled = this.bucketKeyEnabled?.toString().toXml("BucketKeyEnabled") ?? ""
        let applyServerSideEncryptionByDefault = this.applyServerSideEncryptionByDefault?.toXml(
            ServerSideEncryptionByDefault.ELE_NAME) ?? ""
        return "<${eleName}>${bucketKeyEnabled}${applyServerSideEncryptionByDefault}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ServerSideEncryptionRule {
        return ServerSideEncryptionRule(
            bucketKeyEnabled: ele.childContent("BucketKeyEnabled")?.toBool(),
            applyServerSideEncryptionByDefault: ele.child(
                ServerSideEncryptionByDefault.ELE_NAME,
                ServerSideEncryptionByDefault.fromXml
            )
        )
    }
}

extend ServerSideEncryptionByDefault <: S3XmlObject<ServerSideEncryptionByDefault> {
    public static prop ELE_NAME: String {
        get() {
            "ApplyServerSideEncryptionByDefault"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let sseAlgorithm = this.sseAlgorithm.toXml("SSEAlgorithm")
        let kmsMasterKeyID = this.kmsMasterKeyID?.toXml("KMSMasterKeyID") ?? ""
        return "<${eleName}>${sseAlgorithm}${kmsMasterKeyID}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ServerSideEncryptionByDefault {
        return ServerSideEncryptionByDefault(
            sseAlgorithm: ele.childContentRequired("SSEAlgorithm"),
            kmsMasterKeyID: ele.childContent("KMSMasterKeyID")
        )
    }
}
