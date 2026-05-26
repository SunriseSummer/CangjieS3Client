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
public class CompletedMultipartUpload <: ToString {
    public CompletedMultipartUpload(public let parts!: ArrayList<CompletedPart>) {
    }

    public func toString(): String {
        return "CompletedMultipartUpload(parts=${parts})"
    }
}

public class CompletedPart <: ToString {
    public CompletedPart(
        public let etag!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let partNumber!: ?Int32 = None
    ) {
    }

    public func toString(): String {
        return "CompletedPart(" +
            "etag=${etag}, checksumCRC32=${checksumCRC32}, checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, " +
            "checksumSHA256=${checksumSHA256}, partNumber=${partNumber}" + //
                ")"
    }
}

// -----
//
// -----

extend CompletedMultipartUpload <: S3XmlObject<CompletedMultipartUpload> {
    public static prop ELE_NAME: String {
        get() {
            "CompleteMultipartUpload"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let parts = this.parts |> map<CompletedPart, String> {part => part.toXml()} |> collectString<String>()
        return "<${eleName} ${namespace(isRoot)}>${parts}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): CompletedMultipartUpload {
        throw UnsupportedException()
    }
}

extend CompletedPart <: S3XmlObject<CompletedPart> {
    public static prop ELE_NAME: String {
        get() {
            "Part"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let etag = this.etag?.toXml("ETag") ?? ""
        let checksumCRC32 = this.checksumCRC32?.toXml("ChecksumCRC32") ?? ""
        let checksumCRC32C = this.checksumCRC32C?.toXml("ChecksumCRC32C") ?? ""
        let checksumSHA1 = this.checksumSHA1?.toXml("ChecksumSHA1") ?? ""
        let checksumSHA256 = this.checksumSHA256?.toXml("ChecksumSHA256") ?? ""
        let partNumber = this.partNumber?.toString().toXml("PartNumber") ?? ""
        return "<${eleName}>${etag}${checksumCRC32}${checksumCRC32C}${checksumSHA1}" +
            "${checksumSHA256}${partNumber}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): CompletedPart {
        throw UnsupportedException()
    }
}
