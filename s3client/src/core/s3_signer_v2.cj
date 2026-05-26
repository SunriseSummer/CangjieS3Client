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
 * @date: 2023-12-21
 */
class V2S3Signer <: S3Signer {
    public prop name: String {
        get() {
            return S3Constants.V2_SIGNER_NAME
        }
    }

    public func sign(request: S3HttpRequestBuilder, signerProps: S3SignerProperties): S3HttpRequest {
        let credentials = signerProps.credentials
        if (credentials.isAnonymous) {
            return request.build()
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
        return "V2S3Signer()"
    }

    private func signedInHeader(request: S3HttpRequestBuilder, signerProps: S3SignerProperties) {
        request.addHeader("Date", DateUtils.toStringRfc822(signerProps.credentialsScope.instant))
        let accessKeyId = signerProps.credentials.accessKeyId
        let signature = signature(request, signerProps)
        request.addHeader(S3Constants.AUTHORIZATION, "AWS " + accessKeyId + ":" + signature)
    }

    private func signedInQuery(request: S3HttpRequestBuilder, signerProps: S3SignerProperties) {
        let accessKeyId = signerProps.credentials.accessKeyId
        let signature = signature(request, signerProps)
        request.addQueryParam("Signature", signature)
        request.addQueryParam("AWSAccessKeyId", accessKeyId)
    }

    private func presignedInQuery(
        request: S3HttpRequestBuilder,
        signerProps: S3SignerProperties,
        expirationDuration: Duration
    ) {
        let expires = (signerProps.credentialsScope.instant + expirationDuration).toUnixTimeStamp().toSeconds().toString(
            )
        // 临时添加的 header, 只是用于 signature, 计算后就清空
        // TODO 或者把 request.addQueryParam("Expires", expires) 提前, 然后 signature 做一下特殊处理
        request.addHeader("xx-presigned-expires", expires)
        let accessKeyId = signerProps.credentials.accessKeyId
        let signature = signature(request, signerProps)
        request.removeHeader("xx-presigned-expires")

        request.addQueryParam("Signature", signature)
        request.addQueryParam("AWSAccessKeyId", accessKeyId)
        request.addQueryParam("Expires", expires)
    }

    // -----

    private func signature(request: S3HttpRequestBuilder, signerProps: S3SignerProperties): String {
        // https://docs.aws.amazon.com/AmazonS3/latest/userguide/RESTAuthentication.html
        /*
           Authorization = "AWS" + " " + AWSAccessKeyId + ":" + Signature;

           Signature = Base64( HMAC-SHA1( UTF-8-Encoding-Of(YourSecretAccessKey), UTF-8-Encoding-Of( StringToSign ) ) );

           StringToSign = HTTP-Verb + "\n" +
            Content-MD5 + "\n" +
            Content-Type + "\n" +
            Date + "\n" +
            CanonicalizedAmzHeaders +
            CanonicalizedResource;

           CanonicalizedResource = [ "/" + Bucket ] +
            <HTTP-Request-URI, from the protocol name up to the query string> +
            [ subresource, if present. For example "?acl", "?location", or "?logging"];

           CanonicalizedAmzHeaders = <described below>
         */
        let canonicalRequestString = canonicalRequestString(request, signerProps)
        let secretAccessKey = signerProps.credentials.secretAccessKey
        let signature = DigestUtils.digestAsBase64(
            DigestAlgorithm.ALGO_HMAC_SHA1(StringUtils.toByteArray(secretAccessKey)),
            StringUtils.toByteArray(canonicalRequestString)
        )
        return signature
    }

    public func canonicalRequestString(request: S3HttpRequestBuilder, signerProps: S3SignerProperties): String {
        let resourcePath = signerProps.resourcePath.getOrThrow({=> NoneValueException("'resourcePath' is null")})
        let canonicalHeadersString = canonicalHeadersString(request, signerProps)
        let canonicalParamsString = canonicalParamsString(request, signerProps)
        var canonicalRequestString = request.getMethod() + S3Constants.LF + //
            canonicalHeadersString + resourcePath
        if (canonicalParamsString.size > 0) {
            canonicalRequestString = canonicalRequestString + "?" + canonicalParamsString
        }
        return canonicalRequestString
    }

    // 参考 "com.amazonaws:aws-java-sdk-s3:1.12.622"
    // com.amazonaws.services.s3.internal.RestUtils.makeS3CanonicalString
    private func canonicalHeadersString(request: S3HttpRequestBuilder, _: S3SignerProperties): String {
        let headers = HashMap<String, String>()
        for ((k, values) in request.getHeaders()) {
            let name = StringUtils.toLowerCase(k)
            if (name == "content-type" || name == "content-md5" || name == "date" || name == "xx-presigned-expires" ||
                name.startsWith("x-amz-")) {
                let valuesString = values |> map<String, String>(StringUtils.trim) |> collectString<String>(
                    delimiter: ",")
                headers.add(name, valuesString)
            }
        }
        if (headers.contains("x-amz-date")) {
            headers.add("date", "")
        }
        match (headers.remove("xx-presigned-expires")) {
            case Some(expires) => headers.add("date", expires)
            case None => ()
        }
        if (!headers.contains("content-type")) {
            headers.add("content-type", "")
        }
        if (!headers.contains("content-md5")) {
            headers.add("content-md5", "")
        }

        for ((k, values) in request.getQueryParams()) {
            if (!k.startsWith("x-amz-")) {
                continue
            }
            let valuesString = values |> map<String, String>(StringUtils.trim) |> collectString<String>(delimiter: ",")
            headers.add(k, valuesString)
        }

        let canonicalHeaders = ArrayList<(String, String)>()
        for ((k, v) in headers) {
            canonicalHeaders.add((k, v))
        }
        sort(canonicalHeaders, stable: true, by: {t1: (String, String), t2: (String, String) => t1[0].compare(t2[0])})

        let sb = StringBuilder()
        for ((k, v) in canonicalHeaders) {
            if (k.startsWith("x-amz-")) {
                sb.append(k)
                sb.append(":")
                sb.append(v)
            } else {
                sb.append(v)
            }
            sb.append(S3Constants.LF)
        }
        return sb.toString()
    }

    private static let SIGNED_PARAMETERS = HashSet<String>(
        [
            "acl",
            "torrent",
            "logging",
            "location",
            "policy",
            "requestPayment",
            "versioning",
            "versions",
            "versionId",
            "notification",
            "uploadId",
            "uploads",
            "partNumber",
            "website",
            "delete",
            "lifecycle",
            "tagging",
            "cors",
            "restore",
            "replication",
            "accelerate",
            "inventory",
            "analytics",
            "metrics",
            "response-cache-control",
            "response-content-type",
            "response-content-language",
            "response-expires",
            "response-content-disposition",
            "response-content-encoding"
        ]
    )
    private func canonicalParamsString(request: S3HttpRequestBuilder, _: S3SignerProperties): String {
        let canonicaParams = ArrayList<(String, String)>()
        for ((k, values) in request.getQueryParams()) {
            if (!SIGNED_PARAMETERS.contains(k)) {
                continue
            }
            let valuesString = values |> map<String, String> {
                v => if (v == "") {
                    k
                } else {
                    k + "=" + v
                }
            } |> collectString<String>(delimiter: "&")
            canonicaParams.add((k, valuesString))
        }
        sort(canonicaParams, stable: true, by: {t1: (String, String), t2: (String, String) => t1[0].compare(t2[0])})

        let sb = StringBuilder()
        var isFirst = true
        for ((_, v) in canonicaParams) {
            if (!isFirst) {
                sb.append('&')
            }
            sb.append(v)
            if (isFirst) {
                isFirst = false
            }
        }
        return sb.toString()
    }
}
