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
public class GetObjectLockConfiguration <: AbstractS3Action<GetObjectLockConfigurationRequest,
    GetObjectLockConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetObjectLockConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetObjectLockConfiguration"
        }
    }

    protected func marshalling(s3Req: GetObjectLockConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "object-lock")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetObjectLockConfigurationResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = ObjectLockConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetObjectLockConfigurationResponse(
            S3ResponseMetadata(httpRsp.headers),
            configuration: configuration
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetObjectLockConfigurationRequest <: AbstractS3Request {
    public GetObjectLockConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetObjectLockConfigurationRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetObjectLockConfigurationResponse <: AbstractS3Response {
    public GetObjectLockConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let configuration!: ObjectLockConfiguration
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetObjectLockConfigurationResponse(configuration=${configuration})"
    }
}
