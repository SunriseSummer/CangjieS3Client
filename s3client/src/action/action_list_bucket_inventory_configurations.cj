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
public class ListBucketInventoryConfigurations <: AbstractS3Action<ListBucketInventoryConfigurationsRequest,
    ListBucketInventoryConfigurationsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListBucketInventoryConfigurationsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListBucketInventoryConfigurations"
        }
    }

    protected func marshalling(s3Req: ListBucketInventoryConfigurationsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "inventory")
        httpReq.addQueryParam(S3Constants.QUERY_CONTINUATION_TOKEN, s3Req.continuationToken)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListBucketInventoryConfigurationsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let s3Rsp = ListBucketInventoryConfigurationsResponse(
            S3ResponseMetadata(httpRsp.headers),
            isTruncated: ele.childContent("IsTruncated")?.toBool(),
            continuationToken: ele.childContent("ContinuationToken"),
            nextContinuationToken: ele.childContent("NextContinuationToken"),
            inventoryConfigurationList: ele.childs(
                InventoryConfiguration.ELE_NAME,
                InventoryConfiguration.fromXml
            )
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListBucketInventoryConfigurationsRequest <: AbstractS3Request {
    public ListBucketInventoryConfigurationsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let continuationToken!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "ListBucketInventoryConfigurationsRequest(bucket=${bucket}, continuationToken=${continuationToken}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class ListBucketInventoryConfigurationsResponse <: AbstractS3Response {
    public ListBucketInventoryConfigurationsResponse(
        responseMetadata: S3ResponseMetadata,
        public let isTruncated!: ?Bool = None,
        public let continuationToken!: ?String = None,
        public let nextContinuationToken!: ?String = None,
        public let inventoryConfigurationList!: ?ArrayList<InventoryConfiguration> = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListBucketInventoryConfigurationsResponse(" +
            "isTruncated=${isTruncated}, continuationToken=${continuationToken}, nextContinuationToken=${nextContinuationToken}, " +
            "inventoryConfigurationList=${inventoryConfigurationList}" + ")"
    }
}
