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

internal import std.collection.{ArrayList, HashMap, forEach}
internal import std.time.{DateTime}
internal import std.fs.{Path, File, OpenMode}
internal import stdx.log.{Logger, LogLevel}
internal import std.console.*

internal import s3client.*
internal import s3client.action.*
internal import s3client.core.*
internal import s3client.util.*

/*
 *
 * @author: wangwb
 * @date: 2023-12-14
 */
func loadConfig(): HashMap<String, String> {
    let config = HashMap<String, String>()
    let file = File("./_config.properties", OpenMode.Read)
    for (line in IOUtils.readLines(file)) {
        if (StringUtils.isBlank(line)) {
            continue
        }
        let kv = StringUtils.split(line, "=")
        config.add(StringUtils.trim(kv[0]), StringUtils.trim(kv[1]))
    }
    println(config)
    return config
}

let config = loadConfig()
public let accountId = config["accountId"]
public let ownerId = config["ownerId"]
public let role_arn = config["role_arn"]
public let accessKeyId = config["accessKeyId"]
public let secretAccessKey = config["secretAccessKey"]
public let bucket1 = "cj-test10" // NOTE: bucket requires: version 
public let bucket2 = "cj-test11" // NOTE: bucket requires: acl & version
public let bucket3 = "cj-async-test1"
public let bucket_lock = "cj-test3" // NOTE: bucket requires: acl & version & enable lock

public let bucket1_arn = "arn:aws-cn:s3:::" + bucket1
public let bucket2_arn = "arn:aws-cn:s3:::" + bucket2
public let objectId = "test-obj-01"
public let KNOWN_ISSUES_1 = "[KNOWN_ISSUES] Aws Sdk Java Client also cannot invoke successful! "

public func createS3Client(): S3Client {
    let s3 = S3Client.builder() //
        .anonymous().credentials("${accessKeyId}", "${secretAccessKey}") //
        .trailingChecksum(true) //
        // .region(S3Region.CN_NORTH_1) //
        // .addLoggingMetricPublisher() //
        // .httpClient(DefaultS3HttpClient.builder().setReadTimeout(Duration.second * 30).build()) //
        .
        build()
    println(S3Client.MODULE_INFO)
    println(s3.toString())
    return s3
}

public let s3 = createS3Client()

public func printTestCase(name: String): Unit {
    let separate = StringUtils.repeat("-", name.size + 10)
    let string = "\n${separate}\n     ${name}     \n${separate}"
    println(string)
}
