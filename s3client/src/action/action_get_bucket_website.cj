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
public class GetBucketWebsite <: AbstractS3Action<GetBucketWebsiteRequest, GetBucketWebsiteResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketWebsiteRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketWebsite"
        }
    }

    protected func marshalling(s3Req: GetBucketWebsiteRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "website")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketWebsiteResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = WebsiteConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketWebsiteResponse(
            S3ResponseMetadata(httpRsp.headers),
            errorDocument: configuration.errorDocument,
            indexDocument: configuration.indexDocument,
            redirectAllRequestsTo: configuration.redirectAllRequestsTo,
            routingRules: configuration.routingRules
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketWebsiteRequest <: AbstractS3Request {
    public GetBucketWebsiteRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketWebsiteRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketWebsiteResponse <: AbstractS3Response {
    public GetBucketWebsiteResponse(
        responseMetadata: S3ResponseMetadata,
        public let errorDocument!: ?ErrorDocument = None,
        public let indexDocument!: ?IndexDocument = None,
        public let redirectAllRequestsTo!: ?RedirectAllRequestsTo = None,
        public let routingRules!: ?ArrayList<RoutingRule> = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketWebsiteResponse(" +
            "errorDocument=${errorDocument}, indexDocument=${indexDocument}, redirectAllRequestsTo=${redirectAllRequestsTo}, " +
            "routingRules=${routingRules}" + ")"
    }
}
