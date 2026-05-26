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
 * @date: 2023-12-13
 */
public class ObjectLockRetention <: ToString {
    public ObjectLockRetention(
        public let mode!: ?String = None,
        public let retainUntilDate!: ?DateTime = None
    ) {
    }

    public func toString(): String {
        return "ObjectLockRetention(mode=${mode}, retainUntilDate=${retainUntilDate})"
    }
}

// -----
//
// -----

extend ObjectLockRetention <: S3XmlObject<ObjectLockRetention> {
    public static prop ELE_NAME: String {
        get() {
            "Retention"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let mode = this.mode?.toXml("Mode") ?? ""
        let retainUntilDate = this.retainUntilDate?.toStringIso8601().toXml("RetainUntilDate") ?? ""
        return "<${eleName} ${namespace(isRoot)}>${mode}${retainUntilDate}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): ObjectLockRetention {
        return ObjectLockRetention(
            mode: ele.childContent("Mode"),
            retainUntilDate: ele.childContent("RetainUntilDate")?.toDateIso8601()
        )
    }
}
