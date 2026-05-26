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
public class CreateBucketConfiguration <: ToString {
    public CreateBucketConfiguration(public let locationConstraint!: String) {
    }

    public func toString(): String {
        return "CreateBucketConfiguration(locationConstraint=${locationConstraint})"
    }
}

// -----
//
// -----

extend CreateBucketConfiguration <: S3XmlObject<CreateBucketConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "CreateBucketConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let locationConstraint = this.locationConstraint.toXml("LocationConstraint")
        return "<${eleName} ${namespace(isRoot)}>${locationConstraint}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): CreateBucketConfiguration {
        return CreateBucketConfiguration(locationConstraint: ele.childContentRequired("LocationConstraint"))
    }
}
