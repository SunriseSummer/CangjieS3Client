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
 * @date: 2023-12-11
 */
public class GetBucketNotificationConfiguration <: AbstractS3Action<GetBucketNotificationConfigurationRequest,
    GetBucketNotificationConfigurationResponse> {
    public init(s3ClientConfigMap: S3ConfigMap, s3Req: GetBucketNotificationConfigurationRequest) {
        super(s3ClientConfigMap, s3Req)
    }

    public prop name: String {
        get() {
            return "GetBucketNotificationConfiguration"
        }
    }

    protected func marshalling(s3Req: GetBucketNotificationConfigurationRequest): S3HttpRequestBuilder {
        let httpReq = createHttpRequest("GET", bucket: s3Req.bucket, action: "notification")
        httpReq.addHeader(S3Constants.EXPECTED_BUCKET_OWNER, s3Req.expectedBucketOwner)
        return httpReq
    }

    protected func unmarshalling(httpRsp: S3HttpResponse): GetBucketNotificationConfigurationResponse {
        let rspXml = httpRsp.body.toStringUtf8()
        let configuration = NotificationConfiguration.fromXml(S3XmlElement.fromXml(rspXml))
        let s3Rsp = GetBucketNotificationConfigurationResponse(
            S3ResponseMetadata(httpRsp.headers),
            topicConfigurations: configuration.topicConfigurations,
            queueConfigurations: configuration.queueConfigurations,
            lambdaFunctionConfigurations: configuration.lambdaFunctionConfigurations,
            eventBridgeConfiguration: configuration.eventBridgeConfiguration
        )
        return s3Rsp
    }
}

// -----
//
// -----

public class GetBucketNotificationConfigurationRequest <: AbstractS3Request {
    public GetBucketNotificationConfigurationRequest(
        requestConfig!: ?S3RequestConfig = None,
        public let bucket!: String,
        public let expectedBucketOwner!: ?String = None
    ) {
        super(requestConfig)
    }

    public func toString(): String {
        return "GetBucketNotificationConfigurationRequest(bucket=${bucket}, expectedBucketOwner=${expectedBucketOwner})"
    }
}

public class GetBucketNotificationConfigurationResponse <: AbstractS3Response {
    public GetBucketNotificationConfigurationResponse(
        responseMetadata: S3ResponseMetadata,
        public let topicConfigurations!: ?ArrayList<TopicConfiguration> = None,
        public let queueConfigurations!: ?ArrayList<QueueConfiguration> = None,
        public let lambdaFunctionConfigurations!: ?ArrayList<LambdaFunctionConfiguration> = None,
        public let eventBridgeConfiguration!: ?EventBridgeConfiguration = None
    ) {
        super(responseMetadata)
    }

    public func toString(): String {
        return "GetBucketNotificationConfigurationResponse(" +
            "topicConfigurations=${topicConfigurations}, queueConfigurations=${queueConfigurations}, lambdaFunctionConfigurations=${lambdaFunctionConfigurations}, " +
            "eventBridgeConfiguration=${eventBridgeConfiguration}" + ")"
    }
}
