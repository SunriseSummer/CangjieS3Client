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
    let tester = BucketMetricsTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketMetricsTest {
    @TestCase
    public func testBucket_metrics(): Unit {
        printTestCase("testBucket_metrics")
        let id = "id_01"
        let configuration = MetricsConfiguration(
            id: id,
            filter: MetricsFilter(
                and: MetricsAndOperator(
                    prefix: "documents",
                    tags: ArrayList<Tag>(
                        [
                            Tag(key: "priority", value: "high"),
                            Tag(key: "class", value: "blue")
                        ]
                    )
                )
            )
        )
        println(configuration.toXml())

        let putReq = PutBucketMetricsConfigurationRequest(
            bucket: bucket1,
            id: id,
            configuration: configuration
        )
        println(putReq)
        let putRsp = s3.putBucketMetricsConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        let getReq = GetBucketMetricsConfigurationRequest(
            bucket: bucket1,
            id: id
        )
        println(getReq)
        let getRsp = s3.getBucketMetricsConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketMetricsConfigurationAsync(getReq)

        let listReq = ListBucketMetricsConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketMetricsConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
        s3.listBucketMetricsConfigurationsAsync(listReq)

        let delReq = DeleteBucketMetricsConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketMetricsConfiguration(delReq)
        println(delRsp)
        s3.deleteBucketMetricsConfigurationAsync(delReq)
    }
}
