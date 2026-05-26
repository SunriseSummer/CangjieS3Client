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
public class ListObjectVersions <: AbstractS3Action<ListObjectVersionsRequest, ListObjectVersionsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListObjectVersionsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListObjectVersions"
        }
    }

    protected func marshalling(s3Req: ListObjectVersionsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "versions")
        httpReq.addQueryParam(S3Constants.QUERY_DELIMITER, s3Req.delimiter)
        httpReq.addQueryParam(S3Constants.QUERY_ENCODING_TYPE, s3Req.encodingType)
        httpReq.addQueryParam(S3Constants.QUERY_KEY_MARKER, s3Req.keyMarker)
        httpReq.addQueryParam(S3Constants.QUERY_MAX_KEYS, s3Req.maxKeys?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_VERSION_ID_MARKER, s3Req.versionIdMarker)
        httpReq.addQueryParam(S3Constants.QUERY_PREFIX, s3Req.prefix)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.OPTIONAL_OBJECT_ATTRIBUTES, s3Req.optionalObjectAttributes)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListObjectVersionsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        let s3Rsp = ListObjectVersionsResponse(
            S3ResponseMetadata(headers),
            name: ele.childContentRequired("Name"),
            isTruncated: ele.childContentRequired("IsTruncated").toBool(),
            keyMarker: ele.childContent("KeyMarker"),
            nextKeyMarker: ele.childContent("NextKeyMarker"),
            versionIdMarker: ele.childContent("VersionIdMarker"),
            nextVersionIdMarker: ele.childContent("NextVersionIdMarker"),
            versions: ele.childs(ObjectVersion.ELE_NAME, ObjectVersion.fromXml),
            deleteMarkers: ele.childs(DeleteMarkerEntry.ELE_NAME, DeleteMarkerEntry.fromXml),
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
public class ListObjectVersionsRequest <: AbstractS3Request {
    public ListObjectVersionsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let delimiter!: ?String = None,
        public let encodingType!: ?String = None,
        public let keyMarker!: ?String = None,
        public let maxKeys!: ?Int64 = None,
        public let versionIdMarker!: ?String = None,
        public let prefix!: ?String = None,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let optionalObjectAttributes!: ?ArrayList<String> = None
    ) {
        super(requestConfig)
    }

    public func nextRequest(prevRsp: ListObjectVersionsResponse): ListObjectVersionsRequest {
        return ListObjectVersionsRequest(
            keyMarker: prevRsp.nextKeyMarker,
            versionIdMarker: prevRsp.nextVersionIdMarker,
            requestConfig: this.requestConfig,
            bucket: this.bucket,
            delimiter: this.delimiter,
            encodingType: this.encodingType,
            maxKeys: this.maxKeys,
            prefix: this.prefix,
            requestPayer: this.requestPayer,
            expectedBucketOwner: this.expectedBucketOwner,
            optionalObjectAttributes: this.optionalObjectAttributes
        )
    }

    public func toString(): String {
        return "ListObjectVersionsRequest(" +
            "bucket=${bucket}, delimiter=${delimiter}, encodingType=${encodingType}, keyMarker=${keyMarker}, " +
            "maxKeys=${maxKeys}, versionIdMarker=${versionIdMarker}, prefix=${prefix}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}, optionalObjectAttributes=${optionalObjectAttributes}" + ")"
    }
}

public class ListObjectVersionsResponse <: AbstractS3Response {
    public ListObjectVersionsResponse(
        responseMetadata: S3ResponseMetadata,
        public let name!: String, // bucket
        public let isTruncated!: Bool,
        public let keyMarker!: ?String = None,
        public let nextKeyMarker!: ?String = None,
        public let versionIdMarker!: ?String = None,
        public let nextVersionIdMarker!: ?String = None,
        public let versions!: ?ArrayList<ObjectVersion> = None,
        public let deleteMarkers!: ?ArrayList<DeleteMarkerEntry> = None,
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
        return "ListObjectVersionsResponse(" +
            "name=${name}, isTruncated=${isTruncated}, keyMarker=${keyMarker}, nextKeyMarker=${nextKeyMarker}, " +
            "versionIdMarker=${versionIdMarker}, nextVersionIdMarker=${nextVersionIdMarker}, versions=${versions}, deleteMarkers=${deleteMarkers}, " +
            "prefix=${prefix}, delimiter=${delimiter}, maxKeys=${maxKeys}, commonPrefixes=${commonPrefixes}, " +
            "encodingType=${encodingType}, requestCharged=${requestCharged}" + ")"
    }
}
