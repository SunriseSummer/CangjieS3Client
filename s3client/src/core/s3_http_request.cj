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
 * @date: 2023-10-31
 */
public class S3HttpRequest <: ToString {
    public let method: String
    public let url: URL
    public let queryParams: S3MultiValueMap<String, String>
    public let headers: HttpHeaders
    public let body: ?S3Content
    public let metricCollection: ?S3MetricCollection

    // public func mutate(): S3HttpRequestBuilder {
    //     return S3HttpRequestBuilder(this)
    // }

    public static func builder(): S3HttpRequestBuilder {
        return S3HttpRequestBuilder()
    }

    init(builder: S3HttpRequestBuilder) {
        this.method = builder.method
        this.queryParams = builder.queryParams
        this.headers = builder.headers
        this.body = builder.body
        this.metricCollection = builder.metricCollection
        this.url = builder.url()
    }

    public func toString(): String {
        let sb = StringBuilder()
        sb.append("${method} ${url}")
        sb.append(IOUtils.LINE_SEPARATOR)
        for ((name, values) in headers) {
            sb.append("${name}: ${ToStringUtils.listToString(values)}")
            sb.append(IOUtils.LINE_SEPARATOR)
        }
        sb.toString()
    }
}

public class S3HttpRequestBuilder {
    var method: String = ""
    var baseUrl: URL = URL.parse("")
    // [CANGJIE] 0.45.2 的 Form 无法遍历, 先用 S3MultiValueMap 暂存 QueryParam
    // 注意 baseUrl 不要带 QueryParam, 否则会引起 AWS V4Signer 校验不过, 因为拿不全 QueryParam
    // var _form: Form = Form()
    var queryParams = S3MultiValueMap<String, String>.create()
    var headers = HttpHeaders()
    var body: ?S3Content = None
    var metricCollection: ?S3MetricCollection = None

    init() {}

    // init(request: S3HttpRequest) {
    //     this.method = request.method
    //     this.baseUrl = request.baseUrl
    //     this.queryParams = request.queryParams.clone()
    //     this.headers = request.headers.clone()
    //     this.body = request.body
    //     this.metricCollection = request.metricCollection
    // }

    public func clone(): S3HttpRequestBuilder {
        let cloned = S3HttpRequestBuilder()
        cloned.method = this.method
        cloned.baseUrl = this.baseUrl
        cloned.queryParams = this.queryParams.clone()
        cloned.headers = S3HttpUtils.clone(this.headers)
        cloned.body = this.body
        cloned.metricCollection = this.metricCollection
        return cloned
    }

    public func build(): S3HttpRequest {
        let request = S3HttpRequest(this)
        return request
    }

    public func setMethod(method: String): S3HttpRequestBuilder {
        this.method = method
        return this
    }

    public func setBaseUrl(url: String): S3HttpRequestBuilder {
        this.setBaseUrl(URL.parse(url))
        return this
    }

    public func setBaseUrl(url: URL): S3HttpRequestBuilder {
        this.baseUrl = url
        return this
    }

    public func setBody(body: S3Content): S3HttpRequestBuilder {
        this.body = body
        setHeader(S3Constants.CONTENT_LENGTH, body.contentLength?.toString())
        setHeader(S3Constants.CONTENT_TYPE, body.contentType)
        return this
    }

    public func setMetricCollection(metricCollection: S3MetricCollection): S3HttpRequestBuilder {
        this.metricCollection = metricCollection
        return this
    }

    public func setPath(path: String): S3HttpRequestBuilder {
        this.baseUrl = this.baseUrl.replace(path: path)
        return this
    }

    public func addQueryParam(key: String, value: ?String): S3HttpRequestBuilder {
        match (value) {
            case Some(v) => this.queryParams.add(key, v)
            case None => ()
        }
        return this
    }

    // public func setQueryParam(key: String, value: ?String): S3HttpRequestBuilder {
    //     match (value) {
    //         case None => ()
    //         case Some(v) => this.queryParams.set(key, v)
    //     }
    //     return this
    // }

    public func setHeader(name: String, value: ?String): S3HttpRequestBuilder {
        match (value) {
            case Some(v) => if (v != "") {
                this.headers.set(name, v)
            }
            case None => ()
        }
        return this
    }

    public func addHeader(name: String, value: ?String): S3HttpRequestBuilder {
        match (value) {
            case Some(v) => if (v != "") {
                this.headers.add(name, v)
            }
            case None => ()
        }
        return this
    }

    public func addHeader(name: String, values: ?ArrayList<String>): S3HttpRequestBuilder {
        match (values) {
            case Some(v) => for (_v in v) {
                addHeader(name, _v)
            }
            case None => ()
        }
        return this
    }

    public func removeHeader(name: String): S3HttpRequestBuilder {
        this.headers.del(name)
        return this
    }

    public func getFirstHeader(name: String): String {
        return this.headers.getFirst(name).getOrDefault({=> ""})
    }

    public func isHttps() {
        return "https" == StringUtils.toLowerCase(this.baseUrl.scheme)
    }

    public func getMethod(): String {
        return this.method
    }

    public func getPath(): String {
        return this.baseUrl.path
    }

    public func getQueryParams(): S3MultiValueMap<String, String> {
        return this.queryParams
    }

    public func getHeaders(): HttpHeaders {
        return this.headers
    }

    public func getBody(): ?S3Content {
        return this.body
    }

    public func getBaseUrl(): URL {
        return this.baseUrl
    }

    public func url(): URL {
        if (queryParams.isEmpty()) {
            return baseUrl
        }
        let form = this.baseUrl.queryForm.clone()
        for ((k, values) in queryParams) {
            for (v in values) {
                form.add(k, v)
            }
        }
        return this.baseUrl.replace(query: form.toEncodeString())
    }

    public func getHost(): String {
        let url = baseUrl
        let hostName = url.hostName
        var port = url.port
        if (StringUtils.isBlank(port) || "80" == port || "443" == port) {
            // 不区分是否是 http 还是 https 了
            return hostName
        }
        return hostName + ":" + port
    }
}
