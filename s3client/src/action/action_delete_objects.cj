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
public class DeleteObjects <: AbstractS3Action<DeleteObjectsRequest, DeleteObjectsResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: DeleteObjectsRequest) {
        super(s3ClientConfigMap, s3Req, checksumRequired: true)
    }

    public prop name: String {
        get() {
            return "DeleteObjects"
        }
    }

    protected func marshalling(s3Req: DeleteObjectsRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("POST", bucket: s3Req.bucket, action: "delete")
        httpReq.addHeader(S3Constants.MFA, s3Req.mfa)
        httpReq.addHeader(S3Constants.REQUEST_PAYER, s3Req.requestPayer)
        httpReq.addHeader(S3Constants.BYPASS_GOVERNANCE_RETENTION, s3Req.bypassGovernanceRetention?.toString())
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.SDK_CHECKSUM_ALGORITHM, s3Req.checksumAlgorithm)
        let reqXml = s3Req.delete.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): DeleteObjectsResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let ele = S3XmlElement.fromXml(rspXml)
        let headers = httpRsp.headers
        return DeleteObjectsResponse(
            S3ResponseMetadata(headers),
            deleted: ele.childs(DeletedObject.ELE_NAME, DeletedObject.fromXml),
            errors: ele.childs(S3Error.ELE_NAME, S3Error.fromXml),
            requestCharged: headers.getFirst(S3Constants.REQUEST_CHARGED)
        )
    }
}

// -----
//
// -----

public class DeleteObjectsRequest <: AbstractS3Request {
    public DeleteObjectsRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let delete!: Delete,
        public let mfa!: ?String = None,
        public let requestPayer!: ?String = None,
        public let bypassGovernanceRetention!: ?Bool = None,
        public let expectedBucketOwner!: ?String = None,
        public let checksumAlgorithm!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "DeleteObjectsRequest(" + "bucket=${bucket}, delete=${delete}, mfa=${mfa}, requestPayer=${requestPayer}, " +
            "bypassGovernanceRetention=${bypassGovernanceRetention}, expectedBucketOwner=${expectedBucketOwner}, checksumAlgorithm=${checksumAlgorithm}" +
            ")"
    }
}

public class DeleteObjectsResponse <: AbstractS3Response {
    public DeleteObjectsResponse(
        responseMetadata: S3ResponseMetadata,
        public let deleted!: ?ArrayList<DeletedObject> = None,
        public let errors!: ?ArrayList<S3Error> = None,
        public let requestCharged!: ?String = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "DeleteObjectsResponse(deleted=${deleted}, errors=${errors}, requestCharged=${requestCharged})"
    }
}
