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
    let tester = BucketNotificationTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class BucketNotificationTest {
    @TestCase
    public func testBucket_notification(): Unit {
        printTestCase("testBucket_notification")
        let config1 = NotificationConfiguration(
            topicConfigurations: ArrayList<TopicConfiguration>(
                [
                    TopicConfiguration(
                        id: "id555",
                        topicArn: "arn:aws-cn:sns:cn-north-1:444455556666:s3notificationtopic",
                        events: ArrayList<String>(["s3:ObjectCreated:Put", "s3:ObjectCreated:Post"]),
                        filter: NotificationConfigurationFilter(
                            key: S3KeyFilter(
                                filterRules: ArrayList<FilterRule>(
                                    [
                                        FilterRule(name: "prefix", value: "images/"),
                                        FilterRule(name: "suffix", value: "jpg")
                                    ]
                                )
                            )
                        )
                    )
                ]
            ),
            queueConfigurations: ArrayList<QueueConfiguration>(
                [
                    QueueConfiguration(
                        id: "id666",
                        queueArn: "arn:aws-cn:sqs:cn-north-1:444455556666:s3notificationqueue",
                        events: ArrayList<String>(["s3:ObjectRemoved:DeleteMarkerCreated"])
                    )
                ]
            ),
            lambdaFunctionConfigurations: ArrayList<LambdaFunctionConfiguration>(
                [
                    LambdaFunctionConfiguration(
                        id: "id777",
                        lambdaFunctionArn: "arn:aws-cn:lambda:cn-north-1:444455556666:function:s3notificationlambda",
                        events: ArrayList<String>(["s3:Replication:*"])
                    )
                ]
            ),
        )
        println(config1.toXml())

        let putReq = PutBucketNotificationConfigurationRequest(
            bucket: bucket1,
            configuration: config1
        )
        println(putReq)
        // TODO JavaClient 也没调通, 需要指定的资源确实存在
        try {
            let putRsp = s3.putBucketNotificationConfiguration(putReq)
            println(putRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [putBucketNotificationConfiguration]: ${ex}")
        }

        let config2Xml = """
            <NotificationConfiguration>
            <CloudFunctionConfiguration>
            <Id>ObjectCreatedEvents</Id>
            <CloudFunction>arn:aws:lambda:us-west-2:356671443308:function:CreateThumbnail</CloudFunction>
            <Event>s3:ObjectCreated:*</Event>
            </CloudFunctionConfiguration>
            </NotificationConfiguration>
        """

        let config2 = NotificationConfiguration.fromXml(S3XmlElement.fromXml(config2Xml))
        println(config2)

        let getReq = GetBucketNotificationConfigurationRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketNotificationConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        s3.getBucketNotificationConfigurationAsync(getReq)
    }
}
