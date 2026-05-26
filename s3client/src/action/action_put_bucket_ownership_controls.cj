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
public class PutBucketOwnershipControls <: AbstractS3Action<PutBucketOwnershipControlsRequest,
    PutBucketOwnershipControlsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketOwnershipControlsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketOwnershipControls"
        }
    }

    protected func marshalling(s3Req: PutBucketOwnershipControlsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "ownershipControls")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.CONTENT_MD5, s3Req.contentMD5)
        let reqXml = s3Req.ownershipControls.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketOwnershipControlsResponse {
        return PutBucketOwnershipControlsResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketOwnershipControlsRequest <: AbstractS3Request {
    public PutBucketOwnershipControlsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let ownershipControls!: OwnershipControls,
        public let expectedBucketOwner!: ?String = None,
        public let contentMD5!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketOwnershipControlsRequest(" +
            "bucket=${bucket}, ownershipControls=${ownershipControls}, expectedBucketOwner=${expectedBucketOwner}, " +
            "contentMD5=${contentMD5}" + ")"
    }
}

public class PutBucketOwnershipControlsResponse <: AbstractS3Response {
    public PutBucketOwnershipControlsResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketOwnershipControlsResponse()"
    }
}
