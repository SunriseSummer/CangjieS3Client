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
 * @date: 2023-11-16
 */
public class S3SignerProperties {
    public let credentials: S3Credentials
    public let regionName: String
    public let serviceName: String
    public let signingInstant: DateTime
    public let credentialsScope: CredentialsScope
    public let isDoubleUrlEncode: Bool
    public let isNormalizePath: Bool
    public let authLocation: AuthLocation
    public let expirationDuration: ?Duration
    public let isPayloadSigningEnabled: Bool
    public let isChunkEncodingEnabled: Bool
    public let checksumAlgorithm: ?S3ChecksumAlgorithm
    public let resourcePath: ?String

    public init(
        credentials: S3Credentials,
        regionName: String,
        serviceName: String,
        signingInstant!: DateTime = DateTime.nowUTC(),
        isDoubleUrlEncode!: Bool = true,
        isNormalizePath!: Bool = true,
        authLocation!: AuthLocation = AuthLocation.HEADER,
        expirationDuration!: ?Duration = None,
        isPayloadSigningEnabled!: Bool = false,
        isChunkEncodingEnabled!: Bool = false,
        checksumAlgorithm!: ?S3ChecksumAlgorithm = None,
        resourcePath!: ?String = None
    ) {
        this.credentials = credentials
        this.regionName = regionName
        this.serviceName = serviceName
        this.signingInstant = signingInstant
        this.credentialsScope = CredentialsScope(regionName, serviceName, signingInstant)
        this.isDoubleUrlEncode = isDoubleUrlEncode
        this.isNormalizePath = isNormalizePath
        this.authLocation = authLocation
        this.expirationDuration = expirationDuration
        this.isPayloadSigningEnabled = isPayloadSigningEnabled
        this.isChunkEncodingEnabled = isChunkEncodingEnabled
        this.checksumAlgorithm = checksumAlgorithm
        this.resourcePath = resourcePath
    }
}

public enum AuthLocation <: ToString {
    HEADER | QUERY

    public prop name: String {
        get() {
            let name = match (this) {
                case HEADER => "HEADER"
                case QUERY => "QUERY"
            }
            return name
        }
    }

    public func toString(): String {
        return name
    }
}

// public class RegionSet <: ToString {
//     public static let GLOBAL = create("*")

//     public let regionSet: Set<String>
//     public let regionSetString: String

//     public static func create(value: String): RegionSet {
//         return create(ArrayList(StringUtils.split(value, ",")))
//     }

//     public static func create(regions: Collection<String>): RegionSet {
//         return RegionSet(regions)
//     }
//     private init(regions: Collection<String>) {
//         this.regionSet = HashSet<String>(regions)
//         this.regionSetString = StringUtils.join(regionSet, ",")
//     }
//     public func toString(): String {
//         return regionSetString
//     }
// }

public class CredentialsScope <: ToString {
    public let region: String
    public let service: String
    public let instant: DateTime

    public init(region: String, service: String, instant: DateTime) {
        this.region = region
        this.service = service
        this.instant = instant
    }

    public func date(): String {
        return instant.inUTC().format("yyyyMMdd")
    }

    public func dateTime(): String {
        return instant.inUTC().format("yyyyMMddTHHmmss") + "Z"
    }

    public func scope(): String {
        return date() + "/" + region + "/" + service + "/" + S3Constants.AWS4_TERMINATOR
    }

    public func scope(credentials: S3Credentials): String {
        return credentials.accessKeyId + "/" + scope()
    }

    public func toString(): String {
        return scope()
    }
}
