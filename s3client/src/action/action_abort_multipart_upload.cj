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
public class AbortMultipartUpload <: AbstractS3Action<AbortMultipartUploadRequest, AbortMultipartUploadResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: AbortMultipartUploadRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "AbortMultipartUpload"
        }
    }

    protected func marshalling(s3Req: AbortMultipartUploadRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("DELETE", bucket: s3Req.bucket, key: s3Req.key)
        httpReq.addQueryParam(S3Constants.QUERY_UPLOAD_ID, s3Req.uploadId)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): AbortMultipartUploadResponse {
        return AbortMultipartUploadResponse(
            S3ResponseMetadata(httpRsp.headers),
            requestCharged: httpRsp.headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class AbortMultipartUploadRequest <: AbstractS3Request {
    // TODO toString() 可以考虑下反射
    public AbortMultipartUploadRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let key!: String,
        public let uploadId!: String,
        public let requestPayer!: ?String = None,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "AbortMultipartUploadRequest(" +
            "bucket=${bucket}, key=${key}, uploadId=${uploadId}, requestPayer=${requestPayer}, " +
            "expectedBucketOwner=${expectedBucketOwner}" + ")"
    }
}

public class AbortMultipartUploadResponse <: AbstractS3Response {
    public AbortMultipartUploadResponse(
        responseMetadata: S3ResponseMetadata,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "AbortMultipartUploadResponse(requestCharged=${requestCharged})"
    }
}
