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
 * @date: 2023-11-01
 */
public class S3HttpResponse <: ToString {
    public let request: S3HttpRequest
    public let protocol: Protocol
    public let statusCode: UInt16
    public let statusText: String
    public let headers: HttpHeaders
    public let body: S3Content

    // public func mutate(): S3HttpResponseBuilder {
    //     return S3HttpResponseBuilder(this)
    // }

    public static func builder(): S3HttpResponseBuilder {
        return S3HttpResponseBuilder()
    }

    init(builder: S3HttpResponseBuilder) {
        this.request = builder.request.getOrThrow({=> NoneValueException("request")})
        this.protocol = builder.protocol
        this.statusCode = builder.statusCode
        this.statusText = builder.statusText
        this.headers = builder.headers
        this.body = builder.body()
    }

    public func toString(): String {
        let sb = StringBuilder()
        sb.append("${protocol} ${statusCode} (<== ${request.method} ${request.url})")
        sb.append(IOUtils.LINE_SEPARATOR)
        for ((name, values) in headers) {
            sb.append("${name}: ${ToStringUtils.listToString(values)}")
            sb.append(IOUtils.LINE_SEPARATOR)
        }
        sb.toString()
    }
}

public class S3HttpResponseBuilder {
    private static let EMPTY_BODY_STREAM = ByteBuffer(0)
    var request: ?S3HttpRequest = None
    var protocol: Protocol = Protocol.HTTP1_1
    var statusCode: UInt16 = HttpStatusCode.STATUS_OK
    var statusText: String = ""
    var headers: HttpHeaders = HttpHeaders()
    var bodyStream: InputStream = EMPTY_BODY_STREAM

    init() {
    }

    // init(response: S3HttpResponse) {
    //     this.request = response.request
    //     this.protocol = response.protocol
    //     this.statusCode = response.statusCode
    //     this.statusText = response.statusText
    //     this.headers = response.headers
    //     this.body = response.body
    // }

    public func build(): S3HttpResponse {
        return S3HttpResponse(this)
    }

    public func setRequest(request: S3HttpRequest): S3HttpResponseBuilder {
        this.request = request
        return this
    }

    public func setProtocol(protocol: Protocol): S3HttpResponseBuilder {
        this.protocol = protocol
        return this
    }

    public func setStatusCode(statusCode: UInt16): S3HttpResponseBuilder {
        this.statusCode = statusCode
        return this
    }

    public func setStatusText(statusText: String): S3HttpResponseBuilder {
        this.statusText = statusText
        return this
    }

    public func setHeaders(headers: HttpHeaders): S3HttpResponseBuilder {
        this.headers = headers
        return this
    }

    public func setBodyStream(bodyStream: InputStream): S3HttpResponseBuilder {
        this.bodyStream = bodyStream
        return this
    }

    func body(): S3Content {
        // let contentLength: ?Int64 = match (headers.getFirst("Content-Length")) {
        //     case None => None
        //     case Some(v) => Int64.parse(v)
        // }
        let contentLength: ?Int64 = Int64.tryParse(headers.getFirst("Content-Length") ?? "")

        return S3Content.fromInputStream(
            bodyStream,
            headers.getFirst("Content-Type"),
            contentLength
        )
    }
}
