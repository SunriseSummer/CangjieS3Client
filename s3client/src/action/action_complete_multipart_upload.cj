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
public class CompleteMultipartUpload <: AbstractS3Action<CompleteMultipartUploadRequest, CompleteMultipartUploadResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: CompleteMultipartUploadRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "CompleteMultipartUpload"
        }
    }

    protected func marshalling(s3Req: CompleteMultipartUploadRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("POST", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID, s3Req.uploadId)
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32, s3Req.checksumCRC32)
        httpReq.addHeader(S3Constants.CHECKSUM_CRC32C, s3Req.checksumCRC32C)
        httpReq.addHeader(S3Constants.CHECKSUM_SHA1, s3Req.checksumSHA1)
        httpReq.addHeader(S3Constants.CHECKSUM_SHA256, s3Req.checksumSHA256)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_ALGORITHM, s3Req.sseCustomerAlgorithm)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY, s3Req.sseCustomerKey)
        httpReq.addHeader(S3Constants.SSE_CUSTOMER_KEY_MD5, s3Req.sseCustomerKeyMD5)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.multipartUpload.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): CompleteMultipartUploadResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        return CompleteMultipartUploadResponse(
            S3ResponseMetadata(headers),
            location: ele.childContent("Location"),
            bucket: ele.childContent("Bucket"),
            key: ele.childContent("Key"),
            etag: ele.childContent("ETag"),
            checksumCRC32: ele.childContent("ChecksumCRC32"),
            checksumCRC32C: ele.childContent("ChecksumCRC32C"),
            checksumSHA1: ele.childContent("ChecksumSHA1"),
            checksumSHA256: ele.childContent("ChecksumSHA256"),
            expiration: headers.getFirst(S3Constants.EXPIRATION),
            serverSideEncryption: headers.getFirst(S3Constants.SERVER_SIDE_ENCRYPTION),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            ssekmsKeyId: headers.getFirst(S3Constants.SSEKMS_KEY_ID),
            bucketKeyEnabled: headers.getFirst(S3Constants.BUCKET_KEY_ENABLED)?.toBool(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class CompleteMultipartUploadRequest <: AbstractS3Request {
    public CompleteMultipartUploadRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let uploadId!: String,
        public let multipartUpload!: CompletedMultipartUpload,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let sseCustomerAlgorithm!: ?String = None,
        public let sseCustomerKey!: ?String = None,
        public let sseCustomerKeyMD5!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "CompleteMultipartUploadRequest(" + //
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, multipartUpload=${multipartUpload}, " + //
            "checksumCRC32=${checksumCRC32}, checksumCRC32C=${checksumCRC32C}, checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, " +
            "sseCustomerAlgorithm=${sseCustomerAlgorithm}, sseCustomerKey=${sseCustomerKey}, sseCustomerKeyMD5=${sseCustomerKeyMD5}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}, " + //
                ")"
    }
}

public class CompleteMultipartUploadResponse <: AbstractS3Response {
    public CompleteMultipartUploadResponse(
        responseMetadata: S3ResponseMetadata,
        public let location!: ?String = None,
        public let bucket!: ?String = None,
        public let key!: ?String = None,
        public let expiration!: ?String = None,
        public let serverSideEncryption!: ?String = None,
        public let etag!: ?String = None,
        public let checksumCRC32!: ?String = None,
        public let checksumCRC32C!: ?String = None,
        public let checksumSHA1!: ?String = None,
        public let checksumSHA256!: ?String = None,
        public let versionId!: ?String = None,
        public let ssekmsKeyId!: ?String = None,
        public let bucketKeyEnabled!: ?Bool = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "CompleteMultipartUploadResponse(" + //
            "location=${location}, bucket=${bucket}, key=${key}, expiration=${expiration}, " +
            "serverSideEncryption=${serverSideEncryption}, etag=${etag}, checksumCRC32=${checksumCRC32}, checksumCRC32C=${checksumCRC32C}, " +
            "checksumSHA1=${checksumSHA1}, checksumSHA256=${checksumSHA256}, versionId=${versionId}, ssekmsKeyId=${ssekmsKeyId}, " +
            "bucketKeyEnabled=${bucketKeyEnabled}, requestCharged=${requestCharged}" + //
                ")"
    }
}
