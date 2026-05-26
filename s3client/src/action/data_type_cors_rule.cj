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
 * @date: 2023-12-01
 */
public class CORSRule <: ToString {
    public CORSRule(
        public let id!: ?String = None,
        public let allowedHeaders!: ?ArrayList<String> = None,
        public let allowedMethods!: ?ArrayList<String> = None,
        public let allowedOrigins!: ?ArrayList<String> = None,
        public let exposeHeaders!: ?ArrayList<String> = None,
        public let maxAgeSeconds!: ?Int32 = None
    ) {
    }

    public func toString(): String {
        return "CORSRule(" +
            "id=${id}, allowedHeaders=${allowedHeaders}, allowedMethods=${allowedMethods}, allowedOrigins=${allowedOrigins}, " +
            "exposeHeaders=${exposeHeaders}, maxAgeSeconds=${maxAgeSeconds}" + ")"
    }
}

// -----
//
// -----

extend CORSRule <: S3XmlObject<CORSRule> {
    public static prop ELE_NAME: String {
        get() {
            "CORSRule"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let id = this.id?.toXml("ID") ?? ""
        let allowedHeaders = this.allowedHeaders?.toXml("AllowedHeader") ?? ""
        let allowedMethods = this.allowedMethods?.toXml("AllowedMethod") ?? ""
        let allowedOrigins = this.allowedOrigins?.toXml("AllowedOrigin") ?? ""
        let exposeHeaders = this.exposeHeaders?.toXml("ExposeHeader") ?? ""
        let maxAgeSeconds = this.maxAgeSeconds?.toString().toXml("MaxAgeSeconds") ?? ""
        return "<${eleName}>${allowedHeaders}${allowedMethods}${allowedOrigins}${exposeHeaders}${id}${maxAgeSeconds}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): CORSRule {
        return CORSRule(
            id: ele.childContent("ID"),
            allowedHeaders: ele.childsContents("AllowedHeader"),
            allowedMethods: ele.childsContents("AllowedMethod"),
            allowedOrigins: ele.childsContents("AllowedOrigin"),
            exposeHeaders: ele.childsContents("ExposeHeader"),
            maxAgeSeconds: ele.childContent("maxAgeSeconds")?.toInt32()
        )
    }
}
