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

package s3client.core

/*
 *
 * @author: wangwb
 * @date: 2023-11-13
 */
public enum S3ChecksumAlgorithm <: ToString {
    | ALGO_CRC32C
    | ALGO_CRC32
    | ALGO_MD5
    | ALGO_SHA256
    | ALGO_SHA1

    public static func nameOf(name: String): S3ChecksumAlgorithm {
        return match (name) {
            case "CRC32C" => ALGO_CRC32C
            case "CRC32" => ALGO_CRC32
            case "MD5" => ALGO_MD5
            case "SHA256" => ALGO_SHA256
            case "SHA1" => ALGO_SHA1
            case _ => throw IllegalArgumentException("Illegal algorithmId: ${name}")
        }
    }

    public prop name: String {
        get() {
            let name = match (this) {
                case ALGO_CRC32C => "CRC32C"
                case ALGO_CRC32 => "CRC32"
                case ALGO_MD5 => "MD5"
                case ALGO_SHA256 => "SHA256"
                case ALGO_SHA1 => "SHA1"
            }
            return name
        }
    }

    public func toString(): String {
        return "S3ChecksumAlgorithm(${name})"
    }
}

public interface S3Checksum {
    static func forAlgorithm(algorithm: String): S3Checksum {
        forAlgorithm(S3ChecksumAlgorithm.nameOf(algorithm))
    }

    static func forAlgorithm(algorithm: S3ChecksumAlgorithm): S3Checksum {
        match (algorithm) {
            case ALGO_MD5 => MD5Checksum()
            case ALGO_SHA256 => SHA256Checksum()
            case ALGO_SHA1 => SHA1Checksum()
            case _ => throw UnsupportedException("Unsupported checksum: ${algorithm}")
        }
    }

    prop algorithm: S3ChecksumAlgorithm
    func reset(): S3Checksum
    func update(bytes: Array<Byte>): S3Checksum
    // 返回 ChecksumBytes
    func result(): Array<Byte>

    func resultAsBase64(): String {
        return toBase64String(result())
    }

    func update(input: InputStream): S3Checksum {
        IOUtils.readAndDo(input) {bytes => update(bytes)}
        return this
    }

    func update(content: S3Content): S3Checksum {
        try {
            update(content.stream())
        } finally {
            content.close()
        }
        return this
    }
}
