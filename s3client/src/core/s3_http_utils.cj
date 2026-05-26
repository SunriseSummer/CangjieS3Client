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
 * @date: 2023-12-19
 */
public class S3HttpUtils {
    private static let ENCODED_CHARACTERS_WITH_SLASHES = ["+", "*", "%7E", "%2F"]
    private static let ENCODED_CHARACTERS_WITH_SLASHES_REPLACEMENTS = ["%20", "%2A", "~", "/"]

    private static let ENCODED_CHARACTERS_WITHOUT_SLASHES = ["+", "*", "%7E"]
    private static let ENCODED_CHARACTERS_WITHOUT_SLASHES_REPLACEMENTS = ["%20", "%2A", "~"]

    public static func urlEncode(value: String): String {
        return urlEncode(value, false)
    }

    private static func urlEncode(value: String, ignoreSlashes: Bool): String {
        let form = Form()
        form.add("key", value)
        let encoded = form.toEncodeString()[4..]

        if (!ignoreSlashes) {
            return StringUtils.replaceEach(
                encoded,
                ENCODED_CHARACTERS_WITHOUT_SLASHES,
                ENCODED_CHARACTERS_WITHOUT_SLASHES_REPLACEMENTS
            )
        }

        return StringUtils.replaceEach(
            encoded,
            ENCODED_CHARACTERS_WITH_SLASHES,
            ENCODED_CHARACTERS_WITH_SLASHES_REPLACEMENTS
        )
    }

    public static func clone(original: HttpHeaders): HttpHeaders {
        let cloned = HttpHeaders()
        for ((k, values) in original) {
            for (v in values) {
                cloned.add(k, v)
            }
        }
        return cloned
    }

    public static func headersToString(headers: HttpHeaders): String {
        return ToStringUtils.mapToString(headers)
        // let str = headers |>
        //     map<(String, Collection<String>), String> {
        //     kv => kv[0] + ":" + ToStringUtils.listToString(kv[1])
        // } |> collectString<(String)>(delimiter: ", ")
        // return "{" + str + "}"
    }

    public static func bodyToString(body: ?S3Content): String {
        return match (body) {
            case Some(v) => if (v.isReadOnce) {
                "<read-once-body>"
            } else {
                if (S3MimeType.isStringType(v.contentType ?? "")) {
                    v.toStringUtf8()
                } else {
                    "<stream-body>"
                }
            }
            case None => "<nobody>"
        }
    }
}
