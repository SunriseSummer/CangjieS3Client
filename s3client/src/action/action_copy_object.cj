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
 * @date: 2023-12-15
 */
public class CopyObject <: AbstractS3Action<CopyObjectRequest, CopyObjectResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: CopyObjectRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "CopyObject"
        }
    }

    protected func marshalling(s3Req: CopyObjectRequest): S3HttpRequestBuilder {
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
        httpReq.addHeader(S3Constants.COPY_SOURCE, copySource)
        httpReq.addHeader(S3Constants.ACL, s3Req.acl)
        httpReq.addHeader(S3Constants.CACHE_CONTROL, s3Req.cacheControl)
        httpReq.addHeader(S3Constants.CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.CONTENT_DISPOSITION, s3Req.contentDisposition)
        httpReq.addHeader(S3Constants.CONTENT_ENCODING, s3Req.contentEncoding)
        httpReq.addHeader(S3Constants.CONTENT_LANGUAGE, s3Req.contentLanguage)
        httpReq.addHeader(S3Constants.CONTENT_TYPE, s3Req.contentType)
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_MATCH, s3Req.copySourceIfMatch)
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_MODIFIED_SINCE, s3Req.copySourceIfModifiedSince?.toStringRfc822())
        httpReq.addHeader(S3Constants.COPY_SOURCE_IF_NONE_MATCH, s3Req.copySourceIfNoneMatch)
        httpReq.addHeader(
            S3Constants.COPY_SOURCE_IF_UNMODIFIED_SINCE,
            s3Req.copySourceIfUnmodifiedSince?.toStringRfc822()
        )
        httpReq.addHeader(S3Constants.EXPIRES, s3Req.expires?.toStringRfc822())
        httpReq.addHeader(S3Constants.GRANT_FULL_CONTROL, s3Req.grantFullControl)
        httpReq.addHeader(S3Constants.GRANT_READ, s3Req.grantRead)
        httpReq.addHeader(S3Constants.GRANT_READ_ACP, s3Req.grantReadACP)
        httpReq.addHeader(S3Constants.GRANT_WRITE_ACP, s3Req.grantWriteACP)
        match (s3Req.metadata) { // 19
            case Some(map) => for ((k, v) in map) {
                httpReq.addHeader(S3Constants.META_ + k, v)
            }
            case None => ()
        }
        httpReq.addHeader(S3Constants.METADATA_DIRECTIVE, s3Req.metadataDirective)
        httpReq.addHeader(S3Constants.TAGGING_DIRECTIVE, s3Req.taggingDirective)
        httpReq.addHeader(S3Constants.SERVER_SIDE_ENCRYPTION, s3Req.serverSideEncryption)
        httpReq.addHeader(S3Constants.STORAGE_CLASS, s3Req.storageClass)
        httpReq.addHeader(S3Constants.WEBSITE_REDIRECT_LOCATION, s3Req.websiteRedirectLocation)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.SSEKMS_KEY_ID, s3Req.ssekmsKeyId)
        httpReq.addHeader(S3Constants.SSEKMS_ENCRYPTION_CONTEXT, s3Req.ssekmsEncryptionContext)
        httpReq.addHeader(S3Constants.BUCKET_KEY_ENABLED, s3Req.bucketKeyEnabled?.toString())
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_ALGORITHM, s3Req.copySourceSSECustomerAlgorithm)
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_KEY, s3Req.copySourceSSECustomerKey)
        httpReq.addHeader(S3Constants.COPY_SOURCE_SSE_CUSTOMER_KEY_MD5, s3Req.copySourceSSECustomerKeyMD5)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.TAGGING, s3Req.tagging)
        httpReq.addHeader(S3Constants.OBJECT_LOCK_MODE, s3Req.objectLockMode)
        httpReq.addHeader(S3Constants.OBJECT_LOCK_RETAIN_UNTIL_DATE, s3Req.objectLockRetainUntilDate?.toStringRfc822())
        httpReq.addHeader(S3Constants.OBJECT_LOCK_LEGAL_HOLD_STATUS, s3Req.objectLockLegalHoldStatus)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.EXPECTED_SOURCE_BUCKET_OWNER, s3Req.expectedSourceBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): CopyObjectResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let copyObjectResult = CopyObjectResult.fromXml(S3XmlElement.fromXml(rspXml))
        let headers = httpRsp.headers
        return CopyObjectResponse(
            S3ResponseMetadata(headers),
            copyObjectResult: copyObjectResult,
            expiration: headers.getFirst(S3Constants.EXPIRATION),
            copySourceVersionId: headers.getFirst(S3Constants.COPY_SOURCE_VERSION_ID),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY_MD5),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            ssekmsEncryptionContext: headers.getFirst(S3Constants.SSEKMS_ENCRYPTION_CONTEXT),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class CopyObjectRequest <: AbstractS3Request {
    public CopyObjectRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let destinationBucket!: String,
        public let destinationKey!: String,
        public let copySource!: ?String = None,
        public let sourceBucket!: ?String = None,
        public let sourceKey!: ?String = None,
        public let sourceVersionId!: ?String = None,
        public let acl!: ?String = None,
        public let cacheControl!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let contentDisposition!: ?String = None,
        public let contentEncoding!: ?String = None,
        public let contentLanguage!: ?String = None,
        public let contentType!: ?String = None,
        public let copySourceIfMatch!: ?String = None,
        public let copySourceIfModifiedSince!: ?DateTime = None,
        public let copySourceIfNoneMatch!: ?String = None,
        public let copySourceIfUnmodifiedSince!: ?DateTime = None,
        public let expires!: ?DateTime = None,
        public let grantFullControl!: ?String = None,
        public let grantRead!: ?String = None,
        public let grantReadACP!: ?String = None,
        public let grantWriteACP!: ?String = None,
        public let metadata!: ?Map<String, String> = None,
        public let metadataDirective!: ?String = None,
        public let taggingDirective!: ?String = None,
        public let serverSideEncryption!: ?String = None,
        public let storageClass!: ?String = None,
        public let websiteRedirectLocation!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let ssekmsEncryptionContext!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let copySourceSSECustomerAlgorithm!: ?String = None,
        public let copySourceSSECustomerKey!: ?String = None,
        public let copySourceSSECustomerKeyMD5!: ?String = None,
        public let requestPayer!: ?String = None,
        public let tagging!: ?String = None,
        public let objectLockMode!: ?String = None,
        public let objectLockRetainUntilDate!: ?DateTime = None,
        public let objectLockLegalHoldStatus!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let expectedSourceBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "CopyObjectRequest(" +
            "destinationBucket=${destinationBucket}, destinationKey=${destinationKey}, copySource=${copySource}, sourceBucket=${sourceBucket}, " +
            "sourceKey=${sourceKey}, sourceVersionId=${sourceVersionId}, acl=${acl}, cacheControl=${cacheControl}, " +
            "checksumAlgorithm=${checksumAlgorithm}, contentDisposition=${contentDisposition}, contentEncoding=${contentEncoding}, contentLanguage=${contentLanguage}, " +
            "contentType=${contentType}, copySourceIfMatch=${copySourceIfMatch}, copySourceIfModifiedSince=${copySourceIfModifiedSince}, copySourceIfNoneMatch=${copySourceIfNoneMatch}, " +
            "copySourceIfUnmodifiedSince=${copySourceIfUnmodifiedSince}, expires=${expires}, grantFullControl=${grantFullControl}, grantRead=${grantRead}, " +
            "grantReadACP=${grantReadACP}, grantWriteACP=${grantWriteACP}, metadata=${ToStringUtils.mapToString2(metadata)}, metadataDirective=${metadataDirective}, " +
            "taggingDirective=${taggingDirective}, serverSideEncryption=${serverSideEncryption}, storageClass=${storageClass}, websiteRedirectLocation=${websiteRedirectLocation}, " +
            "sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, " +
            "ssekmsEncryptionContext=${ssekmsEncryptionContext}, bucketKeyEnabled=${bucketKeyEnabled}, copySourceSSECustomerAlgorithm=${copySourceSSECustomerAlgorithm}, copySourceSSECustomerKey=${copySourceSSECustomerKey}, " +
            "copySourceSSECustomerKeyMD5=${copySourceSSECustomerKeyMD5}, requestPayer=${requestPayer}, tagging=${tagging}, objectLockMode=${objectLockMode}, " +
            "objectLockRetainUntilDate=${objectLockRetainUntilDate}, objectLockLegalHoldStatus=${objectLockLegalHoldStatus}, expectedBucketOwner=${expectedBucketOwner}, expectedSourceBucketOwner=${expectedSourceBucketOwner}" +
            ")"
    }
}

public class CopyObjectResponse <: AbstractS3Response {
    public CopyObjectResponse(
        responseMetadata: S3ResponseMetadata,
        public let copyObjectResult!: ?CopyObjectResult = None,
        public let expiration!: ?String = None,
        public let copySourceVersionId!: ?String = None,
        public let versionId!: ?String = None,
        public let serverSideEncryption!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let ssekmsEncryptionContext!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "CopyObjectResponse(" +
            "copyObjectResult=${copyObjectResult}, expiration=${expiration}, copySourceVersionId=${copySourceVersionId}, versionId=${versionId}, " +
            "serverSideEncryption=${serverSideEncryption}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, " +
            "ssekmsEncryptionContext=${ssekmsEncryptionContext}, bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}" +
            ")"
    }
}
