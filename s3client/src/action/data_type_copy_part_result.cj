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
 * @date: 2023-12-18
 */
public class CopyPartResult <: ToString {
    public CopyPartResult(
        public let etag!: ?String = None,
        public let lastModified!: ?DateTime = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None
    ) {
    }

    public func toString(): String {
        return "CopyPartResult(" +
            "etag=${etag}, lastModified=${lastModified}, checksumCRC32=${checksumCRC32}, checksumCRC32C=${checksumCRC32C}, " +
            "checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}" + ")"
    }
}

// -----
//
// -----

extend CopyPartResult <: S3XmlObject<CopyPartResult> {
    public static prop ELE_NAME: String {
        get() {
            "CopyPartResult"
        }
    }

    public func toXml(_: String, _: Bool): String {
        throw UnsupportedException()
    }

    public static func fromXml(ele: S3XmlElement): CopyPartResult {
        return CopyPartResult(
            etag: ele.childContent("ETag"),
            lastModified: ele.childContent("LastModified")?.toDateIso8601(),
            checksumCRC32: ele.childContent("ChecksumCRC32"),
            checksumCRC32C: ele.childContent("ChecksumCRC32C"),
            checksumSHA1: ele.childContent("ChecksumSHA1"),
            checksumSHA256: ele.childContent("ChecksumSHA256")
        )
    }
}
