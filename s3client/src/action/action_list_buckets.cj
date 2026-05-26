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
 * @date: 2023-11-22
 */
public class ListBuckets <: AbstractS3Action<ListBucketsRequest, ListBucketsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListBucketsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListBuckets"
        }
    }

    protected func marshalling(_: ListBucketsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET")
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListBucketsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let s3Rsp = ListBucketsResponse(
            S3ResponseMetadata(httpRsp.headers),
            owner: ele.childRequired(Owner.ELE_NAME, Owner.fromXml),
            buckets: ele.childs(Bucket.ELE_NAME, Bucket.fromXml)
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListBucketsRequest <: AbstractS3Request {
    public ListBucketsRequest(requestConfig!: ?S3RequestConfig = None) {
        super(requestConfig)
    }

    public func toString(): String {
        return "ListBucketsRequest()"
    }
}

public class ListBucketsResponse <: AbstractS3Response {
    public ListBucketsResponse(
        responseMetadata: S3ResponseMetadata,
        public let owner!: Owner,
        public let buckets!: ArrayList<Bucket>
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListBucketsResponse(owner=${owner}, buckets=${buckets})"
    }
}
