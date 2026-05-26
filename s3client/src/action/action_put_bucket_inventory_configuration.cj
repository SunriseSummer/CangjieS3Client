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
 * @date: 2023-12-04
 */
public class PutBucketInventoryConfiguration <: AbstractS3Action<PutBucketInventoryConfigurationRequest,
    PutBucketInventoryConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketInventoryConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketInventoryConfiguration"
        }
    }

    protected func marshalling(s3Req: PutBucketInventoryConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "inventory")
        httpReq.addQueryParam(S3Constants.QUERY_ID, s3Req.id)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.configuration.toXml() // S3RequestXml.toXml(s3Req.configuration)
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketInventoryConfigurationResponse {
        return PutBucketInventoryConfigurationResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketInventoryConfigurationRequest <: AbstractS3Request {
    public PutBucketInventoryConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let id!: String,
        public let configuration!: InventoryConfiguration,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketInventoryConfigurationRequest(" +
            "bucket=${bucket}, id=${id}, configuration=${configuration}, expectedBucketOwner=${expectedBucketOwner}" +
            ")"
    }
}

public class PutBucketInventoryConfigurationResponse <: AbstractS3Response {
    public PutBucketInventoryConfigurationResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketInventoryConfigurationResponse()"
    }
}
