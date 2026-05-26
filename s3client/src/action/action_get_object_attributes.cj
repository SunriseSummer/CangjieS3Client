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

package s3client.action

/*
 *
 * @author: wangwb
 * @date: 2023-12-13
 */
public class GetObjectAttributes <: AbstractS3Action<GetObjectAttributesRequest, GetObjectAttributesResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetObjectAttributesRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetObjectAttributes"
        }
    }

    protected func marshalling(s3Req: GetObjectAttributesRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, key: s3Req.key, action: "attributes")
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.MAX_PARTS, s3Req.maxParts?.toString())
        httpReq.addHeader(S3Constants.PART_NUMBER_MARKER, s3Req.partNumberMarker?.toString())
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.OBJECT_ATTRIBUTES, s3Req.objectAttributes)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetObjectAttributesResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        let s3Rsp = GetObjectAttributesResponse(
            S3ResponseMetadata(headers),
            deleteMarker: headers.getFirst(S3Constants.DELETE_MARKER)?.toBool(),
            lastModified: headers.getFirst(S3Constants.LAST_MODIFIED)?.toDateRfc822(),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED),
            etag: ele.childContent("ETag"),
            checksum: ele.child(Checksum.ELE_NAME, Checksum.fromXml),
            objectParts: ele.child(GetObjectAttributesParts.ELE_NAME, GetObjectAttributesParts.fromXml),
            storageClass: ele.childContent("StorageClass"),
            objectSize: ele.childContent("ObjectSize")?.toInt64()
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetObjectAttributesRequest <: AbstractS3Request {
    public GetObjectAttributesRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let versionId!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let maxParts!: ?Int32 = None,
        public let partNumberMarker!: ?Int32 = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let objectAttributes!: ArrayList<String>
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetObjectAttributesRequest(" +
            "bucket=${bucket}, key=${key}, versionId=${versionId}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}, maxParts=${maxParts}, partNumberMarker=${partNumberMarker}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, objectAttributes=${objectAttributes}" +
            ")"
    }
}

public class GetObjectAttributesResponse <: AbstractS3Response {
    public GetObjectAttributesResponse(
        responseMetadata: S3ResponseMetadata,
        public let deleteMarker!: ?Bool = None,
        public let lastModified!: ?DateTime = None,
        public let versionId!: ?String = None,
        public let requestCharged!: ?String = None,
        public let etag!: ?String = None,
        public let checksum!: ?Checksum = None,
        public let objectParts!: ?GetObjectAttributesParts = None,
        public let storageClass!: ?String = None,
        public let objectSize!: ?Int64 = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetObjectAttributesResponse(" +
            "deleteMarker=${deleteMarker}, lastModified=${lastModified}, versionId=${versionId}, requestCharged=${requestCharged}, " +
            "etag=${etag}, checksum=${checksum}, objectParts=${objectParts}, storageClass=${storageClass}, " +
            "objectSize=${objectSize}" + ")"
    }
}
