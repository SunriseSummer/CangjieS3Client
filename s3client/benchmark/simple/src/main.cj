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

package benchmark_simple
import std.collection.{Map, HashMap, ArrayList, LinkedList, forEach, collectString, collectArrayList, map}
import std.time.{DateTime, TimeZone}

import s3client.*
import s3client.action.*
import s3client.core.*
/*
 *
 * @author: wangwb
 * @date: 2024-04-25
 */
let s3 = S3Client.builder() //
    .credentials("1", "2") //
    .trailingChecksum(true) //
    .httpClient(MockHttpClient()) //
    .build()

main(): Int64 {
    testGetObjectAcl()
    testPutObjectAcl()
    testListObjectsV2Paginator()
    return 0
}

let LOOP_COUNT = 100

func testGetObjectAcl(): Unit {
    let beginTime = DateTime.nowUTC()
    for (_ in 0..LOOP_COUNT) {
        let rsp = s3.getObjectAcl(
            GetObjectAclRequest(
                bucket: "oldsix",
                key: "oldsix"
            )
        )
        // println(rsp.owner.id)
    }
    println("===== GetObjectAcl: ${DateTime.nowUTC() - beginTime}")
}

func testPutObjectAcl(): Unit {
    let beginTime = DateTime.nowUTC()
    for (_ in 0..LOOP_COUNT) {
        let policy = AccessControlPolicy(
            owner: Owner(id: "1"),
            grants: ArrayList<Grant>(
                [
                    Grant(
                        permission: "FULL_CONTROL",
                        grantee: Grantee(id: "1", _type: "CanonicalUser")
                    )
                ]
            )
        )
        let rsp = s3.putObjectAcl(
            PutObjectAclRequest(
                bucket: "oldsix",
                key: "oldsix",
                accessControlPolicy: policy
            )
        )
        // println(rsp.requestCharged)
    }
    println("===== PutObjectAcl: ${DateTime.nowUTC() - beginTime}")
}

func testListObjectsV2Paginator(): Unit {
    let beginTime = DateTime.nowUTC()
    for (_ in 0..LOOP_COUNT) {
        let iterRsp = s3.listObjectsV2Paginator(ListObjectsV2Request(bucket: "cj-test11"))
        var count = 0
        for (rsp in iterRsp) {
            count += rsp.contents?.size ?? 0
        }
    }
    println("===== ListObjectsV2Paginator: ${DateTime.nowUTC() - beginTime}")
}

class MockHttpClient <: S3HttpClient {
    public prop name: String {
        get() {
            "Mock"
        }
    }

    public func close(): Unit {
    }

    public func toString(): String {
        return "MockHttpClient"
    }

    public func call(s3HttpReq: S3HttpRequest): S3HttpResponse {
        let query = s3HttpReq.url.query.getOrDefault({=> ""})
        return S3HttpResponse.builder() //
            .setRequest(s3HttpReq) //
            .setStatusCode(200) //
            .setBodyStream(
            S3Content.fromString(mock_data_map[query]).stream()) //
                .build()
    }

    static let mock_data_map = HashMap<String, String>(
        [("acl=", """
<?xml version="1.0" encoding="UTF-8"?>
<AccessControlPolicy>
   <Owner>
      <DisplayName>DisplayName</DisplayName>
      <ID>ID</ID>
   </Owner>
   <AccessControlList>
      <Grant>
         <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xsi:type">
            <DisplayName>DisplayName</DisplayName>
            <EmailAddress>EmailAddress</EmailAddress>
            <ID>ID</ID>
            <xsi:type>xsi:type</xsi:type>
            <URI>URI</URI>
         </Grantee>
         <Permission>Permission</Permission>
      </Grant>
   </AccessControlList>
</AccessControlPolicy>
"""),
        ("list-type=2", mock_data_ListObjectsV2())])

    private static func mock_data_ListObjectsV2(): String {
        let contents = StringBuilder();
        for (i in 0..100) {
            contents.append(
                """
<Contents>
    <Key>mock_key_${i}</Key>
    <!--<LastModified>2024-03-22T08:04:59.000Z</LastModified>-->
    <ETag>&quot;1d0f249c316092c34288a77d779eeaba-${i}&quot;</ETag>
    <ChecksumAlgorithm>SHA256</ChecksumAlgorithm>
    <Size>5</Size>
    <StorageClass>STANDARD</StorageClass>
</Contents>
"""
            )
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
}
