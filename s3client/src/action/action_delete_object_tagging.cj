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
 * @date: 2023-12-14
 */
public class DeleteObjectTagging <: AbstractS3Action<DeleteObjectTaggingRequest, DeleteObjectTaggingResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: DeleteObjectTaggingRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "DeleteObjectTagging"
        }
    }

    protected func marshalling(s3Req: DeleteObjectTaggingRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("DELETE", bucket: s3Req.bucket, key: s3Req.key, action: "tagging")
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): DeleteObjectTaggingResponse {
        let headers = httpRsp.headers
        return DeleteObjectTaggingResponse(
            S3ResponseMetadata(headers),
            versionId: headers.getFirst(S3Constants.VERSION_ID)
        )
    }
}

// -----
//
// -----

public class DeleteObjectTaggingRequest <: AbstractS3Request {
    public DeleteObjectTaggingRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let versionId!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "DeleteObjectTaggingRequest(bucket=${bucket}, key=${key}, versionId=${versionId}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class DeleteObjectTaggingResponse <: AbstractS3Response {
    public DeleteObjectTaggingResponse(
        responseMetadata: S3ResponseMetadata,
        public let versionId!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "DeleteObjectTaggingResponse(versionId=${versionId})"
    }
}
