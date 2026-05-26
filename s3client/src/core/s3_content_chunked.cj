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
 * @date: 2023-12-28
 */
public class S3ChunkedContent <: S3Content {
    private static let CHUNK_DATA_LENGTH = 128 * 1024 // 128K
    private let delegate: S3Content
    private let checksum: S3Checksum
    private let chunkedContentStream: ChunkedInputStream
    private let chunkedContentLength: Int64

    public prop isReadOnce: Bool {
        get() {
            return true
        }
    }
    public prop contentLength: ?Int64 {
        get() {
            return chunkedContentLength
        }
    }
    public prop contentType: ?String {
        get() {
            return delegate.contentType
        }
    }

    public init(
        delegate: S3Content,
        checksum: S3Checksum
    ) {
        this.chunkedContentLength = calculateChunkedContentLength(
            delegate.contentLength.getOrThrow(),
            checksum,
            CHUNK_DATA_LENGTH
        )
        checksum.reset() // 计算长度的时候会用到checksum, 需要重置
        this.delegate = delegate
        this.checksum = checksum
        this.chunkedContentStream = ChunkedInputStream(delegate.stream(), checksum, CHUNK_DATA_LENGTH)
    }

    public func stream(): InputStream {
        return chunkedContentStream
    }

    public func close(): Unit {
        S3CloseUtils.close(chunkedContentStream)
    }

    public func toString(): String {
        return "S3ChunkedContent()"
    }

    private static func calculateChunkedContentLength(
        contentLength: Int64,
        checksum: S3Checksum,
        chunkDataLength: Int64
    ): Int64 {
        let chunkSize = contentLength / chunkDataLength
        var chunkedContentLength = 0
        for (_ in 0..chunkSize) {
            chunkedContentLength += Chunk.calculateLength(dataLenth: chunkDataLength, checksum: checksum)
        }
        let remainContentLength = contentLength - (chunkDataLength * chunkSize)
        if (remainContentLength > 0) {
            // 多补一个chunk
            chunkedContentLength += Chunk.calculateLength(dataLenth: remainContentLength, checksum: checksum)
        }
        // 最后一个chunk
        chunkedContentLength += Chunk.calculateLength(dataLenth: 0, isLast: true, checksum: checksum)
        return chunkedContentLength
    }
}

class ChunkedInputStream <: InputStream & S3Closeable {
    private let delegate: InputStream
    private let checksum: S3Checksum
    private let chunkDataLength: Int64
    private var chunk: Chunk

    public init(delegate: InputStream, checksum: S3Checksum, chunkDataLength: Int64) {
        this.delegate = delegate
        this.checksum = checksum
        this.chunkDataLength = chunkDataLength
        this.chunk = getChunk(delegate, checksum, chunkDataLength)
    }

    public func read(buffer: Array<Byte>): Int64 {
        if (this.chunk.remainLength == 0) {
            if (this.chunk.isLast) {
                return 0
            } else {
                this.chunk = getChunk(delegate, checksum, chunkDataLength)
            }
        }
        let read = chunk.read(buffer)
        return read
    }

    public func close(): Unit {
        S3CloseUtils.close(delegate)
    }

    private static func getChunk(stream: InputStream, checksum: S3Checksum, chunkDataLength: Int64): Chunk {
        let data = Array<Byte>(chunkDataLength, repeat: 0)
        let read = stream.read(data)
        let chunk = Chunk(data.slice(0, read), checksum)
        return chunk
    }
}

class Chunk {
    private let stream: ByteBuffer
    private let checksum: S3Checksum
    public let isLast: Bool
    public prop remainLength: Int64 {
        get() {
            stream.remainLength
        }
    }

    init(data: Array<Byte>, checksum: S3Checksum) {
        this.isLast = data.size == 0
        this.checksum = checksum
        if (!isLast) {
            checksum.update(data)
            // data.size.format("x") 16进制表示的数据长度
            let dataLengthBytes = StringUtils.toByteArray(data.size.format("x"))
            stream = ByteBuffer(
                dataLengthBytes.size + S3Constants.CRLF_BYTES.size + data.size + S3Constants.CRLF_BYTES.size)
            stream.write(dataLengthBytes)
            stream.write(S3Constants.CRLF_BYTES)
            stream.write(data)
            stream.write(S3Constants.CRLF_BYTES)
        } else {
            let trailer = StringUtils.toLowerCase(S3Constants.CHECKSUM_ + checksum.algorithm.name) + ":" +
                checksum.resultAsBase64()
            let dataLengthBytes = StringUtils.toByteArray("0")
            stream = ByteBuffer()
            stream.write(dataLengthBytes)
            stream.write(S3Constants.CRLF_BYTES)
            stream.write(StringUtils.toByteArray(trailer))
            stream.write(S3Constants.CRLF_BYTES)
            stream.write(S3Constants.CRLF_BYTES)
        }
    }

    public static func calculateLength(dataLenth!: Int64, isLast!: Bool = false, checksum!: S3Checksum): Int64 {
        // https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-streaming-trailers.html
        // TODO 记得在哪里看到过 chunked 格式说明的, 现在找不到了....
        // 2 length is S3Constants.CRLF_BYTES.size
        if (!isLast) {
            // dataLenth.format("x") 16进制表示的数据长度
            return StringUtils.toByteArray(dataLenth.format("x")).size + 2 + dataLenth + 2
        } else {
            let trailer = S3Constants.CHECKSUM_ + checksum.algorithm.name + ":" + checksum.resultAsBase64()
            return 1 + 2 + StringUtils.toByteArray(trailer).size + 2 + 2
        }
    }

    public func read(buffer: Array<Byte>): Int64 {
        return stream.read(buffer)
    }
}
