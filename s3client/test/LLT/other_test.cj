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

import stdx.net.http.{ClientBuilder, HttpRequestBuilder, Client, HttpRequest, HttpResponse, HttpHeaders, Protocol, 
    HttpStatusCode}
import stdx.encoding.url.{URL, Form}
import std.unittest.*
import std.unittest.testmacro.*

/*
 *
 * @author: wangwb
 * @date: 2024-02-21
 */

// DEPENDENCE: _config.cj _config.properties
// EXEC: cjc %import-path %L %l %f _config.cj _config.properties
// EXEC: ./main
main(): Int64 {
    let tester = OtherTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class OtherTest {
    @TestCase
    public func testBase(): Unit {
        println("===== S3Region")
        println(S3Region.CN_NORTH_1.toString())

        println("===== S3RequestContext")
        println(S3RequestContext.create("test").toString())

        println("===== S3Metric")
        println(S3MetricLevel.ERROR)
        println(S3MetricLevel.INFO)
        println(S3MetricLevel.TRACE)
        println(S3Metrics.API_CALL_DURATION)
        println(S3MetricRecord("a", "TestA"))

        println(S3ChecksumAlgorithm.nameOf("CRC32C"))
        println(S3ChecksumAlgorithm.nameOf("CRC32"))
        println(S3ChecksumAlgorithm.ALGO_CRC32C)
        try {
            println(S3ChecksumAlgorithm.nameOf("MD6"))
        } catch (ex: Exception) {
        }
    }

    @TestCase
    public func testAction(): Unit {
        println(HeadObjectResponse(S3ResponseMetadata(HttpHeaders())))
        println(GetObjectResponse(S3ResponseMetadata(HttpHeaders())))
        println(ListBucketAnalyticsConfigurationsResponse(S3ResponseMetadata(HttpHeaders())))
        println(ListBucketIntelligentTieringConfigurationsResponse(S3ResponseMetadata(HttpHeaders())))
        println(ListBucketInventoryConfigurationsResponse(S3ResponseMetadata(HttpHeaders())))
        println(ListBucketMetricsConfigurationsResponse(S3ResponseMetadata(HttpHeaders())))
        println(ListObjectsResponse(S3ResponseMetadata(HttpHeaders()), name: "name", isTruncated: false, maxKeys: 10))
        println(PutBucketAccelerateConfigurationResponse(S3ResponseMetadata(HttpHeaders())))
        println(PutBucketNotificationConfigurationResponse(S3ResponseMetadata(HttpHeaders())))
        println(RestoreObjectResponse(S3ResponseMetadata(HttpHeaders())))
        println(UploadPartResponse(S3ResponseMetadata(HttpHeaders())))
        println(CompleteMultipartUploadResponse(S3ResponseMetadata(HttpHeaders())))
        println(GetBucketNotificationConfigurationResponse(S3ResponseMetadata(HttpHeaders())))
        println(GetBucketWebsiteResponse(S3ResponseMetadata(HttpHeaders())))
        println(GetObjectAttributesResponse(S3ResponseMetadata(HttpHeaders())))
        println(GetBucketAccelerateConfigurationResponse(S3ResponseMetadata(HttpHeaders()), status: "status"))
        println(AccessControlPolicy())
        println(Checksum())
        println(DeleteMarkerEntry())
        println(DeletedObject())
        println(GetObjectAttributesParts())
        println(MultipartUpload(uploadId: "uploadId", key: "key", initiator: Initiator()))
    }

    @TestCase
    public func testCommonPrefix(): Unit {
        println("===== CommonPrefix")
        let prefix = CommonPrefix(prefix: "prefix")
        println(prefix)
        let xml = prefix.toXml()
        println(xml)
        println(CommonPrefix.fromXml(S3XmlElement.fromXml(xml)))
    }

    @TestCase
    public func testS3Error(): Unit {
        println("===== S3Error")
        let err = S3Error()
        println(err)
        let xml = "<Error><Key>xx</Key></Error>"
        println(S3Error.fromXml(S3XmlElement.fromXml(xml)))
    }

    @TestCase
    public func testRestoreStatus(): Unit {
        println("===== RestoreStatus")
        let status = RestoreStatus(isRestoreInProgress: true, restoreExpiryDate: DateTime.nowUTC())
        println(status)
        let xml = status.toXml()
        println(xml)
        println(RestoreStatus.fromXml(S3XmlElement.fromXml(xml)))
    }

    @TestCase
    public func testS3ClientBuild(): Unit {
        println("===== S3ClientBuild")
        let s3 = S3Client
            .builder() //
            .region(S3Region.CN_NORTH_1) //
            .addLoggingMetricPublisher() //
            .endpoint("http://localhost:9999") //
            .forcePathStyle(true) //
            .loggingErrorResponse(true) //
            .retryer(S3Retryer<S3HttpResponse>.zero()) //
            .httpClient(DefaultS3HttpClient.builder().build()) //
            .build()
    }

    @TestCase
    public func testUploadPartCopyRequest(): Unit {
        println("===== UploadPartCopyRequest")
        let req = UploadPartCopyRequest(
            destinationBucket: "bucket",
            destinationKey: "key",
            uploadId: "uploadId",
            partNumber: 1
        )
        println(req)

        let rsp = UploadPartCopyResponse(S3ResponseMetadata(HttpHeaders()))
        println(rsp)
    }

    @TestCase
    public func testListPartsResponse(): Unit {
        println("===== ListPartsResponse")
        let rsp = ListPartsResponse(
            S3ResponseMetadata(HttpHeaders()),
            bucket: "bucket",
            key: "key",
            uploadId: "uploadId",
            isTruncated: true,
            parts: ArrayList<Part>([])
        )
        println(rsp)

        let req = ListPartsRequest(
            bucket: "bucket",
            key: "key",
            uploadId: "uploadId"
        )
        req.nextRequest(rsp)
    }

    @TestCase
    public func testListObjectVersionsRequest(): Unit {
        println("===== testListObjectVersionsRequest")
        let req = ListObjectVersionsRequest(bucket: "bucket")
        println(req)

        let rsp = ListObjectVersionsResponse(
            S3ResponseMetadata(HttpHeaders()),
            name: "name",
            isTruncated: false,
            maxKeys: 100
        )
        println(rsp)
    }

    @TestCase
    public func testAbortMultipartUploadRequest(): Unit {
        println("===== AbortMultipartUploadRequest")
        let req = AbortMultipartUploadRequest(
            bucket: "bucket",
            key: "key",
            uploadId: "uploadId"
        )
        println(req)
        let rsp = AbortMultipartUploadResponse(S3ResponseMetadata(HttpHeaders()))
        println(rsp)
    }

    @TestCase
    public func testListMultipartUploadsResponse(): Unit {
        println("===== ListMultipartUploadsResponse")
        let rsp = ListMultipartUploadsResponse(
            S3ResponseMetadata(HttpHeaders()),
            bucket: "bucket",
            isTruncated: true,
            uploads: ArrayList<MultipartUpload>([])
        )
        println(rsp)

        let req = ListMultipartUploadsRequest(bucket: "bucket")
        req.nextRequest(rsp)
    }

    @TestCase
    public func testIntelligentTieringFilter(): Unit {
        println("===== IntelligentTieringFilter")
        let and = IntelligentTieringAndOperator()
        println(and)
        let filter = IntelligentTieringFilter(and: and)
        println(filter)
        let xml = filter.toXml()
        println(xml)
        let filter2 = IntelligentTieringFilter.fromXml(S3XmlElement.fromXml(xml))
        println(filter2)
    }

    @TestCase
    public func testS3ConfigMap(): Unit {
        println("===== S3ConfigMap")
        let map1 = S3ConfigMap.create(HashMap<String, Any>())
        let map2 = map1.add(S3ConfigMap.create(HashMap<String, Any>()))
        println(map1)
        println(map2)

        println(S3ConfigKey<Int64>.intType("test", "int"))
        println(S3ConfigKey<URL>.urlType("test", "int"))
        println(S3ConfigKey<Duration>.durationType("test", "int"))
    }

    @TestCase
    public func testAnalyticsFilter(): Unit {
        println("===== AnalyticsFilter ")
        let and = AnalyticsAndOperator()
        println(and)
        let filter = AnalyticsFilter(prefix: "Prefix", and: and)
        println(filter)
        let xml = filter.toXml()
        println(xml)
        let filter2 = AnalyticsFilter.fromXml(S3XmlElement.fromXml(xml))
        println(filter2)
    }

    @TestCase
    public func testLifecycle(): Unit {
        println("===== Lifecycle ")
        let and = LifecycleRuleAndOperator()
        println(and)
        let xml = and.toXml()
        println(xml)
        let and2 = LifecycleRuleAndOperator.fromXml(S3XmlElement.fromXml(xml))
        println(and2)

        let transition = NoncurrentVersionTransition()
        println(transition)
        let transitionXml = transition.toXml()
        println(transitionXml)
        let transition2 = NoncurrentVersionTransition.fromXml(S3XmlElement.fromXml(transitionXml))
        println(transition2)

        let expiration = NoncurrentVersionExpiration()
        println(expiration)
        let expirationXml = expiration.toXml()
        println(expirationXml)
        let expiration2 = NoncurrentVersionExpiration.fromXml(S3XmlElement.fromXml(expirationXml))
        println(expiration2)

        let upload = AbortIncompleteMultipartUpload()
        println(upload)
        let uploadXml = upload.toXml()
        println(uploadXml)
        let upload2 = AbortIncompleteMultipartUpload.fromXml(S3XmlElement.fromXml(uploadXml))
        println(upload2)
    }

    @TestCase
    public func testLogging(): Unit {
        let grant = TargetGrant(grantee: Grantee(_type: "type"), permission: "permission")
        println(grant)
        let grantXml = grant.toXml()
        println(grantXml)
        let grant2 = TargetGrant.fromXml(S3XmlElement.fromXml(grantXml))
        println(grant2)

        let enabled = LoggingEnabled(targetBucket: "bucket", targetPrefix: "prefix", targetGrants: ArrayList([grant]))
        println(enabled)
        let enabledXml = enabled.toXml()
        println(enabledXml)
        let enabled2 = LoggingEnabled.fromXml(S3XmlElement.fromXml(enabledXml))
        println(enabled2)
    }

    @TestCase
    public func testBucket(): Unit {
        let bucket = Bucket(name: "name", creationDate: DateTime.nowUTC())
        println(bucket)
        let xml = "<Bucket><Name>name</Name><CreationDate>${DateUtils.toStringIso8601(DateTime.nowUTC())}</CreationDate></Bucket>"
        println(xml)
        let bucket2 = Bucket.fromXml(S3XmlElement.fromXml(xml))
        println(bucket2)
    }

    @TestCase
    public func testCreateBucketConfiguration(): Unit {
        let config = CreateBucketConfiguration(locationConstraint: "locationConstraint")
        println(config)
        let xml = config.toXml()
        println(xml)
        let config2 = CreateBucketConfiguration.fromXml(S3XmlElement.fromXml(xml))
        println(config2)
    }

    // -----
    //
    // -----
    @TestCase
    public func testV4Signer(): Unit {
        println("\n===== SignerTest.testV4Signer")
        println(S3Signer.v4())
        let request = S3HttpRequest
            .builder()
            .setMethod("GET")
            .setBaseUrl("https://s3.cn-north-1.amazonaws.com.cn")
            .addHeader("amz-sdk-invocation-id", IdUtils.id())

        let credentials = BasicS3Credentials("accessKeyId", "secretAccessKey")
        let signerProps = S3SignerProperties(credentials, "cn-north-1", "s3")

        let signedRequest = S3Signer.v4().sign(request, signerProps)
        println(signedRequest)

        let signerProps2 = S3SignerProperties(credentials, "cn-north-1", "s3", authLocation: AuthLocation.QUERY)
        let signedRequest2 = S3Signer.v4().sign(request, signerProps2)
        println(signedRequest2)

        let signerProps3 = S3SignerProperties(
            credentials,
            "cn-north-1",
            "s3",
            authLocation: AuthLocation.QUERY,
            expirationDuration: Duration.second * 10
        )
        let signedRequest3 = S3Signer.v4().sign(request, signerProps3)
        println(signedRequest3)
    }

    @TestCase
    public func testV2Signer(): Unit {
        println("\n===== SignerTest.testV2Signer")
        println(S3Signer.v2())
        let request = S3HttpRequest
            .builder()
            . //
                setMethod("POST")
            . //
                setBaseUrl("https://s3.cn-north-1.amazonaws.com.cn")
            . //
                addHeader("amz-sdk-invocation-id", "123")
            .addQueryParam("acl", "")

        let credentials = BasicS3Credentials("accessKeyId", "secretAccessKey")
        let signerProps = S3SignerProperties(credentials, "cn-north-1", "s3", resourcePath: "/cj-test1/")

        let signedRequest = S3Signer.v2().sign(request, signerProps)
        println(signedRequest)

        let signerProps2 = S3SignerProperties(
            credentials,
            "cn-north-1",
            "s3",
            resourcePath: "/cj-test1/",
            authLocation: AuthLocation.QUERY
        )
        let signedRequest2 = S3Signer.v2().sign(request, signerProps2)
        println(signedRequest2)

        let signerProps3 = S3SignerProperties(
            credentials,
            "cn-north-1",
            "s3",
            resourcePath: "/cj-test1/",
            authLocation: AuthLocation.QUERY,
            expirationDuration: Duration.second * 10
        )
        let signedRequest3 = S3Signer.v2().sign(request, signerProps3)
        println(signedRequest3)
    }

    @TestCase
    public func testClientException(): Unit {
        println(S3ClientException("S3ClientException"))
        // println(AbortedException("AbortedException"))
        println(ApiCallAttemptTimeoutException("ApiCallAttemptTimeoutException"))
        // println(ApiCallTimeoutException("ApiCallTimeoutException"))
        // println(NonRetryableException("NonRetryableException"))
        // println(RetryableException("RetryableException"))
    }

    @TestCase
    public func testServiceException(): Unit {
        let errorRsp = ErrorResponse(
            requestId: "test1",
            request: "request",
        )
        println(S3ServiceException(errorRsp))
        println(BucketAlreadyExistsException(errorRsp))
        println(BucketAlreadyOwnedByYouException(errorRsp))
        println(InvalidObjectStateException(errorRsp))
        println(NoSuchBucketException(errorRsp))
        println(NoSuchKeyException(errorRsp))
        println(NoSuchUploadException(errorRsp))
        println(ObjectAlreadyInActiveTierErrorException(errorRsp))
        println(ObjectNotInActiveTierErrorException(errorRsp))
    }

    @TestCase
    public func testFuture1(): Unit {
        let result = S3Future<String>
            .sync() {
                return "Old Six"
            }
            .thenAsync<String>() {
                str =>
                sleep(1 * Duration.second)
                return "老六 (${str})"
            }
            .thenAsync<Unit>() {
                str =>
                sleep(1 * Duration.second)
                println(str)
            }
            .thenAsync<String>() {
                _, ex =>
                println("ex??? => ${ex}")
                return "New Old Six"
            }
            .then<Unit>() {
                str => println(str)
            }
        sleep(Duration.second * 5)
    }

    @TestCase
    public func testFuture2(): Unit {
        try {
            let result = S3Future<String>
                .sync() {
                    return "Old Six"
                }
                .thenAsync<String>(
                    {
                        str, ex => match (ex) {
                            case Some(_ex) =>
                                println("Catch exception: ${ex}")
                                return "error"
                            case None => throw UnsupportedException("123")
                        }
                    })
                .thenAsync<Unit>() {
                    str =>
                    println(str)
                    throw UnsupportedException("456")
                }
                .thenAsync<String>() {
                    _ => return "New Old Six"
                }
                .get()
            println(result)
        } catch (ex: Exception) {
            return
        }
        throw IllegalStateException("Expect exception")
    }

    @TestCase
    public func testLogger1(): Unit {
        println(S3LoggerFactory.LOG_LEVEL)
        S3LoggerFactory.LOG_LEVEL = LogLevel.ALL
        println(S3LoggerFactory.LOG_LEVEL)

        let logger = S3LoggerFactory.getLogger("test")

        logger.trace() {"This is trace"}
        logger.debug() {"This is debug"}
        logger.info() {"This is info"}
        logger.warn() {"This is warn"}
        logger.error() {"This is error"}

        let errorRsp = ErrorResponse(
            requestId: "test1",
            request: "request",
            statusCode: 404,
            errorDetails: ErrorDetails(code: "code", message: "message")
        )
        let ex = S3ServiceException.create(errorRsp)
        // logger.trace(ex)
        // logger.debug(ex)
        // logger.info(ex)
        // logger.warn(ex)
        logger.error(ex)

        // logger.trace(ex, {=> "This is trace"})
        // logger.debug(ex, {=> "This is debug"})
        // logger.info(ex, {=> "This is info"})
        // logger.warn(ex, {=> "This is warn"})
        // logger.error(ex, {=> "This is error"})

        logger.trace("This is trace")
        logger.debug("This is debug")
        logger.info("This is info")
        logger.warn("This is warn")
        logger.error("This is error")

        // println(logger.isTraceEnabled())
        // println(logger.isDebugEnabled())
        // println(logger.isInfoEnabled())
        // println(logger.isWarnEnabled())
        // println(logger.isErrorEnabled())

        let logger2 = S3LoggerFactory.getLogger("six", level: LogLevel.ERROR)
        logger2.error() {"error level: error"}
        logger2.info() {"error level: info"}
        logger2.level = LogLevel.INFO
        logger2.info() {"info level: info"}
        // logger2.setOutput(Console.stdOut)
    }
}
