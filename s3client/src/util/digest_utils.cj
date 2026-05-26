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

package s3client.util

/*
 *
 * @author: wangwb
 * @date: 2023-11-17
 */
public class DigestUtils {
    public static func digestAsHex(algorithm: DigestAlgorithm, data: Array<Byte>): String {
        return toHexString(digest(algorithm, data))
    }

    public static func digestAsBase64(algorithm: DigestAlgorithm, data: Array<Byte>): String {
        return toBase64String(digest(algorithm, data))
    }

    public static func digest(algorithm: DigestAlgorithm, data: Array<Byte>): Array<Byte> {
        return getDigest(algorithm)(data)
    }

    private static func getDigest(algorithm: DigestAlgorithm): (Array<Byte>) -> Array<Byte> {
        match (algorithm) {
            case ALGO_HMAC_MD5(key) =>  {
                data => 
                let d = HMAC(key, HashType.MD5)
                d.write(data)
                return d.finish()
                
            }
            case ALGO_HMAC_SHA256(key) => {
                data =>
                let d = HMAC(key, HashType.SHA256)
                d.write(data)
                return d.finish()
            }
            case ALGO_HMAC_SHA1(key) =>  {
                data =>
                let d = HMAC(key, HashType.SHA1)
                d.write(data)
                return d.finish()
            }
            case ALGO_MD5 => {
                data =>
                let d = MD5()
                d.write(data)
                return d.finish()
            }
            case ALGO_SHA256 =>  {
                data =>
                let d = SHA256()
                d.write(data)
                return d.finish()
            }
            case ALGO_SHA1 => {
                data =>
                let d = SHA1()
                d.write(data)
                return d.finish()
            }
        }
    }
}

public enum DigestAlgorithm <: ToString {
    | ALGO_HMAC_MD5(Array<Byte>)
    | ALGO_HMAC_SHA256(Array<Byte>)
    | ALGO_HMAC_SHA1(Array<Byte>)
    | ALGO_MD5
    | ALGO_SHA256
    | ALGO_SHA1

    public prop name: String {
        get() {
            let name = match (this) {
                case ALGO_HMAC_MD5(_) => "HMAC_MD5"
                case ALGO_HMAC_SHA256(_) => "HMAC_SHA256"
                case ALGO_HMAC_SHA1(_) => "HMAC_SHA1"
                case ALGO_MD5 => "MD5"
                case ALGO_SHA256 => "SHA256"
                case ALGO_SHA1 => "SHA1"
            }
            return name
        }
    }

    public func toString(): String {
        return name
    }
}
