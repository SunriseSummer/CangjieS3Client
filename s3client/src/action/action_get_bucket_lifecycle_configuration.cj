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
 * @date: 2023-12-07
 */
public class GetBucketLifecycleConfiguration <: AbstractS3Action<GetBucketLifecycleConfigurationRequest,
    GetBucketLifecycleConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketLifecycleConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketLifecycleConfiguration"
        }
    }

    protected func marshalling(s3Req: GetBucketLifecycleConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "lifecycle")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketLifecycleConfigurationResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = LifecycleConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketLifecycleConfigurationResponse(
            S3ResponseMetadata(httpRsp.headers),
            rules: configuration.rules
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketLifecycleConfigurationRequest <: AbstractS3Request {
    public GetBucketLifecycleConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketLifecycleConfigurationRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketLifecycleConfigurationResponse <: AbstractS3Response {
    public GetBucketLifecycleConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let rules!: ArrayList<LifecycleRule>
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketLifecycleConfigurationResponse(rules=${rules})"
    }
}
