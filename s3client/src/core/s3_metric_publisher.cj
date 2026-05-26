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
public interface S3MetricPublisher {
    func publish(collection: S3MetricCollection): Unit
}

public enum Format {
    PLAIN | PRETTY
}

public class LoggingS3MetricPublisher <: S3MetricPublisher {
    private static let LOGGER = S3LoggerFactory.getLogger("s3client.S3MetricPublisher")
    private static let INDENT_SIZE = 4
    private let level: LogLevel
    private let format: Format

    public init() {
        this(LogLevel.INFO, Format.PRETTY)
    }

    public init(logLevel: LogLevel, format: Format) {
        this.level = logLevel
        this.format = format
    }

    public func publish(collection: S3MetricCollection): Unit {
        if (!LOGGER.enabled(level)) {
            return
        }
        match (format) {
            case PLAIN => LOGGER.log(level) {"Metrics published: " + collection.toString()}
            case PRETTY => LOGGER.log(level) {"\n" + toPrettyString(collection, 0)}
        }
    }

    private func toPrettyString(collection: S3MetricCollection, indent: Int64): String {
        let records = ArrayList<String>()
        for (r in collection.getRecords()) {
            records.add("${r.metric} = ${r.value}")
        }

        let maxLen = getMaxLen(records)
        let indentStr = StringUtils.repeat(" ", indent)
        let dashStr = StringUtils.repeat("─", maxLen + 2)

        let sb = StringBuilder()
        // MetricCollection name
        sb.append("${indentStr} ${collection.name}")
        sb.append("\n")

        // Open box
        sb.append("${indentStr} ┌${dashStr}┐")
        sb.append("\n")

        // Metric key-value-pairs
        for (record in records) {
            sb.append("${indentStr} │ ${pad(record, maxLen)} │")
            sb.append("\n")
        }

        // Close box
        sb.append("${indentStr} └${dashStr}┘")
        sb.append("\n")

        // Recursively repeat for any children
        for (child in collection.getChildren()) {
            sb.append(toPrettyString(child, indent + INDENT_SIZE))
        }
        return sb.toString()
    }

    private static func getMaxLen(strings: ArrayList<String>): Int64 {
        var maxLen = 0
        for (str in strings) {
            maxLen = if (maxLen > str.size) {
                maxLen
            } else {
                str.size
            }
        }
        return maxLen
    }

    private static func pad(str: String, length: Int64): String {
        return str.padEnd(length)
    }
}
