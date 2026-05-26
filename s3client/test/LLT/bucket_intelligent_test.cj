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
    let tester = BucketIntelligentTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketIntelligentTest {
    @TestCase
    public func testBucket_intelligent(): Unit {
        printTestCase("testBucket_intelligent")
        let id = "config_1"
        let config = IntelligentTieringConfiguration(
            id: id,
            status: "Enabled",
            tierings: ArrayList<Tiering>([Tiering(days: 100, accessTier: "ARCHIVE_ACCESS")])
        )
        let putReq = PutBucketIntelligentTieringConfigurationRequest(
            id: id,
            bucket: bucket1,
            configuration: config
        )
        println(config.toXml())
        println(putReq)
        let putRsp = s3.putBucketIntelligentTieringConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        let getReq = GetBucketIntelligentTieringConfigurationRequest(bucket: bucket1, id: id)
        println(getReq)
        let getRsp = s3.getBucketIntelligentTieringConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketIntelligentTieringConfigurationAsync(getReq)

        let listReq = ListBucketIntelligentTieringConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketIntelligentTieringConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
        s3.listBucketIntelligentTieringConfigurationsAsync(listReq)

        let delReq = DeleteBucketIntelligentTieringConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketIntelligentTieringConfiguration(delReq)
        println(delRsp)
        s3.deleteBucketIntelligentTieringConfigurationAsync(delReq)
    }
}
