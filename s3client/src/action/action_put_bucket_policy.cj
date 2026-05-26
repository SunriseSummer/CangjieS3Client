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
 * @date: 2023-12-05
 */
public class PutBucketPolicy <: AbstractS3Action<PutBucketPolicyRequest, PutBucketPolicyResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketPolicyRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketPolicy"
        }
    }

    protected func marshalling(s3Req: PutBucketPolicyRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "policy")
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(
            S3Constants.CONFIRM_REMOVE_SELF_BUCKET_ACCESS,
            s3Req.confirmRemoveSelfBucketAccess?.toString()
        )
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)

        let reqJson = s3Req.policy
        httpReq.setBody(S3Content.fromString(reqJson, S3MimeType.MIME_TYPE_JSON))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketPolicyResponse {
        return PutBucketPolicyResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketPolicyRequest <: AbstractS3Request {
    public PutBucketPolicyRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let contentMD5!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let confirmRemoveSelfBucketAccess!: ?Bool = None,
        public let policy!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketPolicyRequest(" +
            "bucket=${bucket}, contentMD5=${contentMD5}, checksumAlgorithm=${checksumAlgorithm}, " +
            "confirmRemoveSelfBucketAccess=${confirmRemoveSelfBucketAccess}, policy=${policy}, expectedBucketOwner=${expectedBucketOwner}" +
            ")"
    }
}

public class PutBucketPolicyResponse <: AbstractS3Response {
    public PutBucketPolicyResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketPolicyResponse()"
    }
}
