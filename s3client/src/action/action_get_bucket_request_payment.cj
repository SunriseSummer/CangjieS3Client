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
 * @date: 2023-12-12
 */
public class GetBucketRequestPayment <: AbstractS3Action<GetBucketRequestPaymentRequest, GetBucketRequestPaymentResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketRequestPaymentRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketRequestPayment"
        }
    }

    protected func marshalling(s3Req: GetBucketRequestPaymentRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "requestPayment")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketRequestPaymentResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = RequestPaymentConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketRequestPaymentResponse(
            S3ResponseMetadata(httpRsp.headers),
            payer: configuration.payer
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketRequestPaymentRequest <: AbstractS3Request {
    public GetBucketRequestPaymentRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketRequestPaymentRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketRequestPaymentResponse <: AbstractS3Response {
    public GetBucketRequestPaymentResponse(
        responseMetadata: S3ResponseMetadata,
        public let payer!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketRequestPaymentResponse(payer=${payer})"
    }
}
