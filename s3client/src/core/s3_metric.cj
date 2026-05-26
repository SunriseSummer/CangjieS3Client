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
public enum S3MetricLevel <: ToString {
    TRACE | INFO | ERROR

    public prop name: String {
        get() {
            let name = match (this) {
                case TRACE => "TRACE"
                case INFO => "INFO"
                case ERROR => "ERROR"
            }
            return name
        }
    }

    public func toString(): String {
        return "S3MetricLevel(${name})"
    }
}

public class S3Metric<T> <: ToString {
    public let name: String
    public let level: S3MetricLevel

    init(name: String, level: S3MetricLevel) {
        this.name = name
        this.level = level
    }

    public func toString(): String {
        return "S3Metric(name=${name}, level=${level})"
    }
}

public class S3MetricRecord <: ToString {
    public let metric: String
    public let value: ToString

    public init(metric: String, value: ToString) {
        this.metric = metric
        this.value = value
    }

    public func toString(): String {
        return "S3MetricRecord(metric=${metric}, value=${value})"
    }
}
