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
 * @date: 2023-11-21
 */
public interface S3Content <: S3Closeable & ToString {
    // 是否只能读一次:
    // true: 只能调用一次 stream(), 第二次调用会抛异常
    // false: 每次调用 stream() 方法返回新的 stream
    prop isReadOnce: Bool
    prop contentLength: ?Int64
    prop contentType: ?String
    func stream(): InputStream

    // -----
    func readAndDo(action: (Array<Byte>) -> Unit): Unit {
        try {
            IOUtils.readAndDo(stream(), action)
        } finally {
            close()
        }
    }

    // -----

    func toFile(path: String, overwrite: Bool): Unit {
        toFile(Path(path), overwrite)
    }

    func toFile(path: Path, overwrite: Bool): Unit {
        if (!exists(path)) {
            if (!exists(path.parent)) {
                Directory.create(path.parent, recursive: true)
            }
        }
        let option = if (overwrite) {
            OpenMode.Write
        } else {
            OpenMode.Append
        }
        try (file = File(path, option)) {
            // File.create(path)
            IOUtils.readAndDo(stream(), {bytes => file.write(bytes)})
            file.flush()
        } finally {
            close()
        }
    }

    func toStringUtf8(): String {
        try {
            return IOUtils.copyToString(stream())
        } finally {
            close()
        }
    }

    func toBytes(): Array<Byte> {
        try {
            return IOUtils.copyToBytes(stream())
        } finally {
            close()
        }
    }

    // -----

    // static func empty(): S3Content {
    //     fromBytes([])
    // }

    static func fromInputStream(input: InputStream, contentType: ?String, contentLength: ?Int64): S3Content {
        return InputStreamContent(
            input,
            false, // false 是否合适?
            contentType: contentType,
            contentLength: contentLength
        )
    }

    static func fromBytes(bytes: Array<Byte>): S3Content {
        return fromBytes(bytes, S3MimeType.MIME_TYPE_OCTET_STREAM)
    }

    static func fromBytes(bytes: Array<Byte>, contentType: String): S3Content {
        return ByteArrayContent(bytes, contentType: contentType)
    }

    static func fromString(string: String): S3Content {
        return fromBytes(StringUtils.toByteArray(string), S3MimeType.MIME_TYPE_TEXT_PLAIN)
    }

    static func fromString(string: String, contentType: String): S3Content {
        return fromBytes(StringUtils.toByteArray(string), contentType)
    }

    static func fromFile(path: Path): S3Content {
        return FileContent(path, None)
    }

    static func fromFile(path: Path, contentType: String): S3Content {
        return FileContent(path, contentType)
    }

    static func fromFile(path: String): S3Content {
        return fromFile(Path(path))
    }

    static func fromFile(path: String, contentType: String): S3Content {
        return fromFile(Path(path), contentType)
    }
}

class InputStreamContent <: S3Content {
    private var input: ?InputStream
    private let closeEnabled: Bool
    private let _contentLength: ?Int64
    private let _contentType: ?String

    public prop isReadOnce: Bool {
        get() {
            return true
        }
    }
    public prop contentLength: ?Int64 {
        get() {
            return _contentLength
        }
    }
    public prop contentType: ?String {
        get() {
            return _contentType
        }
    }

    public init(
        input: InputStream,
        closeEnabled: Bool,
        contentLength!: ?Int64 = None,
        contentType!: ?String = S3MimeType.MIME_TYPE_OCTET_STREAM
    ) {
        this.input = input
        this.closeEnabled = closeEnabled
        this._contentLength = contentLength
        this._contentType = contentType
    }

    public func stream(): InputStream {
        return this.input.getOrThrow({=> IllegalStateException("InputStream is closed")})
    }

    public func close(): Unit {
        if (!closeEnabled) {
            return
        }
        match (input) {
            case Some(v) => S3CloseUtils.close(v)
            case None => ()
        }
        input = None
    }

    public func toString(): String {
        return "InputStreamContent"
    }
}

class ByteArrayContent <: S3Content {
    private let bytes: Array<Byte>
    private let _contentLength: ?Int64
    private let _contentType: ?String

    public prop isReadOnce: Bool {
        get() {
            return false
        }
    }
    public prop contentLength: ?Int64 {
        get() {
            return _contentLength
        }
    }
    public prop contentType: ?String {
        get() {
            return _contentType
        }
    }

    public init(
        bytes: Array<Byte>,
        contentType!: ?String = S3MimeType.MIME_TYPE_OCTET_STREAM
    ) {
        this.bytes = bytes
        this._contentLength = bytes.size
        this._contentType = contentType
    }

    public func stream(): InputStream {
        let stream = ByteBuffer()
        stream.write(bytes)
        return stream
    }

    public func close(): Unit {
        // nothing to do
    }

    public func toString(): String {
        return "ByteArrayContent"
    }
}

class FileContent <: S3Content {
    private let path: Path
    private var currentStream: ?File = None
    private let _contentLength: ?Int64
    private let _contentType: ?String

    public prop isReadOnce: Bool {
        get() {
            return false
        }
    }
    public prop contentLength: ?Int64 {
        get() {
            return _contentLength
        }
    }
    public prop contentType: ?String {
        get() {
            return _contentType
        }
    }

    public init(path: Path, contentType: ?String) {
        this.path = path
        this._contentLength = FileInfo(path).size
        this._contentType = contentType.getOrDefault({=> S3MimeType.getMimeType(path)})
    }

    private func closeCurrentStream() {
        match (currentStream) {
            case Some(v) => v.close()
            case None => ()
        }
        currentStream = None
    }

    public func stream(): InputStream {
        closeCurrentStream()
        this.currentStream = File(path, OpenMode.Read)
        return this.currentStream.getOrThrow()
    }

    public func close(): Unit {
        closeCurrentStream()
    }

    public func toString(): String {
        return "FileContent"
    }
}
