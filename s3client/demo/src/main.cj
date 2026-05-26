package s3client_demo
import s3client.*
import s3client.action.*
import s3client.core.*

main(): Int64 {
    let s3 = S3Client.builder() //
        .endpoint("http://127.0.0.1:9000") //
        .forcePathStyle(true) // 本地 minio 需要
        .credentials("DxXnzPqzfWlU0XKWBCK3", "7rGzgiKaya5oBuRgKk4dlvnMGt36hZUpk9FOMlVB") //
        .build()

    let bucket = "async-oldsix"

    if (isBucketExists(s3, bucket)) {
        println("===> Bucket '${bucket}' is exists")
        s3.close()
        return 0
    }

    let createReq = CreateBucketRequest(bucket: bucket)
    s3.createBucketAsync(createReq).thenAsync<Unit>() {
        rsp, ex => match (rsp) {
            case Some(createRsp) => println(createRsp)
            case None => println("===> EX: ${ex.getOrThrow()}")
        }
    }
    println("After CreateBucketAsync")
    sleep(Duration.second * 1)
    println("After sleep 1 second")
    s3.close()
    return 0
}

func isBucketExists(s3: S3Client, bucket: String): Bool {
    try {
        let requestConfig = S3RequestConfig.create().loggingErrorResponse(false)
        s3.headBucket(HeadBucketRequest(bucket: bucket, //
            requestConfig: requestConfig))
        return true
    } catch (ex: S3ServiceException) {
        if (ex.statusCode == 404) {
            return false
        }
        throw ex
    }
}
