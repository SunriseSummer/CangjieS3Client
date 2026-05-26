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
public class Tiering <: ToString {
    public Tiering(
        public let days!: Int32,
        public let accessTier!: String
    ) {
    }

    public func toString(): String {
        return "Tiering(days=${days}, accessTier=${accessTier})"
    }
}

// -----
//
// -----

extend Tiering <: S3XmlObject<Tiering> {
    public static prop ELE_NAME: String {
        get() {
            "Tiering"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let days = this.days.toString().toXml("Days",)
        let accessTier = this.accessTier.toXml("AccessTier")
        return "<${eleName}>${days}${accessTier}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): Tiering {
        return Tiering(
            days: ele.childContentRequired("Days").toInt32(),
            accessTier: ele.childContentRequired("AccessTier")
        )
    }
}
