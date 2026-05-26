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
    let tester = ObjectMultipartTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class ObjectMultipartTest {
    @TestCase
    public func testObject_multipart(): Unit {
        printTestCase("testObject_multipart")

        let objectId = "cj_Multipart"

        println("=> 1. Delete Object: ${objectId}")
        s3.deleteObject(DeleteObjectRequest(bucket: bucket2, key: objectId))

        println("=> 2. Abort MultipartUpload")
        let listReq = ListMultipartUploadsRequest(bucket: bucket2, maxUploads: 10)
        println(listReq)
        let listRsp = s3.listMultipartUploads(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
        for (upload in listRsp.uploads) {
            let abortReq = AbortMultipartUploadRequest(
                bucket: listRsp.bucket,
                key: upload.key,
                uploadId: upload.uploadId
            )
            println(abortReq)
            let abortRsp = s3.abortMultipartUpload(abortReq)
            println(abortRsp)
        }

        println("=> 3 Create MultipartUpload")
        let createReq = CreateMultipartUploadRequest(
            bucket: bucket2,
            key: objectId,
            checksumAlgorithm: "SHA256"
        )
        println(createReq)
        let createRsp = s3.createMultipartUpload(createReq)
        println(createRsp)

        let uploadId = createRsp.uploadId
        println("=> 4 Upload Part: ${uploadId}")
        let completedParts = ArrayList<CompletedPart>()
        for (i in 0..1) {
            let partNumber = Int32(i + 1)
            let uploadReq = UploadPartRequest(
                bucket: bucket2,
                key: objectId,
                uploadId: uploadId,
                partNumber: partNumber,
                checksumAlgorithm: "SHA256"
            )
            println(uploadReq)
            let data = StringUtils.repeat("A", 5) 
            let uploadRsp = s3.uploadPart(uploadReq, S3Content.fromString(data))
            println(uploadRsp)

            let completedPart = CompletedPart(
                partNumber: uploadReq.partNumber,
                etag: uploadRsp.etag,
                checksumSHA256: uploadRsp.checksumSHA256
            )
            completedParts.add(completedPart)
        }

        println("=> 5 List Part: ${uploadId}")
        let listPartsReq = ListPartsRequest(
            bucket: bucket2,
            key: objectId,
            uploadId: uploadId
        )
        println(listPartsReq)
        let listPartsRsp = s3.listParts(listPartsReq)
        println(listPartsRsp)

        println("=> 6 Complete Part: ${uploadId}")
        let completeReq = CompleteMultipartUploadRequest(
            bucket: bucket2,
            key: objectId,
            uploadId: uploadId,
            multipartUpload: CompletedMultipartUpload(parts: completedParts)
        )
        println(completeReq)
        let completeRsp = s3.completeMultipartUpload(completeReq)
        println(completeRsp)

        // ----- 插入一个 GetObjectAttributesRequest 的测试 -----
        println("")
        let getReq = GetObjectAttributesRequest(
            bucket: bucket2,
            key: objectId,
            objectAttributes: ArrayList<String>(
                [
                    "ETag",
                    "Checksum",
                    "ObjectParts",
                    "StorageClass",
                    "ObjectSize"
                ]
            )
        )
        println(getReq)
        let getRsp = s3.getObjectAttributes(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        // -----
    }
}
