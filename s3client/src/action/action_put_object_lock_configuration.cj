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
public class PutObjectLockConfiguration <: AbstractS3Action<PutObjectLockConfigurationRequest,
    PutObjectLockConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutObjectLockConfigurationRequest) {
        super(s3ClientConfigMap, s3Req, checksumRequired: true)
    }

    public prop name: String {
        get() {
            return "PutObjectLockConfiguration"
        }
    }

    protected func marshalling(s3Req: PutObjectLockConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "object-lock")
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.TOKEN, s3Req.token)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.configuration.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutObjectLockConfigurationResponse {
        let headers = httpRsp.headers
        return PutObjectLockConfigurationResponse(
            S3ResponseMetadata(headers),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class PutObjectLockConfigurationRequest <: AbstractS3Request {
    public PutObjectLockConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let configuration!: ObjectLockConfiguration,
        public let contentMD5!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let requestPayer!: ?String = None,
        public let token!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutObjectLockConfigurationRequest(" +
            "bucket=${bucket}, configuration=${configuration}, contentMD5=${contentMD5}, checksumAlgorithm=${checksumAlgorithm}, " +
            "requestPayer=${requestPayer}, token=${token}, expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class PutObjectLockConfigurationResponse <: AbstractS3Response {
    public PutObjectLockConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutObjectLockConfigurationResponse(requestCharged=${requestCharged})"
    }
}
