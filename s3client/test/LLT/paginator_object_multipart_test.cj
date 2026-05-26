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
    let tester = PaginatorObjectMultipartTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class PaginatorObjectMultipartTest {
    @TestCase
    public static func testObject_multipart_paginator(): Unit {
        printTestCase("testObject_multipart_paginator")

        let bucket = bucket3
        let objectId = "cj_Multipart2"
       
        println("=> 0. Abort MultipartUpload")
        let listReq = ListMultipartUploadsRequest(bucket: bucket, maxUploads: 10)
        let listRsp = s3.listMultipartUploads(listReq)
        for (upload in listRsp.uploads) {
            let abortReq = AbortMultipartUploadRequest(
                bucket: listRsp.bucket,
                key: upload.key,
                uploadId: upload.uploadId
            )
            let abortRsp = s3.abortMultipartUpload(abortReq)
        }

        println("=> 1. Delete Object: ${objectId}")
        s3.deleteObject(DeleteObjectRequest(bucket: bucket, key: objectId))

        println("=> 2. Create MultipartUpload")
        let createReq = CreateMultipartUploadRequest(
            bucket: bucket,
            key: objectId,
            checksumAlgorithm: "SHA256"
        )
        let createRsp = s3.createMultipartUpload(createReq)
        let uploadId = createRsp.uploadId
        println("=> 3. Upload Parts with uploadId: ${uploadId}")
        let completedParts = ArrayList<CompletedPart>()
        for (i in 0..1) {
            let partNumber = Int32(i + 1)
            let uploadReq = UploadPartRequest(
                bucket: bucket,
                key: objectId,
                uploadId: uploadId,
                partNumber: partNumber,
                checksumAlgorithm: "SHA256"
            )
            let data = StringUtils.repeat("A", 10) 
            let uploadRsp = s3.uploadPart(uploadReq, S3Content.fromString(data))
            let completedPart = CompletedPart(
                partNumber: uploadReq.partNumber,
                etag: uploadRsp.etag,
                checksumSHA256: uploadRsp.checksumSHA256
            )
            completedParts.add(completedPart)
        }

        // ----------------------------
        println("=====> listMultipartUploadsPaginator.sync")
        let iterRsp = s3.listMultipartUploadsPaginator(ListMultipartUploadsRequest(bucket: bucket, maxUploads: 1))
        iterRsp |> forEach<ListMultipartUploadsResponse> {rsp => println(rsp)}

        println("=====> listMultipartUploadsPaginator.async")
        iterRsp.iterator().subscribe() {
            rsp, ex =>
            let isContinue = match (rsp) {
                case Some(v) =>
                    println(v)
                    true
                case None =>
                    println(ex)
                    false
            }
            return isContinue
        }
        sleep(Duration.second*1)

        println("=====> listPartsPaginator.sync")
        let iterRsp2 = s3.listPartsPaginator(
            ListPartsRequest(bucket: bucket, key: objectId, uploadId: uploadId, maxParts: 1))
        iterRsp2 |> forEach<ListPartsResponse> {rsp => println(rsp)}
        
        println("=====> listPartsPaginator.async")
        iterRsp2.iterator().subscribe() {
            rsp, ex =>
            let isContinue = match (rsp) {
                case Some(v) =>
                    println(v)
                    true
                case None =>
                    println(ex)
                    false
            }
            return isContinue
        }

        sleep(Duration.second*5)
        // ------------------------------

        println("=> 4. Complete MultipartUpload: ${uploadId}")
        let completeReq = CompleteMultipartUploadRequest(
            bucket: bucket,
            key: objectId,
            uploadId: uploadId,
            multipartUpload: CompletedMultipartUpload(parts: completedParts)
        )
        let completeRsp = s3.completeMultipartUpload(completeReq)
    }
}
