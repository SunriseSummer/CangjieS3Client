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
public class PutBucketAcl <: AbstractS3Action<PutBucketAclRequest, PutBucketAclResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketAclRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketAcl"
        }
    }

    protected func marshalling(s3Req: PutBucketAclRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "acl")
        httpReq.addHeader(S3Constants.ACL, s3Req.acl)
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.GRANT_FULL_CONTROL, s3Req.grantFullControl)
        httpReq.addHeader(S3Constants.GRANT_READ, s3Req.grantRead)
        httpReq.addHeader(S3Constants.GRANT_WRITE, s3Req.grantWrite)
        httpReq.addHeader(S3Constants.GRANT_READ_ACP, s3Req.grantReadACP)
        httpReq.addHeader(S3Constants.GRANT_WRITE_ACP, s3Req.grantWriteACP)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.accessControlPolicy.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketAclResponse {
        return PutBucketAclResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketAclRequest <: AbstractS3Request {
    public PutBucketAclRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let acl!: ?String = None,
        public let accessControlPolicy!: AccessControlPolicy = AccessControlPolicy(),
        public let contentMD5!: ?String = None,
        public let checksumAlgorithm!: ?String = None,
        public let grantFullControl!: ?String = None,
        public let grantRead!: ?String = None,
        public let grantWrite!: ?String = None,
        public let grantReadACP!: ?String = None,
        public let grantWriteACP!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketAclRequest(" +
            "bucket=${bucket}, acl=${acl}, accessControlPolicy=${accessControlPolicy}, contentMD5=${contentMD5}, " +
            "checksumAlgorithm=${checksumAlgorithm}, grantFullControl=${grantFullControl}, grantRead=${grantRead}, " +
            "grantWrite=${grantWrite}, grantReadACP=${grantReadACP}, grantWriteACP=${grantWriteACP}, " +
            "expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class PutBucketAclResponse <: AbstractS3Response {
    public PutBucketAclResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketAclResponse()"
    }
}
