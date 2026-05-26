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
public class GetObjectLegalHold <: AbstractS3Action<GetObjectLegalHoldRequest, GetObjectLegalHoldResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetObjectLegalHoldRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetObjectLegalHold"
        }
    }

    protected func marshalling(s3Req: GetObjectLegalHoldRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, key: s3Req.key, action: "legal-hold")
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID, s3Req.versionId)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetObjectLegalHoldResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let legalHold = ObjectLockLegalHold.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetObjectLegalHoldResponse(
            S3ResponseMetadata(httpRsp.headers),
            legalHold: legalHold
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetObjectLegalHoldRequest <: AbstractS3Request {
    public GetObjectLegalHoldRequest(
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
        return "GetObjectLegalHoldRequest(" +
            "bucket=${bucket}, key=${key}, versionId=${versionId}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class GetObjectLegalHoldResponse <: AbstractS3Response {
    public GetObjectLegalHoldResponse(
        responseMetadata: S3ResponseMetadata,
        public let legalHold!: ObjectLockLegalHold
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetObjectLegalHoldResponse(legalHold=${legalHold})"
    }
}
