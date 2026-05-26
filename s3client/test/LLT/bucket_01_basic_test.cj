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
    let tester = BucketBasicTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        printTestCase("testBucket_basic")

        let createReq = CreateBucketRequest(bucket: "cj-101")
        println(createReq)
        let createRsp = s3.createBucket(createReq)
        println(createRsp)

        let deleteReq = DeleteBucketRequest(bucket: "cj-101")
        println(deleteReq)
        let deleteRsp = s3.deleteBucket(deleteReq)
        println(deleteRsp)

        let headReq = HeadBucketRequest(bucket: bucket1)
        println(headReq)
        let headRsp = s3.headBucket(headReq)
        println(headRsp)
        println(headRsp.responseMetadata)
        s3.headBucketAsync(headReq)

        let listReq = ListBucketsRequest()
        println(listReq)
        let listRsp = s3.listBuckets(listReq)
        println(listRsp)
        s3.listBucketsAsync(listReq)

        let getLocationReq = GetBucketLocationRequest(bucket: bucket1)
        println(getLocationReq)
        let getLocationRsp = s3.getBucketLocation(getLocationReq)
        println(getLocationRsp)
        s3.getBucketLocationAsync(getLocationReq)
    }
}
