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
public class S3Region <: ToString {
    // -----
    public static let CN_NORTH_1 = S3Region.of("cn-north-1")
    // public static let CN_NORTHWEST_1 = S3Region.of("cn-northwest-1")
    // public static let US_EAST_1 = S3Region.of("us-east-1")
    // public static let US_EAST_2 = S3Region.of("us-east-2")
    // public static let AWS_GLOBAL = S3Region.of("aws-global", true)
    // public static let AWS_CN_GLOBAL = S3Region.of("aws-cn-global", true)

    // public static let AP_SOUTH_2 = S3Region.of("ap-south-2")
    // public static let AP_SOUTH_1 = S3Region.of("ap-south-1")
    // public static let EU_SOUTH_1 = S3Region.of("eu-south-1")
    // public static let EU_SOUTH_2 = S3Region.of("eu-south-2")
    // public static let US_GOV_EAST_1 = S3Region.of("us-gov-east-1")
    // public static let ME_CENTRAL_1 = S3Region.of("me-central-1")
    // public static let IL_CENTRAL_1 = S3Region.of("il-central-1")
    // public static let CA_CENTRAL_1 = S3Region.of("ca-central-1")
    // public static let EU_CENTRAL_1 = S3Region.of("eu-central-1")
    // public static let US_ISO_WEST_1 = S3Region.of("us-iso-west-1")
    // public static let EU_CENTRAL_2 = S3Region.of("eu-central-2")
    // public static let US_WEST_1 = S3Region.of("us-west-1")
    // public static let US_WEST_2 = S3Region.of("us-west-2")
    // public static let AF_SOUTH_1 = S3Region.of("af-south-1")
    // public static let EU_NORTH_1 = S3Region.of("eu-north-1")
    // public static let EU_WEST_3 = S3Region.of("eu-west-3")
    // public static let EU_WEST_2 = S3Region.of("eu-west-2")
    // public static let EU_WEST_1 = S3Region.of("eu-west-1")
    // public static let AP_NORTHEAST_3 = S3Region.of("ap-northeast-3")
    // public static let AP_NORTHEAST_2 = S3Region.of("ap-northeast-2")
    // public static let AP_NORTHEAST_1 = S3Region.of("ap-northeast-1")
    // public static let ME_SOUTH_1 = S3Region.of("me-south-1")
    // public static let SA_EAST_1 = S3Region.of("sa-east-1")
    // public static let AP_EAST_1 = S3Region.of("ap-east-1")
    // public static let US_GOV_WEST_1 = S3Region.of("us-gov-west-1")
    // public static let AP_SOUTHEAST_1 = S3Region.of("ap-southeast-1")
    // public static let AP_SOUTHEAST_2 = S3Region.of("ap-southeast-2")
    // public static let US_ISO_EAST_1 = S3Region.of("us-iso-east-1")
    // public static let AP_SOUTHEAST_3 = S3Region.of("ap-southeast-3")
    // public static let AP_SOUTHEAST_4 = S3Region.of("ap-southeast-4")
    // public static let US_ISOB_EAST_1 = S3Region.of("us-isob-east-1")
    // public static let AWS_US_GOV_GLOBAL = S3Region.of("aws-us-gov-global", true)
    // public static let AWS_ISO_GLOBAL = S3Region.of("aws-iso-global", true)
    // public static let AWS_ISO_B_GLOBAL = S3Region.of("aws-iso-b-global", true)

    public static func of(id: String): S3Region {
        return of(id, false)
    }

    public static func of(id: String, isGlobal: Bool): S3Region {
        return S3Region(id, isGlobal)
    }

    // -----

    public let isGlobal: Bool
    public let id: String

    private init(id: String, isGlobal: Bool) {
        this.id = id
        this.isGlobal = isGlobal
    }

    public func toString(): String {
        return "S3Region(id=${id}, isGlobalRegion=${isGlobal})"
    }
}
