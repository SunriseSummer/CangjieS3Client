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
    let tester = BucketInventoryTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketInventoryTest {
    @TestCase
    public func testBucket_inventory(): Unit {
        printTestCase("testBucket_inventory")
        let id = "report_1"
        let config = InventoryConfiguration(
            id: id,
            isEnabled: true,
            includedObjectVersions: "All",
            filter: InventoryFilter(prefix: "filterPrefix"),
            schedule: InventorySchedule(frequency: "Daily"),
            destination: InventoryDestination(
                s3BucketDestination: InventoryS3BucketDestination(
                    accountId: accountId,
                    bucket: bucket1_arn,
                    format: "CSV",
                    prefix: "prefix1",
                    encryption: InventoryEncryption(
                        ssekms: SSEKMS(
                            keyId: "arn:aws:kms:uswest-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab")
                    )
                )
            ),
            optionalFields: ArrayList<String>(["Size", "LastModifiedDate"])
        )
        let xml = config.toXml()
        println(xml)
        let putReq = PutBucketInventoryConfigurationRequest(
            bucket: bucket1,
            id: id,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketInventoryConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)

        println(InventoryConfiguration.fromXml(S3XmlElement.fromXml(xml)))

        let getReq = GetBucketInventoryConfigurationRequest(
            bucket: bucket1,
            id: id
        )
        println(getReq)
        let getRsp = s3.getBucketInventoryConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketInventoryConfigurationAsync(getReq)

        let listReq = ListBucketInventoryConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketInventoryConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
        s3.listBucketInventoryConfigurationsAsync(listReq)

        let delReq = DeleteBucketInventoryConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketInventoryConfiguration(delReq)
        println(delRsp)
        s3.deleteBucketInventoryConfigurationAsync(delReq)
    }
}
