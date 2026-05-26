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
    let tester = BucketLoggingTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketLoggingTest {
    @TestCase
    public func testBucket_logging(): Unit {
        printTestCase("testBucket_logging")

        let getReq = GetBucketLoggingRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketLogging(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)

        let loggingStatus = LoggingStatus(
            loggingEnabled: LoggingEnabled(
                targetBucket: bucket1,
                targetPrefix: "cj-test1-access_log-"
                // targetGrants: ArrayList<TargetGrant>(
                //     [
                //         TargetGrant(
                //             permission: "READ",
                //             grantee: Grantee(
                //                 _type: "AmazonCustomerByEmail",
                //                 emailAddress: "user@company.com"
                //             )
                //         )
                //     ]
                // )
            )
        )
        println(loggingStatus.toXml())
        let putReq = PutBucketLoggingRequest(
            bucket: bucket1,
            loggingStatus: loggingStatus
        )
        println(putReq)
        let putRsp = s3.putBucketLogging(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        let getRsp2 = s3.getBucketLogging(GetBucketLoggingRequest(bucket: bucket1))
        println(getRsp2)
        println(getRsp2.responseMetadata)
        s3.getBucketLoggingAsync(GetBucketLoggingRequest(bucket: bucket1))
    }
}
