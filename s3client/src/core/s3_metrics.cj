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

package s3client.core

/*
 *
 * @author: wangwb
 * @date: 2024-01-04
 */
public class S3Metrics {
    private static func metric<T>(name: String, level: S3MetricLevel): S3Metric<T> where T <: ToString {
        return S3Metric<T>(name, level)
    }
    public static let SERVICE_ID = metric<String>("ServiceId", S3MetricLevel.ERROR)
    public static let OPERATION_NAME = metric<String>("OperationName", S3MetricLevel.ERROR)
    public static let API_CALL_SUCCESSFUL = metric<Bool>("ApiCallSuccessful", S3MetricLevel.ERROR)
    public static let RETRY_COUNT = metric<Int32>("RetryCount", S3MetricLevel.ERROR)
    public static let SERVICE_ENDPOINT = metric<URL>("ServiceEndpoint", S3MetricLevel.ERROR)
    public static let API_CALL_DURATION = metric<Duration>("ApiCallDuration", S3MetricLevel.INFO)
    // public static let CREDENTIALS_FETCH_DURATION = metric<Duration>("CredentialsFetchDuration", S3MetricLevel.INFO)
    // public static let TOKEN_FETCH_DURATION = metric<Duration>("TokenFetchDuration", S3MetricLevel.INFO)
    public static let BACKOFF_DELAY_DURATION = metric<Duration>("BackoffDelayDuration", S3MetricLevel.INFO)
    public static let MARSHALLING_DURATION = metric<Duration>("MarshallingDuration", S3MetricLevel.INFO)
    public static let SIGNING_DURATION = metric<Duration>("SigningDuration", S3MetricLevel.INFO)
    public static let SERVICE_CALL_DURATION = metric<Duration>("ServiceCallDuration", S3MetricLevel.INFO)
    public static let UNMARSHALLING_DURATION = metric<Duration>("UnmarshallingDuration", S3MetricLevel.INFO)
    public static let AWS_REQUEST_ID = metric<String>("AwsRequestId", S3MetricLevel.INFO)
    public static let AWS_EXTENDED_REQUEST_ID = metric<String>("AwsExtendedRequestId", S3MetricLevel.INFO)
    public static let ERROR_TYPE = metric<String>("ErrorType", S3MetricLevel.INFO)

    public static let HTTP_STATUS_CODE = metric<UInt16>("HttpStatusCode", S3MetricLevel.TRACE)
    public static let HTTP_CLIENT_NAME = metric<String>("HttpClientName", S3MetricLevel.INFO)
}
