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
public class UploadPart <: AbstractS3Action<UploadPartRequest, UploadPartResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: UploadPartRequest, reqBody: S3Content) {
        super(s3ClientConfigMap, s3Req, reqBody: reqBody, checksumRequired: true)
    }

    public prop name: String {
        get() {
            return "UploadPart"
        }
    }

    protected func marshalling(s3Req: UploadPartRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID, s3Req.uploadId)
        httpReq.addQueryParam(S3Constants.QUERY_PART_NUMBER, s3Req.partNumber.toString())
        httpReq.addHeader(S3Constants.CONTENT_LENGTH, s3Req.contentLength?.toString())
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32, s3Req.checksumCRC32)
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32C, s3Req.checksumCRC32C)
        httpReq.addHeader(S3Constants.CHECKSUM_SHA1, s3Req.checksumSHA1)
        httpReq.addHeader(S3Constants.CHECKSUM_SHA256, s3Req.checksumSHA256)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): UploadPartResponse {
        let headers = httpRsp.headers
        return UploadPartResponse(
            S3ResponseMetadata(headers),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            etag: headers.getFirst(S3Constants.ETAG),
            checksumCRC32: headers.getFirst(S3Constants.CHECKSUM_CRC32),
            checksumCRC32C: headers.getFirst(S3Constants.CHECKSUM_CRC32C),
            checksumSHA1: headers.getFirst(S3Constants.CHECKSUM_SHA1),
            checksumSHA256: headers.getFirst(S3Constants.CHECKSUM_SHA256),
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY_MD5),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class UploadPartRequest <: AbstractS3Request {
    public UploadPartRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let partNumber!: Int32,
        public let uploadId!: String,
        public let contentLength!: ?Int64 = None,
        public let contentMD5!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let sdkPartType!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "UploadPartRequest(" + //
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, partNumber=${partNumber}, " + //
            "contentLength=${contentLength}, contentMD5=${contentMD5}, checksumAlgorithm=${checksumAlgorithm}, checksumCRC32=${checksumCRC32}, " +
            "checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, requestPayer=${requestPayer}, expectedBucketOwner=${expectedBucketOwner}, " +
            "sdkPartType=${sdkPartType}" + //
                ")"
    }
}

public class UploadPartResponse <: AbstractS3Response {
    public UploadPartResponse(
        responseMetadata: S3ResponseMetadata,
        public let serverSideEncryption!: ?String = None,
        public let etag!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "UploadPartResponse(" + //
            "serverSideEncryption=${serverSideEncryption}, etag=${etag}, checksumCRC32=${checksumCRC32}, checksumCRC32C=${checksumCRC32C}, " +
            "checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, " +
            "ssekmsKeyId=${ssekmsKeyId}, bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}" + //
                ")"
    }
}
