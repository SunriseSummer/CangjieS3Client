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
 * @date: 2024-01-10
 */
public class S3Retryer<V> {
    let maxAttempts: Int32 // <=0 最多只尝试一次调用
    let timeout: Duration // <=0 没有超时限制
    let retryPolicy: (S3RetryAttempt<V>) -> Bool
    let backoffPolicy: (S3RetryAttempt<V>) -> Duration

    public static func zero(): S3Retryer<V> {
        // 0 次重试, 即最多只尝试一次调用
        return builder().maxAttempts(1).build()
    }

    // TODO 可以搞个Exponential的backoff
    /*
       https://www.celerycn.io/yong-hu-zhi-nan/ren-wu-tasks/zhong-shi-retrying

       Task.retry_backoff
       一个布尔值或一个数字。如果将此选项设置为True，则自动重试将按照 exponential backoff 规则延迟。
       第一次重试延迟 1 秒，第二次重试延迟 2 秒，第三次延迟 4 秒，第四次延迟 8 秒，以此类推。
       （如果启用了 retry_jitter 会修改延迟值）。
       如果该选项设置为数字，则作为延迟因子，例如，该选项设置为 3，那么第一次重试将延迟 3 秒，第二次将延迟 6 秒，
       第三次延迟 12 秒，第四次延迟 24秒，以此类推。
       默认情况下，该选项设置为 False，自动重试不会延迟。

       Task.retry_backoff_max
       一个数字，如果启动了 retry_backoff，该选项在任务自动重试之间设置以秒为单位的最大延迟。
       默认情况，该选项默认值为 600，即 10分钟。
     */
    //
    //
    //

    public static func builder(): S3RetryerBuilder<V> {
        return S3RetryerBuilder<V>()
    }

    public func mutate(): S3RetryerBuilder<V> {
        return S3RetryerBuilder<V>(this)
    }

    init(builder: S3RetryerBuilder<V>) {
        this.maxAttempts = builder._maxAttempts
        this.timeout = builder._timeout
        this.retryPolicy = builder._retryPolicy
        this.backoffPolicy = builder._backoffPolicy
    }

    public func call(fn: () -> V): V {
        return call({_ => fn()}).getResultOrThrow()
    }

    public func call(fn: (S3RetryAttempt<V>) -> V): S3RetryAttempt<V> {
        return attemptCall(S3RetryAttempt<V>(maxAttempts: maxAttempts, timeout: timeout), fn)
    }

    private func attemptCall(attempt: S3RetryAttempt<V>, fn: (S3RetryAttempt<V>) -> V): S3RetryAttempt<V> {
        // 传入的是没有执行结果的attempt, 返回的是带执行结果的attempt
        let attemptWithResult = try {
            attempt.withResult(fn(attempt))
        } catch (ex: Exception) {
            attempt.withException(ex)
        }
        if (attempt.attempts < attempt.maxAttempts && retryPolicy(attemptWithResult)) {
            // 防止 retryPolicy 里没有判断 maxAttempts
            // 其实 maxAttempts 和 timeout 都可以在 retryPolicy 里处理掉
            let delay = backoffPolicy(attemptWithResult)
            sleep(delay)
            if (attempt.timeout > Duration.Zero && (DateTime.nowUTC() - attempt.firstAttemptTime) > attempt.timeout) {
                return attempt.withException(
                    ApiCallAttemptTimeoutException(
                        "retryer timeout: ${attempt.timeout}, actual duration: ${DateTime.nowUTC() - attempt.firstAttemptTime}") //
                        )
            }
            return attemptCall(attempt.nextAttempt(delay), fn)
        } else {
            return attemptWithResult
        }
    }

    // public func callAsync(action: () -> V): S3Future<V> {
    //     return attemptAsync(DateTime.nowUTC(), 0, action).thenAsync<V>() {attempt => attempt.getOrThrow()}
    // }

    // private func attemptAsync(firstAttemptTime: DateTime, attemptNumber: Int32, action: () -> V): S3Future<S3RetryAttempt<V>> {
    //     let future = S3Future<V>.async(action).thenAsync<S3RetryAttempt<V>> {
    //         result, ex =>
    //         let attempt = S3RetryAttempt<V>(
    //             result: result,
    //             ex: ex,
    //             firstAttemptTime: firstAttemptTime,
    //             attemptNumber: attemptNumber
    //         )
    //         if (!stopStrategy(attempt)) {
    //             sleep(waitStrategy(attempt))
    //             return attemptAsync(firstAttemptTime, attemptNumber + 1, action).get()
    //         }
    //         return attempt
    //     }
    //     return future
    // }
}

public class S3RetryerBuilder<V> {
    var _maxAttempts: Int32 = 1
    var _retryPolicy: (S3RetryAttempt<V>) -> Bool = {
        attempt => attempt.ex.isSome() && attempt.attempts < attempt.maxAttempts
    }
    var _backoffPolicy: (S3RetryAttempt<V>) -> Duration = {
        _ => return Duration.second * 1
    }
    var _timeout = Duration.Zero

    init() {
    }

    init(retryer: S3Retryer<V>) {
        this._maxAttempts = retryer.maxAttempts
        this._timeout = retryer.timeout
        this._retryPolicy = retryer.retryPolicy
        this._backoffPolicy = retryer.backoffPolicy
    }

    public func build(): S3Retryer<V> {
        return S3Retryer<V>(this)
    }

    public func maxAttempts(maxAttempts: Int32): S3RetryerBuilder<V> {
        this._maxAttempts = maxAttempts
        return this
    }

    public func retryPolicy(fn: (S3RetryAttempt<V>) -> Bool): S3RetryerBuilder<V> {
        this._retryPolicy = fn
        return this
    }

    public func backoffPolicy(fn: (S3RetryAttempt<V>) -> Duration): S3RetryerBuilder<V> {
        this._backoffPolicy = fn
        return this
    }

    public func timeout(timeout: Duration): S3RetryerBuilder<V> {
        this._timeout = timeout
        return this
    }
}

public class S3RetryAttempt<V> <: ToString {
    public let maxAttempts: Int32 // 最大尝试次数
    public let timeout: Duration // 超时时间, <=0 没有超时
    public let firstAttemptTime: DateTime // 第1次尝试的时间
    public let attempts: Int32 // 第N次尝试, 从1开始
    public let backoffDelay: Duration // 第N-1次到N次尝试之间的延迟时间
    public let result: ?V // 第N次尝试的结果
    public let ex: ?Exception // 第N次尝试的异常

    init(
        maxAttempts!: Int32,
        timeout!: Duration,
        firstAttemptTime!: DateTime = DateTime.nowUTC(),
        attempts!: Int32 = 1,
        backoffDelay!: Duration = Duration.Zero,
        result!: ?V = None,
        ex!: ?Exception = None
    ) {
        this.maxAttempts = maxAttempts
        this.timeout = timeout
        this.firstAttemptTime = firstAttemptTime
        this.attempts = attempts
        this.backoffDelay = backoffDelay
        this.result = result
        this.ex = ex
    }

    func nextAttempt(backoffDelay: Duration): S3RetryAttempt<V> {
        // 生成一个不带结果的attempt, 用于下一次尝试
        return S3RetryAttempt<V>(
            maxAttempts: this.maxAttempts,
            timeout: this.timeout,
            firstAttemptTime: this.firstAttemptTime,
            attempts: this.attempts + 1,
            backoffDelay: backoffDelay
        )
    }

    func withResult(result: V): S3RetryAttempt<V> {
        return S3RetryAttempt<V>(
            maxAttempts: this.maxAttempts,
            timeout: this.timeout,
            firstAttemptTime: this.firstAttemptTime,
            attempts: this.attempts,
            result: result
        )
    }

    func withException(ex: Exception): S3RetryAttempt<V> {
        return S3RetryAttempt<V>(
            maxAttempts: this.maxAttempts,
            timeout: this.timeout,
            firstAttemptTime: this.firstAttemptTime,
            attempts: this.attempts,
            ex: ex
        )
    }

    public func getResultOrThrow(): V {
        return match (result) {
            case Some(v) => (v as V).getOrThrow({=> IllegalArgumentException("Cast result to expected type failed")})
            case None => throw ex.getOrThrow({=> IllegalArgumentException("There were neither result nor exception")})
        }
    }

    public func toString(): String {
        return "S3RetryAttempt(" +
            "maxAttempts=${maxAttempts}, timeout=${timeout}, firstAttemptTime=${firstAttemptTime}, attempts=${attempts}, " +
            "backoffDelay=${backoffDelay}, withResult=${result.isSome()}, withException=${ex.isSome()}" + //
                ")"
    }
}
