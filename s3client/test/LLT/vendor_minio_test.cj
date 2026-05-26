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
 * @date: 2024-02-01
 */

// EXEC: cjc %import-path %L %l %f 
// EXEC: ./main
main(): Int64 {
    let tester = MinioTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class MinioTest {
    @TestCase
    public func test(): Unit {
        try {
            _test()
        } catch (ex: Exception) {
            println(ToStringUtils.exceptionToString(ex))
            println("本地启动 MinIO 并修改 credentials")
        }
    }

    public func _test(): Unit {
        println("===== MinioTest =====")
        // MinIO: Version: RELEASE.2024-01-31T20-20-33Z
        let s3 = S3Client.builder() //
            .credentials("DxXnzPqzfWlU0XKWBCK3", "7rGzgiKaya5oBuRgKk4dlvnMGt36hZUpk9FOMlVB") //
            .
            endpoint("http://127.0.0.1:9000") //
                .forcePathStyle(true) //
                .trailingChecksum(false).build()

        s3.createBucket(CreateBucketRequest(bucket: "bucket-99"))
        let putObjRsp = s3.putObject(
            PutObjectRequest(bucket: "bucket-99", key: "oldsix"),
            S3Content.fromString("老六")
        )
        println(putObjRsp)

        let presignedReq = s3.presignGetObject(GetObjectRequest(bucket: "bucket-99", key: "oldsix"), Duration.day * 7)
        println(presignedReq.url)

        let httpRsp = ClientBuilder().build().get(presignedReq.url.toString())
        println(httpRsp)
        println("==== Get Object Body ====")
        println(IOUtils.copyToString(httpRsp.body))
    }
}
