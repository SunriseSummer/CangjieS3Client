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

import std.unittest.*
import std.unittest.testmacro.*

/*
 *
 * @author: wangwb
 * @date: 2024-01-12
 */

// DEPENDENCE: _config.cj _config.properties
// EXEC: cjc %import-path %L %l %f _config.cj _config.properties
// EXEC: ./main
main(): Int64 {
    let tester = BucketCorsTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketCorsTest {
    @TestCase
    public func testBucket_cors(): Unit {
        printTestCase("testBucket_cors")
        let corsRules = [
            CORSRule(
                allowedMethods: ArrayList<String>(["PUT", "GET"]),
                allowedOrigins: ArrayList<String>(["http://example.com"])
            )
        ]
        let putReq = PutBucketCorsRequest(
            bucket: bucket1,
            configuration: CORSConfiguration(corsRules: ArrayList<CORSRule>(corsRules))
        )
        println(putReq)
        let putRsp = s3.putBucketCors(putReq)
        println(putRsp)

        let getReq = GetBucketCorsRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketCors(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketCorsAsync(getReq)

        let delReq = DeleteBucketCorsRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketCors(delReq)
        println(delRsp)
        s3.deleteBucketCorsAsync(delReq)
    }
}
