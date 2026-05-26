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
 * @date: 2023-11-10
 */
public open class S3ServiceException <: Exception {
    public let errorResponse: ErrorResponse

    public static func create(errorResponse: ErrorResponse): S3ServiceException {
        return match (errorResponse.errorDetails?.code ?? "") {
            case "NoSuchBucket" => NoSuchBucketException(errorResponse)
            case "BucketAlreadyExists" => BucketAlreadyExistsException(errorResponse)
            case "BucketAlreadyOwnedByYou" => BucketAlreadyOwnedByYouException(errorResponse)
            case "NoSuchKey" => NoSuchKeyException(errorResponse)
            case "NoSuchUpload" => NoSuchUploadException(errorResponse)
            case "InvalidObjectState" => InvalidObjectStateException(errorResponse)
            case "ObjectNotInActiveTierError" => ObjectNotInActiveTierErrorException(errorResponse)
            case "ObjectAlreadyInActiveTierError" => ObjectAlreadyInActiveTierErrorException(errorResponse)
            case _ => S3ServiceException(errorResponse)
        }
    }

    public static func is404(ex: ?Exception): Bool {
        if (ex.isNone()) {
            return false
        }
        match (ex.getOrThrow() as S3ServiceException) {
            case Some(s3Ex) =>
                if (s3Ex.errorResponse.statusCode == 404) {
                    return true
                }
                return false
            case None => return false
        }
    }

    public init(errorResponse: ErrorResponse) {
        this.errorResponse = errorResponse
    }

    public open prop message: String {
        get() {
            return errorResponse.errorDetails?.message ?? "${errorResponse}"
        }
    }

    public open prop statusCode: UInt16 {
        get() {
            return errorResponse.statusCode
        }
    }

    protected open func getClassName(): String {
        return "S3ServiceException"
    }
}

public class BucketAlreadyExistsException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "BucketAlreadyExistsException"
    }
}

public class BucketAlreadyOwnedByYouException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "BucketAlreadyOwnedByYouException"
    }
}

public class InvalidObjectStateException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "InvalidObjectStateException"
    }
}

public class NoSuchBucketException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "NoSuchBucketException"
    }
}

public class NoSuchKeyException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "NoSuchKeyException"
    }
}

public class NoSuchUploadException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "NoSuchUploadException"
    }
}

// https://e.gitee.com/HW-PLLab-pro/projects/268968/issues/list?issue=I901KC
// [CANGJIE] 0.49.2 已解决
// [CANGJIE] 0.48.2 类名以Object开头, 编译时会出现以下错误, 好像不影响运行
// [CANGJIE] 0.47.2 类名以Object开头, 编译时会出现以下错误
// error: Very incompatible object types: ObjectAlreadyInActiveTierErrorException vs S3ServiceException
public class ObjectAlreadyInActiveTierErrorException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "ObjectAlreadyInActiveTierErrorException"
    }
}

public class ObjectNotInActiveTierErrorException <: S3ServiceException {
    public init(errorResponse: ErrorResponse) {
        super(errorResponse)
    }

    protected func getClassName(): String {
        return "ObjectNotInActiveTierErrorException"
    }
}

public class ErrorResponse <: ToString {
    public let request: String // 请求的简单信息 "${Action} ${METHOD} ${URL}"
    public let requestId: String
    public let extendedRequestId: ?String
    public let statusCode: UInt16
    public let errorDetails: ?ErrorDetails

    public init(
        request!: String,
        requestId!: String,
        extendedRequestId!: ?String = None,
        statusCode!: UInt16 = 500,
        errorDetails!: ?ErrorDetails = None
    ) {
        this.request = request
        this.requestId = requestId
        this.extendedRequestId = extendedRequestId
        this.statusCode = statusCode
        this.errorDetails = errorDetails
    }

    public func toString(): String {
        return "ErrorResponse(" + //
            "request=${request}, requestId=${requestId}, extendedRequestId=${extendedRequestId}, statusCode=${statusCode}, " +
            "errorDetails=${errorDetails}" + //
                ")"
    }
}

public class ErrorDetails <: ToString {
    public let code: String
    public let message: String

    public init(
        code!: String,
        message!: String
    ) {
        this.code = code
        this.message = message
    }

    public func toString(): String {
        return "ErrorDetails(message=${message}, code=${code})"
    }
}
