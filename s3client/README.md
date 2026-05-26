<div align="center">
    <h1>s3client4cj</h1>
</div>

<div align="center">
    <img alt="" src="https://img.shields.io/badge/release-v0.5.0-brightgreen" style="display: inline-block;" />
    <img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
    <img alt="" src="https://img.shields.io/badge/cjc-v1.0.0-brightgreen" style="display: inline-block;" />
    <img alt="" src="https://img.shields.io/badge/cjcov-90%25-brightgreen" style="display: inline-block;" />
</div>

## 介绍
AWS S3 的仓颉客户端, 由 [普元信息技术股份有限公司](https://www.primeton.com/) 主导开发并提供支持，同时感谢 [广发期货有限公司](https://www.gfqh.com.cn/) 的开发与推广贡献。 客户端功能特性参考 Java 库实现 `software.amazon.awssdk:s3:2.21.21`

### 特性
- 🚀 支持 AWS Signature Version 2
- 🚀 支持 AWS Signature Version 4
- 🚀 支持 S3 Service 的错误响应报文
- 🚀 支持 Bucket 相关操作接口
- 🚀 支持 Object 相关操作接口
- 🚀 支持同步/异步编程接口
- 🚀 支持分段上传
- 🚀 支持自动分页
- 🚀 支持预签名 URL (Presigned URL)
- 🚀 支持 MD5/SHA1/SHA256 的 Checksum
- 🚀 支持 SHA1/SHA256 的 Trailing Checksum
- 🚀 支持 Metric
- 🚀 支持重试
- 🚀 支持 Waiter

### 支持的 S3 Action 列表
- HeadBucket (p. 203)
- CreateBucket (p. 34)
- ListBuckets (p. 233)
- DeleteBucket (p. 50)
- DeleteBucketAnalyticsConfiguration (p. 52)
- DeleteBucketCors (p. 54)
- DeleteBucketEncryption (p. 56)
- DeleteBucketIntelligentTieringConfiguration (p. 58)
- DeleteBucketInventoryConfiguration (p. 60)
- DeleteBucketLifecycle (p. 62)
- DeleteBucketMetricsConfiguration (p. 64)
- DeleteBucketOwnershipControls (p. 66)
- DeleteBucketPolicy (p. 68)
- DeleteBucketReplication (p. 70)
- DeleteBucketTagging (p. 72)
- DeleteBucketWebsite (p. 74)
- PutBucketAccelerateConfiguration (p. 280)
- PutBucketAcl (p. 283)
- PutBucketCors (p. 294)
- PutBucketAnalyticsConfiguration (p. 290)
- PutBucketEncryption (p. 298)
- PutBucketIntelligentTieringConfiguration (p. 302)
- PutBucketInventoryConfiguration (p. 305)
- PutBucketLifecycleConfiguration (p. 316)
- PutBucketLogging (p. 322)
- PutBucketMetricsConfiguration (p. 326)
- PutBucketNotificationConfiguration (p. 334)
- PutBucketOwnershipControls (p. 340)
- PutBucketPolicy (p. 344)
- PutBucketReplication (p. 347)
- PutBucketRequestPayment (p. 353)
- PutBucketTagging (p. 356)
- PutBucketVersioning (p. 359)
- PutBucketWebsite (p. 364)
- GetBucketAccelerateConfiguration (p. 94)
- GetBucketAcl (p. 97)
- GetBucketAnalyticsConfiguration (p. 100)
- GetBucketCors (p. 104)
- GetBucketEncryption (p. 108)
- GetBucketIntelligentTieringConfiguration (p. 111)
- GetBucketInventoryConfiguration (p. 114)
- GetBucketLifecycleConfiguration (p. 121)
- GetBucketLocation (p. 125)
- GetBucketLogging (p. 128)
- GetBucketMetricsConfiguration (p. 131)
- GetBucketNotificationConfiguration (p. 137)
- GetBucketOwnershipControls (p. 141)
- GetBucketPolicy (p. 144)
- GetBucketPolicyStatus (p. 147)
- GetBucketReplication (p. 150)
- GetBucketRequestPayment (p. 154)
- GetBucketTagging (p. 156)
- GetBucketVersioning (p. 159)
- GetBucketWebsite (p. 162)
- ListBucketAnalyticsConfigurations (p. 217)
- ListBucketIntelligentTieringConfigurations (p. 221)
- ListBucketInventoryConfigurations (p. 224)
- ListBucketMetricsConfigurations (p. 229)
- PutPublicAccessBlock (p. 405)
- GetPublicAccessBlock (p. 200)
- DeletePublicAccessBlock (p. 92)
- HeadObject (p. 206)
- PutObject (p. 371)
- PutObjectAcl (p. 384)
- PutObjectLegalHold (p. 392)
- PutObjectLockConfiguration (p. 395)
- PutObjectRetention (p. 398)
- PutObjectTagging (p. 401)
- GetObject (p. 165)
- GetObjectAcl (p. 178)
- GetObjectAttributes (p. 183)
- GetObjectLegalHold (p. 188)
- GetObjectLockConfiguration (p. 190)
- GetObjectRetention (p. 192)
- GetObjectTagging (p. 194)
- ListObjects (p. 244)
- ListObjectsV2 (p. 252)
- ListObjectVersions (p. 262)
- DeleteObject (p. 76)
- DeleteObjects (p. 81)
- DeleteObjectTagging (p. 89)
- CopyObject (p. 21)
- RestoreObject (p. 409)
- CreateMultipartUpload (p. 40)
- UploadPart (p. 426)
- AbortMultipartUpload (p. 10)
- CompleteMultipartUpload (p. 13)
- ListMultipartUploads (p. 235)
- ListParts (p. 274)
- UploadPartCopy (p. 433)

### 代码覆盖率报告
![代码率覆盖率](./doc/cjcov/cjcov.png)
> [代码率覆盖率.html](./doc/cjcov/index.html)


## 源码目录
```shell
.
├── doc
├── src
│   ├── s3_client.cj
│   ├── action
│   ├── core
│   └── util
└── test
    └── LLT
```

- `src` 源码目录
    - `src/s3_client.cj` S3Client 的统一操作类
    - `src/action` S3 的 Actions, Data Types, 自动分页
    - `src/core` 日志, 异常, HTTP Client, Checksum, Signer, Retryer, Future, 其它数据结构等
    - `src/util` 工具类
- `test` 测试目录


## 接口说明       
可以参考一个简单的规则, 对于上面所列 **[[支持的 S3 Action 列表]](#支持的-s3-action-列表)**, 每个 `Action` 都有自己的 `REQ/RSP`, 并且在 `s3_client.cj` 有对应方法, 如: 以 **`HeadBucket`** 为例    
- 同步方法 `s3.headBucket(s3Req: HeadBucketRequest): HeadBucketResponse`     
- 异步方法以 `Async` 结尾, `s3.headBucketAsync(s3Req: HeadBucketRequest): S3Future<HeadBucketResponse>`  
    - 异步方法的返回值是 `s3client.core.S3Future<RSP>`, 可以通过调用其方法 `thenAsync<V2>` 进行后续处理, `thenAsync<V2>` 方法参数是一个函数 `(?RSP, ?Exception) -> V2`     
    - 更多的异步接口使用可以参考后面的异步相关示例 **[桶创建 (异步)](#桶创建-异步)**
- `HeadBucketRequest/HeadBucketResponse` 里的字段可以参考Java实现     

更多的接口说明, 可以参考 
- 🚀 **[s3client4cj 接口文档](./doc/S3_API.md)**
- [Amazon S3 API Reference](https://docs.aws.amazon.com/zh_cn/AmazonS3/latest/API/API_Operations_Amazon_Simple_Storage_Service.html)
- [AWS SDK for Java API Reference](https://sdk.amazonaws.com/java/api/2.21.21/software/amazon/awssdk/services/s3/S3Client.html)

## 使用说明

### 编译（Win/Linux）     
```shell
cjpm clean

cjpm build
```

### 代码覆盖率     
``` shell
rm -fr build .cache module-lock.json html_output tmp anyxml_log ci_test test_temp output
cjpm clean
python ../testJekins/src/ci_test/ciTest build --coverage
python ../testJekins/src/ci_test/ciTest test
cjcov --root=./ -e "" --html-details -o output

# 1.0.0
# python ../TPC-Test-Framework/ci_test/ciTest test

# python ../testJekins/src/ci_test/ciTest test --case a_test.cj
# python ../testJekins/src/ci_test/ciTest coverage --html
# cjpm test --coverage
# cjcov --root=./ --html-details -o output
```
**注意:** 执行测试需要
- 在 `test/LLT` 目录下增加文件 `_config.properties`, 文件格式如下
```
accountId = xxx
ownerId = xxx
role_arn = xxx
accessKeyId = xxx
secretAccessKey = xxx
```

- 提前手工创建好以下 Bucket
```
public let bucket1 = "cj-test10" // NOTE: bucket requires: version 
public let bucket2 = "cj-test11" // NOTE: bucket requires: acl & version
public let bucket3 = "cj-async-test1"
public let bucket_lock = "cj-test3" // NOTE: bucket requires: acl & version & enable lock
```

### 功能示例

#### 创建 S3Client
``` cangjie
import s3client.*

main() {
    let s3 = S3Client.builder() 
            .credentials("${accessKeyId}", "${secretAccessKey}")
            .trailingChecksum(true) 
            .build()
    ....
    s3.close()
}
```
> ⚠️ **注意:** S3Client 需要 close **`s3.close()`**, 但不用每次请求都创建、关闭 S3Client

> **S3Client 支持的可配置属性**

| 可配置项 | 方法名称 | 参数类型 | 默认值 | 描述 |
|-|-|-|-|-|
| 身份凭证 | credentials() | String, String | 无 | 指定 accessKeyId 和 secretAccessKey |
| 区域 | region() | s3client.core.S3Region | S3Region.CN_NORTH_1 | 指定 S3 服务所在区域 |
| 指定访问端点 | endpoint() | String | 无 | 指定访问端点, 优先级高于 region() |
| HTTP Client 实现 | httpClient() | s3client.core.S3HttpClient | s3client.core.DefaultS3HttpClient.builder().build() | HTTP Client 的实现, 默认实现是 `s3client.core.DefaultS3HttpClient`, 其底层是 `stdx.net.http.Client` 并配置: maxPerHost(即poolSize)是100, CertificateVerifyMode.TrustAll |
| 签名方式 | signer() | s3client.core.S3Signer | s3client.core.S3Signer.v4() | 签名方式 |
| 是否强制路径方式 | forcePathStyle() | Bool | false | 是否强制路径方式 |
| 重试 | retryer() | s3client.core.S3Retryer<s3client.core.S3HttpResponse> | s3client.core.S3Retryer<S3HttpResponse>.zero() | 重试 |
| 是否记录错误的 HTTP Response | loggingErrorResponse() | Bool | true | 当 HTTP Response 的 Status Code >=400 时, 是否记录详细的 HTTP Request 和 Response 信息 |
| 是否使用尾随校验和 | trailingChecksum() | Bool | false | 是否使用尾随校验和 |

#### 创建 S3Client - 使用 AWS Signature Version 2
``` cangjie
import ...
import s3client.core.*

main() {
    let s3 = S3Client.builder()
            .signer(S3Signer.v2())
            ....
            .build()
}
```
> ⚠️ **注意:** 如果没有显示指定, 默认是使用 `S3Signer.v4()`      

#### 创建 S3Client - 使用自定义 HttpClient
``` cangjie
import ...
import s3client.core.*

main() {
    let logger = S3LoggerFactory.getLogger("s3client.S3HttpClient", level: LogLevel.ALL)
    let httpClient = DefaultS3HttpClient(ClientBuilder().logger(logger).build())

    let s3 = S3Client.builder()
            .httpClient(httpClient)
            ...
            .build()
}
```
> 有2种方式实现自定义HttpClient
> - 使用默认的实现类 `s3client.core.DefaultS3HttpClient`, 其构造方法的参数是 `stdx.net.http.Client`, 可以对 `stdx.net.http.Client` 进行自定义, 如示例代码, 就是定义了一个高日志级别的 `stdx.net.http.Client`. *更多的 `stdx.net.http.Client` 使用方法, 如支持HTTP2等, 可以参考仓颉库使用指南*
> - 提供一个新的实现类, 实现接口 `s3client.core.S3HttpClient`       

#### 创建 S3Client - 使用自定义 Retryer
``` cangjie
import ...
import std.time.Duration
import s3client.core.*

main() {
    let retryer = S3Retryer<S3HttpResponse>.builder()
            .maxAttempts(2)
            .retryPolicy({attempt => attempt.ex.isSome()})
            .backoffPolicy({attempt => Duration.second * 1})
            .build()

    let s3 = S3Client.builder()
            .retryer(retryer)
            ....
            .build()
}
```
> ⚠️ **注意:** 
> - `retryPolicy` 方法参数 `(S3RetryAttempt<V>) -> Bool`, 返回结果表示是否要重试
> - `backoffPolicy` 方法参数 `(S3RetryAttempt<V>) -> Duration`, 返回结果表示推迟多少时间后, 进行下一次重试

#### 桶创建 (同步)
``` cangjie
import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let createReq = CreateBucketRequest(bucket: "oldsix")
    // 使用 S3RequestConfig 
    // let s3ReqCfg = S3RequestConfig.create().forcePathStyle(true)
    // let createReq = CreateBucketRequest(requestConfig: s3ReqCfg, bucket: "oldsix")
    let createRsp = s3.createBucket(createReq)
    println(createRsp)
    s3.close()
}
```

```
CreateBucketResponse(location=http://oldsix.s3.cn-north-1.amazonaws.com.cn/)
```

> ⚠️ **注意:** 
> - 所有 `REQ` 都实现了 `s3client.core.S3Request`, `s3client.core.S3Request` 里的有属性 `requestConfig: ?s3client.core.S3RequestConfig`, 用于设置当前请求相关的配置, 优先级高于 **S3Client的配置**      
> - 所有 `RSP` 都实现了 `s3client.core.S3Response`, `s3client.core.S3Response` 里的有属性 `responseMetadata: s3client.core.S3ResponseMetadata`, 用于获取 HTTP Response Header 的数据        

> **S3Request 支持的可配置属性**, 优先级高于 **S3Client的配置**

| 可配置项 | 方法名称 | 参数类型 | 默认值 | 描述 |
|-|-|-|-|-|
| 签名方式 | signer() | s3client.core.S3Signer | 无 | 签名方式 |
| 是否强制路径方式 | forcePathStyle() | Bool | 无 | 是否强制路径方式 |
| 重试 | retryer() | s3client.core.S3Retryer<s3client.core.S3HttpResponse> | 无 | 重试 |
| 是否记录错误的 HTTP Response | loggingErrorResponse() | Bool | 无 | 当 HTTP Response 的 Status Code >=400 时, 是否记录详细的 HTTP Request 和 Response 信息 |
| 是否使用尾随校验和 | trailingChecksum() | Bool | 无 | 是否使用尾随校验和 |

#### 桶创建 (异步)
``` cangjie
import std.time.Duration
import std.sync.sleep

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let createReq = CreateBucketRequest(bucket: "async-oldsix")
    s3.createBucketAsync(createReq).thenAsync<Unit>() {
        rsp, ex => match (rsp) {
            case Some(createRsp) => println(createRsp)
            case None => println("*** EX: ${ex.getOrThrow()}")
        }
        // 也可以使用下面的代码, 或者直接使用只有一个参数的函数 `thenAsync<V2>(fn: (V) -> V2)`
        // rsp, ex =>
        //    let _rsp = S3Future<CreateBucketResponse>.getResultOrThrow(rsp, ex)
        //    println(_rsp)
    }
    println("After CreateBucketAsync")
    sleep(Duration.second * 1)
    println("After sleep 1 second")
    s3.close()
}
```
> ⚠️ **注意:** 异步接口的返回值是 `s3client.core.S3Future<V>`, 支持后续的异步或同步处理
> - `thenAsync<V2>()` 进行异步的后续处理
>   - 方法一: 参数是一个函数 `(?V, ?Exception) -> V2`, 其中函数的参数 `(?V, ?Exception)` 为上一步的执行结果和异常
>   - 方法二: 参数是一个函数 `(V) -> V2`, 其中函数的参数 `V` 为上一步的执行结果  
> - `then<V2>()` 进行同步的后续处理
>   - 方法一: 参数是一个函数 `(?V, ?Exception) -> V2`, 其中函数的参数 `(?V, ?Exception)` 为上一步的执行结果和异常
>   - 方法二: 参数是一个函数 `(V) -> V2`, 其中函数的参数 `V` 为上一步的执行结果  


```
After CreateBucketAsync
CreateBucketResponse(location=http://async-oldsix.s3.cn-north-1.amazonaws.com.cn/)
After sleep 1 second
```

#### 上传/下载文件
``` cangjie
import std.collection.{HashMap}

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    println("----- 上传文件 -----")
    let putReq = PutObjectRequest(
        bucket: "cj-test2",
        key: "b.txt",
        metadata: HashMap([("k1", "v1"), ("k2", "v2")])
    )
    let putRsp = s3.putObject(
        putReq,
        S3Content.fromFile("./b.txt")
    )
    println("----- 下载文件 -----")
    let getReq = GetObjectRequest(bucket: "cj-test2", key: "b.txt")
    s3.getObject(getReq) {
        getRsp, rspBody => rspBody.toFile("./tmp/b.txt", true)
    }
    s3.close()
}
```

#### 分段上传 + SHA256 校验
``` cangjie
import std.collection.{HashMap}

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let objectId = "cj_Multipart2"
    let bucket = "cj-async-test1"

    println("=> 1. Delete Object: ${objectId}")
    s3.deleteObject(DeleteObjectRequest(bucket: bucket, key: objectId))

    println("=> 2. Create MultipartUpload")
    let createReq = CreateMultipartUploadRequest(
        bucket: bucket,
        key: objectId,
        checksumAlgorithm: "SHA256"
    )
    let createRsp = s3.createMultipartUpload(createReq)
    println(createRsp.responseMetadata)
    println(createRsp)

    let uploadId = createRsp.uploadId
    println("=> 3. Upload Parts with uploadId: ${uploadId}")
    let alphabets = "ABCDE"
    let completedParts = ArrayList<CompletedPart>()
    for (i in 0..2) {
        let partNumber = Int32(i + 1)
        let uploadReq = UploadPartRequest(
            bucket: bucket,
            key: objectId,
            uploadId: uploadId,
            partNumber: partNumber,
            checksumAlgorithm: "SHA256"
        )
        let data = StringUtils.repeat(alphabets[i..i + 1], 5 * 1024 * 1024) // 5MB
        let uploadRsp = s3.uploadPart(uploadReq, S3Content.fromString(data))
        let completedPart = CompletedPart(
            partNumber: uploadReq.partNumber,
            etag: uploadRsp.etag,
            checksumSHA256: uploadRsp.checksumSHA256
        )
        completedParts.append(completedPart)
    }

    println("=> 4. Complete MultipartUpload: ${uploadId}")
    let completeReq = CompleteMultipartUploadRequest(
        bucket: bucket,
        key: objectId,
        uploadId: uploadId,
        multipartUpload: CompletedMultipartUpload(parts: completedParts)
    )
    let completeRsp = s3.completeMultipartUpload(completeReq)
    println(completeRsp)
    s3.close()
}
```
> ⚠️ **注意**
如果每段小于5M, 会有以下异常, **更多分段上传限制** [参考官方文档](https://docs.aws.amazon.com/zh_cn/AmazonS3/latest/userguide/qfacts.html)
```xml
<Error><Code>EntityTooSmall</Code><Message>Your proposed upload is smaller than the minimum allowed size</Message><ProposedSize>102400</ProposedSize><MinSizeAllowed>5242880</MinSizeAllowed><PartNumber>1</PartNumber><ETag>17fea6e97583648e493e6d8bcd54c8f4</ETag><RequestId>C8QVGFFJE5JSC46Y</RequestId><HostId>xyXZs3LoW/MliVee6/XXcPH51+RPi7RR7yrZgT4fo+4wmurav6ALQaPjLFAlv8i7szGyXflEDWBFkd+5ThhasA==</HostId></Error>
```

#### 自动分页 (同步)
``` cangjie
import std.collection.*

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let iterRsp = s3.listObjectVersionsPaginator(ListObjectVersionsRequest(bucket: "oldsix", maxKeys: 10))
    iterRsp |> forEach<ListObjectVersionsResponse> {rsp => println(rsp)}
    s3.close()
}
```

#### 自动分页 (异步)
``` cangjie
import std.time.Duration
import std.sync.sleep
import std.collection.*

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let iterRsp = s3.listObjectVersionsPaginator(ListObjectVersionsRequest(bucket: "oldsix", maxKeys: 10))
    iterRsp.iterator().subscribe() {
        rsp, ex => 
        let isContinue = match (rsp) {
                case Some(v) =>
                    println(v)
                    true
                case None =>
                    println(ex)
                    false
            }
        // 返回 false 则停止订阅
        return isContinue
    }
    println("After listObjectVersionsPaginatorAsync")
    sleep(Duration.second * 2)
    println("After sleep 2 second")
    s3.close()
}
```

```
After listObjectVersionsPaginatorAsync
ListObjectVersionsResponse(name=oldsix, isTruncated=true, keyMarker=Some(), nextKeyMarker=Some(aaa), versionIdMarker=Some(), nextVersionIdMarker=Some(jpxjespa8xDElo22zAW4tylab5Wviimp), versions=Some([]), deleteMarkers=Some([DeleteMarkerEntry(key=Some(aaa), versionId=Some(jpxjespa8xDElo22zAW4tylab5Wviimp), isLatest=Some(true), lastModified=Some(2024-01-03T03:03:54Z), owner=Some(Owner(id=xxxxxx, displayName=None)))]), prefix=Some(), delimiter=None, maxKeys=1, commonPrefixes=Some([]), encodingType=None, requestCharged=None)
After sleep 2 second
```

#### 预签名 URL - PutObject
``` cangjie
import std.time.{Duration}
import stdx.net.http.{ClientBuilder, HttpRequestBuilder, Client, HttpRequest, HttpResponse, HttpHeaders, Protocol, HttpStatusCode}
import stdx.encoding.url.{URL, Form}
import stdx.net.tls.*

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let s3Req = PutObjectRequest(
        bucket: "bucket-99",
        key: "oldsix"
    )
    let presignedReq = s3.presignPutObject(s3Req, Duration.hour * 1)
    println(presignedReq)

    // ----- 使用原生 HttpClient 上传
    var tlsCfg = TlsClientConfig()
    tlsCfg.verifyMode = TrustAll
    let httpClient = ClientBuilder().tlsConfig(tlsCfg).build()
    let httpReq = stdx.net.http.HttpRequestBuilder() //
        .method(presignedReq.method) //
        .url(presignedReq.url) //
        .setHeaders(presignedReq.headers) //
        .header("Content-Type", "text/plain") //
        .body(S3Content.fromString("老六老六").toBytes())
        .build()
    let httpRsp = httpClient.send(httpReq)
    println(httpReq)
    s3.close()
}
```

#### 预签名 URL - GetObject
``` cangjie
import std.time.{Duration}
import stdx.net.http.{ClientBuilder, HttpRequestBuilder, Client, HttpRequest, HttpResponse, HttpHeaders, Protocol, HttpStatusCode}
import stdx.encoding.url.{URL, Form}
import stdx.net.tls.*

import s3client.*
import s3client.action.*
import s3client.core.*
import s3client.util.*

main() {
    let s3 = ...
    let s3Req = GetObjectRequest(
        bucket: "bucket-99",
        key: "oldsix"
    )
    let presignedReq = s3.presignGetObject(s3Req, Duration.hour * 1)
    println(presignedReq.url)
    s3.close()
}
```

```
https://bucket-99.s3.cn-north-1.amazonaws.com.cn/oldsix?X-Amz-Date=20240228T020109Z&X-Amz-Expires=3600&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=XXX%252F20240228%252Fcn-north-1%252Fs3%252Faws4_request&X-Amz-SignedHeaders=host&X-Amz-Signature=2d94d3620e97ec150bdb331fbd1fa1c2f74869bb586a064ead2c1fc366b1519b
```
> ⚠️ **注意:** 如果要把URL直接复制到浏览器的地址栏, 需要将 `%25` 替换成 `%`

#### Waiter     
``` cangjie
import std.time.{Duration}

import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let result = s3.waitUntilBucketExists(HeadBucketRequest(bucket: "bucket-2024"), Duration.second * 3)
    println(result)
    s3.close()
}
```
> `waitUntilXXX` 的参数 `timeout: Duration` 用于指定等待的超时时间, 如果 `<=0` 则表示一直等待     
> 返回值是一个 `Bool` 类型: `true` 表示等到了预期的结果; `false` 则是等待超时

#### Metric     
``` cangjie
import s3client.*
import s3client.action.*
import s3client.core.*

main() {
    let s3 = ...
    let req = HeadBucketRequest(
            requestConfig: S3RequestConfig.create().addLoggingMetricPublisher(),
            bucket: "oldsix"
    )
    s3.headBucket(req)
    s3.close()
}
```
> 可以在2个地方设置 `s3client.core.S3MetricPublisher`, `addLoggingMetricPublisher()` 是值将 Metric 输出到日志.      
> ⚠️ **注意:** 使用 `addLoggingMetricPublisher()`会影响性能
> - 在创建 `REQ` 时设置 `requestConfig: S3RequestConfig.create().addLoggingMetricPublisher()` 只对当前请求生效
> - 在创建 `S3Client` 设置 `addLoggingMetricPublisher()` 对所有请求生效

```
 ApiCall
 ┌─────────────────────────────────────────────────────────────────┐
 │ ServiceId = S3                                                  │
 │ OperationName = HeadBucket                                      │
 │ MarshallingDuration = 131us400ns                                │
 │ ServiceEndpoint = https://oldsix.s3.cn-north-1.amazonaws.com.cn │
 │ RetryCount = 0                                                  │
 │ UnmarshallingDuration = 17us800ns                               │
 │ ApiCallSuccessful = true                                        │
 │ ApiCallDuration = 232ms17us200ns                                │
 └─────────────────────────────────────────────────────────────────┘
     ApiCallAttempt
     ┌───────────────────────────────────────┐
     │ BackoffDelayDuration = 0s             │
     │ SigningDuration = 1ms538us400ns       │
     │ ServiceCallDuration = 230ms17us400ns  │
     │ HttpStatusCode = 200                  │
     │ AwsRequestId = Some(E5SPNKFHAWT9X48R) │
     │ AwsExtendedRequestId = Some(xxxxxxxx) │
     └───────────────────────────────────────┘
        HttpClient
         ┌──────────────────────────────────┐
         │ HttpClientName = stdx.net.http.Client │
         └──────────────────────────────────┘
```

#### 访问其他 S3 存储服务 - MinIO    
```
let s3 = S3Client.builder() //
    .credentials("7TqWZaaRE8IZuzjXKctd", "Oe16N435sZZtXM9qXs59Yo6v5JvOAmNvGZTvpzkX") //
    .endpoint("http://127.0.0.1:9000") //
    .forcePathStyle(true) //
    .trailingChecksum(false) 
    .build()

s3.createBucket(CreateBucketRequest(bucket: "bucket-99"))
let putObjRsp = s3.putObject(
    PutObjectRequest(bucket: "bucket-99", key: "oldsix"),
    S3Content.fromString("老六")
)
println(putObjRsp)

let presignedReq = s3.presignGetObject(GetObjectRequest(bucket: "bucket-99", key: "oldsix"), Duration.day * 7)
println(presignedReq.url)

let httpRsp = ClientBuilder().build().get(presignedReq.url.toString())
println(httpRsp)
println("==== Get Object Body ====")
println(IOUtils.copyToString(httpRsp.body))
```
> 在 `MinIO Version: RELEASE.2024-01-31T20-20-33Z` 测试

#### 访问其 S3 他存储服务 - OBS    
```
let s3 = S3Client.builder() //
    .credentials("1", "2") //
    .endpoint("https://obs.cn-east-3.myhuaweicloud.com") //
    .region(S3Region.of("cn-east-3")) // 必需设置
    .signer(S3Signer.v4()) // v2/v4 都支持
    .trailingChecksum(false) //
    .build()

s3.createBucket(CreateBucketRequest(bucket: "bucket-99"))
let putObjRsp = s3.putObject(
    PutObjectRequest(
        bucket: "bucket-99",
        key: "oldsix"
    ),
    S3Content.fromString("老六")
)
println(putObjRsp)

let presignedReq = s3.presignGetObject(GetObjectRequest(bucket: "bucket-99", key: "oldsix"), Duration.day * 7)
println(presignedReq.url)

var tlsCfg = TlsClientConfig()
tlsCfg.verifyMode = TrustAll
let httpClient = ClientBuilder().tlsConfig(tlsCfg).build()
let httpReq = stdx.net.http.HttpRequestBuilder() //
    .method(presignedReq.method) //
    .url(presignedReq.url) //
    .setHeaders(presignedReq.headers) //
    .build()
let httpRsp = httpClient.send(httpReq)
println(httpReq)
println("==== Get Object Body ====")
println(IOUtils.copyToString(httpRsp.body))
```
> ⚠️ **注意:**  需要设置 `region(S3Region.of("cn-east-3"))`


## 性能对比      

单线程的循环测试, 不实际发送 HTTP 请求, 主要测试除 HTTP 请求之外的代码耗时 **[测试代码](./test/LLT/benchmark)**     
```
python ../testJekins/src/ci_test/ciTest test --path=./test/LLT/benchmark -O2
```

**GetObjectAcl**
```
- 循环 100 次
    - Cangjie 耗时为  6ms 左右
    - Java    耗时为 110ms 左右 (预热100次)
    - Java    耗时为  40ms 左右 (预热1000次)
    - Java    耗时为  14ms 左右 (预热10000次)
```

**PutObjectAcl**
```
- 循环 100 次
    - Cangjie 耗时为  6ms 左右
    - Java    耗时为 80ms 左右 (预热100次)
    - Java    耗时为 40ms 左右 (预热1000次)
    - Java    耗时为  9ms 左右 (预热10000次)
```

**ListObjectsV2Paginator**
```
- 循环 100 次
    - Cangjie 耗时为  82ms 左右
    - Java    耗时为  66ms 左右 (预热10000次)
```

> - ⚠️ 30K的xml反序列化, Cangjie比较慢 (可能和数据量以及字符串转时间有关系), **[火焰图](./doc/cjprof/list_objects_v2_iterable.svg)**
>   - 数据量大的解析问题已经解决, 剩下的是字符串转时间较慢, 等待以后标准库更新
> - ~~⚠️ 试过用Cangjie和Java重新实现一个简单的xml解析, 差距非常大 (可能和Cangjie的字符串处理和循环有关), **[解析代码](./test/LLT/benchmark/xml_parse_test.cj)**,  **[火焰图](./doc/cjprof/xml_parse.svg)**~~


### 自定义XML解析    

**最终结果:** 自定义XML解析在速度上是有优势的, 在大数据量 `testS3XmlElement2_xml1 (9.506 ms)` 和小数据量 `testS3XmlElement2_xml2 (0.195 ms)` 上解析速度都比其他解析方式快
> ⚠️ **SDK默认使用的是自定义XML解析**, 如果使用中发现有XML解析问题, 可以通过设置 `s3client.core.S3XmlElement.DEFAULT_PARSER=s3client.core.S3XmlElement.PARSER_SAX` 切换到 SAX 解析     
> ⚠️ 自定义XML解析仅为支持S3协议的XML格式数据

```
--------------------------------------------------------------------------------------------------
TP: benchmark, time elapsed: 46218483444 ns, Result:
    TCS: XmlParseTest, time elapsed: 46218277087 ns, RESULT:
    | Case                   |   Median |         Err |   Err% |     Mean |
    |:-----------------------|---------:|------------:|-------:|---------:|
    | testS3XmlElement1_xml1 | 58.54 ms |   ±51.12 ms | ±87.3% | 60.77 ms |
    | testS3XmlElement2_xml1 | 9.506 ms |  ±0.0393 ms |  ±0.4% | 9.523 ms |
    | testStdDomParse_xml1   | 55.70 ms |   ±34.06 ms | ±61.1% | 54.74 ms |
    | testStdSaxParse_xml1   | 34.86 ms |   ±0.314 ms |  ±0.9% | 34.86 ms |
    | testS3XmlElement1_xml2 | 0.990 ms | ±0.00245 ms |  ±0.2% | 0.980 ms |
    | testS3XmlElement2_xml2 | 0.195 ms |  ±0.0008 ms |  ±0.4% | 0.201 ms |
    | testStdDomParse_xml2   | 1.035 ms | ±0.00353 ms |  ±0.3% | 1.030 ms |
    | testStdSaxParse_xml2   | 0.814 ms | ±0.00217 ms |  ±0.3% | 0.816 ms |
    Summary: TOTAL: 8
    PASSED: 8, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------
```
说明: 
- xml1: 30K左右的XML
- xml2: 600B左右的XML
- testS3XmlElement1: 基于SAX解析成S3XmlElement
- testS3XmlElement2: 基于自定义解析成S3XmlElement
- testStdDomParse: 标准库的DOM解析
- testStdSaxParse: 标准库的SAX解析 (SAX Handler是个空实现)


~~**相关的讨论和改进**~~

基于 `cangjie-0.45.2`
见 ISSUE [XML解析性能](https://e.gitee.com/HW-PLLab-pro/dashboard?issue=I9FP7X)

改进过程中的测试数据
```
30K XML 循环100次
- Cangjie:
    - XmlParse (Array<Rune>):         82ms774us353ns
    - XmlParse (Array<Byte>):         72ms802us891ns
    - XmlParse (Array<Byte>) unsafe:  73ms499us472ns
    - XmlParse (String):              65ms576us58ns
- Java
    - XmlParse: 12ms
```
- XmlParse (Array\<Rune\>): [代码](./test/LLT/benchmark/xml_parse_test_runes.cj), [火焰图](./doc/cjprof/xml_parse_test_runes.svg)
- XmlParse (Array\<Byte\>): [代码](./test/LLT/benchmark/xml_parse_test_bytes.cj), [火焰图](./doc/cjprof/xml_parse_test_bytes.svg)
- XmlParse (Array\<Byte\>) unsafe: [代码](./test/LLT/benchmark/xml_parse_test_bytes_unsafe.cj), [火焰图](./doc/cjprof/xml_parse_test_bytes_unsafe.svg)
- XmlParse (Array\<String\>): [代码](./test/LLT/benchmark/xml_parse_test_string.cj), [火焰图](./doc/cjprof/xml_parse_test_string.svg)

## 参与贡献     
欢迎给我们提交 PR，欢迎给我们提交 Issue，欢迎参与任何形式的贡献。

- 感谢 [广发期货有限公司](https://www.gfqh.com.cn/) 为 AWS S3 的仓颉客户端做出的开发与推广贡献！

