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

package s3client.util

/*
 *
 * @author: wangwb
 * @date: 2023-11-02
 */
public class StringUtils {
    public static func join<T>(values: Iterable<T>, delimiter: String): String where T <: ToString {
        let str = values |> collectString<T>(delimiter: delimiter)
        return str
    }

    public static func split(str: String, delimiter: String): Array<String> {
        return str.split(delimiter)
    }

    public static func trim(str: String): String {
        return str.trimAscii()
    }

    public static func isBlank(str: String): Bool {
        return str.isAsciiBlank()
    }

    public static func toLowerCase(str: String): String {
        return str.toAsciiLower()
    }

    public static func toUpperCase(str: String): String {
        return str.toAsciiUpper()
    }

    public static func replaceEach(str: String, searchArray: Array<String>, replacementArray: Array<String>): String {
        var result = str
        for (i in 0..searchArray.size) {
            result = result.replace(searchArray[i], replacementArray[i])
        }
        return result
    }

    public static func toString(bytes: Array<Byte>): String {
        return String.fromUtf8(bytes)
    }

    public static func toByteArray(str: String): Array<Byte> {
        return str.toArray()
    }

    // /**
    //  * a.b -> A_B
    //  * aaBb -> AA_BB
    //  * a.bbCc -> A_BB_CC
    //  * a-b-c -> A_B_C
    //  */
    // public static func toUnderscore(str: String): String {
    //     if (isBlank(str)) {
    //         return ""
    //     }
    //     let sb = StringBuilder(str.size)
    //     let charArr = toCharArray(str)
    //     for (ch in charArr) {
    //         if (ch == '.' || ch == '-') {
    //             sb.append("_")
    //         } else if (ch.isAsciiUpperCase() && !ch.isAsciiNumber()) {
    //             sb.append("_")
    //             sb.append(ch)
    //         } else {
    //             sb.append(ch.toAsciiUpperCase())
    //         }
    //     }
    //     return sb.toString()
    // }

    public static func repeat(str: String, count: Int64): String {
        if (count <= 0) {
            return ""
        }
        if (count == 1) {
            return str
        }
        let capacity = str.size * count
        let sb = StringBuilder(capacity)
        for (_ in 0..count) {
            sb.append(str)
        }
        return sb.toString()
    }
}
