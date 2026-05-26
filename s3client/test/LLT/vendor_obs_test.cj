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
import std.unittest.*
import std.unittest.testmacro.*
import std.time.{DateTime, TimeZone}
import std.collection.{ArrayList, HashMap, forEach}
import stdx.net.http.{ClientBuilder, HttpRequestBuilder, Client, HttpRequest, HttpResponse, HttpHeaders, Protocol, 
    HttpStatusCode}
import stdx.net.tls.*
import s3client.*
import s3client.action.*
import s3client.core.*
import s3client.util.*

import std.unittest.*
import std.unittest.testmacro.*

/*
 *
 * @author: wangwb
 * @date: 2024-02-06
 */

// EXEC: cjc %import-path %L %l %f 
// EXEC: ./main
main(): Int64 {
    let tester = ObsTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class ObsTest {
    @TestCase
    public func test(): Unit {
        try {
            _test()
        } catch (ex: Exception) {
            println(ToStringUtils.exceptionToString(ex))
            println("修改 credentials")
        }
    }

    public func _test(): Unit {
        println("===== ObsTest =====")
        let s3 = S3Client.builder() //
            .credentials("KOY6YMZKO70ZF3XO324E", "E2bYQFSlhXtMWee4YEPcpB4oxeaZ2K5Bms296B9o") //
            .endpoint("https://obs.cn-east-3.myhuaweicloud.com") //
            .region(
            S3Region.of("cn-east-3")) // 必需设置
                .signer(S3Signer.v4()) // v2/v4 都支持
                .trailingChecksum(false) //
                .build()
        print(s3)
        s3.createBucket(CreateBucketRequest(bucket: "bucket-99"))
        let putObjRsp = s3.putObject(
            PutObjectRequest(
                bucket: "bucket-99",
                key: "oldsix",
                checksumAlgorithm: "MD5"
            ),
            S3Content.fromString("老六")
        )
        println(putObjRsp)
        println(putObjRsp.responseMetadata)

        println("--- getobject ---")
        let getRsp = s3.getObject(GetObjectRequest(bucket: "bucket-99", key: "oldsix"))[0]
        println(getRsp)
        println(getRsp.responseMetadata)

        println("--- presign ---")
        let presignedReq = s3.presignGetObject(GetObjectRequest(bucket: "bucket-99", key: "oldsix"), Duration.day * 7)
        println(presignedReq.url)

        var tlsCfg = TlsClientConfig()
        tlsCfg.verifyMode = TrustAll
        let httpClient = ClientBuilder().tlsConfig(tlsCfg).build()
        let httpReq = HttpRequestBuilder() //
            .method(presignedReq.method) //
            .url(presignedReq.url) //
            .setHeaders(
            presignedReq.headers) //
                .build()
        let httpRsp = httpClient.send(httpReq)
        println(httpRsp)
        println("==== Get Object Body ====")
        println(IOUtils.copyToString(httpRsp.body))
    }
}
