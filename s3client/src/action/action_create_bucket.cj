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
 * @date: 2023-11-22
 */
public class CreateBucket <: AbstractS3Action<CreateBucketRequest, CreateBucketResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: CreateBucketRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "CreateBucket"
        }
    }

    protected func marshalling(s3Req: CreateBucketRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket)
        httpReq.addHeader(S3Constants.ACL, s3Req.acl)
        httpReq.addHeader(S3Constants.GRANT_FULL_CONTROL, s3Req.grantFullControl)
        httpReq.addHeader(S3Constants.GRANT_READ, s3Req.grantRead)
        httpReq.addHeader(S3Constants.GRANT_WRITE, s3Req.grantWrite)
        httpReq.addHeader(S3Constants.GRANT_READ_ACP, s3Req.grantReadACP)
        httpReq.addHeader(S3Constants.GRANT_WRITE_ACP, s3Req.grantWriteACP)
        httpReq.addHeader(S3Constants.BUCKET_OBJECT_LOCK_ENABLED, s3Req.objectLockEnabledForBucket?.toString())
        httpReq.addHeader(S3Constants.OBJECT_OWNERSHIP, s3Req.objectOwnership)

        let createBucketConfiguration = s3Req.configuration ?? CreateBucketConfiguration(
            locationConstraint: S3ConfigKeys.REGION.getOrThrow(getConfigMap()).id)
        let reqXml = createBucketConfiguration.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): CreateBucketResponse {
        return CreateBucketResponse(
            S3ResponseMetadata(httpRsp.headers),
            location: httpRsp.headers.getFirst(S3Constants.LOCATION).getOrThrow()
        )
    }
}

// -----
//
// -----

public class CreateBucketRequest <: AbstractS3Request {
    public CreateBucketRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let acl!: ?String = None,
        public let configuration!: ?CreateBucketConfiguration = None,
        public let grantFullControl!: ?String = None,
        public let grantRead!: ?String = None,
        public let grantWrite!: ?String = None,
        public let grantReadACP!: ?String = None,
        public let grantWriteACP!: ?String = None,
        public let objectLockEnabledForBucket!: ?Bool = None,
        public let objectOwnership!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "CreateBucketRequest(" +
            "bucket=${bucket}, acl=${acl}, configuration=${configuration}, grantFullControl=${grantFullControl}, " +
            "grantRead=${grantRead}, grantWrite=${grantWrite}, grantReadACP=${grantReadACP}, grantWriteACP=${grantWriteACP}, " +
            "objectLockEnabledForBucket=${objectLockEnabledForBucket}, objectOwnership=${objectOwnership}" + //
                ")"
    }
}

public class CreateBucketResponse <: AbstractS3Response {
    public CreateBucketResponse(
        responseMetadata: S3ResponseMetadata,
        public let location!: String
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "CreateBucketResponse(location=${location})"
    }
}
