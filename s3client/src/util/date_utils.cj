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
 * @date: 2023-11-23
 */
public class DateUtils {
    // -----
    // 一般是:
    // header 是 toDateRfc822
    // query 和 payload 是 toDateIso8601
    // -----
    /* 
       XmlProtocolMarshaller.java
       private static Map<MarshallLocation, TimestampFormatTrait.Format> getDefaultTimestampFormats() {
        Map<MarshallLocation, TimestampFormatTrait.Format> formats = new EnumMap<>(MarshallLocation.class);
        formats.put(MarshallLocation.HEADER, TimestampFormatTrait.Format.RFC_822);
        formats.put(MarshallLocation.PAYLOAD, TimestampFormatTrait.Format.ISO_8601);
        formats.put(MarshallLocation.QUERY_PARAM, TimestampFormatTrait.Format.ISO_8601);
        return Collections.unmodifiableMap(formats);
       }
     */
    public static func toDateRfc822(str: String): DateTime {
        let value = str.replace("GMT", "UTC")
        return DateTime.parse(value, DateTimeFormat.RFC1123)
    }

    public static func toDateIso8601(str: String): DateTime {
        let value = str.replace("Z", "")
        return DateTime.parse(value, "yyyy-MM-ddTHH:mm:ss.S")
    }

    public static func toStringRfc822(date: DateTime): String {
        // RFC1123: Tue, 12 Dec 2023 07:04:50 UTC
        // RFC822: Tue, 12 Dec 2023 07:04:50 GMT
        let value = date.inUTC().format(DateTimeFormat.RFC1123)
        return value.replace("UTC", "GMT")
    }

    public static func toStringIso8601(date: DateTime): String {
        let value = date.inUTC().format("yyyy-MM-ddTHH:mm:ss.S") + "Z"
        return value
    }

    public static func toStringMidnight(date: ?DateTime): ?String {
        return match (date) {
            case Some(v) => v.inUTC().format("yyyy-MM-dd") + "T00:00:00.000Z"
            case None => None
        }
    }

    public static func toDateMidnight(str: ?String): ?DateTime {
        return match (str) {
            case Some(v) => DateTime.parse(v.replace("T00:00:00.000Z", ""), "yyyy-MM-dd")
            case None => None
        }
    }
}
