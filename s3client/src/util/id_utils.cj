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
 * @date: 2023-11-06
 */
public class IdUtils {
    private static let ID_CACHE = ConcurrentHashMap<Int64, (String, AtomicUInt64)>()
    public static func id(): String {
        // 每天一个key, value是yyyyMMddHHmmss-${counter}
        // TODO 测试时遇到过 DateTime.nowUTC() hang住的情况, 不知道什么原因
        let now = DateTime.nowUTC()
        let key = now.toUnixTimeStamp().toDays()
        let valueTuple = match (ID_CACHE.get(key)) {
            case Some(v) => v
            case None => ID_CACHE.addIfAbsent(key, (now.format("yyyyMMddHHmmss"), AtomicUInt64(0))) ?? ID_CACHE[key]
        }
        let id = valueTuple[0] + "-" + valueTuple[1].fetchAdd(1).toString()
        if (ID_CACHE.size > 1) {
            // 删除以前的数据
            for (i in 1..5) {
                ID_CACHE.remove(key - i)
            }
        }
        return id
    }

    // // 暂时没有使用uuid
    // public static func uuid(): String {
    //     return UUID.randomUUID().toString()
    // }
}

// // [复制/参考] https://gitee.com/HW-PLLab/uuid4cj, 开发项目的时候标准类库里还没有UUID, 以后标准类库里提供了再修改
// class UUID <: ToString {
//     private let bytes: Array<Byte> = Array(16, item: 0)

//     public init(data: Array<Byte>) {
//         if (data.size != 16) {
//             throw IllegalArgumentException("data must be 16 bytes in length")
//         }
//         data.copyTo(bytes, 0, 0, bytes.size)
//     }

//     /**
//      * Static factory to retrieve a type 4 (pseudo randomly generated) UUID.
//      * The {@code UUID} is generated using a cryptographically strong pseudo random number generator.
//      *
//      * @return  A randomly generated {@code UUID}
//      */
//     public static func randomUUID(): UUID {
//         let ng: SecureRandom = SecureRandom(priv: false)
//         let randomBytes = ng.nextBytes(16)
//         randomBytes[6] &= 0x0f /* clear version        */
//         randomBytes[6] |= 0x40 /* set to version 4     */
//         randomBytes[8] &= 0x3f /* clear variant        */
//         randomBytes[8] |= 0x80 /* set to IETF variant  */
//         return UUID(randomBytes)
//     }

//     /**
//      * Returns a {@code String} object representing this {@code UUID}.
//      *
//      * The UUID string representation is as described by this BNF:
//      * {@code
//      * UUID                   = <time_low> "-" <time_mid> "-"
//      *                          <time_high_and_version> "-"
//      *                          <variant_and_sequence> "-"
//      *                          <node>
//      * time_low               = 4*<hexOctet>
//      * time_mid               = 2*<hexOctet>
//      * time_high_and_version  = 2*<hexOctet>
//      * variant_and_sequence   = 2*<hexOctet>
//      * node                   = 6*<hexOctet>
//      * hexOctet               = <hexDigit><hexDigit>
//      * hexDigit               =
//      *       "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
//      *       | "a" | "b" | "c" | "d" | "e" | "f"
//      *       | "A" | "B" | "C" | "D" | "E" | "F"
//      * }
//      *
//      * @return A string representation of this {@code UUID}
//      */
//     public func toString(): String {
//         return (toHexString(this.bytes.slice(0, 4)) + "-" + toHexString(this.bytes.slice(4, 2)) + "-" + toHexString(
//             this.bytes.slice(6, 2)) + "-" + toHexString(this.bytes.slice(8, 2)) + "-" + toHexString(
//             this.bytes.slice(10, 6)))
//     }
// }
