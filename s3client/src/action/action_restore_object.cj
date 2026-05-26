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
public class RestoreObject <: AbstractS3Action<RestoreObjectRequest, RestoreObjectResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: RestoreObjectRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "RestoreObject"
        }
    }

    protected func marshalling(s3Req: RestoreObjectRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("POST", bucket: s3Req.bucket, key: s3Req.key, action: "restore")
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.restoreRequest.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): RestoreObjectResponse {
        let headers = httpRsp.headers
        return RestoreObjectResponse(
            S3ResponseMetadata(headers),
            restoreOutputPath: headers.getFirst(S3Constants.RESTORE_OUTPUT_PATH),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class RestoreObjectRequest <: AbstractS3Request {
    public RestoreObjectRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let versionId!: ?String = None,
        public let restoreRequest!: RestoreRequest = RestoreRequest(),
        public let requestPayer!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "RestoreObjectRequest(" +
            "bucket=${bucket}, key=${key}, versionId=${versionId}, restoreRequest=${restoreRequest}, " +
            "requestPayer=${requestPayer}, checksumAlgorithm=${checksumAlgorithm}, expectedBucketOwner=${expectedBucketOwner}" +
            ")"
    }
}

public class RestoreObjectResponse <: AbstractS3Response {
    public RestoreObjectResponse(
        responseMetadata: S3ResponseMetadata,
        public let restoreOutputPath!: ?String = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "RestoreObjectResponse(restoreOutputPath=${restoreOutputPath}, requestCharged=${requestCharged})"
    }
}
