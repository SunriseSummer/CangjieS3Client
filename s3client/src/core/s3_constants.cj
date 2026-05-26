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
 * 绝大部分都是和 HTTP 请求有关
 * @author: wangwb
 * @date: 2023-11-20
 */
public class S3Constants {
    public static let MODULE_INFO = "CJ-s3client"
    public static let INT32_MAX: Int32 = 0x7fffffff
    public static let CRLF_BYTES = [b'\r', b'\n']

    // SignerConstant
    public static let V4_SIGNER_NAME = "V4Signer"
    public static let V2_SIGNER_NAME = "V2Signer"

    public static let AWS4_TERMINATOR = "aws4_request"
    public static let AWS4_SIGNING_ALGORITHM = "AWS4-HMAC-SHA256"
    public static let X_AMZ_CONTENT_SHA256 = "x-amz-content-sha256"
    public static let X_AMZ_SECURITY_TOKEN = "X-Amz-Security-Token"
    public static let X_AMZ_CREDENTIAL = "X-Amz-Credential"
    public static let X_AMZ_DATE = "X-Amz-Date"
    public static let X_AMZ_EXPIRES = "X-Amz-Expires"
    public static let X_AMZ_SIGNED_HEADERS = "X-Amz-SignedHeaders"
    public static let X_AMZ_SIGNATURE = "X-Amz-Signature"
    public static let X_AMZ_ALGORITHM = "X-Amz-Algorithm"
    public static let X_AMZ_DECODED_CONTENT_LENGTH = "x-amz-decoded-content-length"
    public static let X_AMZ_TRAILER = "x-amz-trailer"
    public static let AWS_CHUNKED = "aws-chunked"
    public static let HOST = "Host"
    public static let LF = "\n"
    public static let UNSIGNED_PAYLOAD = "UNSIGNED-PAYLOAD"
    public static let STREAMING_UNSIGNED_PAYLOAD_TRAILER = "STREAMING-UNSIGNED-PAYLOAD-TRAILER"
    // public static let STREAMING_EVENTS_PAYLOAD = "STREAMING-AWS4-HMAC-SHA256-EVENTS"
    // public static let STREAMING_ECDSA_SIGNED_PAYLOAD = "STREAMING-AWS4-ECDSA-P256-SHA256-PAYLOAD"
    // public static let STREAMING_ECDSA_SIGNED_PAYLOAD_TRAILER = "STREAMING-AWS4-ECDSA-P256-SHA256-PAYLOAD-TRAILER"
    // public static let STREAMING_SIGNED_PAYLOAD = "STREAMING-AWS4-HMAC-SHA256-PAYLOAD"
    // public static let STREAMING_SIGNED_PAYLOAD_TRAILER = "STREAMING-AWS4-HMAC-SHA256-PAYLOAD-TRAILER"
    public static let PRESIGN_URL_MAX_EXPIRATION_DURATION = Duration.day * 7

    public static let SDK_RETRY_INFO_HEADER = "amz-sdk-request"

    // Common Http Header
    public static let AUTHORIZATION = "Authorization"
    public static let CONTENT_LENGTH = "Content-Length"
    public static let CONTENT_TYPE = "Content-Type"
    public static let CONTENT_MD5 = "Content-MD5"
    public static let CONTENT_RANGE = "Content-Range"
    public static let TRANSFER_ENCODING = "Transfer-Encoding"
    public static let CHUNKED = "chunked"
    public static let CONNECTION = "Connection"
    public static let KEEP_ALIVE_VALUE = "keep-alive"
    public static let ACCEPT = "Accept"
    public static let USER_AGENT = "User-Agent"
    public static let LOCATION = "Location"
    public static let CACHE_CONTROL = "Cache-Control"
    public static let CONTENT_DISPOSITION = "Content-Disposition"
    public static let CONTENT_ENCODING = "Content-Encoding"
    public static let CONTENT_LANGUAGE = "Content-Language"
    public static let EXPIRES = "Expires"
    public static let ETAG = "ETag"
    public static let IF_MATCH = "If-Match"
    public static let IF_MODIFIED_SINCE = "If-Modified-Since"
    public static let IF_NONE_MATCH = "If-None-Match"
    public static let IF_UNMODIFIED_SINCE = "If-Unmodified-Since"
    public static let RANGE = "Range"
    public static let ACCEPT_RANGES = "accept-ranges"
    public static let LAST_MODIFIED = "Last-Modified"

    // 
    public static let TRACE_ID = "X-Amzn-Trace-Id"
    public static let SDK_TRANSACTION_ID = "amz-sdk-invocation-id"

    //
    public static let ACL = "x-amz-acl"
    public static let GRANT_FULL_CONTROL = "x-amz-grant-full-control"
    public static let GRANT_READ = "x-amz-grant-read"
    public static let GRANT_WRITE = "x-amz-grant-write"
    public static let GRANT_READ_ACP = "x-amz-grant-read-acp"
    public static let GRANT_WRITE_ACP = "x-amz-grant-write-acp"
    public static let BUCKET_OBJECT_LOCK_ENABLED = "x-amz-bucket-object-lock-enabled"
    public static let OBJECT_OWNERSHIP = "x-amz-object-ownership"

    public static let EXPECTED_BUCKET_OWNER = "x-amz-expected-bucket-owner"
    public static let REQUEST_PAYER = "x-amz-request-payer"
    public static let REQUEST_CHARGED = "x-amz-request-charged"
    public static let CHECKSUM_ALGORITHM = "x-amz-checksum-algorithm"
    public static let SDK_CHECKSUM_ALGORITHM = "x-amz-sdk-checksum-algorithm"
    public static let CHECKSUM_ = "x-amz-checksum-"
    public static let CHECKSUM_CRC32 = "x-amz-checksum-crc32"
    public static let CHECKSUM_CRC32C = "x-amz-checksum-crc32c"
    public static let CHECKSUM_SHA1 = "x-amz-checksum-sha1"
    public static let CHECKSUM_SHA256 = "x-amz-checksum-sha256"
    public static let META_ = "x-amz-meta-"
    public static let SERVER_SIDE_ENCRYPTION = "x-amz-server-side-encryption"
    public static let STORAGE_CLASS = "x-amz-storage-class"
    public static let WEBSITE_REDIRECT_LOCATION = "x-amz-website-redirect-location"
    public static let SSE_CUSTOMER_ALGORITHM = "x-amz-server-side-encryption-customer-algorithm"
    public static let SSE_CUSTOMER_KEY = "x-amz-server-side-encryption-customer-key"
    public static let SSE_CUSTOMER_KEY_MD5 = "x-amz-server-side-encryption-customer-key-MD5"
    public static let SSEKMS_KEY_ID = "x-amz-server-side-encryption-aws-kms-key-id"
    public static let SSEKMS_ENCRYPTION_CONTEXT = "x-amz-server-side-encryption-context"
    public static let BUCKET_KEY_ENABLED = "x-amz-server-side-encryption-bucket-key-enabled"
    public static let TAGGING = "x-amz-tagging"
    public static let OBJECT_LOCK_MODE = "x-amz-object-lock-mode"
    public static let OBJECT_LOCK_RETAIN_UNTIL_DATE = "x-amz-object-lock-retain-until-date"
    public static let OBJECT_LOCK_LEGAL_HOLD_STATUS = "x-amz-object-lock-legal-hold"
    public static let EXPIRATION = "x-amz-expiration"
    public static let VERSION_ID = "x-amz-version-id"
    public static let MFA = "x-amz-mfa"
    public static let BYPASS_GOVERNANCE_RETENTION = "x-amz-bypass-governance-retention"
    public static let DELETE_MARKER = "x-amz-delete-marker"
    public static let OPTIONAL_OBJECT_ATTRIBUTES = "x-amz-optional-object-attributes"
    public static let SKIP_DESTINATION_VALIDATION = "x-amz-skip-destination-validation"
    public static let CONFIRM_REMOVE_SELF_BUCKET_ACCESS = "x-amz-confirm-remove-self-bucket-access"
    public static let BUCKET_OBJECT_LOCK_TOKEN = "x-amz-bucket-object-lock-token"
    public static let CHECKSUM_MODE = "x-amz-checksum-mode"
    public static let RESTORE = "x-amz-restore"
    public static let ARCHIVE_STATUS = "x-amz-archive-status"
    public static let MISSING_META = "x-amz-missing-meta"
    public static let REPLICATION_STATUS = "x-amz-replication-status"
    public static let PARTS_COUNT = "x-amz-mp-parts-count"
    public static let TOKEN = "x-amz-bucket-object-lock-token"
    public static let TAG_COUNT = "x-amz-tagging-count"
    public static let MAX_PARTS = "x-amz-max-parts"
    public static let PART_NUMBER_MARKER = "x-amz-part-number-marker"
    public static let OBJECT_ATTRIBUTES = "x-amz-object-attributes"
    public static let COPY_SOURCE_VERSION_ID = "x-amz-copy-source-version-id"
    public static let COPY_SOURCE = "x-amz-copy-source"
    public static let COPY_SOURCE_IF_MATCH = "x-amz-copy-source-if-match"
    public static let COPY_SOURCE_IF_MODIFIED_SINCE = "x-amz-copy-source-if-modified-since"
    public static let COPY_SOURCE_IF_NONE_MATCH = "x-amz-copy-source-if-none-match"
    public static let COPY_SOURCE_IF_UNMODIFIED_SINCE = "x-amz-copy-source-if-unmodified-since"
    public static let COPY_SOURCE_RANGE = "x-amz-copy-source-range"
    public static let COPY_SOURCE_SSE_CUSTOMER_ALGORITHM = "x-amz-copy-source-server-side-encryption-customer-algorithm"
    public static let COPY_SOURCE_SSE_CUSTOMER_KEY = "x-amz-copy-source-server-side-encryption-customer-key"
    public static let COPY_SOURCE_SSE_CUSTOMER_KEY_MD5 = "x-amz-copy-source-server-side-encryption-customer-key-MD5"
    public static let METADATA_DIRECTIVE = "x-amz-metadata-directive"
    public static let TAGGING_DIRECTIVE = "x-amz-tagging-directive"
    public static let EXPECTED_SOURCE_BUCKET_OWNER = "x-amz-source-expected-bucket-owner"
    public static let RESTORE_OUTPUT_PATH = "x-amz-restore-output-path"
    public static let REQUEST_ROUTE = "x-amz-request-route"
    public static let REQUEST_TOKEN = "x-amz-request-token"
    public static let ABORT_DATE = "x-amz-abort-date"
    public static let ABORT_RULE_ID = "x-amz-abort-rule-id"

    // -----
    //
    // -----
    public static let QUERY_VERSION_ID = "versionId"
    public static let QUERY_DELIMITER = "delimiter"
    public static let QUERY_ENCODING_TYPE = "encoding-type"
    public static let QUERY_MARKER = "marker"
    public static let QUERY_KEY_MARKER = "key-marker"
    public static let QUERY_MAX_KEYS = "max-keys"
    public static let QUERY_PREFIX = "prefix"
    public static let QUERY_CONTINUATION_TOKEN = "continuation-token"
    public static let QUERY_FETCH_OWNER = "fetch-owner"
    public static let QUERY_START_AFTER = "start-after"
    public static let QUERY_ID = "id"
    public static let QUERY_PART_NUMBER = "partNumber"
    public static let QUERY_RESPONSE_CACHE_CONTROL = "response-cache-control"
    public static let QUERY_RESPONSE_CONTENT_DISPOSITION = "response-content-disposition"
    public static let QUERY_RESPONSE_CONTENT_ENCODING = "response-content-encoding"
    public static let QUERY_RESPONSE_CONTENT_LANGUAGE = "response-content-language"
    public static let QUERY_RESPONSE_CONTENT_TYPE = "response-content-type"
    public static let QUERY_RESPONSE_EXPIRES = "response-expires"
    public static let QUERY_VERSION_ID_MARKER = "version-id-marker"
    public static let QUERY_UPLOAD_ID = "uploadId"
    public static let QUERY_MAX_UPLOADS = "max-uploads"
    public static let QUERY_UPLOAD_ID_MARKER = "upload-id-marker"
    public static let QUERY_MAX_PARTS = "max-parts"
    public static let QUERY_PART_NUMBER_MARKER = "part-number-marker"
}
