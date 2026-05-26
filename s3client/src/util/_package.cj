
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


internal import std.collection.ArrayList
internal import std.collection.Map
internal import std.collection.HashMap
internal import std.collection.EquatableCollection
internal import std.collection.map
internal import std.collection.collectString
internal import std.collection.collectArrayList
internal import std.collection.concurrent.ConcurrentHashMap
internal import std.sync.AtomicUInt64
internal import std.time.DateTime
internal import std.time.DateTimeFormat
internal import std.time.TimeZone
internal import std.io.InputStream
internal import std.io.OutputStream
internal import std.io.ByteBuffer
internal import std.io.StringWriter
internal import std.io.StringReader
internal import std.unicode.UnicodeRuneExtension
internal import std.reflect.TypeInfo


internal import stdx.crypto.crypto.SecureRandom
internal import stdx.crypto.digest.HMAC
internal import stdx.crypto.digest.MD5
internal import stdx.crypto.digest.SHA1
internal import stdx.crypto.digest.SHA256
internal import stdx.crypto.digest.HashType
internal import stdx.encoding.hex.toHexString
internal import stdx.encoding.hex.fromHexString
internal import stdx.encoding.base64.toBase64String


