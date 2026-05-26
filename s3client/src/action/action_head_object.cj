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
 * @date: 2023-12-12
 */
public class HeadObject <: AbstractS3Action<HeadObjectRequest, HeadObjectResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: HeadObjectRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "HeadObject"
        }
    }

    protected func marshalling(s3Req: HeadObjectRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("HEAD", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addQueryParam(S3Constants.QUERY_PART_NUMBER, s3Req.partNumber?.toString())
        httpReq.addHeader(S3Constants.IF_MATCH, s3Req.ifMatch)
        httpReq.addHeader(S3Constants.IF_MODIFIED_SINCE, s3Req.ifModifiedSince?.toStringRfc822())
        httpReq.addHeader(S3Constants.IF_NONE_MATCH, s3Req.ifNoneMatch)
        httpReq.addHeader(S3Constants.IF_UNMODIFIED_SINCE, s3Req.ifUnmodifiedSince?.toStringRfc822())
        httpReq.addHeader(S3Constants.RANGE, s3Req.range)
        httpReq.addHeader(S3Constants.CHECKSUM_MODE, s3Req.checksumMode)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): HeadObjectResponse {
        let headers = httpRsp.headers
        let metadata = HashMap<String, String>()
        for ((k, v) in headers) {
            if (k.startsWith(S3Constants.META_)) {
                let name = k[S3Constants.META_.size..k.size]
                metadata.add(name, v.iterator().next().getOrDefault({=> ""}))
            }
        }
        return HeadObjectResponse(
            S3ResponseMetadata(headers),
            deleteMarker: headers.getFirst(S3Constants.DELETE_MARKER)?.toBool(),
            acceptRanges: headers.getFirst(S3Constants.ACCEPT_RANGES),
            expiration: headers.getFirst(S3Constants.EXPIRATION),
            restore: headers.getFirst(S3Constants.RESTORE),
            archiveStatus: headers.getFirst(S3Constants.ARCHIVE_STATUS),
            lastModified: headers.getFirst(S3Constants.LAST_MODIFIED)?.toDateRfc822(),
            contentLength: headers.getFirst(S3Constants.CONTENT_LENGTH)?.toInt64(),
            checksumCRC32: headers.getFirst(S3Constants.CHECKSUM_CRC32),
            checksumCRC32C: headers.getFirst(S3Constants.CHECKSUM_CRC32C),
            checksumSHA1: headers.getFirst(S3Constants.CHECKSUM_SHA1),
            checksumSHA256: headers.getFirst(S3Constants.CHECKSUM_SHA256),
            etag: headers.getFirst(S3Constants.ETAG),
            missingMeta: headers.getFirst(S3Constants.MISSING_META)?.toInt32(),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            cacheControl: headers.getFirst(S3Constants.CACHE_CONTROL),
            contentDisposition: headers.getFirst(S3Constants.CONTENT_DISPOSITION),
            contentEncoding: headers.getFirst(S3Constants.CONTENT_ENCODING),
            contentLanguage: headers.getFirst(S3Constants.CONTENT_LANGUAGE),
            contentType: headers.getFirst(S3Constants.CONTENT_TYPE),
            expires: headers.getFirst(S3Constants.EXPIRES)?.toDateRfc822(),
            websiteRedirectLocation: headers.getFirst(S3Constants.WEBSITE_REDIRECT_LOCATION),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            metadata: metadata,
            sseCustomerAlgorithm: headers.getFirst(S3Constants.SSE_CUSTOMER_ALGORITHM),
            sseCustomerKeyMD5: headers.getFirst(S3Constants.SSE_CUSTOMER_KEY_MD5),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            storageClass: headers.getFirst(S3Constants.STORAGE_CLASS),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED),
            replicationStatus: headers.getFirst(S3Constants.REPLICATION_STATUS),
            partsCount: headers.getFirst(S3Constants.PARTS_COUNT)?.toInt32(),
            objectLockMode: headers.getFirst(S3Constants.OBJECT_LOCK_MODE),
            objectLockRetainUntilDate: headers.getFirst(S3Constants.OBJECT_LOCK_RETAIN_UNTIL_DATE)?.toDateIso8601(),
            objectLockLegalHoldStatus: headers.getFirst(S3Constants.OBJECT_LOCK_LEGAL_HOLD_STATUS)
        )
    }
}

// -----
//
// -----

public class HeadObjectRequest <: AbstractS3Request {
    public HeadObjectRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let ifMatch!: ?String = None,
        public let ifModifiedSince!: ?DateTime = None,
        public let ifNoneMatch!: ?String = None,
        public let ifUnmodifiedSince!: ?DateTime = None,
        public let partNumber!: ?Int32 = None,
        public let range!: ?String = None,
        public let versionId!: ?String = None,
        public let checksumMode!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let requestPayer!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "HeadObjectRequest(" +
            "bucket=${bucket}, key=${key}, ifMatch=${ifMatch}, ifModifiedSince=${ifModifiedSince}, " +
            "ifNoneMatch=${ifNoneMatch}, ifUnmodifiedSince=${ifUnmodifiedSince}, range=${range}, versionId=${versionId}, " +
            "sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, requestPayer=${requestPayer}, " +
            "partNumber=${partNumber}, expectedBucketOwner=${expectedBucketOwner}, checksumMode=${checksumMode}" + ")"
    }
}

public class HeadObjectResponse <: AbstractS3Response {
    public HeadObjectResponse(
        responseMetadata: S3ResponseMetadata,
        public let deleteMarker!: ?Bool = None,
        public let acceptRanges!: ?String = None,
        public let expiration!: ?String = None,
        public let restore!: ?String = None,
        public let archiveStatus!: ?String = None,
        public let lastModified!: ?DateTime = None,
        public let contentLength!: ?Int64 = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let etag!: ?String = None,
        public let missingMeta!: ?Int32 = None,
        public let versionId!: ?String = None,
        public let cacheControl!: ?String = None,
        public let contentDisposition!: ?String = None,
        public let contentEncoding!: ?String = None,
        public let contentLanguage!: ?String = None,
        public let contentType!: ?String = None,
        public let expires!: ?DateTime = None,
        public let websiteRedirectLocation!: ?String = None,
        public let serverSideEncryption!: ?String = None,
        public let metadata!: ?Map<String, String> = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let storageClass!: ?String = None,
        public let requestCharged!: ?String = None,
        public let replicationStatus!: ?String = None,
        public let partsCount!: ?Int32 = None,
        public let objectLockMode!: ?String = None,
        public let objectLockRetainUntilDate!: ?DateTime = None,
        public let objectLockLegalHoldStatus!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "HeadObjectResponse(" +
            "deleteMarker=${deleteMarker}, acceptRanges=${acceptRanges}, expiration=${expiration}, restore=${restore}, " +
            "archiveStatus=${archiveStatus}, lastModified=${lastModified}, contentLength=${contentLength}, checksumCRC32=${checksumCRC32}, " +
            "checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, etag=${etag}, " +
            "missingMeta=${missingMeta}, versionId=${versionId}, cacheControl=${cacheControl}, contentDisposition=${contentDisposition}, " +
            "contentEncoding=${contentEncoding}, contentLanguage=${contentLanguage}, contentType=${contentType}, expires=${expires}, " +
            "websiteRedirectLocation=${websiteRedirectLocation}, serverSideEncryption=${serverSideEncryption}, metadata=${ToStringUtils.mapToString2(metadata)}, sseCustomerAlgorithm=${sseCustomerAlgorithm}, " +
            "sseCustomerKeyMD5=${sseCustomerKeyMD5}, ssekmsKeyId=${ssekmsKeyId}, bucketKeyEnabled=${bucketKeyEnabled}, storageClass=${storageClass}, " +
            "requestCharged=${requestCharged}, replicationStatus=${replicationStatus}, partsCount=${partsCount}, objectLockMode=${objectLockMode}, " +
            "objectLockRetainUntilDate=${objectLockRetainUntilDate}, objectLockLegalHoldStatus=${objectLockLegalHoldStatus}" +
            ")"
    }
}
