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
public class GetBucketAccelerateConfiguration <: AbstractS3Action<GetBucketAccelerateConfigurationRequest,
    GetBucketAccelerateConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketAccelerateConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketAccelerateConfiguration"
        }
    }

    protected func marshalling(s3Req: GetBucketAccelerateConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "accelerate")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketAccelerateConfigurationResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = AccelerateConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        return GetBucketAccelerateConfigurationResponse(
            S3ResponseMetadata(httpRsp.headers),
            status: configuration.status,
            requestCharged: httpRsp.headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class GetBucketAccelerateConfigurationRequest <: AbstractS3Request {
    public GetBucketAccelerateConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None,
        public let requestPayer!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketAccelerateConfigurationRequest(" +
            "bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner}, requestPayer=${requestPayer}" + ")"
    }
}

public class GetBucketAccelerateConfigurationResponse <: AbstractS3Response {
    public GetBucketAccelerateConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let status!: String,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketAccelerateConfigurationResponse(status=${status}, requestCharged=${requestCharged})"
    }
}
