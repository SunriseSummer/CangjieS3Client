package cdrive.service

import s3client.*
import s3client.action.*
import s3client.core.*
import std.collection.*
import std.time.*

public class StorageService {
    private let s3: S3Client
    private let bucket: String

    public init(endpoint: String, accessKey: String, secretKey: String, bucket: String) {
        this.bucket = bucket
        this.s3 = S3Client.builder()
            .endpoint(endpoint)
            .forcePathStyle(true)
            .credentials(accessKey, secretKey)
            .build()
        ensureBucket()
    }

    private func ensureBucket() {
        try {
            let requestConfig = S3RequestConfig.create().loggingErrorResponse(false)
            s3.headBucket(HeadBucketRequest(bucket: bucket, requestConfig: requestConfig))
        } catch (ex: S3ServiceException) {
            if (ex.statusCode == 404) {
                s3.createBucket(CreateBucketRequest(bucket: bucket))
                println("  Created S3 bucket: ${bucket}")
            } else {
                throw ex
            }
        }
    }

    public func uploadFile(key: String, data: Array<Byte>, contentType: String): String {
        let req = PutObjectRequest(bucket: bucket, key: key, contentType: contentType)
        let rsp = s3.putObject(req, S3Content.fromBytes(data))
        return rsp.etag
    }

    public func uploadString(key: String, content: String, contentType: String): String {
        let req = PutObjectRequest(bucket: bucket, key: key, contentType: contentType)
        let rsp = s3.putObject(req, S3Content.fromString(content))
        return rsp.etag
    }

    public func downloadFile(key: String): (Array<Byte>, String) {
        let getReq = GetObjectRequest(bucket: bucket, key: key)
        let resultTuple = s3.getObject(getReq)
        try {
            let bytes = resultTuple[1].toBytes()
            let contentType = resultTuple[0].contentType
            return (bytes, contentType)
        } finally {
            resultTuple[1].close()
        }
    }

    public func downloadFileAsString(key: String): String {
        let getReq = GetObjectRequest(bucket: bucket, key: key)
        var result = ""
        s3.getObject(getReq) {
            rsp, body =>
            result = body.toStringUtf8()
        }
        return result
    }

    public func deleteFile(key: String): Unit {
        let req = DeleteObjectRequest(bucket: bucket, key: key)
        s3.deleteObject(req)
    }

    public func getPresignedDownloadUrl(key: String): String {
        let req = GetObjectRequest(bucket: bucket, key: key)
        let presigned = s3.presignGetObject(req, Duration.hour)
        return presigned.url
    }

    public func close(): Unit {
        s3.close()
    }
}
