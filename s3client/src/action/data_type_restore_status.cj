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
 * @date: 2023-11-29
 */
public class RestoreStatus <: ToString {
    public RestoreStatus(
        public let isRestoreInProgress!: Bool,
        public let restoreExpiryDate!: ?DateTime
    ) {
    }

    public func toString(): String {
        return "RestoreStatus(isRestoreInProgress=${isRestoreInProgress}, restoreExpiryDate=${restoreExpiryDate})"
    }
}

// -----
//
// -----

extend RestoreStatus <: S3XmlObject<RestoreStatus> {
    public static prop ELE_NAME: String {
        get() {
            "RestoreStatus"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let isRestoreInProgress = this.isRestoreInProgress.toString().toXml("IsRestoreInProgress")
        let restoreExpiryDate = DateUtils.toStringMidnight(this.restoreExpiryDate)?.toXml("RestoreExpiryDate") ?? ""
        return "<${eleName}>${isRestoreInProgress}${restoreExpiryDate}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): RestoreStatus {
        return RestoreStatus(
            isRestoreInProgress: ele.childContentRequired("IsRestoreInProgress").toBool(),
            restoreExpiryDate: DateUtils.toDateMidnight(ele.childContent("RestoreExpiryDate"))
        )
    }
}
