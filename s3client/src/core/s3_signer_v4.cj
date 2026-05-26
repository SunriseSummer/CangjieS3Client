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
 * @date: 2023-11-14
 */
class V4S3Signer <: S3Signer {
    public prop name: String {
        get() {
            return S3Constants.V4_SIGNER_NAME
        }
    }

    public func sign(request: S3HttpRequestBuilder, signerProps: S3SignerProperties): S3HttpRequest {
        let credentials = signerProps.credentials
        if (credentials.isAnonymous) {
            return request.build()
        }

        if (request.getFirstHeader(S3Constants.X_AMZ_CONTENT_SHA256) == "") {
            request.addHeader(S3Constants.X_AMZ_CONTENT_SHA256, S3Constants.UNSIGNED_PAYLOAD)
        }

        let authLocation = signerProps.authLocation
        let expirationDuration = signerProps.expirationDuration
        match (authLocation) {
            case HEADER =>
                if (expirationDuration.isSome()) {
                    throw UnsupportedException("EXPIRATION_DURATION is not supported for ${AuthLocation.HEADER}")
                }
                signedInHeader(request, signerProps)
            case QUERY => match (expirationDuration) {
                case Some(v) => presignedInQuery(request, signerProps, v)
                case None => signedInQuery(request, signerProps)
            }
        }
        return request.build()
    }

    public func toString(): String {
        return "V4S3Signer()"
    }

    private func signedInHeader(request: S3HttpRequestBuilder, signerProps: S3SignerProperties) {
        // if (signerProps.credentials is SdkSessionCredentials) {
        //     let sessionToken = (signerProps.credentials as SdkSessionCredentials).getOrThrow().sessionToken
        //     request.addHeader(S3Constants.X_AMZ_SECURITY_TOKEN, sessionToken)
        // }

        let contentHash = request.getFirstHeader(S3Constants.X_AMZ_CONTENT_SHA256)
        let credential = signerProps.credentialsScope.scope(signerProps.credentials)
        request.addHeader(S3Constants.HOST, request.getHost())
        request.addHeader(S3Constants.X_AMZ_DATE, signerProps.credentialsScope.dateTime())
        let signature = signature(request, signerProps, contentHash)
        let authHeader = S3Constants.AWS4_SIGNING_ALGORITHM + // 
            " Credential=${credential}, SignedHeaders=${signature.signedHeaders}, Signature=${signature.signature}"
        request.addHeader(S3Constants.AUTHORIZATION, authHeader)
    }

    private func signedInQuery(request: S3HttpRequestBuilder, signerProps: S3SignerProperties) {
        // if (signerProps.credentials is SdkSessionCredentials) {
        //     let sessionToken = (signerProps.credentials as SdkSessionCredentials).getOrThrow().sessionToken
        //     request.addQueryParam(S3Constants.X_AMZ_SECURITY_TOKEN, sessionToken)
        // }

        let contentHash = request.getFirstHeader(S3Constants.X_AMZ_CONTENT_SHA256)
        let credential = signerProps.credentialsScope.scope(signerProps.credentials)
        request.addHeader(S3Constants.HOST, request.getHost())
        request.addQueryParam(S3Constants.X_AMZ_DATE, signerProps.credentialsScope.dateTime())
        request.addQueryParam(S3Constants.X_AMZ_ALGORITHM, S3Constants.AWS4_SIGNING_ALGORITHM)
        request.addQueryParam(S3Constants.X_AMZ_CREDENTIAL, credential)
        request.addQueryParam(S3Constants.X_AMZ_SIGNED_HEADERS, signedHeaders(canonicalHeaders(request)))
        let signature = signature(request, signerProps, contentHash)
        request.addQueryParam(S3Constants.X_AMZ_SIGNATURE, signature.signature)
    }

    private func presignedInQuery(
        request: S3HttpRequestBuilder,
        signerProps: S3SignerProperties,
        expirationDuration: Duration
    ) {
        // if (signerProps.credentials is SdkSessionCredentials) {
        //     let sessionToken = (signerProps.credentials as SdkSessionCredentials).getOrThrow().sessionToken
        //     request.addQueryParam(S3Constants.X_AMZ_SECURITY_TOKEN, sessionToken)
        // }

        let contentHash = request.getFirstHeader(S3Constants.X_AMZ_CONTENT_SHA256)
        request.removeHeader(S3Constants.X_AMZ_CONTENT_SHA256)
        let credential = signerProps.credentialsScope.scope(signerProps.credentials)
        request.addHeader(S3Constants.HOST, request.getHost())
        request.addQueryParam(S3Constants.X_AMZ_DATE, signerProps.credentialsScope.dateTime())
        request.addQueryParam(S3Constants.X_AMZ_EXPIRES, expirationDuration.toSeconds().toString())
        request.addQueryParam(S3Constants.X_AMZ_ALGORITHM, S3Constants.AWS4_SIGNING_ALGORITHM)
        request.addQueryParam(S3Constants.X_AMZ_CREDENTIAL, credential)
        request.addQueryParam(S3Constants.X_AMZ_SIGNED_HEADERS, signedHeaders(canonicalHeaders(request)))
        let signature = signature(request, signerProps, contentHash)
        request.addQueryParam(S3Constants.X_AMZ_SIGNATURE, signature.signature)
    }

    // -----------

    private func signature(request: S3HttpRequestBuilder, signerProps: S3SignerProperties, contentHash: String): SignatureResult {
        let canonicalParams = canonicalParams(request)
        let canonicalHeaders = canonicalHeaders(request)
        let canonicalUri = canonicalUri(request, signerProps)
        let canonicalParamsString = canonicalParamsString(canonicalParams)
        let canonicalHeadersString = canonicalHeadersString(canonicalHeaders)
        let signedHeaders = signedHeaders(canonicalHeaders)
        // https://docs.aws.amazon.com/zh_cn/IAM/latest/UserGuide/create-signed-request.html
        let canonicalRequestString = [
            request.getMethod(),
            canonicalUri,
            canonicalParamsString,
            canonicalHeadersString,
            signedHeaders,
            contentHash
        ] |> collectString<String>(delimiter: S3Constants.LF)

        let canonicalRequestHash = S3SignerUtils.sha256AsHex(canonicalRequestString)

        let stringToSign = [
            S3Constants.AWS4_SIGNING_ALGORITHM,
            signerProps.credentialsScope.dateTime(),
            signerProps.credentialsScope.scope(),
            canonicalRequestHash
        ] |> collectString<String>(delimiter: S3Constants.LF)

        let signKey = getSigningKey(signerProps)
        let signature = S3SignerUtils.hmacSha256AsHex(stringToSign, signKey)
        return SignatureResult(signature, signedHeaders)
    }

    //  -----
    public static func canonicalUri(request: S3HttpRequestBuilder, _: S3SignerProperties): String {
        // TODO 这里没按 v4Props.isNormalizePath 和 v4Props.isDoubleUrlEncode处理
        let path = request.getPath()
        if (path == "") {
            return "/"
        }
        return path
    }

    private func canonicalParams(request: S3HttpRequestBuilder): ArrayList<(String, Collection<String>)> {
        let result = ArrayList<(String, Collection<String>)>()
        for ((k, values) in request.getQueryParams()) {
            if (values.size == 0) {
                continue
            }
            let _k = S3HttpUtils.urlEncode(k)
            let _values = values |> map<String, String>(S3HttpUtils.urlEncode) |> collectArrayList<String>
            result.add((_k, _values))
        }
        sort(result, stable: true,
            by: {t1: (String, Collection<String>), t2: (String, Collection<String>) => t1[0].compare(t2[0])})
        return result
    }

    private static let IGNORE_HEADERS = HashSet<String>(
        [
            "connection",
            "x-amzn-trace-id",
            "user-agent",
            "expect"
        ]
    )
    private func canonicalHeaders(request: S3HttpRequestBuilder): ArrayList<(String, Collection<String>)> {
        let result = ArrayList<(String, Collection<String>)>()
        for ((k, values) in request.getHeaders()) {
            let name = StringUtils.toLowerCase(k)
            if (IGNORE_HEADERS.contains(name)) {
                continue
            }
            result.add((name, values))
        }
        sort(result, stable: true,
            by: {t1: (String, Collection<String>), t2: (String, Collection<String>) => t1[0].compare(t2[0])})
        return result
    }

    private func canonicalParamsString(canonicalParams: ArrayList<(String, Collection<String>)>): String {
        if (canonicalParams.size == 0) {
            return ""
        }
        let sb = StringBuilder()
        var isFirst = true
        for ((k, values) in canonicalParams) {
            let valuesString = values |> map<String, String> {v => k + "=" + v} |> collectString<String>(delimiter: "&")
            if (!isFirst) {
                sb.append('&')
            }
            sb.append(valuesString)
            if (isFirst) {
                isFirst = false
            }
        }
        return sb.toString()
    }

    private func canonicalHeadersString(canonicalHeaders: ArrayList<(String, Collection<String>)>): String {
        let sb = StringBuilder()
        for ((k, values) in canonicalHeaders) {
            // TODO aws的实现是value除了去除前后空格, 中间多个连续空格也会变成1个
            let valuesString = values |> map<String, String>(StringUtils.trim) |> collectString<String>(delimiter: ",")
            sb.append(k)
            sb.append(":")
            sb.append(valuesString)
            sb.append(S3Constants.LF)
        }
        return sb.toString()
    }

    private func signedHeaders(canonicalHeaders: ArrayList<(String, Collection<String>)>): String {
        let signedHeadersString = canonicalHeaders |> map<(String, Collection<String>), String> {kv => kv[0]} |>
            collectString<String>(delimiter: ";")
        return signedHeadersString
    }

    private func getSigningKey(signerProps: S3SignerProperties): Array<Byte> {
        return S3SignerUtils.deriveSigningKey(
            signerProps.credentials,
            signerProps.credentialsScope
        )
    }
}

class SignatureResult {
    public let signature: String
    public let signedHeaders: String

    public init(
        signature: String,
        signedHeaders: String
    ) {
        this.signature = signature
        this.signedHeaders = signedHeaders
    }
}
