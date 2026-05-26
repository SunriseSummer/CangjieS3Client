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
public class ListBucketIntelligentTieringConfigurations <: AbstractS3Action<ListBucketIntelligentTieringConfigurationsRequest,
    ListBucketIntelligentTieringConfigurationsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListBucketIntelligentTieringConfigurationsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListBucketIntelligentTieringConfigurations"
        }
    }

    protected func marshalling(s3Req: ListBucketIntelligentTieringConfigurationsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "intelligent-tiering")
        httpReq.addQueryParam(S3Constants.QUERY_CONTINUATION_TOKEN, s3Req.continuationToken)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListBucketIntelligentTieringConfigurationsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let s3Rsp = ListBucketIntelligentTieringConfigurationsResponse(
            S3ResponseMetadata(httpRsp.headers),
            isTruncated: ele.childContent("IsTruncated")?.toBool(),
            continuationToken: ele.childContent("ContinuationToken"),
            nextContinuationToken: ele.childContent("NextContinuationToken"),
            intelligentTieringConfigurationList: ele.childs(
                IntelligentTieringConfiguration.ELE_NAME,
                IntelligentTieringConfiguration.fromXml
            )
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListBucketIntelligentTieringConfigurationsRequest <: AbstractS3Request {
    public ListBucketIntelligentTieringConfigurationsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let continuationToken!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "ListBucketIntelligentTieringConfigurationsRequest(bucket=${bucket}, continuationToken=${continuationToken})"
    }
}

public class ListBucketIntelligentTieringConfigurationsResponse <: AbstractS3Response {
    public ListBucketIntelligentTieringConfigurationsResponse(
        responseMetadata: S3ResponseMetadata,
        public let isTruncated!: ?Bool = None,
        public let continuationToken!: ?String = None,
        public let nextContinuationToken!: ?String = None,
        public let intelligentTieringConfigurationList!: ?ArrayList<IntelligentTieringConfiguration> = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListBucketIntelligentTieringConfigurationsResponse(" +
            "isTruncated=${isTruncated}, continuationToken=${continuationToken}, nextContinuationToken=${nextContinuationToken}, " +
            "intelligentTieringConfigurationList=${intelligentTieringConfigurationList}" + ")"
    }
}
