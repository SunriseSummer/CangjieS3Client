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
 * @date: 2023-11-02
 */
public interface S3HttpClient <: S3Closeable & ToString {
    // 返回 HttpClient 具体底层实现的名称, 如 "stdx.net.http.Client"
    prop name: String

    func call(s3HttpReq: S3HttpRequest): S3HttpResponse

    func callAsync(s3HttpReq: S3HttpRequest): S3Future<S3HttpResponse> {
        return S3Future<S3HttpResponse>.async() {call(s3HttpReq)}
    }
}

// Default Implementation
public class DefaultS3HttpClient <: S3HttpClient {
    private static let LOGGER = S3LoggerFactory.getLogger("s3client.S3HttpClient")
    private let client: Client
    private var isClosed = AtomicBool(false)

    public static func builder(): DefaultS3HttpClientBuilder {
        return DefaultS3HttpClientBuilder()
    }

    public init(client: Client) {
        this.client = client
    }

    public prop name: String {
        get() {
            return "stdx.net.http.Client"
        }
    }

    public func close(): Unit {
        if (!isClosed.compareAndSwap(false, true)) {
            LOGGER.warn() {"Already closed"}
            return
        }
        client.close()
        LOGGER.info() {"Closed"}
    }

    public func toString(): String {
        return "DefaultS3HttpClient(${name})"
    }

    public func call(s3HttpReq: S3HttpRequest): S3HttpResponse {
        return doCall(s3HttpReq)
    }

    func doCall(s3HttpReq: S3HttpRequest): S3HttpResponse {
        try {
            let httpReq = toRequest(s3HttpReq, s3HttpReq.body)
            let httpRsp = send(httpReq, s3HttpReq.body)
            let s3HttpRsp = toResponse(s3HttpReq, httpRsp)
            return s3HttpRsp
        } finally {
            s3HttpReq.body?.close()
        }
    }

    private func send(httpReq: HttpRequest, body: ?S3Content): HttpResponse {
        try {
            return client.send(httpReq)
        } catch (ex: Exception) {
            let sb = StringBuilder()
            sb.append(ex.toString())
            sb.append(IOUtils.LINE_SEPARATOR)
            sb.append(httpReq.toString())
            sb.append(IOUtils.LINE_SEPARATOR)
            sb.append(S3HttpUtils.bodyToString(body))
            LOGGER.error() {sb.toString()}
            throw ex
        }
    }

    func toRequest(s3HttpReq: S3HttpRequest, body: ?S3Content): HttpRequest {
        let httpReq = HttpRequestBuilder() //
            .method(s3HttpReq.method) //
            .url(s3HttpReq.url) //
            .setHeaders(s3HttpReq.headers)
            // .header("Connection", "close")
            // [CANGJIE] 0.45.2 需要加上面这行
            /* 
                否则会出现 "ERROR Logger [ConnNode#sendBody] the content-length is wrong"
                可能的原因是: 连接在重连之后, 数据没有发送
            */
        match (body) {
            case Some(v) => httpReq.body(v.stream())
            case None => ()
        }
        return httpReq.build()
    }

    func toResponse(s3HttpReq: S3HttpRequest, httpRsp: HttpResponse): S3HttpResponse {
        let s3HttpRsp = S3HttpResponse.builder() //
            .setRequest(s3HttpReq) //
            .setStatusCode(httpRsp.status) //
            .setProtocol(httpRsp.version) //
            .setHeaders(httpRsp.headers) //
            .setBodyStream(httpRsp.body) //
            .build()
        return s3HttpRsp
    }
}

public class DefaultS3HttpClientBuilder {
    private let builder = ClientBuilder()

    init() {
        var tlsCfg = TlsClientConfig()
        tlsCfg.verifyMode = TrustAll
        // ["http/1.1", "h2"]
        // tlsCfg.alpnProtocolsList = ["h2"]
        builder.tlsConfig(tlsCfg)
        builder.poolSize(100)
    }

    public func setReadTimeout(timeout: Duration): DefaultS3HttpClientBuilder {
        builder.readTimeout(timeout)
        return this
    }

    public func setWriteTimeout(timeout: Duration): DefaultS3HttpClientBuilder {
        builder.writeTimeout(timeout)
        return this
    }

    public func setMaxPerHost(size: Int64): DefaultS3HttpClientBuilder {
        builder.poolSize(size)
        return this
    }

    public func build(): S3HttpClient {
        return DefaultS3HttpClient(builder.build())
    }
}
