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
 * @date: 2023-11-09
 */
class S3SignerUtils {
    private static let SIGNING_KEY_CACHE = ConcurrentHashMap<String, (Int64, Array<Byte>)>()

    public static func deriveSigningKey(
        credentials: S3Credentials,
        credentialsScope: CredentialsScope
    ): Array<Byte> {
        // 按照这个cache key的逻辑, 缓存的数据应该是不多的 (可能一直只有一个), 所以没有做逐出的操作
        let cacheKey = credentials.secretAccessKey + "/" + credentialsScope.region + "/" + credentialsScope.service
        let cacheValue = SIGNING_KEY_CACHE.get(cacheKey)
        let days = credentialsScope.instant.toUnixTimeStamp().toDays()
        match (cacheValue) {
            case Some(v) => if (v[0] == days) {
                return v[1]
            }
            case None => ()
        }
        let kSecret = StringUtils.toByteArray("AWS4" + credentials.secretAccessKey)
        let kDate = S3SignerUtils.hmacSha256(credentialsScope.date(), kSecret)
        let kRegion = S3SignerUtils.hmacSha256(credentialsScope.region, kDate)
        let kService = S3SignerUtils.hmacSha256(credentialsScope.service, kRegion)
        let signingKey = S3SignerUtils.hmacSha256(S3Constants.AWS4_TERMINATOR, kService)
        SIGNING_KEY_CACHE.add(cacheKey, (days, signingKey))
        return signingKey
    }

    public static func sha256(data: String): Array<Byte> {
        return DigestUtils.digest(DigestAlgorithm.ALGO_SHA256, StringUtils.toByteArray(data))
    }

    public static func sha256AsHex(data: String): String {
        return toHexString(sha256(data))
    }

    public static func hmacSha256(data: String, key: Array<Byte>): Array<Byte> {
        return DigestUtils.digest(DigestAlgorithm.ALGO_HMAC_SHA256(key), StringUtils.toByteArray(data))
    }

    public static func hmacSha256AsHex(data: String, key: Array<Byte>): String {
        return toHexString(hmacSha256(data, key))
    }
}
