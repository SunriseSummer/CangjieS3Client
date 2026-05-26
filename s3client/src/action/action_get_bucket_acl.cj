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
 * @date: 2023-12-06
 */
public class GetBucketAcl <: AbstractS3Action<GetBucketAclRequest, GetBucketAclResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketAclRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketAcl"
        }
    }

    protected func marshalling(s3Req: GetBucketAclRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "acl")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketAclResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let policy = AccessControlPolicy.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketAclResponse(
            S3ResponseMetadata(httpRsp.headers),
            owner: policy.owner.getOrThrow(),
            grants: policy.grants.getOrThrow()
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketAclRequest <: AbstractS3Request {
    public GetBucketAclRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketAclRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketAclResponse <: AbstractS3Response {
    public GetBucketAclResponse(
        responseMetadata: S3ResponseMetadata,
        public let owner!: Owner,
        public let grants!: ArrayList<Grant>
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketAclResponse(owner=${owner}, grants=${grants})"
    }
}
