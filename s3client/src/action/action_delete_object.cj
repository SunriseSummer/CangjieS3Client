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
 * @date: 2023-11-29
 */
public class DeleteObject <: AbstractS3Action<DeleteObjectRequest, DeleteObjectResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: DeleteObjectRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "DeleteObject"
        }
    }

    protected func marshalling(s3Req: DeleteObjectRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("DELETE", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.MFA, s3Req.mfa)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.BYPASS_GOVERNANCE_RETENTION, s3Req.bypassGovernanceRetention?.toString())
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): DeleteObjectResponse {
        let headers = httpRsp.headers
        return DeleteObjectResponse(
            S3ResponseMetadata(headers),
            deleteMarker: Bool.tryParse(headers.getFirst(S3Constants.DELETE_MARKER).getOrDefault({=> ""})),
            versionId: headers.getFirst(S3Constants.VERSION_ID),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class DeleteObjectRequest <: AbstractS3Request {
    public DeleteObjectRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let mfa!: ?String = None,
        public let versionId!: ?String = None,
        public let requestPayer!: ?String = None,
        public let bypassGovernanceRetention!: ?Bool = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "DeleteObjectRequest(" +
            "bucket=${bucket}, key=${key}, mfa=${mfa}, versionId=${versionId}, requestPayer=${requestPayer}, " +
            "bypassGovernanceRetention=${bypassGovernanceRetention}, expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class DeleteObjectResponse <: AbstractS3Response {
    public DeleteObjectResponse(
        responseMetadata: S3ResponseMetadata,
        public let deleteMarker!: ?Bool = None,
        public let versionId!: ?String = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "DeleteObjectResponse(deleteMarker=${deleteMarker}, versionId=${versionId}, requestCharged=${requestCharged})"
    }
}
