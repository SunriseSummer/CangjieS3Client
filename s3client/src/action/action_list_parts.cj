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
 * @date: 2023-12-18
 */
public class ListParts <: AbstractS3Action<ListPartsRequest, ListPartsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListPartsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListParts"
        }
    }

    protected func marshalling(s3Req: ListPartsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID, s3Req.uploadId)
        httpReq.addQueryParam(S3Constants.QUERY_MAX_PARTS, s3Req.maxParts?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_PART_NUMBER_MARKER, s3Req.partNumberMarker?.toString())
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListPartsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        return ListPartsResponse(
            S3ResponseMetadata(headers),
            bucket: ele.childContentRequired("Bucket"),
            key: ele.childContentRequired("Key"),
            uploadId: ele.childContentRequired("UploadId"),
            partNumberMarker: ele.childContent("PartNumberMarker")?.toInt32(),
            nextPartNumberMarker: ele.childContent("NextPartNumberMarker")?.toInt32(),
            maxParts: ele.childContent("MaxParts")?.toInt32(),
            isTruncated: ele.childContentRequired("IsTruncated").toBool(),
            parts: ele.childs(Part.ELE_NAME, Part.fromXml),
            initiator: ele.child(Initiator.ELE_NAME, Initiator.fromXml),
            owner: ele.child(Owner.ELE_NAME, Owner.fromXml),
            storageClass: ele.childContent("StorageClass"),
            checksumAlgorithm: ele.childContent("ChecksumAlgorithm"),
            abortDate: headers.getFirst(S3Constants.ABORT_DATE)?.toDateRfc822(),
            abortRuleId: headers.getFirst(S3Constants.ABORT_RULE_ID),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class ListPartsRequest <: AbstractS3Request {
    public ListPartsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let uploadId!: String,
        public let maxParts!: ?Int32 = None,
        public let partNumberMarker!: ?Int32 = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None
    ) {
        super(requestConfig)
    }

    public func nextRequest(prevRsp: ListPartsResponse): ListPartsRequest {
        return ListPartsRequest(
            partNumberMarker: prevRsp.nextPartNumberMarker,
            requestConfig: this.requestConfig,
            bucket: this.bucket,
            key: this.key,
            uploadId: this.uploadId,
            maxParts: this.maxParts,
            requestPayer: this.requestPayer,
            expectedBucketOwner: this.expectedBucketOwner,
            sseCustomerAlgorithm: this.sseCustomerAlgorithm,
            sseCustomerKey: this.sseCustomerKey,
            sseCustomerKeyMD5: this.sseCustomerKeyMD5
        )
    }

    public func toString(): String {
        return "ListPartsRequest(" + //
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, maxParts=${maxParts}, " + //
            "partNumberMarker=${partNumberMarker}, requestPayer=${requestPayer}, expectedBucketOwner=${expectedBucketOwner}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " + //
            "sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}" + //
                ")"
    }
}

public class ListPartsResponse <: AbstractS3Response {
    public ListPartsResponse(
        responseMetadata: S3ResponseMetadata,
        public let bucket!: String,
        public let key!: String,
        public let uploadId!: String,
        public let abortDate!: ?DateTime = None,
        public let abortRuleId!: ?String = None,
        public let partNumberMarker!: ?Int32 = None,
        public let nextPartNumberMarker!: ?Int32 = None,
        public let maxParts!: ?Int32 = None,
        public let isTruncated!: Bool,
        public let parts!: ArrayList<Part>,
        public let initiator!: ?Initiator = None,
        public let owner!: ?Owner = None,
        public let storageClass!: ?String = None,
        public let requestCharged!: ?String = None,
        public let checksumAlgorithm!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListPartsResponse(" + //
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, abortDate=${abortDate}, " + //
            "abortRuleId=${abortRuleId}, partNumberMarker=${partNumberMarker}, nextPartNumberMarker=${nextPartNumberMarker}, maxParts=${maxParts}, " +
            "isTruncated=${isTruncated}, parts=${parts}, initiator=${initiator}, owner=${owner}, " + //
            "storageClass=${storageClass}, requestCharged=${requestCharged}, checksumAlgorithm=${checksumAlgorithm}" + //
            ")"
    }
}
