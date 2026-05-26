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
public class LoggingStatus <: ToString {
    public LoggingStatus(public let loggingEnabled!: ?LoggingEnabled = None) {
    }

    public func toString(): String {
        return "LoggingStatus(loggingEnabled=${loggingEnabled})"
    }
}

public class LoggingEnabled <: ToString {
    public LoggingEnabled(
        public let targetBucket!: String,
        public let targetGrants!: ?ArrayList<TargetGrant> = None,
        public let targetPrefix!: String
    ) {
    }

    public func toString(): String {
        return "LoggingEnabled(targetBucket=${targetBucket}, targetGrants=${targetGrants}, targetPrefix=${targetPrefix})"
    }
}

public class TargetGrant <: ToString {
    public TargetGrant(
        public let grantee!: Grantee,
        public let permission!: String
    ) {
    }

    public func toString(): String {
        return "TargetGrant(grantee=${grantee}, permission=${permission})"
    }
}

// -----
//
// -----

extend LoggingStatus <: S3XmlObject<LoggingStatus> {
    public static prop ELE_NAME: String {
        get() {
            "BucketLoggingStatus"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let loggingEnabled = this.loggingEnabled?.toXml(LoggingEnabled.ELE_NAME) ?? ""
        return "<${eleName} ${namespace(isRoot)}>${loggingEnabled}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LoggingStatus {
        return LoggingStatus(loggingEnabled: ele.child(LoggingEnabled.ELE_NAME, LoggingEnabled.fromXml))
    }
}

extend LoggingEnabled <: S3XmlObject<LoggingEnabled> {
    public static prop ELE_NAME: String {
        get() {
            "LoggingEnabled"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let targetBucket = this.targetBucket.toXml("TargetBucket")
        let targetPrefix = this.targetPrefix.toXml("TargetPrefix")
        let targetGrants = match (this.targetGrants) {
            case Some(v) =>
                let grants = v |> map<TargetGrant, String> {grant => grant.toXml(TargetGrant.ELE_NAME)} |>
                    collectString<String>()
                "<TargetGrants>${grants}</TargetGrants>"
            case None => ""
        }
        return "<${eleName}>${targetBucket}${targetPrefix}${targetGrants}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): LoggingEnabled {
        return LoggingEnabled(
            targetBucket: ele.childContentRequired("TargetBucket"),
            targetPrefix: ele.childContentRequired("TargetPrefix"),
            targetGrants: ele.childs(TargetGrant.ELE_NAME, TargetGrant.fromXml)
        )
    }
}

extend TargetGrant <: S3XmlObject<TargetGrant> {
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

    public static func fromXml(ele: S3XmlElement): TargetGrant {
        return TargetGrant(
            grantee: ele.childRequired(Grantee.ELE_NAME, Grantee.fromXml),
            permission: ele.childContentRequired("Permission")
        )
    }
}
