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
 * @date: 2023-11-28
 */
public class PutObject <: AbstractS3Action<PutObjectRequest, PutObjectResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutObjectRequest, reqBody: ?S3Content) {
        /*
        遇到过下面的错误, 可能和打开了lock策略有关
        <?xml version="1.0" encoding="UTF-8"?>
        <Error>
            <Code>InvalidRequest</Code>
            <Message>Content-MD5 OR x-amz-checksum- HTTP header is required for
                Put Object requests with Object Lock parameters</Message>
        </Error>
         */
        super(s3ClientConfigMap, s3Req, reqBody: reqBody)
    }

    public prop name: String {
        get() {
            return "PutObject"
        }
    }

    protected func marshalling(s3Req: PutObjectRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addHeader(S3Constants.ACL, s3Req.acl) // 1
        httpReq.addHeader(S3Constants.CACHE_CONTROL, s3Req.cacheControl) // 2
        httpReq.addHeader(S3Constants.CONTENT_DISPOSITION, s3Req.contentDisposition) // 3
        httpReq.addHeader(S3Constants.CONTENT_ENCODING, s3Req.contentEncoding) // 4
        httpReq.addHeader(S3Constants.CONTENT_LANGUAGE, s3Req.contentLanguage) // 5
        httpReq.addHeader(S3Constants.CONTENT_LENGTH, s3Req.contentLength?.toString()) // 6
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5) // 7
        httpReq.addHeader(S3Constants.CONTENT_TYPE, s3Req.contentType) // 8
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm) // 9
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32, s3Req.checksumCRC32) // 10
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32C, s3Req.checksumCRC32C) // 11
        httpReq.addHeader(S3Constants.CHECKSUM_SHA1, s3Req.checksumSHA1) // 12
        httpReq.addHeader(S3Constants.CHECKSUM_SHA256, s3Req.checksumSHA256) // 13
        httpReq.addHeader(S3Constants.EXPIRES, s3Req.expires?.toStringRfc822()) // 14
        httpReq.addHeader(S3Constants.GRANT_FULL_CONTROL, s3Req.grantFullControl) // 15
        httpReq.addHeader(S3Constants.GRANT_READ, s3Req.grantRead) // 16
        httpReq.addHeader(S3Constants.GRANT_READ_ACP, s3Req.grantReadACP) // 17
        httpReq.addHeader(S3Constants.GRANT_WRITE_ACP, s3Req.grantWriteACP) // 18
        match (s3Req.metadata) { // 19
            case Some(map) => for ((k, v) in map) {
                httpReq.addHeader(S3Constants.META_ + k, v)
            }
            case None => ()
        }
        httpReq.addHeader(S3Constants.SERVER_SIDE_ENCRYPTION, s3Req.serverSideEncryption) // 20
        httpReq.addHeader(S3Constants.STORAGE_CLASS, s3Req.storageClass) // 21
        httpReq.addHeader(S3Constants.WEBSITE_REDIRECT_LOCATION, s3Req.websiteRedirectLocation) // 22
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm) // 23
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey) // 24
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5) // 25
        httpReq.addHeader(S3Constants.SSEKMS_KEY_ID, s3Req.ssekmsKeyId) // 26
        httpReq.addHeader(S3Constants.SSEKMS_ENCRYPTION_CONTEXT, s3Req.ssekmsEncryptionContext) // 27
        httpReq.addHeader(S3Constants.BUCKET_KEY_ENABLED, s3Req.bucketKeyEnabled?.toString()) // 28
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer) // 29
        httpReq.addHeader(S3Constants.TAGGING, s3Req.tagging) // 30
        httpReq.addHeader(S3Constants.OBJECT_LOCK_MODE, s3Req.objectLockMode) // 31
        httpReq.addHeader(
            S3Constants.OBJECT_LOCK_RETAIN_UNTIL_DATE,
            s3Req.objectLockRetainUntilDate?.toStringRfc822()
        ) // 32
        httpReq.addHeader(S3Constants.OBJECT_LOCK_LEGAL_HOLD_STATUS, s3Req.objectLockLegalHoldStatus) // 33
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner) // 34
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutObjectResponse {
        let headers = httpRsp.headers
        return PutObjectResponse(
            S3ResponseMetadata(headers),
            etag: headers.getFirst(S3Constants.ETAG).getOrThrow(),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            expiration: headers.getFirst(S3Constants.EXPIRATION),
            checksumCRC32: headers.getFirst(S3Constants.CHECKSUM_CRC32),
            checksumCRC32C: headers.getFirst(S3Constants.CHECKSUM_CRC32C),
            checksumSHA1: headers.getFirst(S3Constants.CHECKSUM_SHA1),
            checksumSHA256: headers.getFirst(S3Constants.CHECKSUM_SHA256),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY_MD5),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            ssekmsEncryptionContext: headers.getFirst(S3Constants.SSEKMS_ENCRYPTION_CONTEXT),
            bucketKeyEnabled: Bool.tryParse(headers.getFirst(S3Constants.BUCKET_KEY_ENABLED).getOrDefault({=> ""})),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class PutObjectRequest <: AbstractS3Request {
    public PutObjectRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let acl!: ?String = None,
        public let cacheControl!: ?String = None,
        public let contentDisposition!: ?String = None,
        public let contentEncoding!: ?String = None,
        public let contentLanguage!: ?String = None,
        public let contentLength!: ?Int64 = None,
        public let contentMD5!: ?String = None,
        public let contentType!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let expires!: ?DateTime = None,
        public let grantFullControl!: ?String = None,
        public let grantRead!: ?String = None,
        public let grantReadACP!: ?String = None,
        public let grantWriteACP!: ?String = None,
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
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutObjectRequest(" +
            "bucket=${bucket}, key=${key}, acl=${acl}, cacheControl=${cacheControl}, contentDisposition=${contentDisposition}, " +
            "contentEncoding=${contentEncoding}, contentLanguage=${contentLanguage}, contentLength=${contentLength}, " +
            "contentMD5=${contentMD5}, contentType=${contentType}, checksumAlgorithm=${checksumAlgorithm}, checksumCRC32=${checksumCRC32}, " +
            "checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, expires=${expires}, " +
            "grantFullControl=${grantFullControl}, grantRead=${grantRead}, grantReadACP=${grantReadACP}, grantWriteACP=${grantWriteACP}, " +
            "metadata=${ToStringUtils.mapToString2(metadata)}, serverSideEncryption=${serverSideEncryption}, storageClass=${storageClass}, " +
            "websiteRedirectLocation=${websiteRedirectLocation}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, " +
            "ssekmsEncryptionContext=${ssekmsEncryptionContext}, bucketKeyEnabled=${bucketKeyEnabled}, requestPayer=${requestPayer}, " +
            "tagging=${tagging}, objectLockMode=${objectLockMode}, objectLockRetainUntilDate=${objectLockRetainUntilDate}, " +
            "objectLockLegalHoldStatus=${objectLockLegalHoldStatus}, expectedBucketOwner=${expectedBucketOwner}" + //
                ")"
    }
}

public class PutObjectResponse <: AbstractS3Response {
    public PutObjectResponse(
        responseMetadata: S3ResponseMetadata,
        public let etag!: String,
        public let serverSideEncryption!: ?String = None,
        public let expiration!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let versionId!: ?String = None,
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
        return "PutObjectResponse(" +
            "etag=${etag}, serverSideEncryption=${serverSideEncryption}, expiration=${expiration}, checksumCRC32=${checksumCRC32}, " +
            "checksumCRC32C=${checksumCRC32C}, checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, " +
            "checksumSHA256=${checksumSHA256}, versionId=${versionId}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, ssekmsEncryptionContext=${ssekmsEncryptionContext}, " +
            "bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}" + //
                ")"
    }
}
