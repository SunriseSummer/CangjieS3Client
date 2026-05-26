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
 * @date: 2023-12-18
 */
public class ListMultipartUploads <: AbstractS3Action<ListMultipartUploadsRequest, ListMultipartUploadsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: ListMultipartUploadsRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "ListMultipartUploads"
        }
    }

    protected func marshalling(s3Req: ListMultipartUploadsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "uploads")
        httpReq.addQueryParam(S3Constants.QUERY_DELIMITER, s3Req.delimiter)
        httpReq.addQueryParam(S3Constants.QUERY_ENCODING_TYPE, s3Req.encodingType)
        httpReq.addQueryParam(S3Constants.QUERY_KEY_MARKER, s3Req.keyMarker)
        httpReq.addQueryParam(S3Constants.QUERY_MAX_UPLOADS, s3Req.maxUploads?.toString())
        httpReq.addQueryParam(S3Constants.QUERY_PREFIX, s3Req.prefix)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID_MARKER, s3Req.uploadIdMarker)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): ListMultipartUploadsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        return ListMultipartUploadsResponse(
            S3ResponseMetadata(headers),
            bucket: ele.childContentRequired("Bucket"),
            keyMarker: ele.childContent("KeyMarker"),
            uploadIdMarker: ele.childContent("UploadIdMarker"),
            nextKeyMarker: ele.childContent("NextKeyMarker"),
            prefix: ele.childContent("Prefix"),
            delimiter: ele.childContent("Delimiter"),
            nextUploadIdMarker: ele.childContent("NextUploadIdMarker"),
            maxUploads: ele.childContent("MaxUploads")?.toInt32(),
            isTruncated: ele.childContentRequired("IsTruncated").toBool(),
            uploads: ele.childs(MultipartUpload.ELE_NAME, MultipartUpload.fromXml),
            commonPrefixes: ele.child("CommonPrefixes")?.childs("Prefix", CommonPrefix.fromXml),
            encodingType: ele.childContent("EncodingType"),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class ListMultipartUploadsRequest <: AbstractS3Request {
    public ListMultipartUploadsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let delimiter!: ?String = None,
        public let encodingType!: ?String = None,
        public let keyMarker!: ?String = None,
        public let maxUploads!: ?Int32 = None,
        public let prefix!: ?String = None,
        public let uploadIdMarker!: ?String = None,
        public let expectedBucketOwner!: ?String = None,
        public let requestPayer!: ?String = None
    ) {
        super(requestConfig)
    }

    public func nextRequest(prevRsp: ListMultipartUploadsResponse): ListMultipartUploadsRequest {
        return ListMultipartUploadsRequest(
            keyMarker: prevRsp.nextKeyMarker,
            uploadIdMarker: prevRsp.nextUploadIdMarker,
            requestConfig: this.requestConfig,
            bucket: this.bucket,
            delimiter: this.delimiter,
            encodingType: this.encodingType,
            maxUploads: this.maxUploads,
            prefix: this.prefix,
            expectedBucketOwner: this.expectedBucketOwner,
            requestPayer: this.requestPayer
        )
    }

    public func toString(): String {
        return "ListMultipartUploadsRequest(" + //
            "bucket=${bucket}, delimiter=${delimiter}, encodingType=${encodingType}, keyMarker=${keyMarker}, " + //
            "maxUploads=${maxUploads}, prefix=${prefix}, uploadIdMarker=${uploadIdMarker}, expectedBucketOwner=${expectedBucketOwner}, " + //
            "requestPayer=${requestPayer}" + //
                ")"
    }
}

public class ListMultipartUploadsResponse <: AbstractS3Response {
    public ListMultipartUploadsResponse(
        responseMetadata: S3ResponseMetadata,
        public let bucket!: String,
        public let keyMarker!: ?String = None,
        public let uploadIdMarker!: ?String = None,
        public let nextKeyMarker!: ?String = None,
        public let prefix!: ?String = None,
        public let delimiter!: ?String = None,
        public let nextUploadIdMarker!: ?String = None,
        public let maxUploads!: ?Int32 = None,
        public let isTruncated!: Bool,
        public let uploads!: ArrayList<MultipartUpload>,
        public let commonPrefixes!: ?ArrayList<CommonPrefix> = None,
        public let encodingType!: ?String = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "ListMultipartUploadsResponse(" + //
            "bucket=${bucket}, keyMarker=${keyMarker}, uploadIdMarker=${uploadIdMarker}, nextKeyMarker=${nextKeyMarker}, " +
            "prefix=${prefix}, delimiter=${delimiter}, nextUploadIdMarker=${nextUploadIdMarker}, maxUploads=${maxUploads}, " +
            "isTruncated=${isTruncated}, uploads=${uploads}, commonPrefixes=${commonPrefixes}, encodingType=${encodingType}, " +
            "requestCharged=${requestCharged}" + //
                ")"
    }
}
