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
import std.core.{Duration}
import std.time.{DateTime}
import std.unittest.*
import std.unittest.testmacro.*
import s3client.*
import s3client.action.*
import s3client.core.*
import s3client.util.*
import std.unittest.*
import std.unittest.testmacro.*

/*
 *
 * @author: wangwb
 * @date: 2024-03-27
 */

// EXEC: cjc %import-path %L %l %f
// EXEC: ./main
main(): Int64 {
    let tester = XmlParseTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class XmlParseTest {
    // @TestCase
    // public func test_sax_parse(): Unit {
    //     let beginTime = DateTime.nowUTC()
    //     let xml = xml()
    //     print(S3XmlElement.fromXml(xml, parser: S3XmlElement.PARSER_SAX))
    //     for (_ in 0..100) {
    //         let ele = S3XmlElement.fromXml(xml, parser: S3XmlElement.PARSER_SAX)
    //     }
    //     println("===== XmlParse (Sax): ${DateTime.nowUTC() - beginTime}")
    // }

    @TestCase
    public func test_simple_parse(): Unit {
        let beginTime = DateTime.nowUTC()
        let xml = xml()
        print(S3XmlElement.fromXml(xml, parser: S3XmlElement.PARSER_SIMPLE))
        for (_ in 0..100) {
            let ele = S3XmlElement.fromXml(xml, parser: S3XmlElement.PARSER_SIMPLE)
        }
        println("===== XmlParse (Simple): ${DateTime.nowUTC() - beginTime}")
    }
}

func xml(): String {
    let contents = StringBuilder();
    for (i in 0..100) {
        contents.append(
            """
<Contents>
    <Key>mock_key_${i}</Key>
    <LastModified>2024-03-22T08:04:59.000Z</LastModified>
    <ETag>&quot;1d0f249c316092c34288a77d779eeaba-${i}&quot;</ETag>
    <ChecksumAlgorithm>SHA256</ChecksumAlgorithm>
    <Size>5</Size>
    <StorageClass>STANDARD</StorageClass>
</Contents>
""")
    }
    return """
<ListBucketResult
    xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
    <Name>cj-test11</Name>
    <Prefix></Prefix>
    <KeyCount>100</KeyCount>
    <MaxKeys>100</MaxKeys>
    <IsTruncated>false</IsTruncated>
    ${contents}
</ListBucketResult>
"""
}
