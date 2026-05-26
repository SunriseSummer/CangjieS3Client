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
 * @date: 2023-11-30
 */
public class ListObjectsV2 <: AbstractS3Action<ListObjectsV2Request, ListObjectsV2Response> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListObjectsV2Request) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListObjectsV2"
        }
    }

    protected func marshalling(s3Req: ListObjectsV2Request): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "list-type=2")
        httpReq.addQueryParam(S3Constants.QUERY_DELIMITER, s3Req.delimiter)
        httpReq.addQueryParam(S3Constants.QUERY_ENCODING_TYPE, s3Req.encodingType)
        httpReq.addQueryParam(S3Constants.QUERY_MAX_KEYS, s3Req.maxKeys?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_PREFIX, s3Req.prefix)
        httpReq.addQueryParam(S3Constants.QUERY_CONTINUATION_TOKEN, s3Req.continuationToken)
        httpReq.addQueryParam(S3Constants.QUERY_FETCH_OWNER, s3Req.fetchOwner?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_START_AFTER, s3Req.startAfter)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.OPTIONAL_OBJECT_ATTRIBUTES, s3Req.optionalObjectAttributes)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListObjectsV2Response {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        let s3Rsp = ListObjectsV2Response(
            S3ResponseMetadata(headers),
            name: ele.childContentRequired("Name"),
            isTruncated: ele.childContentRequired("IsTruncated").toBool(),
            contents: ele.childs(S3Object.ELE_NAME, S3Object.fromXml),
            prefix: ele.childContent("Prefix"),
            delimiter: ele.childContent("Delimiter"),
            maxKeys: ele.childContentRequired("MaxKeys").toInt64(),
            commonPrefixes: ele.childs("CommonPrefixes", CommonPrefix.fromXml),
            encodingType: ele.childContent("EncodingType"),
            keyCount: ele.childContentRequired("KeyCount").toInt64(),
            continuationToken: ele.childContent("ContinuationToken"),
            nextContinuationToken: ele.childContent("NextContinuationToken"),
            startAfter: ele.childContent("StartAfter"),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
        return s3Rsp
    }
}

// -----
//
// -----
public class ListObjectsV2Request <: AbstractS3Request {
    public ListObjectsV2Request(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let delimiter!: ?String = None,
        public let encodingType!: ?String = None,
        public let maxKeys!: ?Int64 = None,
        public let continuationToken!: ?String = None,
        public let fetchOwner!: ?Bool = None,
        public let startAfter!: ?String = None,
        public let prefix!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let optionalObjectAttributes!: ?ArrayList<String> = None
    ) {
        super(requestConfig)
    }

    public func nextRequest(prevRsp: ListObjectsV2Response): ListObjectsV2Request {
        return ListObjectsV2Request(
            continuationToken: prevRsp.nextContinuationToken,
            requestConfig: this.requestConfig,
            bucket: this.bucket,
            delimiter: this.delimiter,
            encodingType: this.encodingType,
            maxKeys: this.maxKeys,
            fetchOwner: this.fetchOwner,
            startAfter: this.startAfter,
            prefix: this.prefix,
            requestPayer: this.requestPayer,
            expectedBucketOwner: this.expectedBucketOwner,
            optionalObjectAttributes: this.optionalObjectAttributes
        )
    }

    public func toString(): String {
        return "ListObjectsV2Request(" +
            "bucket=${bucket}, delimiter=${delimiter}, encodingType=${encodingType}, maxKeys=${maxKeys}, " +
            "continuationToken=${continuationToken}, fetchOwner=${fetchOwner}, startAfter=${startAfter}, prefix=${prefix}, " +
            "requestPayer=${requestPayer}, expectedBucketOwner=${expectedBucketOwner}, optionalObjectAttributes=${optionalObjectAttributes}" +
            ")"
    }
}

public class ListObjectsV2Response <: AbstractS3Response {
    public ListObjectsV2Response(
        responseMetadata: S3ResponseMetadata,
        public let name!: String,
        public let isTruncated!: Bool,
        public let contents!: ?ArrayList<S3Object> = None,
        public let prefix!: ?String = None,
        public let delimiter!: ?String = None,
        public let maxKeys!: Int64,
        public let commonPrefixes!: ?ArrayList<CommonPrefix> = None,
        public let encodingType!: ?String = None,
        public let keyCount!: Int64,
        public let continuationToken!: ?String = None,
        public let nextContinuationToken!: ?String = None,
        public let startAfter!: ?String = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListObjectsV2Response(" +
            "name=${name}, isTruncated=${isTruncated}, contents=${contents}, prefix=${prefix}, " +
            "delimiter=${delimiter}, maxKeys=${maxKeys}, commonPrefixes=${commonPrefixes}, encodingType=${encodingType}, " +
            "keyCount=${keyCount}, continuationToken=${continuationToken}, nextContinuationToken=${nextContinuationToken}, startAfter=${startAfter}, " +
            "requestCharged=${requestCharged}" + ")"
    }
}
