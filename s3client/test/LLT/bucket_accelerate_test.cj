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
    let tester = BucketAccelerateTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketAccelerateTest {
    @TestCase
    public func testBucket_accelerate(): Unit {
        printTestCase("testBucket_accelerate")
        let config = AccelerateConfiguration(status: "Enabled")
        let putReq = PutBucketAccelerateConfigurationRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)

        // TODO JavaClient 也没调通
        try {
            let putRsp = s3.putBucketAccelerateConfiguration(putReq)
            println(putRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [putBucketAccelerateConfiguration]: ${ex}")
        }

        let rspXml = """
<AccelerateConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
 <Status>Enabled</Status>
</AccelerateConfiguration>
"""
        @Expect(AccelerateConfiguration.fromXml(S3XmlElement.fromXml(rspXml)).status == "Enabled")
        // TODO JavaClient 也没调通
        let getReq = GetBucketAccelerateConfigurationRequest(bucket: bucket1)
        println(getReq)
        try {
            let getRsp = s3.getBucketAccelerateConfiguration(getReq)
            println(getRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [getBucketAccelerateConfiguration]: ${ex}")
        }
    }
}
