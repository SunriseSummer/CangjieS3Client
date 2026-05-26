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
 * @date: 2023-12-14
 */
public class Delete <: ToString {
    public Delete(
        public let objects!: ArrayList<ObjectIdentifier>,
        public let quiet!: ?Bool = None
    ) {
    }

    public func toString(): String {
        return "Delete(objects=${objects}, quiet=${quiet})"
    }
}

public class ObjectIdentifier <: ToString {
    public ObjectIdentifier(
        public let key!: String,
        public let versionId!: ?String = None
    ) {
    }

    public func toString(): String {
        return "ObjectIdentifier(key=${key}, versionId=${versionId})"
    }
}

// -----
//
// -----

extend Delete <: S3XmlObject<Delete> {
    public static prop ELE_NAME: String {
        get() {
            "Delete"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let objects = this.objects |> map<ObjectIdentifier, String> {object => object.toXml(ObjectIdentifier.ELE_NAME)} |>
            collectString<String>()
        let quiet = this.quiet?.toString().toXml("Quiet") ?? ""
        return "<${eleName} ${namespace(isRoot)}>${objects}${quiet}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): Delete {
        throw UnsupportedException()
    }
}

extend ObjectIdentifier <: S3XmlObject<ObjectIdentifier> {
    public static prop ELE_NAME: String {
        get() {
            "Object"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let key = this.key.toXml("Key")
        let versionId = this.versionId?.toXml("VersionId") ?? ""
        return "<${eleName}>${key}${versionId}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): ObjectIdentifier {
        throw UnsupportedException()
    }
}
