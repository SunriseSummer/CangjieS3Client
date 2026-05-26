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
 * @date: 2023-12-05
 */
public class PutBucketNotificationConfiguration <: AbstractS3Action<PutBucketNotificationConfigurationRequest,
    PutBucketNotificationConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: PutBucketNotificationConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "PutBucketNotificationConfiguration"
        }
    }

    protected func marshalling(s3Req: PutBucketNotificationConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("PUT", bucket: s3Req.bucket, action: "notification")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        httpReq.addHeader(S3Constants.SKIP_DESTINATION_VALIDATION, s3Req.skipDestinationValidation?.toString())
        let reqXml = s3Req.configuration.toXml()
        httpReq.setBody(S3Content.fromString(reqXml, S3MimeType.MIME_TYPE_XML))
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): PutBucketNotificationConfigurationResponse {
        return PutBucketNotificationConfigurationResponse(S3ResponseMetadata(httpRsp.headers))
    }
}

// -----
//
// -----

public class PutBucketNotificationConfigurationRequest <: AbstractS3Request {
    public PutBucketNotificationConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let configuration!: NotificationConfiguration,
        public let expectedBucketOwner!: ?String = None,
        public let skipDestinationValidation!: ?Bool = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "PutBucketNotificationConfigurationRequest(" +
            "bucket=${bucket}, configuration=${configuration}, expectedBucketOwner=${expectedBucketOwner}, " +
            "skipDestinationValidation=${skipDestinationValidation}" + ")"
    }
}

public class PutBucketNotificationConfigurationResponse <: AbstractS3Response {
    public PutBucketNotificationConfigurationResponse(responseMetadata: S3ResponseMetadata) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "PutBucketNotificationConfigurationResponse()"
    }
}
