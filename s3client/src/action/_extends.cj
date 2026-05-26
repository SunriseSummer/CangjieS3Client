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
 * @date: 2023-11-30
 */
extend String {
    public func toXml(eleName: String): String {
        return "<${eleName}>${this}</${eleName}>"
    }
}

extend ArrayList<String> {
    public func toXml(eleName: String): String {
        if (size == 0) {
            return ""
        }
        return this |> map<String, String> {item => item.toXml(eleName)} |> collectString<String>()
    }
}

extend String {
    public func toBool(): Bool {
        return Bool.parse(this.toAsciiLower())
    }

    public func toInt64(): Int64 {
        return Int64.parse(this)
    }

    public func toInt32(): Int32 {
        return Int32.parse(this)
    }

    public func toDateRfc822(): DateTime {
        return DateUtils.toDateRfc822(this)
    }

    public func toDateIso8601(): DateTime {
        return DateUtils.toDateIso8601(this)
    }
}

extend DateTime {
    public func toStringRfc822(): String {
        return DateUtils.toStringRfc822(this)
    }

    public func toStringIso8601(): String {
        return DateUtils.toStringIso8601(this)
    }
}
