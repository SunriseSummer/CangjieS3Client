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
 * @date: 2024-01-29
 */
public class S3RequestContext <: ToString {
    private static let TL = ThreadLocal<S3RequestContext>()

    public static func create(action: String): S3RequestContext {
        let context = S3RequestContext(action)
        TL.set(context)
        context
    }

    public static func clear(): ?S3RequestContext {
        let context = TL.get()
        TL.set(None)
        return context
    }

    public static func bind(context: ?S3RequestContext): ?S3RequestContext {
        // 用于跨线程时, 多个线程可以使用同一个上下文
        TL.set(context)
        return context
    }

    public static func current(): ?S3RequestContext {
        return TL.get()
    }

    public static func required(): S3RequestContext {
        return match (TL.get()) {
            case Some(context) => context
            case None => throw NoneValueException("Thread <${Thread.currentThread.id}> has not bound S3RequestContext")
        }
    }

    public let id: String // request id
    public let action: String // s3 action

    init(action: String) {
        this.id = IdUtils.id()
        this.action = action
    }

    public func toString(): String {
        return "S3RequestContext(id=${id}, action=${action})"
    }
}
