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
public class GetObjectAttributesParts <: ToString {
    public GetObjectAttributesParts(
        public let totalPartsCount!: ?Int32 = None,
        public let partNumberMarker!: ?Int32 = None,
        public let nextPartNumberMarker!: ?Int32 = None,
        public let maxParts!: ?Int32 = None,
        public let isTruncated!: ?Bool = None,
        public let parts!: ?ArrayList<ObjectPart> = None
    ) {
    }

    public func toString(): String {
        return "GetObjectAttributesParts(" +
            "totalPartsCount=${totalPartsCount}, partNumberMarker=${partNumberMarker}, nextPartNumberMarker=${nextPartNumberMarker}, maxParts=${maxParts}, " +
            "isTruncated=${isTruncated}, parts=${parts}" + ")"
    }
}

// -----
//
// -----

extend GetObjectAttributesParts <: S3XmlObject<GetObjectAttributesParts> {
    public static prop ELE_NAME: String {
        get() {
            "ObjectParts"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): GetObjectAttributesParts {
        return GetObjectAttributesParts(
            totalPartsCount: ele.childContent("PartsCount")?.toInt32(),
            partNumberMarker: ele.childContent("PartNumberMarker")?.toInt32(),
            nextPartNumberMarker: ele.childContent("NextPartNumberMarker")?.toInt32(),
            maxParts: ele.childContent("MaxParts")?.toInt32(),
            isTruncated: ele.childContent("IsTruncated")?.toBool(),
            parts: ele.childs(ObjectPart.ELE_NAME, ObjectPart.fromXml)
        )
    }
}
