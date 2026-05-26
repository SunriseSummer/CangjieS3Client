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
public class GetObjectAcl <: AbstractS3Action<GetObjectAclRequest, GetObjectAclResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetObjectAclRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetObjectAcl"
        }
    }

    protected func marshalling(s3Req: GetObjectAclRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, key: s3Req.key, action: "acl")
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetObjectAclResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let policy = AccessControlPolicy.fromXml(S3XmlElement.fromXml(rspXml))
        let headers = httpRsp.headers
        let s3Rsp = GetObjectAclResponse(
            S3ResponseMetadata(headers),
            owner: policy.owner.getOrThrow(),
            grants: policy.grants.getOrThrow(),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetObjectAclRequest <: AbstractS3Request {
    public GetObjectAclRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let versionId!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetObjectAclRequest(" +
            "bucket=${bucket}, key=${key}, versionId=${versionId}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class GetObjectAclResponse <: AbstractS3Response {
    public GetObjectAclResponse(
        responseMetadata: S3ResponseMetadata,
        public let owner!: Owner,
        public let grants!: ArrayList<Grant>,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetObjectAclResponse(owner=${owner}, grants=${grants}, requestCharged=${requestCharged})"
    }
}
