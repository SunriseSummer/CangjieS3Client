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
 * @date: 2023-11-28
 */
public interface S3Request <: ToString {
    prop requestConfig: ?S3RequestConfig
}

public abstract class AbstractS3Request <: S3Request {
    private let _requestConfig: ?S3RequestConfig

    public prop requestConfig: ?S3RequestConfig {
        get() {
            return _requestConfig
        }
    }

    protected init(requestConfig: ?S3RequestConfig) {
        this._requestConfig = requestConfig
    }
}

public class S3RequestConfig <: ToString {
    private let configMap = HashMap<String, Any>()

    func toConfigMap(): S3ConfigMap {
        return S3ConfigMap.create(configMap)
    }

    public static func create(): S3RequestConfig {
        return S3RequestConfig()
    }

    init() {
    }

    public func toString(): String {
        return "S3RequestConfig(${toConfigMap()})"
    }

    public func signer(signer: S3Signer): S3RequestConfig {
        configMap.add(S3ConfigKeys.SIGNER.qname, signer)
        return this
    }

    public func forcePathStyle(forcePathStyle: Bool): S3RequestConfig {
        configMap.add(S3ConfigKeys.FORCE_PATH_STYLE.qname, forcePathStyle)
        return this
    }

    public func metricPublishers(publishers: ArrayList<S3MetricPublisher>): S3RequestConfig {
        configMap.add(S3ConfigKeys.METRIC_PUBLISHERS.qname, publishers)
        return this
    }

    public func addLoggingMetricPublisher(): S3RequestConfig {
        let publishers = match (configMap.get(S3ConfigKeys.METRIC_PUBLISHERS.qname)) {
            case Some(v) => (v as ArrayList<S3MetricPublisher>).getOrThrow()
            case None => ArrayList<S3MetricPublisher>()
        }
        publishers.add(LoggingS3MetricPublisher())
        return metricPublishers(publishers)
    }

    public func retryer(retryer: S3Retryer<S3HttpResponse>): S3RequestConfig {
        configMap.add(S3ConfigKeys.RETRYER.qname, retryer)
        return this
    }

    public func loggingErrorResponse(loggingErrorResponse: Bool): S3RequestConfig {
        configMap.add(S3ConfigKeys.LOGGING_ERROR_RESPONSE.qname, loggingErrorResponse)
        return this
    }

    public func trailingChecksum(trailingChecksum: Bool): S3RequestConfig {
        configMap.add(S3ConfigKeys.TRAILING_CHECKSUM.qname, trailingChecksum)
        return this
    }
}
