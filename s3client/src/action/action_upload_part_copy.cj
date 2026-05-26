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
public class UploadPartCopy <: AbstractS3Action<UploadPartCopyRequest, UploadPartCopyResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: UploadPartCopyRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "UploadPartCopy"
        }
    }

    protected func marshalling(s3Req: UploadPartCopyRequest): S3HttpRequestBuilder {
        var copySource = s3Req.copySource.getOrDefault({=> ""})
        if (copySource == "") {
            let sourceBucket = s3Req.sourceBucket.getOrThrow()
            let sourceKey = s3Req.sourceKey.getOrThrow()
            let sourceVersionId = s3Req.sourceVersionId.getOrDefault({=> ""})
            copySource = sourceBucket + "/" + sourceKey
            if (sourceVersionId != "") {
                copySource = copySource + "?versionId=" + sourceVersionId
            }
        }
        let httpReq = createHttpRequest("PUT", bucket: s3Req.destinationBucket, key: s3Req.destinationKey)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID, s3Req.uploadId)
        httpReq.addQueryParam(S3Constants.QUERY_PART_NUMBER, s3Req.partNumber.toString())
        httpReq.addHeader(S3Constants.COPY_SOURCE, copySource)
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_MATCH, s3Req.copySourceIfMatch)
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_MODIFIED_SINCE, s3Req.copySourceIfModifiedSince?.toStringRfc822()
        )
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_NONE_MATCH, s3Req.copySourceIfNoneMatch)
        httpReq.addHeader(
            S3Constants.COPY_SOURCE_IF_UNMODIFIED_SINCE,
            s3Req.copySourceIfUnmodifiedSince?.toStringRfc822()
        )
        httpReq.addHeader(S3Constants.COPY_SOURCE_RANGE, s3Req.copySourceRange)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_ALGORITHM, s3Req.copySourceSSECustomerAlgorithm)
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_KEY, s3Req.copySourceSSECustomerKey)
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_KEY_MD5, s3Req.copySourceSSECustomerKeyMD5)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.EXPECTED_SOURCE_BUCKET_OWNER, s3Req.expectedSourceBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): UploadPartCopyResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let copyPartResult = CopyPartResult.fromXml(S3XmlElement.fromXml(rspXml))
        let headers = httpRsp.headers
        return UploadPartCopyResponse(
            S3ResponseMetadata(headers),
            copyPartResult: copyPartResult,
            copySourceVersionId: headers.getFirst(S3Constants.COPY_SOURCE_VERSION_ID),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class UploadPartCopyRequest <: AbstractS3Request {
    public UploadPartCopyRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let destinationBucket!: String,
        public let destinationKey!: String,
        public let uploadId!: String,
        public let partNumber!: Int32,
        public let copySource!: ?String = None,
        public let sourceBucket!: ?String = None,
        public let sourceKey!: ?String = None,
        public let sourceVersionId!: ?String = None,
        public let copySourceIfMatch!: ?String = None,
        public let copySourceIfModifiedSince!: ?DateTime = None,
        public let copySourceIfNoneMatch!: ?String = None,
        public let copySourceIfUnmodifiedSince!: ?DateTime = None,
        public let copySourceRange!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let copySourceSSECustomerAlgorithm!: ?String = None,
        public let copySourceSSECustomerKey!: ?String = None,
        public let copySourceSSECustomerKeyMD5!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let expectedSourceBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "UploadPartCopyRequest(" +
            "destinationBucket=${destinationBucket}, destinationKey=${destinationKey}, uploadId=${uploadId}, partNumber=${partNumber}, " +
            "copySource=${copySource}, sourceBucket=${sourceBucket}, sourceKey=${sourceKey}, sourceVersionId=${sourceVersionId}, " +
            "copySourceIfMatch=${copySourceIfMatch}, copySourceIfModifiedSince=${copySourceIfModifiedSince}, copySourceIfNoneMatch=${copySourceIfNoneMatch}, copySourceIfUnmodifiedSince=${copySourceIfUnmodifiedSince}, " +
            "copySourceRange=${copySourceRange}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, " +
            "copySourceSSECustomerAlgorithm=${copySourceSSECustomerAlgorithm}, copySourceSSECustomerKey=${copySourceSSECustomerKey}, copySourceSSECustomerKeyMD5=${copySourceSSECustomerKeyMD5}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}, expectedSourceBucketOwner=${expectedSourceBucketOwner}" + //
                ")"
    }
}

public class UploadPartCopyResponse <: AbstractS3Response {
    public UploadPartCopyResponse(
        responseMetadata: S3ResponseMetadata,
        public let copyPartResult!: ?CopyPartResult = None,
        public let copySourceVersionId!: ?String = None,
        public let serverSideEncryption!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "UploadPartCopyResponse(" +
            "copyPartResult=${copyPartResult}, copySourceVersionId=${copySourceVersionId}, serverSideEncryption=${serverSideEncryption}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}" +
            ")"
    }
}
