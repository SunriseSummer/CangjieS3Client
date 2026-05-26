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
 * @date: 2023-12-11
 */
public class VersioningConfiguration <: ToString {
    public VersioningConfiguration(
        public let mfaDelete!: ?String = None,
        public let status!: ?String = None
    ) {
    }

    public func toString(): String {
        return "VersioningConfiguration(mfaDelete=${mfaDelete}, status=${status})"
    }
}

// -----
//
// -----

extend VersioningConfiguration <: S3XmlObject<VersioningConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "VersioningConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let mfaDelete = this.mfaDelete?.toXml("MfaDelete") ?? ""
        let status = this.status?.toXml("Status") ?? ""
        return "<${eleName} ${namespace(isRoot)}>${mfaDelete}${status}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): VersioningConfiguration {
        return VersioningConfiguration(
            mfaDelete: ele.childContent("MfaDelete"),
            status: ele.childContent("Status")
        )
    }
}
