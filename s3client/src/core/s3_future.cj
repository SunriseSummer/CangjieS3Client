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
 * @date: 2023-12-20
 */
public class S3Future<V> {
    private static let LOGGER = S3LoggerFactory.getLogger("s3client.S3Future")

    public static func sync<V1>(fn: () -> V1): S3Future<V1> {
        let sync_result: (?V1, ?Exception, ?S3RequestContext) = try {
            // 注意: 要求在 fn() 里不能清空 S3RequestContext, 否则这里 S3RequestContext.current() 会为 none
            // TODO: 未经测试, 不确定程序里对 S3RequestContext.current() 的处理是否有问题 (因为没有地方调用过 S3RequestContext.current().clear())
            // 如果是协程, 使用完自动销毁, 按理是会自动清空 S3RequestContext 里的 ThreadLocal
            // https://e.gitee.com/HW-PLLab-pro/dashboard?issue=I5D6JW (说有个inner thread池, 可能是Cangjie的内部实现)
            // https://e.gitee.com/HW-PLLab-pro/dashboard?issue=I59SLV (说像协程, 不用关心线程池)
            (fn(), None, S3RequestContext.current())
        } catch (ex: Exception) {
            (None, ex, S3RequestContext.current())
        }
        return S3Future<V1>(sync_result: sync_result)
    }

    public static func async<V1>(fn: () -> V1): S3Future<V1> {
        let async_future: Future<(?V1, ?Exception, ?S3RequestContext)> = spawn {
            => try {
                (fn(), None, S3RequestContext.current())
            } catch (ex: Exception) {
                (None, ex, S3RequestContext.current())
            }
        }
        return S3Future<V1>(async_future: async_future)
    }

    public static func getResultOrThrow<V1>(result: ?V1, ex: ?Exception): V1 {
        return match (result) {
            case Some(v) => (v as V1).getOrThrow({=> IllegalArgumentException("Cast result to expected type failed")})
            case None => throw ex.getOrThrow({=> IllegalArgumentException("There were neither result nor exception")})
        }
    }

    private let sync_result: ?(?V, ?Exception, ?S3RequestContext)
    private let async_future: ?Future<(?V, ?Exception, ?S3RequestContext)>

    init(
        sync_result!: ?(?V, ?Exception, ?S3RequestContext) = None,
        async_future!: ?Future<(?V, ?Exception, ?S3RequestContext)> = None
    ) {
        this.sync_result = sync_result
        this.async_future = async_future
    }

    public func cancel(): Unit {
        match (async_future) {
            // 异步调用才有可能取消
            case Some(future) => future.cancel()
            case None => ()
        }
    }

    public func getResultTuple(ns: Int64): ?(?V, ?Exception, ?S3RequestContext) {
        if (sync_result.isSome()) {
            // 同步调用
            return sync_result
        } else {
            // 异步调用
            if (ns < 0) {
                return async_future.getOrThrow().get()
            } else if (ns == 0) {
                return async_future.getOrThrow().tryGet()
            } else {
                return async_future.getOrThrow().get(Duration.nanosecond * ns)
            }
        }
    }

    public func get(ns: Int64): ?V {
        let resultTuple = getResultTuple(ns) // resultTuple = ?(?result, ?exception, ?context)
        return match (resultTuple) {
            case Some(v) => getResultOrThrow<V>(v[0], v[1])
            case None => None // 还没有结果
        }
    }

    public func get(): V {
        return get(-1).getOrThrow()
    }

    public func tryGet(): ?V {
        return get(0)
    }

    public func then<V2>(fn: (V) -> V2): S3Future<V2> {
        sync(wrap(fn))
    }

    public func then<V2>(fn: (?V, ?Exception) -> V2): S3Future<V2> {
        sync(wrap(fn))
    }

    public func thenAsync<V2>(fn: (V) -> V2): S3Future<V2> {
        async(wrap(fn))
    }

    public func thenAsync<V2>(fn: (?V, ?Exception) -> V2): S3Future<V2> {
        async(wrap(fn))
    }

    private func wrap<V2>(fn: (V) -> V2): () -> V2 {
        return {
            =>
            var isFnError: Bool = false
            try {
                let resultTuple = getResultTuple(-1).getOrThrow()
                S3RequestContext.bind(resultTuple[2])
                let result = getResultOrThrow<V>(resultTuple[0], resultTuple[1])
                isFnError = true
                fn(result)
            } catch (ex: Exception) {
                if (isFnError) {
                    // 说明是 fn() 发生的异常, 需要记录日志
                    // 非 fn 的异常, 都认为上一步操作发生的异常, 不需要记录日志, 只需要抛出
                    LOGGER.error(ex)
                }
                throw ex
            }
        }
    }

    private func wrap<V2>(fn: (?V, ?Exception) -> V2): () -> V2 {
        return {
            =>
            var isFnError: Bool = false
            try {
                let resultTuple = getResultTuple(-1).getOrThrow()
                S3RequestContext.bind(resultTuple[2])
                let result = getResultOrThrow(resultTuple[0], resultTuple[1])
                isFnError = true
                fn(result, None)
            } catch (ex: Exception) {
                if (isFnError) {
                    // 说明是 fn() 发生的异常, fn() 发生的异常不应再被 fn() 处理
                    // 需要记录日志
                    LOGGER.error(ex)
                    throw ex
                } else {
                    // 说明是 getResult 发生的异常, 就当作上一步操作发生的异常处理
                    fn(None, ex)
                }
            }
        }
    }
}
