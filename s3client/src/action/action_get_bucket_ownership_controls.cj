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
 * @date: 2023-12-11
 */
public class GetBucketOwnershipControls <: AbstractS3Action<GetBucketOwnershipControlsRequest,
    GetBucketOwnershipControlsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketOwnershipControlsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketOwnershipControls"
        }
    }

    protected func marshalling(s3Req: GetBucketOwnershipControlsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "ownershipControls")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketOwnershipControlsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ownershipControls = OwnershipControls.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketOwnershipControlsResponse(
            S3ResponseMetadata(httpRsp.headers),
            ownershipControls: ownershipControls
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketOwnershipControlsRequest <: AbstractS3Request {
    public GetBucketOwnershipControlsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketOwnershipControlsRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketOwnershipControlsResponse <: AbstractS3Response {
    public GetBucketOwnershipControlsResponse(
        responseMetadata: S3ResponseMetadata,
        public let ownershipControls!: ?OwnershipControls = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketOwnershipControlsResponse(ownershipControls=${ownershipControls})"
    }
}
