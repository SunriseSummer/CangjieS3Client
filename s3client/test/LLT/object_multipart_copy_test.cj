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
    let tester = ObjectMultipartCopyTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class ObjectMultipartCopyTest {
    @TestCase
    public func testObject_multipart_copy(): Unit {
        printTestCase("testObject_multipart_copy")
        let fromObjectId = objectId
        let toObjectId = "cj_Multipart_copy"

        println("=> 1. Delete Object: ${toObjectId}")
        s3.deleteObject(DeleteObjectRequest(bucket: bucket2, key: toObjectId))

        println("=> 2. Abort MultipartUpload")
        let listReq = ListMultipartUploadsRequest(bucket: bucket2, maxUploads: 10)
        let listRsp = s3.listMultipartUploads(listReq)
        println(listRsp.responseMetadata)
        println(listRsp)
        for (upload in listRsp.uploads) {
            let abortReq = AbortMultipartUploadRequest(
                bucket: listRsp.bucket,
                key: upload.key,
                uploadId: upload.uploadId
            )
            println("=> 2.1 Abort MultipartUpload: ${upload.uploadId}")
            let abortRsp = s3.abortMultipartUpload(abortReq)
            println(abortRsp.responseMetadata)
            println(abortRsp)
        }

        let createReq = CreateMultipartUploadRequest(
            bucket: bucket2,
            key: toObjectId,
        )
        let createRsp = s3.createMultipartUpload(createReq)
        println(createRsp)

        //-----
        let copyReq = UploadPartCopyRequest(
            sourceBucket: bucket2,
            sourceKey: fromObjectId,
            destinationBucket: bucket2,
            destinationKey: toObjectId,
            uploadId: createRsp.uploadId,
            partNumber: 1
        )
        let copyRsp = s3.uploadPartCopy(copyReq)
        println(copyRsp)
        //-----

        let abortRsp = s3.abortMultipartUpload(
            AbortMultipartUploadRequest(
                bucket: bucket2,
                key: toObjectId,
                uploadId: createRsp.uploadId
            )
        )
    }
}
