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
public class CreateMultipartUpload <: AbstractS3Action<CreateMultipartUploadRequest, CreateMultipartUploadResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: CreateMultipartUploadRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "CreateMultipartUpload"
        }
    }

    protected func marshalling(s3Req: CreateMultipartUploadRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("POST", bucket: s3Req.bucket, key: s3Req.key, action: "uploads")
        httpReq.addHeader(S3Constants.ACL, s3Req.acl)
        httpReq.addHeader(S3Constants.CACHE_CONTROL, s3Req.cacheControl)
        httpReq.addHeader(S3Constants.CONTENT_DISPOSITION, s3Req.contentDisposition)
        httpReq.addHeader(S3Constants.CONTENT_ENCODING, s3Req.contentEncoding)
        httpReq.addHeader(S3Constants.CONTENT_LANGUAGE, s3Req.contentLanguage)
        httpReq.addHeader(S3Constants.CONTENT_TYPE, s3Req.contentType)
        httpReq.addHeader(S3Constants.EXPIRES, s3Req.expires?.toStringRfc822())
        httpReq.addHeader(S3Constants.GRANT_FULL_CONTROL, s3Req.grantFullControl)
        httpReq.addHeader(S3Constants.GRANT_READ, s3Req.grantRead)
        httpReq.addHeader(S3Constants.GRANT_READ_ACP, s3Req.grantReadACP)
        httpReq.addHeader(S3Constants.GRANT_WRITE_ACP, s3Req.grantWriteACP)
        match (s3Req.metadata) {
            case Some(map) => for ((k, v) in map) {
                httpReq.addHeader(S3Constants.META_ + k, v)
            }
            case None => ()
        }
        httpReq.addHeader(S3Constants.SERVER_SIDE_ENCRYPTION, s3Req.serverSideEncryption)
        httpReq.addHeader(S3Constants.STORAGE_CLASS, s3Req.storageClass)
        httpReq.addHeader(S3Constants.WEBSITE_REDIRECT_LOCATION, s3Req.websiteRedirectLocation)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.SSEKMS_KEY_ID, s3Req.ssekmsKeyId)
        httpReq.addHeader(S3Constants.SSEKMS_ENCRYPTION_CONTEXT, s3Req.ssekmsEncryptionContext)
        httpReq.addHeader(S3Constants.BUCKET_KEY_ENABLED, s3Req.bucketKeyEnabled?.toString())
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.TAGGING, s3Req.tagging)
        httpReq.addHeader(S3Constants.OBJECT_LOCK_MODE, s3Req.objectLockMode)
        httpReq.addHeader(S3Constants.OBJECT_LOCK_RETAIN_UNTIL_DATE, s3Req.objectLockRetainUntilDate?.toStringRfc822())
        httpReq.addHeader(S3Constants.OBJECT_LOCK_LEGAL_HOLD_STATUS, s3Req.objectLockLegalHoldStatus)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): CreateMultipartUploadResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers

        return CreateMultipartUploadResponse(
            S3ResponseMetadata(headers),
            bucket: ele.childContentRequired("Bucket"),
            key: ele.childContentRequired("Key"),
            uploadId: ele.childContentRequired("UploadId"),
            abortDate: headers.getFirst(S3Constants.ABORT_DATE)?.toDateRfc822(),
            abortRuleId: headers.getFirst(S3Constants.ABORT_RULE_ID),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY_MD5),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            ssekmsEncryptionContext: headers.getFirst(S3Constants.SSEKMS_ENCRYPTION_CONTEXT),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED),
            checksumAlgorithm: headers.getFirst(S3Constants.CHECKSUM_ALGORITHM)
        )
    }
}

// -----
//
// -----

public class CreateMultipartUploadRequest <: AbstractS3Request {
    public CreateMultipartUploadRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let acl!: ?String = None,
        public let bucket!: String,
        public let cacheControl!: ?String = None,
        public let contentDisposition!: ?String = None,
        public let contentEncoding!: ?String = None,
        public let contentLanguage!: ?String = None,
        public let contentType!: ?String = None,
        public let expires!: ?DateTime = None,
        public let grantFullControl!: ?String = None,
        public let grantRead!: ?String = None,
        public let grantReadACP!: ?String = None,
        public let grantWriteACP!: ?String = None,
        public let key!: String,
        public let metadata!: ?Map<String, String> = None,
        public let serverSideEncryption!: ?String = None,
        public let storageClass!: ?String = None,
        public let websiteRedirectLocation!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let ssekmsEncryptionContext!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestPayer!: ?String = None,
        public let tagging!: ?String = None,
        public let objectLockMode!: ?String = None,
        public let objectLockRetainUntilDate!: ?DateTime = None,
        public let objectLockLegalHoldStatus!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let checksumAlgorithm!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "CreateMultipartUploadRequest(" + //
            "bucket=${bucket}, key=${key}, acl=${acl}, cacheControl=${cacheControl}, " + //
            "contentDisposition=${contentDisposition}, contentEncoding=${contentEncoding}, contentLanguage=${contentLanguage}, contentType=${contentType}, " +
            "expires=${expires}, grantFullControl=${grantFullControl}, grantRead=${grantRead}, grantReadACP=${grantReadACP}, " +
            "grantWriteACP=${grantWriteACP}, metadata=${ToStringUtils.mapToString2(metadata)}, serverSideEncryption=${serverSideEncryption}, storageClass=${storageClass}, " +
            "websiteRedirectLocation=${websiteRedirectLocation}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, " +
            "ssekmsKeyId=${ssekmsKeyId}, ssekmsEncryptionContext=${ssekmsEncryptionContext}, bucketKeyEnabled=${bucketKeyEnabled}, requestPayer=${requestPayer}, " +
            "tagging=${tagging}, objectLockMode=${objectLockMode}, objectLockRetainUntilDate=${objectLockRetainUntilDate}, objectLockLegalHoldStatus=${objectLockLegalHoldStatus}, " +
            "expectedBucketOwner=${expectedBucketOwner}, checksumAlgorithm=${checksumAlgorithm}" + //
                ")"
    }
}

public class CreateMultipartUploadResponse <: AbstractS3Response {
    public CreateMultipartUploadResponse(
        responseMetadata: S3ResponseMetadata,
        public let abortDate!: ?DateTime = None,
        public let abortRuleId!: ?String = None,
        public let bucket!: String,
        public let key!: String,
        public let uploadId!: String,
        public let serverSideEncryption!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let ssekmsEncryptionContext!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestCharged!: ?String = None,
        public let checksumAlgorithm!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "CreateMultipartUploadResponse(" + //
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, abortDate=${abortDate}, " + //
            "abortRuleId=${abortRuleId}, serverSideEncryption=${serverSideEncryption}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, " +
            "ssekmsKeyId=${ssekmsKeyId}, ssekmsEncryptionContext=${ssekmsEncryptionContext}, bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}, " +
            "checksumAlgorithm=${checksumAlgorithm}" + //
                ")"
    }
}
