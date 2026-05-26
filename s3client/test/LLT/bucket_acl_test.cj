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
    let tester = BucketAclTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketAclTest {
    @TestCase
    public func testBucket_acl(): Unit {
        printTestCase("testBucket_acl")
        let policy = AccessControlPolicy(
            owner: Owner(id: ownerId),
            grants: ArrayList<Grant>(
                [
                    Grant(
                        permission: "FULL_CONTROL",
                        grantee: Grantee(id: ownerId, _type: "CanonicalUser")
                    )
                ]
            )
        )
        println(policy.toXml())
        let putReq = PutBucketAclRequest(
            bucket: bucket2,
            accessControlPolicy: policy
        )
        println(putReq)
        let putRsp = s3.putBucketAcl(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        let getReq = GetBucketAclRequest(bucket: bucket2)
        println(getReq)
        let getRsp = s3.getBucketAcl(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketAclAsync(getReq)
    }
}
