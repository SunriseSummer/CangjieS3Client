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
 * @date: 2023-11-22
 */
public interface S3Action<REQ, RSP> <: ToString where REQ <: S3Request, RSP <: S3Response {
    prop name: String
    func execute(): (RSP, S3Content)
    func executeAsync(): S3Future<(RSP, S3Content)>
    func presign(signatureDuration: Duration): S3PresignedRequest
    func waitUntil(flag: Int8, timeout: Duration): Bool

    func execute1(): RSP {
        return execute()[0]
    }
    func executeAsync1(): S3Future<(RSP)> {
        executeAsync().thenAsync<RSP>() {resultTuple => resultTuple[0]}
    }
    func toString(): String {
        return name + "Action()"
    }
}

public abstract class AbstractS3Action<REQ, RSP> <: S3Action<REQ, RSP> where REQ <: S3Request, RSP <: S3Response {
    private static let LOGGER = S3LoggerFactory.getLogger("s3client.S3Action")
    private let configMap: S3ConfigMap
    private let s3Req: REQ
    private let reqBody: ?S3Content
    private let checksumRequired: Bool
    private var resourcePath: ?String = None // 专门给 V2Signer 使用
    private var waitRetryer: ?S3Retryer<S3HttpResponse> = None // 专门给 waitUtil 使用

    protected init(
        s3ClientConfigMap: S3ConfigMap,
        s3Req: REQ,
        reqBody!: ?S3Content = None,
        checksumRequired!: Bool = false
    ) {
        // s3RequestConfigMap + s3ClientConfigMap
        this.configMap = s3Req.requestConfig?.toConfigMap().add(s3ClientConfigMap) ?? s3ClientConfigMap
        this.s3Req = s3Req
        this.reqBody = reqBody
        this.checksumRequired = checksumRequired
    }

    public func execute(): (RSP, S3Content) {
        return doExecute(this.name)
    }

    public func executeAsync(): S3Future<(RSP, S3Content)> {
        return S3Future<(RSP, S3Content)>.async() {
            => return doExecute(this.name + "(async)")
        }
    }

    public func presign(signatureDuration: Duration): S3PresignedRequest {
        S3RequestContext.create(this.name + "(presign)")
        try {
            let httpReq = marshalling(s3Req)
            let signedHttpReq = sign(
                httpReq,
                authLocation: AuthLocation.QUERY,
                expirationDuration: signatureDuration
            )
            return S3PresignedRequest(
                expiration: DateTime.nowUTC() + signatureDuration - Duration.second * 5, // TODO 最好根据请求的queryparam来计算时间, 这样直接根据当前时间, 可能会有点误差
                method: signedHttpReq.method,
                url: signedHttpReq.url,
                headers: signedHttpReq.headers,
                body: signedHttpReq.body
            )
        } finally {
            S3RequestContext.clear()
        }
    }

    public func waitUntil(flag: Int8, timeout: Duration): Bool {
        let isUntil: (?Exception) -> Bool = {
            ex => if (flag == 1) {
                // waitUntilExists: 没有异常表示成功
                return ex.isNone()
            } else {
                // waitUntilNotExists: 404 表示成功
                return S3ServiceException.is404(ex)
            }
        }
        this.waitRetryer = S3Retryer<S3HttpResponse>.builder() //
            .maxAttempts(S3Constants.INT32_MAX) //
            .timeout(timeout) //
            .retryPolicy() {attempt => !isUntil(attempt.ex)} // 不满足期望的情况, 就继续重试
            .build()
        try {
            doExecute(this.name + "(wait_until)") // 方法内部的 httpCall() 里会使用 waitRetryer 进行重试
            return isUntil(None)
        } catch (ex: Exception) {
            return isUntil(ex)
        }
    }

    private func doExecute(ctxName: String): (RSP, S3Content) {
        S3RequestContext.create(ctxName)
        let beginTime = DateTime.nowUTC()
        let metricCollection_1 = createMetricCollection()
        var isOk = false
        try {
            let httpReq = S3MetricUtils.measureDuration<S3HttpRequestBuilder>(
                metricCollection_1,
                S3Metrics.MARSHALLING_DURATION.name,
                {=> marshalling(s3Req)}
            )
            metricCollection_1.addRecord(S3Metrics.SERVICE_ENDPOINT.name, httpReq.url())
            checksum(httpReq)
            let httpRsp = httpCall(httpReq, metricCollection_1)
            let s3Rsp = S3MetricUtils.measureDuration<RSP>(
                metricCollection_1,
                S3Metrics.UNMARSHALLING_DURATION.name,
                // TODO unmarshalling 出错, 最好能记录下报文, 不过有些麻烦, 现在的S3HttpResponse.body是一次性读取的
                // 可以考虑在 S3XmlElement 抛出异常的时候, 顺便记录报文
                {=> unmarshalling(httpRsp)}
            )
            isOk = true
            return (s3Rsp, httpRsp.body)
        } catch (ex: Exception) {
            // 异常可能是被 metricCollection_2 记录后又再次抛出的,
            // 因为不太好区分, 这里捕获到就没有再记录到 metricCollection_1, 防止有些异常会重复记录
            isOk = false
            if (waitRetryer.isNone()) {
                // 如果是wait相关操作, 可能就会一直抛异常, 就不记录日志了
                if (!(ex is S3ServiceException)) { // 如果是S3ServiceException, 已经在checkErrorResponse()记录过
                    LOGGER.error(ex)
                }
            }
            throw ex
        } finally {
            metricCollection_1.addRecord(S3Metrics.API_CALL_SUCCESSFUL.name, isOk)
            metricCollection_1.addRecord(S3Metrics.API_CALL_DURATION.name, DateTime.nowUTC() - beginTime)
            publishMetricCollection(metricCollection_1)
            S3RequestContext.clear()
        }
    }

    protected func marshalling(s3Req: REQ): S3HttpRequestBuilder

    protected func unmarshalling(httpRsp: S3HttpResponse): RSP

    protected func getConfigMap() {
        return configMap
    }

    protected func createHttpRequest(
        method: String,
        bucket!: String = "",
        key!: String = "",
        action!: String = ""
    ): S3HttpRequestBuilder {
        let endpoint = match (S3ConfigKeys.ENDPOINT.get(configMap)) {
            case Some(v) => v
            case None =>
                let region = S3ConfigKeys.REGION.getOrThrow(configMap)
                if (region.id.startsWith("cn-")) {
                    "https://s3.${region.id}.amazonaws.com.cn"
                } else {
                    "https://s3.${region.id}.amazonaws.com"
                }
        }
        var baseUrl = URL.parse(endpoint)
        if (baseUrl.scheme == "") {
            baseUrl = baseUrl.replace(scheme: "https")
        }
        if (bucket != "") {
            let forcePathStyle = S3ConfigKeys.FORCE_PATH_STYLE.getOrThrow(configMap)
            if (forcePathStyle) {
                baseUrl = baseUrl.replace(path: baseUrl.path + "/" + bucket)
            } else {
                baseUrl = baseUrl.replace(hostName: bucket + "." + baseUrl.hostName)
            }
        }
        if (key != "") {
            baseUrl = baseUrl.replace(path: baseUrl.path + "/" + key)
        }
        let httpReq = S3HttpRequest.builder().setMethod(method).setBaseUrl(baseUrl)
        if (action != "") {
            let params = StringUtils.split(action, "=")
            if (params.size > 1) {
                httpReq.addQueryParam(params[0], params[1])
            } else {
                httpReq.addQueryParam(params[0], "")
            }
        }

        if (let Some(reqBody) <- reqBody) {
            // 实例级别的变量 reqBody, 现在只有上传文件会使用
            httpReq.setBody(reqBody)
        }

        // resourcePath 专门给 V2Signer 使用
        var resourcePath = "/"
        if (bucket != "") {
            resourcePath += bucket + "/"
        }
        if (key != "") {
            resourcePath += key
        }
        this.resourcePath = resourcePath
        return httpReq
    }

    private func httpCall(httpReq: S3HttpRequestBuilder, metricCollection_1: S3MetricCollection): S3HttpResponse {
        /* Metric Collection Tree:
           ApiCall (metricCollection_1)
           ┌──────────────────────────────┐
           └──────────────────────────────┘
              ApiCallAttempt (metricCollection_2)
              ┌─────────────────────────────┐
              └─────────────────────────────┘
                  HttpClient (metricCollection_3)
                  ┌─────────────────────────────┐
                  └─────────────────────────────┘
         */
        let httpClient = S3ConfigKeys.HTTP_CLIENT.getOrThrow(configMap)
        let retryer = this.waitRetryer ?? S3ConfigKeys.RETRYER.getOrThrow(configMap)

        let attemptWithResult = retryer.call() {
            attempt =>
            let metricCollection_2 = metricCollection_1.createChild("ApiCallAttempt")
            metricCollection_2.addRecord(
                // 记录该次请求距离上一次的退避延迟时间
                S3Metrics.BACKOFF_DELAY_DURATION.name,
                attempt.backoffDelay
            )
            let newHttpReq = httpReq.clone()
            newHttpReq.setHeader(
                S3Constants.SDK_RETRY_INFO_HEADER,
                "attempt=${attempt.attempts}; max=${attempt.maxAttempts}"
            )
            let metricCollection_3 = metricCollection_2.createChild("HttpClient")
            // TODO aws 还有一些最大连接数, 挂起连接的一些监控指标, 现在 Cangjie 的这个 HTTP 客户端实现还拿不到这些数据
            metricCollection_3.addRecord(S3Metrics.HTTP_CLIENT_NAME.name, httpClient.name)
            newHttpReq.setMetricCollection(metricCollection_3)
            let signedHttpReq = S3MetricUtils.measureDuration<S3HttpRequest>(
                metricCollection_2,
                S3Metrics.SIGNING_DURATION.name,
                {=> sign(newHttpReq)}
            )
            let httpRsp = S3MetricUtils.measureDuration<S3HttpResponse>(
                metricCollection_2,
                S3Metrics.SERVICE_CALL_DURATION.name,
                {=> httpClient.call(signedHttpReq)}
            )
            metricCollection_2.addRecord(S3Metrics.HTTP_STATUS_CODE.name, httpRsp.statusCode)
            metricCollection_2.addRecord(
                S3Metrics.AWS_REQUEST_ID.name,
                httpRsp.headers.getFirst(S3ResponseMetadata.REQUEST_ID)
            )
            metricCollection_2.addRecord(
                S3Metrics.AWS_EXTENDED_REQUEST_ID.name,
                httpRsp.headers.getFirst(S3ResponseMetadata.EXTENDED_REQUEST_ID)
            )
            checkErrorResponse(httpRsp)
            return httpRsp
        }
        metricCollection_1.addRecord(
            S3Metrics.RETRY_COUNT.name,
            attemptWithResult.attempts - 1
        )
        return attemptWithResult.getResultOrThrow()
    }

    private func createMetricCollection(): S3MetricCollection {
        let publishers = S3ConfigKeys.METRIC_PUBLISHERS.get(configMap)
        let collection = match (publishers) {
            case Some(_) => S3MetricCollection.create("ApiCall")
            case None => S3MetricCollection.EMPTY_COLLECTION
        }
        collection.addRecord(S3Metrics.SERVICE_ID.name, "S3")
        collection.addRecord(S3Metrics.OPERATION_NAME.name, this.name)
        return collection
    }

    private func publishMetricCollection(collection: S3MetricCollection): Unit {
        let metricPublishers = S3ConfigKeys.METRIC_PUBLISHERS.get(configMap)
        match (metricPublishers) {
            case Some(publishers) => for (p in publishers) {
                p.publish(collection)
            }
            case None => ()
        }
    }

    private func setHttpHeaders(httpReq: S3HttpRequestBuilder): Unit {
        // 设置通用请求头, 需要在重试之前     
        // TODO 这个SDK_TRANSACTION_ID, 每次重试都会变 (Java的实现就是这样), 感觉以后如果需要找多个重试请求之间的关系不是很好找
        httpReq.setHeader(S3Constants.SDK_TRANSACTION_ID, S3RequestContext.required().id)
        httpReq.setHeader(S3Constants.USER_AGENT, S3Constants.MODULE_INFO)
    }

    private func sign(
        httpReq: S3HttpRequestBuilder,
        authLocation!: AuthLocation = AuthLocation.HEADER,
        expirationDuration!: ?Duration = None
    ): S3HttpRequest {
        let region = S3ConfigKeys.REGION.getOrThrow(configMap)
        let signer = S3ConfigKeys.SIGNER.getOrThrow(configMap)
        let credentials = S3ConfigKeys.CREDENTIALS.getOrThrow(configMap)
        let signerProps = S3SignerProperties(
            credentials,
            region.id,
            "s3",
            resourcePath: resourcePath,
            authLocation: authLocation,
            expirationDuration: expirationDuration
        )
        if (authLocation.name == AuthLocation.HEADER.name || expirationDuration.isNone()) {
            // 非 Presign, 才添加通用请求头
            // TODO 在这里加通用请求头有点奇怪, 主要是在这里可以方便的判断是不是 Presign
            // 把这段 if 逻辑复制到外面放在 sign() 调用之前也可以
            setHttpHeaders(httpReq)
        }
        let signedHttpReq = signer.sign(httpReq, signerProps)
        return signedHttpReq
    }

    private func checksum(httpReq: S3HttpRequestBuilder) {
        var algorithmName = httpReq.getFirstHeader(S3Constants.SDK_CHECKSUM_ALGORITHM)
        if (algorithmName == "") {
            if (checksumRequired) {
                algorithmName = S3ChecksumAlgorithm.ALGO_MD5.name
            } else {
                return
            }
        }
        var isMD5 = false
        if (algorithmName == S3ChecksumAlgorithm.ALGO_MD5.name) {
            // TODO S3 本身是不支持 S3Constants.SDK_CHECKSUM_ALGORITHM 的值是 MD5 的
            // 这里是自己做的一个扩展, 允许用户通过 CHECKSUM_ALGORITHM 指定 MD5
            // 实际发送时还是要删除这个头
            isMD5 = true
            httpReq.removeHeader(S3Constants.SDK_CHECKSUM_ALGORITHM)
        }
        let checksumHeader = if (isMD5) {
            S3Constants.CONTENT_MD5
        } else {
            StringUtils.toLowerCase(S3Constants.CHECKSUM_ + algorithmName)
        }
        if (httpReq.getFirstHeader(checksumHeader) != "") {
            // 已经由用户设置过校验和
            return
        }
        if (httpReq.getBody().isNone()) {
            // 不要报错, CreateMultipartUpload 就是要支持先申明需要 checksum 但是却没有 body
            return
        }
        let httpReqBody = httpReq.getBody().getOrThrow()
        let checksum = S3Checksum.forAlgorithm(algorithmName)
        // TODO 2024-01-15 checksum的逻辑是不是放在signer里更好, 不像现在一样需要在外面判断 signer 
        if (S3ConfigKeys.SIGNER.getOrThrow(configMap).name == S3Constants.V4_SIGNER_NAME && !isMD5 &&
            S3ConfigKeys.TRAILING_CHECKSUM.getOrThrow(configMap)) {
            httpReq.addHeader(S3Constants.X_AMZ_CONTENT_SHA256, S3Constants.STREAMING_UNSIGNED_PAYLOAD_TRAILER)
            httpReq.addHeader(S3Constants.CONTENT_ENCODING, S3Constants.AWS_CHUNKED)
            httpReq.addHeader(S3Constants.X_AMZ_TRAILER, checksumHeader)
            httpReq.addHeader(
                S3Constants.X_AMZ_DECODED_CONTENT_LENGTH,
                httpReqBody.contentLength.getOrThrow({=> NoneValueException("httpReqBody.contentLength")}).toString()
            )
            // 替换为 S3ChunkedContent
            httpReq.setBody(S3ChunkedContent(httpReqBody, checksum))
            return
        }
        if (httpReqBody.isReadOnce) {
            throw UnsupportedException(
                "HttpRequestBody is only read once, not support calculate checksum before send data")
        }
        let checksumResult = checksum.update(httpReqBody).resultAsBase64()
        httpReq.addHeader(checksumHeader, checksumResult)
    }

    private func checkErrorResponse(httpRsp: S3HttpResponse) {
        if (httpRsp.statusCode < 400) {
            return
        }
        let httpRspXml = httpRsp.body.toStringUtf8()
        let errorDetails = if (httpRspXml == "") {
            Option<ErrorDetails>.None
        } else {
            let ele = S3XmlElement.fromXml(httpRspXml)
            ErrorDetails(
                code: ele.childContentRequired("Code"),
                message: ele.childContentRequired("Message")
            )
        }
        if (S3ConfigKeys.LOGGING_ERROR_RESPONSE.getOrDefault(configMap, true) && waitRetryer.isNone()) {
            LOGGER.error() {
                let msg = [
                    "===== S3 HTTP RESPONSE ERROR =====",
                    httpRsp.request.toString(),
                    S3HttpUtils.bodyToString(httpRsp.request.body),
                    httpRsp.toString(),
                    httpRspXml,
                    "=========="
                ] |> collectString<String>(delimiter: IOUtils.LINE_SEPARATOR)
                return msg
            }
        }
        let metadata = S3ResponseMetadata(httpRsp.headers)
        let errorRsp = ErrorResponse(
            request: "(${this.name}) ${httpRsp.request.method} ${httpRsp.request.url}",
            requestId: metadata.requestId,
            extendedRequestId: metadata.extendedRequestId,
            statusCode: httpRsp.statusCode,
            errorDetails: errorDetails
        )
        throw S3ServiceException.create(errorRsp)
    }
}
