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
 * @date: 2023-12-01
 */
public class DeleteBucketLifecycle <: AbstractS3Action<DeleteBucketLifecycleRequest, DeleteBucketLifecycleResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: DeleteBucketLifecycleRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "DeleteBucketLifecycle"
        }
    }

    protected func marshalling(s3Req: DeleteBucketLifecycleRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("DELETE", bucket: s3Req.bucket, action: "lifecycle")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): DeleteBucketLifecycleResponse {
        return DeleteBucketLifecycleResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class DeleteBucketLifecycleRequest <: AbstractS3Request {
    public DeleteBucketLifecycleRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "DeleteBucketLifecycleRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class DeleteBucketLifecycleResponse <: AbstractS3Response {
    public DeleteBucketLifecycleResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "DeleteBucketLifecycleResponse()"
    }
}
