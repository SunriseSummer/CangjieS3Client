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

package s3client

public import std.collection.ArrayList
public import std.collection.HashMap
public import std.time.DateTime
public import stdx.net.http.HttpHeaders

public import s3client.core.*
public import s3client.action.*

/*
 *
 * @author: wangwb
 * @date: 2023-11-27
 */
public interface S3Client <: S3Closeable & ToString {
    static func builder(): S3ClientBuilder {
        return S3ClientBuilder()
    }

    static prop MODULE_INFO: String {
        get() {
            return S3Constants.MODULE_INFO
        }
    }

    // ----- Bucket 相关 -----
    func headBucket(s3Req: HeadBucketRequest): HeadBucketResponse
    func headBucketAsync(s3Req: HeadBucketRequest): S3Future<HeadBucketResponse>

    func createBucket(s3Req: CreateBucketRequest): CreateBucketResponse
    func createBucketAsync(s3Req: CreateBucketRequest): S3Future<CreateBucketResponse>

    func putBucketAccelerateConfiguration(s3Req: PutBucketAccelerateConfigurationRequest): PutBucketAccelerateConfigurationResponse
    func putBucketAccelerateConfigurationAsync(s3Req: PutBucketAccelerateConfigurationRequest): S3Future<PutBucketAccelerateConfigurationResponse>

    func putBucketAcl(s3Req: PutBucketAclRequest): PutBucketAclResponse
    func putBucketAclAsync(s3Req: PutBucketAclRequest): S3Future<PutBucketAclResponse>

    func putBucketAnalyticsConfiguration(s3Req: PutBucketAnalyticsConfigurationRequest): PutBucketAnalyticsConfigurationResponse
    func putBucketAnalyticsConfigurationAsync(s3Req: PutBucketAnalyticsConfigurationRequest): S3Future<PutBucketAnalyticsConfigurationResponse>

    func putBucketCors(s3Req: PutBucketCorsRequest): PutBucketCorsResponse
    func putBucketCorsAsync(s3Req: PutBucketCorsRequest): S3Future<PutBucketCorsResponse>

    func putBucketEncryption(s3Req: PutBucketEncryptionRequest): PutBucketEncryptionResponse
    func putBucketEncryptionAsync(s3Req: PutBucketEncryptionRequest): S3Future<PutBucketEncryptionResponse>

    func putBucketIntelligentTieringConfiguration(s3Req: PutBucketIntelligentTieringConfigurationRequest): PutBucketIntelligentTieringConfigurationResponse
    func putBucketIntelligentTieringConfigurationAsync(s3Req: PutBucketIntelligentTieringConfigurationRequest): S3Future<PutBucketIntelligentTieringConfigurationResponse>

    func putBucketInventoryConfiguration(s3Req: PutBucketInventoryConfigurationRequest): PutBucketInventoryConfigurationResponse
    func putBucketInventoryConfigurationAsync(s3Req: PutBucketInventoryConfigurationRequest): S3Future<PutBucketInventoryConfigurationResponse>

    func putBucketLifecycleConfiguration(s3Req: PutBucketLifecycleConfigurationRequest): PutBucketLifecycleConfigurationResponse
    func putBucketLifecycleConfigurationAsync(s3Req: PutBucketLifecycleConfigurationRequest): S3Future<PutBucketLifecycleConfigurationResponse>

    func putBucketLogging(s3Req: PutBucketLoggingRequest): PutBucketLoggingResponse
    func putBucketLoggingAsync(s3Req: PutBucketLoggingRequest): S3Future<PutBucketLoggingResponse>

    func putBucketMetricsConfiguration(s3Req: PutBucketMetricsConfigurationRequest): PutBucketMetricsConfigurationResponse
    func putBucketMetricsConfigurationAsync(s3Req: PutBucketMetricsConfigurationRequest): S3Future<PutBucketMetricsConfigurationResponse>

    func putBucketNotificationConfiguration(s3Req: PutBucketNotificationConfigurationRequest): PutBucketNotificationConfigurationResponse
    func putBucketNotificationConfigurationAsync(s3Req: PutBucketNotificationConfigurationRequest): S3Future<PutBucketNotificationConfigurationResponse>

    func putBucketOwnershipControls(s3Req: PutBucketOwnershipControlsRequest): PutBucketOwnershipControlsResponse
    func putBucketOwnershipControlsAsync(s3Req: PutBucketOwnershipControlsRequest): S3Future<PutBucketOwnershipControlsResponse>

    func putBucketPolicy(s3Req: PutBucketPolicyRequest): PutBucketPolicyResponse
    func putBucketPolicyAsync(s3Req: PutBucketPolicyRequest): S3Future<PutBucketPolicyResponse>

    func putBucketReplication(s3Req: PutBucketReplicationRequest): PutBucketReplicationResponse
    func putBucketReplicationAsync(s3Req: PutBucketReplicationRequest): S3Future<PutBucketReplicationResponse>

    func putBucketRequestPayment(s3Req: PutBucketRequestPaymentRequest): PutBucketRequestPaymentResponse
    func putBucketRequestPaymentAsync(s3Req: PutBucketRequestPaymentRequest): S3Future<PutBucketRequestPaymentResponse>

    func putBucketTagging(s3Req: PutBucketTaggingRequest): PutBucketTaggingResponse
    func putBucketTaggingAsync(s3Req: PutBucketTaggingRequest): S3Future<PutBucketTaggingResponse>

    func putBucketVersioning(s3Req: PutBucketVersioningRequest): PutBucketVersioningResponse
    func putBucketVersioningAsync(s3Req: PutBucketVersioningRequest): S3Future<PutBucketVersioningResponse>

    func putBucketWebsite(s3Req: PutBucketWebsiteRequest): PutBucketWebsiteResponse
    func putBucketWebsiteAsync(s3Req: PutBucketWebsiteRequest): S3Future<PutBucketWebsiteResponse>

    func getBucketAccelerateConfiguration(s3Req: GetBucketAccelerateConfigurationRequest): GetBucketAccelerateConfigurationResponse
    func getBucketAccelerateConfigurationAsync(s3Req: GetBucketAccelerateConfigurationRequest): S3Future<GetBucketAccelerateConfigurationResponse>

    func getBucketAcl(s3Req: GetBucketAclRequest): GetBucketAclResponse
    func getBucketAclAsync(s3Req: GetBucketAclRequest): S3Future<GetBucketAclResponse>

    func getBucketAnalyticsConfiguration(s3Req: GetBucketAnalyticsConfigurationRequest): GetBucketAnalyticsConfigurationResponse
    func getBucketAnalyticsConfigurationAsync(s3Req: GetBucketAnalyticsConfigurationRequest): S3Future<GetBucketAnalyticsConfigurationResponse>

    func getBucketCors(s3Req: GetBucketCorsRequest): GetBucketCorsResponse
    func getBucketCorsAsync(s3Req: GetBucketCorsRequest): S3Future<GetBucketCorsResponse>

    func getBucketEncryption(s3Req: GetBucketEncryptionRequest): GetBucketEncryptionResponse
    func getBucketEncryptionAsync(s3Req: GetBucketEncryptionRequest): S3Future<GetBucketEncryptionResponse>

    func getBucketIntelligentTieringConfiguration(s3Req: GetBucketIntelligentTieringConfigurationRequest): GetBucketIntelligentTieringConfigurationResponse
    func getBucketIntelligentTieringConfigurationAsync(s3Req: GetBucketIntelligentTieringConfigurationRequest): S3Future<GetBucketIntelligentTieringConfigurationResponse>

    func getBucketInventoryConfiguration(s3Req: GetBucketInventoryConfigurationRequest): GetBucketInventoryConfigurationResponse
    func getBucketInventoryConfigurationAsync(s3Req: GetBucketInventoryConfigurationRequest): S3Future<GetBucketInventoryConfigurationResponse>

    func getBucketLifecycleConfiguration(s3Req: GetBucketLifecycleConfigurationRequest): GetBucketLifecycleConfigurationResponse
    func getBucketLifecycleConfigurationAsync(s3Req: GetBucketLifecycleConfigurationRequest): S3Future<GetBucketLifecycleConfigurationResponse>

    func getBucketLocation(s3Req: GetBucketLocationRequest): GetBucketLocationResponse
    func getBucketLocationAsync(s3Req: GetBucketLocationRequest): S3Future<GetBucketLocationResponse>

    func getBucketLogging(s3Req: GetBucketLoggingRequest): GetBucketLoggingResponse
    func getBucketLoggingAsync(s3Req: GetBucketLoggingRequest): S3Future<GetBucketLoggingResponse>

    func getBucketMetricsConfiguration(s3Req: GetBucketMetricsConfigurationRequest): GetBucketMetricsConfigurationResponse
    func getBucketMetricsConfigurationAsync(s3Req: GetBucketMetricsConfigurationRequest): S3Future<GetBucketMetricsConfigurationResponse>

    func getBucketNotificationConfiguration(s3Req: GetBucketNotificationConfigurationRequest): GetBucketNotificationConfigurationResponse
    func getBucketNotificationConfigurationAsync(s3Req: GetBucketNotificationConfigurationRequest): S3Future<GetBucketNotificationConfigurationResponse>

    func getBucketOwnershipControls(s3Req: GetBucketOwnershipControlsRequest): GetBucketOwnershipControlsResponse
    func getBucketOwnershipControlsAsync(s3Req: GetBucketOwnershipControlsRequest): S3Future<GetBucketOwnershipControlsResponse>

    func getBucketPolicy(s3Req: GetBucketPolicyRequest): GetBucketPolicyResponse
    func getBucketPolicyAsync(s3Req: GetBucketPolicyRequest): S3Future<GetBucketPolicyResponse>

    func getBucketPolicyStatus(s3Req: GetBucketPolicyStatusRequest): GetBucketPolicyStatusResponse
    func getBucketPolicyStatusAsync(s3Req: GetBucketPolicyStatusRequest): S3Future<GetBucketPolicyStatusResponse>

    func getBucketReplication(s3Req: GetBucketReplicationRequest): GetBucketReplicationResponse
    func getBucketReplicationAsync(s3Req: GetBucketReplicationRequest): S3Future<GetBucketReplicationResponse>

    func getBucketRequestPayment(s3Req: GetBucketRequestPaymentRequest): GetBucketRequestPaymentResponse
    func getBucketRequestPaymentAsync(s3Req: GetBucketRequestPaymentRequest): S3Future<GetBucketRequestPaymentResponse>

    func getBucketTagging(s3Req: GetBucketTaggingRequest): GetBucketTaggingResponse
    func getBucketTaggingAsync(s3Req: GetBucketTaggingRequest): S3Future<GetBucketTaggingResponse>

    func getBucketVersioning(s3Req: GetBucketVersioningRequest): GetBucketVersioningResponse
    func getBucketVersioningAsync(s3Req: GetBucketVersioningRequest): S3Future<GetBucketVersioningResponse>

    func getBucketWebsite(s3Req: GetBucketWebsiteRequest): GetBucketWebsiteResponse
    func getBucketWebsiteAsync(s3Req: GetBucketWebsiteRequest): S3Future<GetBucketWebsiteResponse>

    func listBuckets(s3Req: ListBucketsRequest): ListBucketsResponse
    func listBucketsAsync(s3Req: ListBucketsRequest): S3Future<ListBucketsResponse>

    func listBucketAnalyticsConfigurations(s3Req: ListBucketAnalyticsConfigurationsRequest): ListBucketAnalyticsConfigurationsResponse
    func listBucketAnalyticsConfigurationsAsync(s3Req: ListBucketAnalyticsConfigurationsRequest): S3Future<ListBucketAnalyticsConfigurationsResponse>

    func listBucketIntelligentTieringConfigurations(s3Req: ListBucketIntelligentTieringConfigurationsRequest): ListBucketIntelligentTieringConfigurationsResponse
    func listBucketIntelligentTieringConfigurationsAsync(s3Req: ListBucketIntelligentTieringConfigurationsRequest): S3Future<ListBucketIntelligentTieringConfigurationsResponse>

    func listBucketInventoryConfigurations(s3Req: ListBucketInventoryConfigurationsRequest): ListBucketInventoryConfigurationsResponse
    func listBucketInventoryConfigurationsAsync(s3Req: ListBucketInventoryConfigurationsRequest): S3Future<ListBucketInventoryConfigurationsResponse>

    func listBucketMetricsConfigurations(s3Req: ListBucketMetricsConfigurationsRequest): ListBucketMetricsConfigurationsResponse
    func listBucketMetricsConfigurationsAsync(s3Req: ListBucketMetricsConfigurationsRequest): S3Future<ListBucketMetricsConfigurationsResponse>

    func deleteBucket(s3Req: DeleteBucketRequest): DeleteBucketResponse
    func deleteBucketAsync(s3Req: DeleteBucketRequest): S3Future<DeleteBucketResponse>

    func deleteBucketAnalyticsConfiguration(s3Req: DeleteBucketAnalyticsConfigurationRequest): DeleteBucketAnalyticsConfigurationResponse
    func deleteBucketAnalyticsConfigurationAsync(s3Req: DeleteBucketAnalyticsConfigurationRequest): S3Future<DeleteBucketAnalyticsConfigurationResponse>

    func deleteBucketCors(s3Req: DeleteBucketCorsRequest): DeleteBucketCorsResponse
    func deleteBucketCorsAsync(s3Req: DeleteBucketCorsRequest): S3Future<DeleteBucketCorsResponse>

    func deleteBucketEncryption(s3Req: DeleteBucketEncryptionRequest): DeleteBucketEncryptionResponse
    func deleteBucketEncryptionAsync(s3Req: DeleteBucketEncryptionRequest): S3Future<DeleteBucketEncryptionResponse>

    func deleteBucketIntelligentTieringConfiguration(s3Req: DeleteBucketIntelligentTieringConfigurationRequest): DeleteBucketIntelligentTieringConfigurationResponse
    func deleteBucketIntelligentTieringConfigurationAsync(s3Req: DeleteBucketIntelligentTieringConfigurationRequest): S3Future<DeleteBucketIntelligentTieringConfigurationResponse>

    func deleteBucketInventoryConfiguration(s3Req: DeleteBucketInventoryConfigurationRequest): DeleteBucketInventoryConfigurationResponse
    func deleteBucketInventoryConfigurationAsync(s3Req: DeleteBucketInventoryConfigurationRequest): S3Future<DeleteBucketInventoryConfigurationResponse>

    func deleteBucketLifecycle(s3Req: DeleteBucketLifecycleRequest): DeleteBucketLifecycleResponse
    func deleteBucketLifecycleAsync(s3Req: DeleteBucketLifecycleRequest): S3Future<DeleteBucketLifecycleResponse>

    func deleteBucketMetricsConfiguration(s3Req: DeleteBucketMetricsConfigurationRequest): DeleteBucketMetricsConfigurationResponse
    func deleteBucketMetricsConfigurationAsync(s3Req: DeleteBucketMetricsConfigurationRequest): S3Future<DeleteBucketMetricsConfigurationResponse>

    func deleteBucketOwnershipControls(s3Req: DeleteBucketOwnershipControlsRequest): DeleteBucketOwnershipControlsResponse
    func deleteBucketOwnershipControlsAsync(s3Req: DeleteBucketOwnershipControlsRequest): S3Future<DeleteBucketOwnershipControlsResponse>

    func deleteBucketPolicy(s3Req: DeleteBucketPolicyRequest): DeleteBucketPolicyResponse
    func deleteBucketPolicyAsync(s3Req: DeleteBucketPolicyRequest): S3Future<DeleteBucketPolicyResponse>

    func deleteBucketReplication(s3Req: DeleteBucketReplicationRequest): DeleteBucketReplicationResponse
    func deleteBucketReplicationAsync(s3Req: DeleteBucketReplicationRequest): S3Future<DeleteBucketReplicationResponse>

    func deleteBucketTagging(s3Req: DeleteBucketTaggingRequest): DeleteBucketTaggingResponse
    func deleteBucketTaggingAsync(s3Req: DeleteBucketTaggingRequest): S3Future<DeleteBucketTaggingResponse>

    func deleteBucketWebsite(s3Req: DeleteBucketWebsiteRequest): DeleteBucketWebsiteResponse
    func deleteBucketWebsiteAsync(s3Req: DeleteBucketWebsiteRequest): S3Future<DeleteBucketWebsiteResponse>

    func putPublicAccessBlock(s3Req: PutPublicAccessBlockRequest): PutPublicAccessBlockResponse
    func putPublicAccessBlockAsync(s3Req: PutPublicAccessBlockRequest): S3Future<PutPublicAccessBlockResponse>

    func getPublicAccessBlock(s3Req: GetPublicAccessBlockRequest): GetPublicAccessBlockResponse
    func getPublicAccessBlockAsync(s3Req: GetPublicAccessBlockRequest): S3Future<GetPublicAccessBlockResponse>

    func deletePublicAccessBlock(s3Req: DeletePublicAccessBlockRequest): DeletePublicAccessBlockResponse
    func deletePublicAccessBlockAsync(s3Req: DeletePublicAccessBlockRequest): S3Future<DeletePublicAccessBlockResponse>

    // ----- Object 相关 -----
    func headObject(s3Req: HeadObjectRequest): HeadObjectResponse
    func headObjectAsync(s3Req: HeadObjectRequest): S3Future<HeadObjectResponse>

    func putObject(s3Req: PutObjectRequest, reqBody: S3Content): PutObjectResponse
    func putObjectAsync(s3Req: PutObjectRequest, reqBody: S3Content): S3Future<PutObjectResponse>

    func putObjectAcl(s3Req: PutObjectAclRequest): PutObjectAclResponse
    func putObjectAclAsync(s3Req: PutObjectAclRequest): S3Future<PutObjectAclResponse>

    func putObjectLegalHold(s3Req: PutObjectLegalHoldRequest): PutObjectLegalHoldResponse
    func putObjectLegalHoldAsync(s3Req: PutObjectLegalHoldRequest): S3Future<PutObjectLegalHoldResponse>

    func putObjectLockConfiguration(s3Req: PutObjectLockConfigurationRequest): PutObjectLockConfigurationResponse
    func putObjectLockConfigurationAsync(s3Req: PutObjectLockConfigurationRequest): S3Future<PutObjectLockConfigurationResponse>

    func putObjectRetention(s3Req: PutObjectRetentionRequest): PutObjectRetentionResponse
    func putObjectRetentionAsync(s3Req: PutObjectRetentionRequest): S3Future<PutObjectRetentionResponse>

    func putObjectTagging(s3Req: PutObjectTaggingRequest): PutObjectTaggingResponse
    func putObjectTaggingAsync(s3Req: PutObjectTaggingRequest): S3Future<PutObjectTaggingResponse>

    func getObject(s3Req: GetObjectRequest, action: (GetObjectResponse, S3Content) -> Any): Any {
        let resultTuple = getObject(s3Req)
        try {
            return action(resultTuple[0], resultTuple[1])
        } finally {
            resultTuple[1].close()
        }
    }
    func getObject(s3Req: GetObjectRequest): (GetObjectResponse, S3Content)
    func getObjectAsync(s3Req: GetObjectRequest): S3Future<(GetObjectResponse, S3Content)>

    func getObjectAcl(s3Req: GetObjectAclRequest): GetObjectAclResponse
    func getObjectAclAsync(s3Req: GetObjectAclRequest): S3Future<GetObjectAclResponse>

    func getObjectAttributes(s3Req: GetObjectAttributesRequest): GetObjectAttributesResponse
    func getObjectAttributesAsync(s3Req: GetObjectAttributesRequest): S3Future<GetObjectAttributesResponse>

    func getObjectLegalHold(s3Req: GetObjectLegalHoldRequest): GetObjectLegalHoldResponse
    func getObjectLegalHoldAsync(s3Req: GetObjectLegalHoldRequest): S3Future<GetObjectLegalHoldResponse>

    func getObjectLockConfiguration(s3Req: GetObjectLockConfigurationRequest): GetObjectLockConfigurationResponse
    func getObjectLockConfigurationAsync(s3Req: GetObjectLockConfigurationRequest): S3Future<GetObjectLockConfigurationResponse>

    func getObjectRetention(s3Req: GetObjectRetentionRequest): GetObjectRetentionResponse
    func getObjectRetentionAsync(s3Req: GetObjectRetentionRequest): S3Future<GetObjectRetentionResponse>

    func getObjectTagging(s3Req: GetObjectTaggingRequest): GetObjectTaggingResponse
    func getObjectTaggingAsync(s3Req: GetObjectTaggingRequest): S3Future<GetObjectTaggingResponse>

    func listObjects(s3Req: ListObjectsRequest): ListObjectsResponse
    func listObjectsAsync(s3Req: ListObjectsRequest): S3Future<ListObjectsResponse>

    func listObjectsV2(s3Req: ListObjectsV2Request): ListObjectsV2Response
    func listObjectsV2Async(s3Req: ListObjectsV2Request): S3Future<ListObjectsV2Response>

    func listObjectVersions(s3Req: ListObjectVersionsRequest): ListObjectVersionsResponse
    func listObjectVersionsAsync(s3Req: ListObjectVersionsRequest): S3Future<ListObjectVersionsResponse>

    func deleteObject(s3Req: DeleteObjectRequest): DeleteObjectResponse
    func deleteObjectAsync(s3Req: DeleteObjectRequest): S3Future<DeleteObjectResponse>

    func deleteObjects(s3Req: DeleteObjectsRequest): DeleteObjectsResponse
    func deleteObjectsAsync(s3Req: DeleteObjectsRequest): S3Future<DeleteObjectsResponse>

    func deleteObjectTagging(s3Req: DeleteObjectTaggingRequest): DeleteObjectTaggingResponse
    func deleteObjectTaggingAsync(s3Req: DeleteObjectTaggingRequest): S3Future<DeleteObjectTaggingResponse>

    func copyObject(s3Req: CopyObjectRequest): CopyObjectResponse
    func copyObjectAsync(s3Req: CopyObjectRequest): S3Future<CopyObjectResponse>

    func restoreObject(s3Req: RestoreObjectRequest): RestoreObjectResponse
    func restoreObjectAsync(s3Req: RestoreObjectRequest): S3Future<RestoreObjectResponse>

    // ----- 分段上传 -----
    func createMultipartUpload(s3Req: CreateMultipartUploadRequest): CreateMultipartUploadResponse
    func createMultipartUploadAsync(s3Req: CreateMultipartUploadRequest): S3Future<CreateMultipartUploadResponse>

    func uploadPart(s3Req: UploadPartRequest, reqBody: S3Content): UploadPartResponse
    func uploadPartAsync(s3Req: UploadPartRequest, reqBody: S3Content): S3Future<UploadPartResponse>

    func uploadPartCopy(s3Req: UploadPartCopyRequest): UploadPartCopyResponse
    func uploadPartCopyAsync(s3Req: UploadPartCopyRequest): S3Future<UploadPartCopyResponse>

    func abortMultipartUpload(s3Req: AbortMultipartUploadRequest): AbortMultipartUploadResponse
    func abortMultipartUploadAsync(s3Req: AbortMultipartUploadRequest): S3Future<AbortMultipartUploadResponse>

    func completeMultipartUpload(s3Req: CompleteMultipartUploadRequest): CompleteMultipartUploadResponse
    func completeMultipartUploadAsync(s3Req: CompleteMultipartUploadRequest): S3Future<CompleteMultipartUploadResponse>

    func listMultipartUploads(s3Req: ListMultipartUploadsRequest): ListMultipartUploadsResponse
    func listMultipartUploadsAsync(s3Req: ListMultipartUploadsRequest): S3Future<ListMultipartUploadsResponse>

    func listParts(s3Req: ListPartsRequest): ListPartsResponse
    func listPartsAsync(s3Req: ListPartsRequest): S3Future<ListPartsResponse>

    // ----- 自动分页 -----
    func listObjectsV2Paginator(s3Req: ListObjectsV2Request): ListObjectsV2Iterable
    func listObjectVersionsPaginator(s3Req: ListObjectVersionsRequest): ListObjectVersionsIterable
    func listMultipartUploadsPaginator(s3Req: ListMultipartUploadsRequest): ListMultipartUploadsIterable
    func listPartsPaginator(s3Req: ListPartsRequest): ListPartsIterable

    // ----- 预签名 URL -----
    func presignGetObject(s3Req: GetObjectRequest, signatureDuration: Duration): S3PresignedRequest
    func presignPutObject(s3Req: PutObjectRequest, signatureDuration: Duration): S3PresignedRequest

    // ----- Waiter -----
    func waitUntilBucketExists(s3Req: HeadBucketRequest, timeout: Duration): Bool
    func waitUntilBucketNotExists(s3Req: HeadBucketRequest, timeout: Duration): Bool
    func waitUntilObjectExists(s3Req: HeadObjectRequest, timeout: Duration): Bool
    func waitUntilObjectNotExists(s3Req: HeadObjectRequest, timeout: Duration): Bool

    // ----- 兼容 awssdk 1.x 的接口 -----
    // func isObjectExists(bucket: String, key: String) {
    //     try {
    //         let request = HeadObjectRequest(
    //             bucket: bucket,
    //             key: key,
    //             requestConfig: S3RequestConfig.create().loggingErrorResponse(false)
    //         )
    //         headObject(request)
    //         return true
    //     } catch (ex: S3ServiceException) {
    //         if (ex.statusCode == 404) {
    //             return false
    //         }
    //         throw ex
    //     }
    // }
}

class DefaultS3Client <: S3Client {
    private static let LOGGER = S3LoggerFactory.getLogger("s3client.S3Client")
    private let s3ClientConfigMap: S3ConfigMap

    init(s3ClientConfigMap: S3ConfigMap) {
        this.s3ClientConfigMap = s3ClientConfigMap
    }

    public func close(): Unit {
        let httpClient = S3ConfigKeys.HTTP_CLIENT.getOrThrow(s3ClientConfigMap)
        httpClient.close()
        LOGGER.info() {"Closed"}
    }

    public func toString(): String {
        return "DefaultS3Client(MODULE_INFO=${S3Client.MODULE_INFO}, configMap=${s3ClientConfigMap})"
    }

    // ----- Bucket 相关 -----
    public func headBucket(s3Req: HeadBucketRequest): HeadBucketResponse {
        return HeadBucket(s3ClientConfigMap, s3Req).execute1()
    }
    public func headBucketAsync(s3Req: HeadBucketRequest): S3Future<HeadBucketResponse> {
        return HeadBucket(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func createBucket(s3Req: CreateBucketRequest): CreateBucketResponse {
        return CreateBucket(s3ClientConfigMap, s3Req).execute1()
    }
    public func createBucketAsync(s3Req: CreateBucketRequest): S3Future<CreateBucketResponse> {
        return CreateBucket(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketAccelerateConfiguration(s3Req: PutBucketAccelerateConfigurationRequest): PutBucketAccelerateConfigurationResponse {
        return PutBucketAccelerateConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketAccelerateConfigurationAsync(s3Req: PutBucketAccelerateConfigurationRequest): S3Future<PutBucketAccelerateConfigurationResponse> {
        return PutBucketAccelerateConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketAcl(s3Req: PutBucketAclRequest): PutBucketAclResponse {
        return PutBucketAcl(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketAclAsync(s3Req: PutBucketAclRequest): S3Future<PutBucketAclResponse> {
        return PutBucketAcl(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketCors(s3Req: PutBucketCorsRequest): PutBucketCorsResponse {
        return PutBucketCors(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketCorsAsync(s3Req: PutBucketCorsRequest): S3Future<PutBucketCorsResponse> {
        return PutBucketCors(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketAnalyticsConfiguration(s3Req: PutBucketAnalyticsConfigurationRequest): PutBucketAnalyticsConfigurationResponse {
        return PutBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketAnalyticsConfigurationAsync(s3Req: PutBucketAnalyticsConfigurationRequest): S3Future<PutBucketAnalyticsConfigurationResponse> {
        return PutBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketEncryption(s3Req: PutBucketEncryptionRequest): PutBucketEncryptionResponse {
        return PutBucketEncryption(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketEncryptionAsync(s3Req: PutBucketEncryptionRequest): S3Future<PutBucketEncryptionResponse> {
        return PutBucketEncryption(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketIntelligentTieringConfiguration(s3Req: PutBucketIntelligentTieringConfigurationRequest): PutBucketIntelligentTieringConfigurationResponse {
        return PutBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketIntelligentTieringConfigurationAsync(s3Req: PutBucketIntelligentTieringConfigurationRequest): S3Future<PutBucketIntelligentTieringConfigurationResponse> {
        return PutBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketInventoryConfiguration(s3Req: PutBucketInventoryConfigurationRequest): PutBucketInventoryConfigurationResponse {
        return PutBucketInventoryConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketInventoryConfigurationAsync(s3Req: PutBucketInventoryConfigurationRequest): S3Future<PutBucketInventoryConfigurationResponse> {
        return PutBucketInventoryConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketLifecycleConfiguration(s3Req: PutBucketLifecycleConfigurationRequest): PutBucketLifecycleConfigurationResponse {
        return PutBucketLifecycleConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketLifecycleConfigurationAsync(s3Req: PutBucketLifecycleConfigurationRequest): S3Future<PutBucketLifecycleConfigurationResponse> {
        return PutBucketLifecycleConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketLogging(s3Req: PutBucketLoggingRequest): PutBucketLoggingResponse {
        return PutBucketLogging(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketLoggingAsync(s3Req: PutBucketLoggingRequest): S3Future<PutBucketLoggingResponse> {
        return PutBucketLogging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketMetricsConfiguration(s3Req: PutBucketMetricsConfigurationRequest): PutBucketMetricsConfigurationResponse {
        return PutBucketMetricsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketMetricsConfigurationAsync(s3Req: PutBucketMetricsConfigurationRequest): S3Future<PutBucketMetricsConfigurationResponse> {
        return PutBucketMetricsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketNotificationConfiguration(s3Req: PutBucketNotificationConfigurationRequest): PutBucketNotificationConfigurationResponse {
        return PutBucketNotificationConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketNotificationConfigurationAsync(s3Req: PutBucketNotificationConfigurationRequest): S3Future<PutBucketNotificationConfigurationResponse> {
        return PutBucketNotificationConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketOwnershipControls(s3Req: PutBucketOwnershipControlsRequest): PutBucketOwnershipControlsResponse {
        return PutBucketOwnershipControls(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketOwnershipControlsAsync(s3Req: PutBucketOwnershipControlsRequest): S3Future<PutBucketOwnershipControlsResponse> {
        return PutBucketOwnershipControls(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketPolicy(s3Req: PutBucketPolicyRequest): PutBucketPolicyResponse {
        return PutBucketPolicy(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketPolicyAsync(s3Req: PutBucketPolicyRequest): S3Future<PutBucketPolicyResponse> {
        return PutBucketPolicy(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketReplication(s3Req: PutBucketReplicationRequest): PutBucketReplicationResponse {
        return PutBucketReplication(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketReplicationAsync(s3Req: PutBucketReplicationRequest): S3Future<PutBucketReplicationResponse> {
        return PutBucketReplication(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketRequestPayment(s3Req: PutBucketRequestPaymentRequest): PutBucketRequestPaymentResponse {
        return PutBucketRequestPayment(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketRequestPaymentAsync(s3Req: PutBucketRequestPaymentRequest): S3Future<PutBucketRequestPaymentResponse> {
        return PutBucketRequestPayment(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketTagging(s3Req: PutBucketTaggingRequest): PutBucketTaggingResponse {
        return PutBucketTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketTaggingAsync(s3Req: PutBucketTaggingRequest): S3Future<PutBucketTaggingResponse> {
        return PutBucketTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketVersioning(s3Req: PutBucketVersioningRequest): PutBucketVersioningResponse {
        return PutBucketVersioning(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketVersioningAsync(s3Req: PutBucketVersioningRequest): S3Future<PutBucketVersioningResponse> {
        return PutBucketVersioning(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putBucketWebsite(s3Req: PutBucketWebsiteRequest): PutBucketWebsiteResponse {
        return PutBucketWebsite(s3ClientConfigMap, s3Req).execute1()
    }
    public func putBucketWebsiteAsync(s3Req: PutBucketWebsiteRequest): S3Future<PutBucketWebsiteResponse> {
        return PutBucketWebsite(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketAccelerateConfiguration(s3Req: GetBucketAccelerateConfigurationRequest): GetBucketAccelerateConfigurationResponse {
        return GetBucketAccelerateConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketAccelerateConfigurationAsync(s3Req: GetBucketAccelerateConfigurationRequest): S3Future<GetBucketAccelerateConfigurationResponse> {
        return GetBucketAccelerateConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketAcl(s3Req: GetBucketAclRequest): GetBucketAclResponse {
        return GetBucketAcl(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketAclAsync(s3Req: GetBucketAclRequest): S3Future<GetBucketAclResponse> {
        return GetBucketAcl(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketAnalyticsConfiguration(s3Req: GetBucketAnalyticsConfigurationRequest): GetBucketAnalyticsConfigurationResponse {
        return GetBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketAnalyticsConfigurationAsync(s3Req: GetBucketAnalyticsConfigurationRequest): S3Future<GetBucketAnalyticsConfigurationResponse> {
        return GetBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketCors(s3Req: GetBucketCorsRequest): GetBucketCorsResponse {
        return GetBucketCors(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketCorsAsync(s3Req: GetBucketCorsRequest): S3Future<GetBucketCorsResponse> {
        return GetBucketCors(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketEncryption(s3Req: GetBucketEncryptionRequest): GetBucketEncryptionResponse {
        return GetBucketEncryption(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketEncryptionAsync(s3Req: GetBucketEncryptionRequest): S3Future<GetBucketEncryptionResponse> {
        return GetBucketEncryption(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketIntelligentTieringConfiguration(s3Req: GetBucketIntelligentTieringConfigurationRequest): GetBucketIntelligentTieringConfigurationResponse {
        return GetBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketIntelligentTieringConfigurationAsync(s3Req: GetBucketIntelligentTieringConfigurationRequest): S3Future<GetBucketIntelligentTieringConfigurationResponse> {
        return GetBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketInventoryConfiguration(s3Req: GetBucketInventoryConfigurationRequest): GetBucketInventoryConfigurationResponse {
        return GetBucketInventoryConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketInventoryConfigurationAsync(s3Req: GetBucketInventoryConfigurationRequest): S3Future<GetBucketInventoryConfigurationResponse> {
        return GetBucketInventoryConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketLifecycleConfiguration(s3Req: GetBucketLifecycleConfigurationRequest): GetBucketLifecycleConfigurationResponse {
        return GetBucketLifecycleConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketLifecycleConfigurationAsync(s3Req: GetBucketLifecycleConfigurationRequest): S3Future<GetBucketLifecycleConfigurationResponse> {
        return GetBucketLifecycleConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketLocation(s3Req: GetBucketLocationRequest): GetBucketLocationResponse {
        return GetBucketLocation(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketLocationAsync(s3Req: GetBucketLocationRequest): S3Future<GetBucketLocationResponse> {
        return GetBucketLocation(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketLogging(s3Req: GetBucketLoggingRequest): GetBucketLoggingResponse {
        return GetBucketLogging(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketLoggingAsync(s3Req: GetBucketLoggingRequest): S3Future<GetBucketLoggingResponse> {
        return GetBucketLogging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketMetricsConfiguration(s3Req: GetBucketMetricsConfigurationRequest): GetBucketMetricsConfigurationResponse {
        return GetBucketMetricsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketMetricsConfigurationAsync(s3Req: GetBucketMetricsConfigurationRequest): S3Future<GetBucketMetricsConfigurationResponse> {
        return GetBucketMetricsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketNotificationConfiguration(s3Req: GetBucketNotificationConfigurationRequest): GetBucketNotificationConfigurationResponse {
        return GetBucketNotificationConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketNotificationConfigurationAsync(s3Req: GetBucketNotificationConfigurationRequest): S3Future<GetBucketNotificationConfigurationResponse> {
        return GetBucketNotificationConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketOwnershipControls(s3Req: GetBucketOwnershipControlsRequest): GetBucketOwnershipControlsResponse {
        return GetBucketOwnershipControls(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketOwnershipControlsAsync(s3Req: GetBucketOwnershipControlsRequest): S3Future<GetBucketOwnershipControlsResponse> {
        return GetBucketOwnershipControls(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketPolicy(s3Req: GetBucketPolicyRequest): GetBucketPolicyResponse {
        return GetBucketPolicy(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketPolicyAsync(s3Req: GetBucketPolicyRequest): S3Future<GetBucketPolicyResponse> {
        return GetBucketPolicy(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketPolicyStatus(s3Req: GetBucketPolicyStatusRequest): GetBucketPolicyStatusResponse {
        return GetBucketPolicyStatus(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketPolicyStatusAsync(s3Req: GetBucketPolicyStatusRequest): S3Future<GetBucketPolicyStatusResponse> {
        return GetBucketPolicyStatus(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketReplication(s3Req: GetBucketReplicationRequest): GetBucketReplicationResponse {
        return GetBucketReplication(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketReplicationAsync(s3Req: GetBucketReplicationRequest): S3Future<GetBucketReplicationResponse> {
        return GetBucketReplication(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketRequestPayment(s3Req: GetBucketRequestPaymentRequest): GetBucketRequestPaymentResponse {
        return GetBucketRequestPayment(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketRequestPaymentAsync(s3Req: GetBucketRequestPaymentRequest): S3Future<GetBucketRequestPaymentResponse> {
        return GetBucketRequestPayment(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketTagging(s3Req: GetBucketTaggingRequest): GetBucketTaggingResponse {
        return GetBucketTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketTaggingAsync(s3Req: GetBucketTaggingRequest): S3Future<GetBucketTaggingResponse> {
        return GetBucketTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketVersioning(s3Req: GetBucketVersioningRequest): GetBucketVersioningResponse {
        return GetBucketVersioning(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketVersioningAsync(s3Req: GetBucketVersioningRequest): S3Future<GetBucketVersioningResponse> {
        return GetBucketVersioning(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getBucketWebsite(s3Req: GetBucketWebsiteRequest): GetBucketWebsiteResponse {
        return GetBucketWebsite(s3ClientConfigMap, s3Req).execute1()
    }
    public func getBucketWebsiteAsync(s3Req: GetBucketWebsiteRequest): S3Future<GetBucketWebsiteResponse> {
        return GetBucketWebsite(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listBuckets(s3Req: ListBucketsRequest): ListBucketsResponse {
        return ListBuckets(s3ClientConfigMap, s3Req).execute1()
    }
    public func listBucketsAsync(s3Req: ListBucketsRequest): S3Future<ListBucketsResponse> {
        return ListBuckets(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listBucketAnalyticsConfigurations(s3Req: ListBucketAnalyticsConfigurationsRequest): ListBucketAnalyticsConfigurationsResponse {
        return ListBucketAnalyticsConfigurations(s3ClientConfigMap, s3Req).execute1()
    }
    public func listBucketAnalyticsConfigurationsAsync(s3Req: ListBucketAnalyticsConfigurationsRequest): S3Future<ListBucketAnalyticsConfigurationsResponse> {
        return ListBucketAnalyticsConfigurations(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listBucketIntelligentTieringConfigurations(s3Req: ListBucketIntelligentTieringConfigurationsRequest): ListBucketIntelligentTieringConfigurationsResponse {
        return ListBucketIntelligentTieringConfigurations(s3ClientConfigMap, s3Req).execute1()
    }
    public func listBucketIntelligentTieringConfigurationsAsync(
        s3Req: ListBucketIntelligentTieringConfigurationsRequest): S3Future<ListBucketIntelligentTieringConfigurationsResponse> {
        return ListBucketIntelligentTieringConfigurations(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listBucketInventoryConfigurations(s3Req: ListBucketInventoryConfigurationsRequest): ListBucketInventoryConfigurationsResponse {
        return ListBucketInventoryConfigurations(s3ClientConfigMap, s3Req).execute1()
    }
    public func listBucketInventoryConfigurationsAsync(s3Req: ListBucketInventoryConfigurationsRequest): S3Future<ListBucketInventoryConfigurationsResponse> {
        return ListBucketInventoryConfigurations(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listBucketMetricsConfigurations(s3Req: ListBucketMetricsConfigurationsRequest): ListBucketMetricsConfigurationsResponse {
        return ListBucketMetricsConfigurations(s3ClientConfigMap, s3Req).execute1()
    }
    public func listBucketMetricsConfigurationsAsync(s3Req: ListBucketMetricsConfigurationsRequest): S3Future<ListBucketMetricsConfigurationsResponse> {
        return ListBucketMetricsConfigurations(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucket(s3Req: DeleteBucketRequest): DeleteBucketResponse {
        return DeleteBucket(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketAsync(s3Req: DeleteBucketRequest): S3Future<DeleteBucketResponse> {
        return DeleteBucket(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketAnalyticsConfiguration(s3Req: DeleteBucketAnalyticsConfigurationRequest): DeleteBucketAnalyticsConfigurationResponse {
        return DeleteBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketAnalyticsConfigurationAsync(s3Req: DeleteBucketAnalyticsConfigurationRequest): S3Future<DeleteBucketAnalyticsConfigurationResponse> {
        return DeleteBucketAnalyticsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketCors(s3Req: DeleteBucketCorsRequest): DeleteBucketCorsResponse {
        return DeleteBucketCors(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketCorsAsync(s3Req: DeleteBucketCorsRequest): S3Future<DeleteBucketCorsResponse> {
        return DeleteBucketCors(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketEncryption(s3Req: DeleteBucketEncryptionRequest): DeleteBucketEncryptionResponse {
        return DeleteBucketEncryption(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketEncryptionAsync(s3Req: DeleteBucketEncryptionRequest): S3Future<DeleteBucketEncryptionResponse> {
        return DeleteBucketEncryption(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketIntelligentTieringConfiguration(s3Req: DeleteBucketIntelligentTieringConfigurationRequest): DeleteBucketIntelligentTieringConfigurationResponse {
        return DeleteBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketIntelligentTieringConfigurationAsync(
        s3Req: DeleteBucketIntelligentTieringConfigurationRequest): S3Future<DeleteBucketIntelligentTieringConfigurationResponse> {
        return DeleteBucketIntelligentTieringConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketInventoryConfiguration(s3Req: DeleteBucketInventoryConfigurationRequest): DeleteBucketInventoryConfigurationResponse {
        return DeleteBucketInventoryConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketInventoryConfigurationAsync(s3Req: DeleteBucketInventoryConfigurationRequest): S3Future<DeleteBucketInventoryConfigurationResponse> {
        return DeleteBucketInventoryConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketLifecycle(s3Req: DeleteBucketLifecycleRequest): DeleteBucketLifecycleResponse {
        return DeleteBucketLifecycle(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketLifecycleAsync(s3Req: DeleteBucketLifecycleRequest): S3Future<DeleteBucketLifecycleResponse> {
        return DeleteBucketLifecycle(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketMetricsConfiguration(s3Req: DeleteBucketMetricsConfigurationRequest): DeleteBucketMetricsConfigurationResponse {
        return DeleteBucketMetricsConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketMetricsConfigurationAsync(s3Req: DeleteBucketMetricsConfigurationRequest): S3Future<DeleteBucketMetricsConfigurationResponse> {
        return DeleteBucketMetricsConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketOwnershipControls(s3Req: DeleteBucketOwnershipControlsRequest): DeleteBucketOwnershipControlsResponse {
        return DeleteBucketOwnershipControls(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketOwnershipControlsAsync(s3Req: DeleteBucketOwnershipControlsRequest): S3Future<DeleteBucketOwnershipControlsResponse> {
        return DeleteBucketOwnershipControls(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketPolicy(s3Req: DeleteBucketPolicyRequest): DeleteBucketPolicyResponse {
        return DeleteBucketPolicy(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketPolicyAsync(s3Req: DeleteBucketPolicyRequest): S3Future<DeleteBucketPolicyResponse> {
        return DeleteBucketPolicy(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketReplication(s3Req: DeleteBucketReplicationRequest): DeleteBucketReplicationResponse {
        return DeleteBucketReplication(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketReplicationAsync(s3Req: DeleteBucketReplicationRequest): S3Future<DeleteBucketReplicationResponse> {
        return DeleteBucketReplication(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketTagging(s3Req: DeleteBucketTaggingRequest): DeleteBucketTaggingResponse {
        return DeleteBucketTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketTaggingAsync(s3Req: DeleteBucketTaggingRequest): S3Future<DeleteBucketTaggingResponse> {
        return DeleteBucketTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteBucketWebsite(s3Req: DeleteBucketWebsiteRequest): DeleteBucketWebsiteResponse {
        return DeleteBucketWebsite(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteBucketWebsiteAsync(s3Req: DeleteBucketWebsiteRequest): S3Future<DeleteBucketWebsiteResponse> {
        return DeleteBucketWebsite(s3ClientConfigMap, s3Req).executeAsync1()
    }

    // ----- 不知道是啥 -----
    public func putPublicAccessBlock(s3Req: PutPublicAccessBlockRequest): PutPublicAccessBlockResponse {
        return PutPublicAccessBlock(s3ClientConfigMap, s3Req).execute1()
    }
    public func putPublicAccessBlockAsync(s3Req: PutPublicAccessBlockRequest): S3Future<PutPublicAccessBlockResponse> {
        return PutPublicAccessBlock(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getPublicAccessBlock(s3Req: GetPublicAccessBlockRequest): GetPublicAccessBlockResponse {
        return GetPublicAccessBlock(s3ClientConfigMap, s3Req).execute1()
    }
    public func getPublicAccessBlockAsync(s3Req: GetPublicAccessBlockRequest): S3Future<GetPublicAccessBlockResponse> {
        return GetPublicAccessBlock(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deletePublicAccessBlock(s3Req: DeletePublicAccessBlockRequest): DeletePublicAccessBlockResponse {
        return DeletePublicAccessBlock(s3ClientConfigMap, s3Req).execute1()
    }
    public func deletePublicAccessBlockAsync(s3Req: DeletePublicAccessBlockRequest): S3Future<DeletePublicAccessBlockResponse> {
        return DeletePublicAccessBlock(s3ClientConfigMap, s3Req).executeAsync1()
    }

    // ----- Object 相关 -----
    public func headObject(s3Req: HeadObjectRequest): HeadObjectResponse {
        return HeadObject(s3ClientConfigMap, s3Req).execute1()
    }
    public func headObjectAsync(s3Req: HeadObjectRequest): S3Future<HeadObjectResponse> {
        return HeadObject(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putObject(s3Req: PutObjectRequest, reqBody: S3Content): PutObjectResponse {
        return PutObject(s3ClientConfigMap, s3Req, reqBody).execute1()
    }
    public func putObjectAsync(s3Req: PutObjectRequest, reqBody: S3Content): S3Future<PutObjectResponse> {
        return PutObject(s3ClientConfigMap, s3Req, reqBody).executeAsync1()
    }

    public func putObjectAcl(s3Req: PutObjectAclRequest): PutObjectAclResponse {
        return PutObjectAcl(s3ClientConfigMap, s3Req).execute1()
    }
    public func putObjectAclAsync(s3Req: PutObjectAclRequest): S3Future<PutObjectAclResponse> {
        return PutObjectAcl(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putObjectLegalHold(s3Req: PutObjectLegalHoldRequest): PutObjectLegalHoldResponse {
        return PutObjectLegalHold(s3ClientConfigMap, s3Req).execute1()
    }
    public func putObjectLegalHoldAsync(s3Req: PutObjectLegalHoldRequest): S3Future<PutObjectLegalHoldResponse> {
        return PutObjectLegalHold(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putObjectLockConfiguration(s3Req: PutObjectLockConfigurationRequest): PutObjectLockConfigurationResponse {
        return PutObjectLockConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func putObjectLockConfigurationAsync(s3Req: PutObjectLockConfigurationRequest): S3Future<PutObjectLockConfigurationResponse> {
        return PutObjectLockConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putObjectRetention(s3Req: PutObjectRetentionRequest): PutObjectRetentionResponse {
        return PutObjectRetention(s3ClientConfigMap, s3Req).execute1()
    }
    public func putObjectRetentionAsync(s3Req: PutObjectRetentionRequest): S3Future<PutObjectRetentionResponse> {
        return PutObjectRetention(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func putObjectTagging(s3Req: PutObjectTaggingRequest): PutObjectTaggingResponse {
        return PutObjectTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func putObjectTaggingAsync(s3Req: PutObjectTaggingRequest): S3Future<PutObjectTaggingResponse> {
        return PutObjectTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObject(s3Req: GetObjectRequest): (GetObjectResponse, S3Content) {
        return GetObject(s3ClientConfigMap, s3Req).execute()
    }
    public func getObjectAsync(s3Req: GetObjectRequest): S3Future<(GetObjectResponse, S3Content)> {
        return GetObject(s3ClientConfigMap, s3Req).executeAsync()
    }

    public func getObjectAcl(s3Req: GetObjectAclRequest): GetObjectAclResponse {
        return GetObjectAcl(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectAclAsync(s3Req: GetObjectAclRequest): S3Future<GetObjectAclResponse> {
        return GetObjectAcl(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObjectAttributes(s3Req: GetObjectAttributesRequest): GetObjectAttributesResponse {
        return GetObjectAttributes(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectAttributesAsync(s3Req: GetObjectAttributesRequest): S3Future<GetObjectAttributesResponse> {
        return GetObjectAttributes(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObjectLegalHold(s3Req: GetObjectLegalHoldRequest): GetObjectLegalHoldResponse {
        return GetObjectLegalHold(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectLegalHoldAsync(s3Req: GetObjectLegalHoldRequest): S3Future<GetObjectLegalHoldResponse> {
        return GetObjectLegalHold(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObjectLockConfiguration(s3Req: GetObjectLockConfigurationRequest): GetObjectLockConfigurationResponse {
        return GetObjectLockConfiguration(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectLockConfigurationAsync(s3Req: GetObjectLockConfigurationRequest): S3Future<GetObjectLockConfigurationResponse> {
        return GetObjectLockConfiguration(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObjectRetention(s3Req: GetObjectRetentionRequest): GetObjectRetentionResponse {
        return GetObjectRetention(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectRetentionAsync(s3Req: GetObjectRetentionRequest): S3Future<GetObjectRetentionResponse> {
        return GetObjectRetention(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func getObjectTagging(s3Req: GetObjectTaggingRequest): GetObjectTaggingResponse {
        return GetObjectTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func getObjectTaggingAsync(s3Req: GetObjectTaggingRequest): S3Future<GetObjectTaggingResponse> {
        return GetObjectTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listObjects(s3Req: ListObjectsRequest): ListObjectsResponse {
        return ListObjects(s3ClientConfigMap, s3Req).execute1()
    }
    public func listObjectsAsync(s3Req: ListObjectsRequest): S3Future<ListObjectsResponse> {
        return ListObjects(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listObjectsV2(s3Req: ListObjectsV2Request): ListObjectsV2Response {
        return ListObjectsV2(s3ClientConfigMap, s3Req).execute1()
    }
    public func listObjectsV2Async(s3Req: ListObjectsV2Request): S3Future<ListObjectsV2Response> {
        return ListObjectsV2(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listObjectVersions(s3Req: ListObjectVersionsRequest): ListObjectVersionsResponse {
        return ListObjectVersions(s3ClientConfigMap, s3Req).execute1()
    }
    public func listObjectVersionsAsync(s3Req: ListObjectVersionsRequest): S3Future<ListObjectVersionsResponse> {
        return ListObjectVersions(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteObject(s3Req: DeleteObjectRequest): DeleteObjectResponse {
        return DeleteObject(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteObjectAsync(s3Req: DeleteObjectRequest): S3Future<DeleteObjectResponse> {
        return DeleteObject(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteObjects(s3Req: DeleteObjectsRequest): DeleteObjectsResponse {
        return DeleteObjects(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteObjectsAsync(s3Req: DeleteObjectsRequest): S3Future<DeleteObjectsResponse> {
        return DeleteObjects(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func deleteObjectTagging(s3Req: DeleteObjectTaggingRequest): DeleteObjectTaggingResponse {
        return DeleteObjectTagging(s3ClientConfigMap, s3Req).execute1()
    }
    public func deleteObjectTaggingAsync(s3Req: DeleteObjectTaggingRequest): S3Future<DeleteObjectTaggingResponse> {
        return DeleteObjectTagging(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func copyObject(s3Req: CopyObjectRequest): CopyObjectResponse {
        return CopyObject(s3ClientConfigMap, s3Req).execute1()
    }
    public func copyObjectAsync(s3Req: CopyObjectRequest): S3Future<CopyObjectResponse> {
        return CopyObject(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func restoreObject(s3Req: RestoreObjectRequest): RestoreObjectResponse {
        return RestoreObject(s3ClientConfigMap, s3Req).execute1()
    }
    public func restoreObjectAsync(s3Req: RestoreObjectRequest): S3Future<RestoreObjectResponse> {
        return RestoreObject(s3ClientConfigMap, s3Req).executeAsync1()
    }

    // ----- 分段上传 -----
    public func createMultipartUpload(s3Req: CreateMultipartUploadRequest): CreateMultipartUploadResponse {
        return CreateMultipartUpload(s3ClientConfigMap, s3Req).execute1()
    }
    public func createMultipartUploadAsync(s3Req: CreateMultipartUploadRequest): S3Future<CreateMultipartUploadResponse> {
        return CreateMultipartUpload(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func uploadPart(s3Req: UploadPartRequest, reqBody: S3Content): UploadPartResponse {
        return UploadPart(s3ClientConfigMap, s3Req, reqBody).execute1()
    }
    public func uploadPartAsync(s3Req: UploadPartRequest, reqBody: S3Content): S3Future<UploadPartResponse> {
        return UploadPart(s3ClientConfigMap, s3Req, reqBody).executeAsync1()
    }

    public func uploadPartCopy(s3Req: UploadPartCopyRequest): UploadPartCopyResponse {
        return UploadPartCopy(s3ClientConfigMap, s3Req).execute1()
    }
    public func uploadPartCopyAsync(s3Req: UploadPartCopyRequest): S3Future<UploadPartCopyResponse> {
        return UploadPartCopy(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listParts(s3Req: ListPartsRequest): ListPartsResponse {
        return ListParts(s3ClientConfigMap, s3Req).execute1()
    }
    public func listPartsAsync(s3Req: ListPartsRequest): S3Future<ListPartsResponse> {
        return ListParts(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func abortMultipartUpload(s3Req: AbortMultipartUploadRequest): AbortMultipartUploadResponse {
        return AbortMultipartUpload(s3ClientConfigMap, s3Req).execute1()
    }
    public func abortMultipartUploadAsync(s3Req: AbortMultipartUploadRequest): S3Future<AbortMultipartUploadResponse> {
        return AbortMultipartUpload(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func completeMultipartUpload(s3Req: CompleteMultipartUploadRequest): CompleteMultipartUploadResponse {
        return CompleteMultipartUpload(s3ClientConfigMap, s3Req).execute1()
    }
    public func completeMultipartUploadAsync(s3Req: CompleteMultipartUploadRequest): S3Future<CompleteMultipartUploadResponse> {
        return CompleteMultipartUpload(s3ClientConfigMap, s3Req).executeAsync1()
    }

    public func listMultipartUploads(s3Req: ListMultipartUploadsRequest): ListMultipartUploadsResponse {
        return ListMultipartUploads(s3ClientConfigMap, s3Req).execute1()
    }
    public func listMultipartUploadsAsync(s3Req: ListMultipartUploadsRequest): S3Future<ListMultipartUploadsResponse> {
        return ListMultipartUploads(s3ClientConfigMap, s3Req).executeAsync1()
    }

    // ----- 自动分页 -----
    public func listObjectsV2Paginator(s3Req: ListObjectsV2Request): ListObjectsV2Iterable {
        return ListObjectsV2Iterable(s3ClientConfigMap, s3Req)
    }
    public func listObjectVersionsPaginator(s3Req: ListObjectVersionsRequest): ListObjectVersionsIterable {
        return ListObjectVersionsIterable(s3ClientConfigMap, s3Req)
    }
    public func listMultipartUploadsPaginator(s3Req: ListMultipartUploadsRequest): ListMultipartUploadsIterable {
        return ListMultipartUploadsIterable(s3ClientConfigMap, s3Req)
    }
    public func listPartsPaginator(s3Req: ListPartsRequest): ListPartsIterable {
        return ListPartsIterable(s3ClientConfigMap, s3Req)
    }

    // ----- 预签名 URL -----
    public func presignGetObject(s3Req: GetObjectRequest, signatureDuration: Duration): S3PresignedRequest {
        return GetObject(s3ClientConfigMap, s3Req).presign(signatureDuration)
    }
    public func presignPutObject(s3Req: PutObjectRequest, signatureDuration: Duration): S3PresignedRequest {
        return PutObject(s3ClientConfigMap, s3Req, None).presign(signatureDuration)
    }

    // ----- Waiter -----
    public func waitUntilBucketExists(s3Req: HeadBucketRequest, timeout: Duration): Bool {
        return HeadBucket(s3ClientConfigMap, s3Req).waitUntil(1, timeout)
    }
    public func waitUntilBucketNotExists(s3Req: HeadBucketRequest, timeout: Duration): Bool {
        return HeadBucket(s3ClientConfigMap, s3Req).waitUntil(0, timeout)
    }
    public func waitUntilObjectExists(s3Req: HeadObjectRequest, timeout: Duration): Bool {
        return HeadObject(s3ClientConfigMap, s3Req).waitUntil(1, timeout)
    }
    public func waitUntilObjectNotExists(s3Req: HeadObjectRequest, timeout: Duration): Bool {
        return HeadObject(s3ClientConfigMap, s3Req).waitUntil(0, timeout)
    }
}

public class S3ClientBuilder {
    private let configMap = HashMap<String, Any>()

    init() {
        configMap.add(S3ConfigKeys.HTTP_CLIENT.qname, DefaultS3HttpClient.builder().build())
        configMap.add(S3ConfigKeys.SIGNER.qname, S3Signer.v4())
        configMap.add(S3ConfigKeys.REGION.qname, S3Region.CN_NORTH_1)
        configMap.add(S3ConfigKeys.FORCE_PATH_STYLE.qname, false)
        configMap.add(S3ConfigKeys.RETRYER.qname, S3Retryer<S3HttpResponse>.zero())
        configMap.add(S3ConfigKeys.LOGGING_ERROR_RESPONSE.qname, true)
        configMap.add(S3ConfigKeys.TRAILING_CHECKSUM.qname, false)
    }

    public func build(): S3Client {
        return DefaultS3Client(S3ConfigMap.create(configMap))
    }

    public func credentials(accessKeyId: String, secretAccessKey: String): S3ClientBuilder {
        configMap.add(S3ConfigKeys.CREDENTIALS.qname, BasicS3Credentials(accessKeyId, secretAccessKey))
        return this
    }

    public func anonymous(): S3ClientBuilder {
        configMap.add(S3ConfigKeys.CREDENTIALS.qname, AnonymousS3Credentials())
        return this
    }

    public func region(region: S3Region): S3ClientBuilder {
        configMap.add(S3ConfigKeys.REGION.qname, region)
        return this
    }

    public func endpoint(endpoint: String): S3ClientBuilder {
        configMap.add(S3ConfigKeys.ENDPOINT.qname, endpoint)
        return this
    }

    public func httpClient(httpClient: S3HttpClient): S3ClientBuilder {
        configMap.add(S3ConfigKeys.HTTP_CLIENT.qname, httpClient)
        return this
    }

    public func signer(signer: S3Signer): S3ClientBuilder {
        configMap.add(S3ConfigKeys.SIGNER.qname, signer)
        return this
    }

    public func forcePathStyle(forcePathStyle: Bool): S3ClientBuilder {
        configMap.add(S3ConfigKeys.FORCE_PATH_STYLE.qname, forcePathStyle)
        return this
    }

    public func metricPublishers(publishers: ArrayList<S3MetricPublisher>): S3ClientBuilder {
        configMap.add(S3ConfigKeys.METRIC_PUBLISHERS.qname, publishers)
        return this
    }

    public func addLoggingMetricPublisher(): S3ClientBuilder {
        let publishers = match (configMap.get(S3ConfigKeys.METRIC_PUBLISHERS.qname)) {
            case Some(v) => (v as ArrayList<S3MetricPublisher>).getOrThrow()
            case None => ArrayList<S3MetricPublisher>()
        }
        publishers.add(LoggingS3MetricPublisher())
        return metricPublishers(publishers)
    }

    public func retryer(retryer: S3Retryer<S3HttpResponse>): S3ClientBuilder {
        configMap.add(S3ConfigKeys.RETRYER.qname, retryer)
        return this
    }

    public func loggingErrorResponse(loggingErrorResponse: Bool): S3ClientBuilder {
        configMap.add(S3ConfigKeys.LOGGING_ERROR_RESPONSE.qname, loggingErrorResponse)
        return this
    }

    public func trailingChecksum(trailingChecksum: Bool): S3ClientBuilder {
        configMap.add(S3ConfigKeys.TRAILING_CHECKSUM.qname, trailingChecksum)
        return this
    }
}
