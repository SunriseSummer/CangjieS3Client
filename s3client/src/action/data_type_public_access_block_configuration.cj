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
 * @date: 2023-12-12
 */
public class PublicAccessBlockConfiguration <: ToString {
    public PublicAccessBlockConfiguration(
        public let blockPublicAcls!: ?Bool = None,
        public let ignorePublicAcls!: ?Bool = None,
        public let blockPublicPolicy!: ?Bool = None,
        public let restrictPublicBuckets!: ?Bool = None
    ) {
    }

    public func toString(): String {
        return "PublicAccessBlockConfiguration(" +
            "blockPublicAcls=${blockPublicAcls}, ignorePublicAcls=${ignorePublicAcls}, blockPublicPolicy=${blockPublicPolicy}, " +
            "restrictPublicBuckets=${restrictPublicBuckets}" + ")"
    }
}

// -----
//
// -----

extend PublicAccessBlockConfiguration <: S3XmlObject<PublicAccessBlockConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "PublicAccessBlockConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let blockPublicAcls = this.blockPublicAcls?.toString().toXml("BlockPublicAcls") ?? ""
        let ignorePublicAcls = this.ignorePublicAcls?.toString().toXml("IgnorePublicAcls") ?? ""
        let blockPublicPolicy = this.blockPublicPolicy?.toString().toXml("BlockPublicPolicy") ?? ""
        let restrictPublicBuckets = this.restrictPublicBuckets?.toString().toXml("RestrictPublicBuckets") ?? ""

        return "<${eleName} ${namespace(isRoot)}>${blockPublicAcls}${ignorePublicAcls}" +
            "${blockPublicPolicy}${restrictPublicBuckets}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): PublicAccessBlockConfiguration {
        return PublicAccessBlockConfiguration(
            blockPublicAcls: ele.childContent("BlockPublicAcls")?.toBool(),
            ignorePublicAcls: ele.childContent("IgnorePublicAcls")?.toBool(),
            blockPublicPolicy: ele.childContent("BlockPublicPolicy")?.toBool(),
            restrictPublicBuckets: ele.childContent("BlockPublicPolicy")?.toBool(),
        )
    }
}
