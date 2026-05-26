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
public class ListBucketAnalyticsConfigurations <: AbstractS3Action<ListBucketAnalyticsConfigurationsRequest,
    ListBucketAnalyticsConfigurationsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListBucketAnalyticsConfigurationsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListBucketAnalyticsConfigurations"
        }
    }

    protected func marshalling(s3Req: ListBucketAnalyticsConfigurationsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "analytics")
        httpReq.addQueryParam(S3Constants.QUERY_CONTINUATION_TOKEN, s3Req.continuationToken)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListBucketAnalyticsConfigurationsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let s3Rsp = ListBucketAnalyticsConfigurationsResponse(
            S3ResponseMetadata(httpRsp.headers),
            isTruncated: ele.childContent("IsTruncated")?.toBool(),
            continuationToken: ele.childContent("ContinuationToken"),
            nextContinuationToken: ele.childContent("NextContinuationToken"),
            analyticsConfigurationList: ele.childs(
                AnalyticsConfiguration.ELE_NAME,
                AnalyticsConfiguration.fromXml
            )
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListBucketAnalyticsConfigurationsRequest <: AbstractS3Request {
    public ListBucketAnalyticsConfigurationsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let continuationToken!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "ListBucketAnalyticsConfigurationsRequest(bucket=${bucket}, continuationToken=${continuationToken}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class ListBucketAnalyticsConfigurationsResponse <: AbstractS3Response {
    public ListBucketAnalyticsConfigurationsResponse(
        responseMetadata: S3ResponseMetadata,
        public let isTruncated!: ?Bool = None,
        public let continuationToken!: ?String = None,
        public let nextContinuationToken!: ?String = None,
        public let analyticsConfigurationList!: ?ArrayList<AnalyticsConfiguration> = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListBucketAnalyticsConfigurationsResponse(" +
            "isTruncated=${isTruncated}, continuationToken=${continuationToken}, nextContinuationToken=${nextContinuationToken}, " +
            "analyticsConfigurationList=${analyticsConfigurationList}" + ")"
    }
}
