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
public class GetBucketInventoryConfiguration <: AbstractS3Action<GetBucketInventoryConfigurationRequest,
    GetBucketInventoryConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketInventoryConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketInventoryConfiguration"
        }
    }

    protected func marshalling(s3Req: GetBucketInventoryConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "inventory")
        httpReq.addQueryParam(S3Constants.QUERY_ID, s3Req.id)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketInventoryConfigurationResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = InventoryConfiguration.fromXml(S3XmlElement.fromXml(rspXml)) // S3ResponseXml.toInventoryConfiguration(rspXml)
        return GetBucketInventoryConfigurationResponse(
            S3ResponseMetadata(httpRsp.headers),
            configuration: configuration
        )
    }
}

// -----
//
// -----

public class GetBucketInventoryConfigurationRequest <: AbstractS3Request {
    public GetBucketInventoryConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let id!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketInventoryConfigurationRequest(bucket=${bucket}, id=${id}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketInventoryConfigurationResponse <: AbstractS3Response {
    public GetBucketInventoryConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let configuration!: ?InventoryConfiguration = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketInventoryConfigurationResponse(configuration=${configuration})"
    }
}
