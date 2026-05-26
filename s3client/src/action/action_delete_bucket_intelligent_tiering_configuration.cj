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
public class DeleteBucketIntelligentTieringConfiguration <: AbstractS3Action<DeleteBucketIntelligentTieringConfigurationRequest,
    DeleteBucketIntelligentTieringConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: DeleteBucketIntelligentTieringConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "DeleteBucketIntelligentTieringConfiguration"
        }
    }

    protected func marshalling(s3Req: DeleteBucketIntelligentTieringConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("DELETE", bucket: s3Req.bucket, action: "intelligent-tiering")
        httpReq.addQueryParam(S3Constants.QUERY_ID, s3Req.id)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): DeleteBucketIntelligentTieringConfigurationResponse {
        return DeleteBucketIntelligentTieringConfigurationResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class DeleteBucketIntelligentTieringConfigurationRequest <: AbstractS3Request {
    public DeleteBucketIntelligentTieringConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let id!: String
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "DeleteBucketIntelligentTieringConfigurationRequest(bucket=${bucket}, id=${id})"
    }
}

public class DeleteBucketIntelligentTieringConfigurationResponse <: AbstractS3Response {
    public DeleteBucketIntelligentTieringConfigurationResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "DeleteBucketIntelligentTieringConfigurationResponse()"
    }
}
