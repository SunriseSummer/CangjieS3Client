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
public class PutBucketLifecycleConfiguration <: AbstractS3Action<PutBucketLifecycleConfigurationRequest,
    PutBucketLifecycleConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketLifecycleConfigurationRequest) {
        super(s3ClientConfigMap, s3Req, checksumRequired: true)
    }

    public prop name: String {
        get() {
            return "PutBucketLifecycleConfiguration"
        }
    }

    protected func marshalling(s3Req: PutBucketLifecycleConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "lifecycle")
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        let reqXml = s3Req.configuration.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketLifecycleConfigurationResponse {
        return PutBucketLifecycleConfigurationResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketLifecycleConfigurationRequest <: AbstractS3Request {
    public PutBucketLifecycleConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let checksumAlgorithm!: ?String = None,
        public let configuration!: LifecycleConfiguration,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketLifecycleConfigurationRequest(" +
            "bucket=${bucket}, checksumAlgorithm=${checksumAlgorithm}, configuration=${configuration}, expectedBucketOwner=${expectedBucketOwner}" +
            ")"
    }
}

public class PutBucketLifecycleConfigurationResponse <: AbstractS3Response {
    public PutBucketLifecycleConfigurationResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketLifecycleConfigurationResponse()"
    }
}
