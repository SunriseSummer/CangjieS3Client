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
    let tester = ObjectBasicTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class ObjectBasicTest {
    @TestCase
    public func prepare_delete_all_versions(): Unit {
        let iterRsp = s3.listObjectVersionsPaginator(ListObjectVersionsRequest(bucket: bucket2, maxKeys: 1))
        for (rsp in iterRsp) {
            match (rsp.versions) {
                case None => ()
                case Some(versions) => for (version in versions) {
                    let key = version.key.getOrThrow()
                    let versionId = version.versionId

                    let delReq = DeleteObjectRequest(
                        bucket: bucket2,
                        key: key,
                        versionId: versionId
                    )
                    println("*** DELETE OBJECT: ${bucket2}, ${key}, ${versionId}")
                    s3.deleteObject(delReq)
                }
            }
        }
    }

    @TestCase
    public func testObject_basic(): Unit {
        printTestCase("testObject_basic")
        S3Content.fromString("""
老六
Old Six
==========
""").toFile("./object.txt", true)
        let key = IdUtils.id()
        let putReq = PutObjectRequest(
            bucket: bucket1,
            key: key,
            expires: DateTime.nowUTC(),
            checksumAlgorithm: "SHA1",
            metadata: HashMap([("k1", "v1"), ("k2", "v2")])
        )
        println(putReq)
        let putObjectRsp = s3.putObject(
            putReq,
            S3Content.fromFile("./object.txt")
        )
        println("=== PutObject(key=${key})")
        println(putObjectRsp)
        println(putObjectRsp.responseMetadata)

        let headReq = HeadObjectRequest(
            bucket: bucket1,
            key: key
        )
        println(headReq)
        let headRsp = s3.headObject(headReq)
        println(headRsp)
        println(headRsp.responseMetadata)

        let listReq = ListObjectsRequest(bucket: bucket1, maxKeys: 1)
        println(listReq)
        let listRsp = s3.listObjects(listReq)
        println(listRsp)

        let listReqV2 = ListObjectsV2Request(bucket: bucket1, maxKeys: 1)
        println(listReqV2)
        let listRspV2 = s3.listObjectsV2(listReqV2)
        println(listRspV2)

        let delReq = DeleteObjectRequest(
            bucket: bucket1,
            key: key
        )
        println(delReq)
        let delRsp = s3.deleteObject(delReq)
        println(delRsp)
        println(delRsp.responseMetadata)

        // -----
        try {
            let headRsp = s3.headObject(HeadObjectRequest(bucket: bucket2, key: objectId))
        } catch (ex: Exception) {
            let putObjectRsp = s3.putObject(
                PutObjectRequest(
                    bucket: bucket2,
                    key: objectId,
                    expires: DateTime.nowUTC() + Duration.day * 365,
                    checksumAlgorithm: "SHA1"
                ),
                S3Content.fromString("Old Six")
            )
        }

        let getReq = GetObjectRequest(
            bucket: bucket2,
            key: objectId
        )
        println(getReq)
        s3.getObject(
            getReq,
            {
                getRsp, rspBody =>
                rspBody.toFile("./tmp/${objectId}.txt", true)
                println(getRsp.responseMetadata)
                println(getRsp)
            }
        )
    }

    @TestCase
    public func testObject_delete_batch(): Unit {
        printTestCase("testObject_delete_batch")
        let delReq = DeleteObjectsRequest(
            bucket: bucket1,
            delete: Delete(
                objects: ArrayList<ObjectIdentifier>(
                    [
                        ObjectIdentifier(key: "eeb4e50e-23da-443c-b55a-fb7c3ea21b6a"),
                        ObjectIdentifier(key: "1")
                    ]
                )
            )
        )
        println(delReq)
        let delRsp = s3.deleteObjects(delReq)
        println(delRsp)
    }

    @TestCase
    public func testObject_copy(): Unit {
        printTestCase("testObject_copy")
        let copyReq = CopyObjectRequest(
            destinationBucket: bucket1,
            destinationKey: "cj-copy",
            sourceBucket: bucket2,
            sourceKey: objectId
        )
        println(copyReq)
        let copyRsp = s3.copyObject(copyReq)
        println(copyRsp)
    }

    @TestCase
    public func testObject_restore(): Unit {
        printTestCase("testObject_restore")
        let restoreReq = RestoreObjectRequest(
            bucket: bucket2,
            key: objectId,
            restoreRequest: RestoreRequest(
                days: 2,
                glacierJobParameters: GlacierJobParameters(tier: "Expedited")
            )
        )
        println(restoreReq)
        try {
            let restoreRsp = s3.restoreObject(restoreReq)
            println(restoreRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [restoreObject]: ${ex}")
        }

        // ----
        let restoreRequest = RestoreRequest(
            days: 2,
            glacierJobParameters: GlacierJobParameters(tier: "Expedited"),
            _type: "_type",
            tier: "tier",
            selectParameters: SelectParameters(
                expressionType: "expressionType",
                expression: "expression",
                inputSerialization: InputSerialization(
                    csv: CSVInput(fileHeaderInfo: "fileHeaderInfo"),
                    compressionType: "compressionType",
                    json: JSONInput(_type: "_type"),
                    parquet: ParquetInput()
                ),
                outputSerialization: OutputSerialization(
                    csv: CSVOutput(quoteFields: "quoteFields"),
                    json: JSONOutput(recordDelimiter: "recordDelimiter")
                )
            ),
            outputLocation: OutputLocation(
                s3: S3Location(
                    bucketName: "bucketName",
                    prefix: "prefix",
                    encryption: Encryption(encryptionType: "encryptionType"),
                    userMetadata: ArrayList<MetadataEntry>([MetadataEntry(name: "name")])
                )
            )
        )
        println(restoreRequest.toString())
        println(restoreRequest.toXml())
    }
}
