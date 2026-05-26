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
 * @date: 2023-10-31
 */
public class S3LoggerFactory {
    public static var LOG_LEVEL: LogLevel = LogLevel.INFO
    public static var LOG_PROVIDER: () -> Logger = {=> SimpleLogger(getStdOut())}

    public static func getLogger(name: String, level!: LogLevel = LOG_LEVEL): S3Logger {
        let delegate = LOG_PROVIDER()
        delegate.level = level
        let logger: S3Logger = S3Logger(name, delegate)
        return logger
    }
}

public class S3Logger <: Logger {
    private let name: String
    private let delegate: Logger

    public init(name: String, delegate: Logger) {
        this.name = name
        this.delegate = delegate
    }

    public mut prop level: LogLevel {
        get() {
            delegate.level
        }
        set(v) {
            delegate.level = v
        }
    }

    public func withAttrs(attrs: Array<Attr>): Logger {
        return S3Logger(name, delegate.withAttrs(attrs))
    }

    public func log(level: LogLevel, message: String, attrs: Array<Attr>): Unit {
        let record = LogRecord(DateTime.nowUTC(), level, message, attrs)
        log(record)
    }

    public func log(level: LogLevel, message: () -> String, attrs: Array<Attr>): Unit {
        let record = LogRecord(DateTime.nowUTC(), level, message(), attrs)
        log(record)
    }

    public func log(record: LogRecord): Unit {
        if (!enabled(record.level)) {
            return
        }
        record.message = StringUtils.repeat(" ", 5 - record.level.toString().size) + "[${name}] " + record.message
        delegate.log(record)
    }

    public func isClosed(): Bool {
        delegate.isClosed()
    }

    public func close(): Unit {
        delegate.close()
    }

    // -----
    public func error(ex: Exception): Unit {
        log(LogLevel.ERROR, {=> ex.message}, ("exception", ex))
    }
}

// public func log(level: LogLevel, ex: ?Exception, msg_fn: ?() -> String): Unit {
//     if (!isEnabled(level)) {
//         return
//     }
//     var msg = match (msg_fn) {
//         case Some(fn) => fn()
//         case None => ""
//     }
//     if (let Some(ex) <- ex) {
//         if (msg == "") {
//             msg = ToStringUtils.exceptionToString(ex)
//         } else {
//             msg = msg + IOUtils.LINE_SEPARATOR + ToStringUtils.exceptionToString(ex)
//         }
//     }
//     if (let Some(context) <- S3RequestContext.current()) {
//         msg = "<${context.id}, ${context.action}> " + msg
//     }
//     // level 最长是5
//     msg = StringUtils.repeat(" ", 5 - level.toString().size) + "[${name}] " + msg
//     delegate.log(level, msg)
// }
