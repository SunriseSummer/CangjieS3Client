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
    let tester = BucketPolicyTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketPolicyTest {
    @TestCase
    public func testBucket_policy(): Unit {
        printTestCase("testBucket_policy")
        let policy = """
{
    "Version": "2008-10-17",
    "Id": "aaaa-bbbb-cccc-dddd",
    "Statement": [
        {
            "Effect": "Allow",
            "Sid": "1",
            "Principal": {
                "AWS": [
                    "${accountId}"
                ]
            },
            "Action": [
                "s3:*"
            ],
            "Resource": "${bucket1_arn}"
        }
    ]
}
        """
        let putReq = PutBucketPolicyRequest(
            bucket: bucket1,
            policy: policy
        )
        println(putReq)
        let putRsp = s3.putBucketPolicy(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        let getReq = GetBucketPolicyRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketPolicy(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)

        let getReq2 = GetBucketPolicyStatusRequest(bucket: bucket1)
        println(getReq2)
        let getRsp2 = s3.getBucketPolicyStatus(getReq2)
        println(getRsp2)
        println(getRsp2.responseMetadata)

        let delReq = DeleteBucketPolicyRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketPolicy(delReq)
        println(delRsp)
    }
}
