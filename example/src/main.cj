package s3client_example

import std.fs.*
import std.time.*
import std.collection.*
import s3client.*
import s3client.action.*
import s3client.core.*

// MinIO 默认凭据（请根据实际环境修改）
let ENDPOINT    = "http://127.0.0.1:9000"
let ACCESS_KEY  = "minioadmin"
let SECRET_KEY  = "minioadmin"
let BUCKET_NAME = "example-bucket"

main(): Int64 {
    println("=== CangjieS3Client 示例程序 ===\n")

    // 1. 创建 S3 客户端
    let s3 = S3Client.builder()
        .endpoint(ENDPOINT)
        .forcePathStyle(true)
        .credentials(ACCESS_KEY, SECRET_KEY)
        .build()

    try {
        // 2. Bucket 操作
        demoBucketOperations(s3)

        // 3. Object 上传
        demoUploadObject(s3)

        // 4. Object 列表
        demoListObjects(s3)

        // 5. Object 下载
        demoDownloadObject(s3)

        // 6. Object 复制
        demoCopyObject(s3)

        // 7. 预签名 URL
        demoPresignedUrl(s3)

        // 8. 异步操作
        demoAsyncOperation(s3)

        // 9. 清理
        demoCleanup(s3)

        println("\n=== 所有示例执行完毕 ===")
    } catch (ex: Exception) {
        println("错误: ${ex}")
    } finally {
        s3.close()
    }
    return 0
}

// ========== Bucket 操作 ==========

func demoBucketOperations(s3: S3Client): Unit {
    println("--- 1. Bucket 操作 ---")

    // 检查 Bucket 是否存在
    if (isBucketExists(s3, BUCKET_NAME)) {
        println("  Bucket '${BUCKET_NAME}' 已存在，跳过创建")
    } else {
        // 创建 Bucket
        let createRsp = s3.createBucket(CreateBucketRequest(bucket: BUCKET_NAME))
        println("  创建 Bucket: ${BUCKET_NAME}, location=${createRsp.location}")
    }

    // 列出所有 Bucket
    let listRsp = s3.listBuckets(ListBucketsRequest())
    println("  当前 Bucket 列表:")
    for (bucket in listRsp.buckets) {
        println("    - ${bucket.name} (创建时间: ${bucket.creationDate})")
    }
    println()
}

// ========== 上传 Object ==========

func demoUploadObject(s3: S3Client): Unit {
    println("--- 2. 上传 Object ---")

    // 2.1 上传字符串内容
    let textContent = "Hello, 仓颉 S3Client! 这是一段测试文本。"
    let putReq1 = PutObjectRequest(bucket: BUCKET_NAME, key: "test/hello.txt", contentType: "text/plain; charset=utf-8")
    let putRsp1 = s3.putObject(putReq1, S3Content.fromString(textContent))
    println("  上传文本: test/hello.txt, ETag=${putRsp1.etag}")

    // 2.2 上传二进制内容
    let bytes = Array<Byte>(256, {i => UInt8(i % 256)})
    let putReq2 = PutObjectRequest(bucket: BUCKET_NAME, key: "test/binary.dat")
    let putRsp2 = s3.putObject(putReq2, S3Content.fromBytes(bytes))
    println("  上传二进制: test/binary.dat, ETag=${putRsp2.etag}")

    // 2.3 上传带有自定义 metadata 的对象
    let putReq3 = PutObjectRequest(
        bucket: BUCKET_NAME,
        key: "test/with-metadata.txt",
        contentType: "text/plain",
        metadata: HashMap<String, String>([("author", "cangjie-example"), ("version", "1.0")])
    )
    let putRsp3 = s3.putObject(putReq3, S3Content.fromString("带有自定义元数据的对象"))
    println("  上传带 Metadata: test/with-metadata.txt, ETag=${putRsp3.etag}")

    // 2.4 上传文件
    let tmpFilePath = "/tmp/s3client_example_upload.txt"
    try (f = File(Path(tmpFilePath), OpenMode.Write)) {
        f.write("这是从文件上传到 S3 的内容。\n仓颉编程语言很棒！".toArray())
        f.flush()
    }
    let putReq4 = PutObjectRequest(bucket: BUCKET_NAME, key: "test/from-file.txt", contentType: "text/plain; charset=utf-8")
    let putRsp4 = s3.putObject(putReq4, S3Content.fromFile(tmpFilePath))
    println("  上传文件: test/from-file.txt, ETag=${putRsp4.etag}")
    println()
}

// ========== 列出 Object ==========

func demoListObjects(s3: S3Client): Unit {
    println("--- 3. 列出 Object ---")

    // 列出 test/ 前缀下的所有对象
    let listReq = ListObjectsV2Request(bucket: BUCKET_NAME, prefix: "test/")
    let listRsp = s3.listObjectsV2(listReq)
    println("  Bucket '${BUCKET_NAME}' 中 'test/' 前缀下的对象 (共 ${listRsp.keyCount} 个):")
    match (listRsp.contents) {
        case Some(objects) =>
            for (obj in objects) {
                let key = obj.key.getOrDefault({=> "?"})
                let size = obj.size.getOrDefault({=> 0})
                println("    - ${key} (大小: ${size} 字节)")
            }
        case None => println("    (无对象)")
    }
    println()
}

// ========== 下载 Object ==========

func demoDownloadObject(s3: S3Client): Unit {
    println("--- 4. 下载 Object ---")

    // 4.1 下载为字符串
    let getReq = GetObjectRequest(bucket: BUCKET_NAME, key: "test/hello.txt")
    s3.getObject(getReq) {
        rsp, body =>
        let text = body.toStringUtf8()
        println("  下载 test/hello.txt: contentLength=${rsp.contentLength}")
        println("  内容: ${text}")
    }

    // 4.2 下载为文件
    let downloadPath = "/tmp/s3client_example_download.txt"
    let getReq2 = GetObjectRequest(bucket: BUCKET_NAME, key: "test/from-file.txt")
    let resultTuple = s3.getObject(getReq2)
    try {
        resultTuple[1].toFile(downloadPath, true)
        println("  下载 test/from-file.txt 到文件: ${downloadPath}")
    } finally {
        resultTuple[1].close()
    }

    // 4.3 读取带 metadata 的对象的头部信息
    let headReq = HeadObjectRequest(bucket: BUCKET_NAME, key: "test/with-metadata.txt")
    let headRsp = s3.headObject(headReq)
    println("  HeadObject test/with-metadata.txt: contentLength=${headRsp.contentLength}, contentType=${headRsp.contentType}")
    println()
}

// ========== 复制 Object ==========

func demoCopyObject(s3: S3Client): Unit {
    println("--- 5. 复制 Object ---")

    let copyReq = CopyObjectRequest(
        sourceBucket: BUCKET_NAME,
        sourceKey: "test/hello.txt",
        destinationBucket: BUCKET_NAME,
        destinationKey: "test/hello-copy.txt"
    )
    let copyRsp = s3.copyObject(copyReq)
    match (copyRsp.copyObjectResult) {
        case Some(result) => println("  复制 test/hello.txt -> test/hello-copy.txt, ETag=${result.etag}")
        case None => println("  复制 test/hello.txt -> test/hello-copy.txt 完成")
    }
    println()
}

// ========== 预签名 URL ==========

func demoPresignedUrl(s3: S3Client): Unit {
    println("--- 6. 预签名 URL ---")

    // 生成 GET 预签名 URL (有效期 1 小时)
    let getReq = GetObjectRequest(bucket: BUCKET_NAME, key: "test/hello.txt")
    let presignedGet = s3.presignGetObject(getReq, Duration.hour)
    println("  GET 预签名 URL (1小时有效):")
    println("    ${presignedGet.url}")

    // 生成 PUT 预签名 URL (有效期 30 分钟)
    let putReq = PutObjectRequest(bucket: BUCKET_NAME, key: "test/presigned-upload.txt")
    let presignedPut = s3.presignPutObject(putReq, Duration.minute * 30)
    println("  PUT 预签名 URL (30分钟有效):")
    println("    ${presignedPut.url}")
    println()
}

// ========== 异步操作 ==========

func demoAsyncOperation(s3: S3Client): Unit {
    println("--- 7. 异步操作 ---")

    // 异步上传
    let asyncContent = "异步上传的内容 - ${DateTime.now()}"
    let putReq = PutObjectRequest(bucket: BUCKET_NAME, key: "test/async-upload.txt")
    let future = s3.putObjectAsync(putReq, S3Content.fromString(asyncContent))
    future.thenAsync<Unit>() {
        rsp, ex => match (rsp) {
            case Some(putRsp) => println("  异步上传完成: test/async-upload.txt, ETag=${putRsp.etag}")
            case None => println("  异步上传失败: ${ex.getOrThrow()}")
        }
    }
    sleep(Duration.second * 2)
    println()
}

// ========== 清理 ==========

func demoCleanup(s3: S3Client): Unit {
    println("--- 8. 清理资源 ---")

    // 列出所有对象并逐个删除
    let listReq = ListObjectsV2Request(bucket: BUCKET_NAME)
    let listRsp = s3.listObjectsV2(listReq)
    match (listRsp.contents) {
        case Some(objects) =>
            for (obj in objects) {
                let key = obj.key.getOrDefault({=> ""})
                if (key != "") {
                    let delReq = DeleteObjectRequest(bucket: BUCKET_NAME, key: key)
                    s3.deleteObject(delReq)
                    println("  删除对象: ${key}")
                }
            }
        case None => ()
    }

    // 删除 Bucket
    s3.deleteBucket(DeleteBucketRequest(bucket: BUCKET_NAME))
    println("  删除 Bucket: ${BUCKET_NAME}")

    // 验证 Bucket 已删除
    if (!isBucketExists(s3, BUCKET_NAME)) {
        println("  确认 Bucket '${BUCKET_NAME}' 已成功删除")
    }
    println()
}

// ========== 工具函数 ==========

func isBucketExists(s3: S3Client, bucket: String): Bool {
    try {
        let requestConfig = S3RequestConfig.create().loggingErrorResponse(false)
        s3.headBucket(HeadBucketRequest(bucket: bucket, requestConfig: requestConfig))
        return true
    } catch (ex: S3ServiceException) {
        if (ex.statusCode == 404) {
            return false
        }
        throw ex
    }
}
