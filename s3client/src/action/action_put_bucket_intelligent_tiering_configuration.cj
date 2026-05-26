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
public class PutBucketIntelligentTieringConfiguration <: AbstractS3Action<PutBucketIntelligentTieringConfigurationRequest,
    PutBucketIntelligentTieringConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketIntelligentTieringConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketIntelligentTieringConfiguration"
        }
    }

    protected func marshalling(s3Req: PutBucketIntelligentTieringConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "intelligent-tiering")
        httpReq.addQueryParam(S3Constants.QUERY_ID, s3Req.id)
        let reqXml = s3Req.configuration.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketIntelligentTieringConfigurationResponse {
        return PutBucketIntelligentTieringConfigurationResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketIntelligentTieringConfigurationRequest <: AbstractS3Request {
    public PutBucketIntelligentTieringConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let id!: String,
        public let configuration!: IntelligentTieringConfiguration
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketIntelligentTieringConfigurationRequest(" +
            "bucket=${bucket}, id=${id}, configuration=${configuration}" + ")"
    }
}

public class PutBucketIntelligentTieringConfigurationResponse <: AbstractS3Response {
    public PutBucketIntelligentTieringConfigurationResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketIntelligentTieringConfigurationResponse()"
    }
}
