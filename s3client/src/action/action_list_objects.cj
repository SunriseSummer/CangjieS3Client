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
 * @date: 2023-11-29
 */
public class ListObjects <: AbstractS3Action<ListObjectsRequest, ListObjectsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListObjectsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListObjects"
        }
    }

    protected func marshalling(s3Req: ListObjectsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket)
        httpReq.addQueryParam(S3Constants.QUERY_DELIMITER, s3Req.delimiter)
        httpReq.addQueryParam(S3Constants.QUERY_ENCODING_TYPE, s3Req.encodingType)
        httpReq.addQueryParam(S3Constants.QUERY_MARKER, s3Req.marker)
        httpReq.addQueryParam(S3Constants.QUERY_MAX_KEYS, s3Req.maxKeys?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_PREFIX, s3Req.prefix)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.OPTIONAL_OBJECT_ATTRIBUTES, s3Req.optionalObjectAttributes)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListObjectsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        let s3Rsp = ListObjectsResponse(
            S3ResponseMetadata(headers),
            name: ele.childContentRequired("Name"),
            isTruncated: ele.childContentRequired("IsTruncated").toBool(),
            marker: ele.childContent("Marker"),
            nextMarker: ele.childContent("NextMarker"),
            contents: ele.childs(S3Object.ELE_NAME, S3Object.fromXml),
            prefix: ele.childContent("Prefix"),
            delimiter: ele.childContent("Delimiter"),
            maxKeys: ele.childContentRequired("MaxKeys").toInt64(),
            commonPrefixes: ele.childs("CommonPrefixes", CommonPrefix.fromXml),
            encodingType: ele.childContent("EncodingType"),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListObjectsRequest <: AbstractS3Request {
    public ListObjectsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let delimiter!: ?String = None,
        public let encodingType!: ?String = None,
        public let marker!: ?String = None,
        public let maxKeys!: ?Int64 = None,
        public let prefix!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let optionalObjectAttributes!: ?ArrayList<String> = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "ListObjectsRequest(" +
            "bucket=${bucket}, delimiter=${delimiter}, encodingType=${encodingType}, marker=${marker}, " +
            "maxKeys=${maxKeys}, prefix=${prefix}, requestPayer=${requestPayer}, expectedBucketOwner=${expectedBucketOwner}, " +
            "optionalObjectAttributes=${optionalObjectAttributes}" + ")"
    }
}

public class ListObjectsResponse <: AbstractS3Response {
    public ListObjectsResponse(
        responseMetadata: S3ResponseMetadata,
        public let name!: String,
        public let isTruncated!: Bool,
        public let marker!: ?String = None,
        public let nextMarker!: ?String = None,
        public let contents!: ?ArrayList<S3Object> = None,
        public let prefix!: ?String = None,
        public let delimiter!: ?String = None,
        public let maxKeys!: Int64,
        public let commonPrefixes!: ?ArrayList<CommonPrefix> = None,
        public let encodingType!: ?String = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListObjectsResponse(" +
            "name=${name}, isTruncated=${isTruncated}, marker=${marker}, nextMarker=${nextMarker}, " +
            "contents=${contents}, prefix=${prefix}, delimiter=${delimiter}, maxKeys=${maxKeys}, " +
            "commonPrefixes=${commonPrefixes}, encodingType=${encodingType}, requestCharged=${requestCharged}" + ")"
    }
}
