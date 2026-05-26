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
 * @date: 2023-11-15
 */
public interface S3ConfigMap <: ToString {
    func get(key: String): ?Any

    func add(configMap: ?S3ConfigMap): S3ConfigMap {
        return match (configMap) {
            case Some(v) =>
                let list = ArrayList<S3ConfigMap>()
                list.add(this)
                list.add(v)
                CompositeConfigMap(list)
            case None => this
        }
    }

    // -----
    static func create(map: Map<String, Any>): S3ConfigMap {
        return ReadableConfigMap(map)
    }
}

class CompositeConfigMap <: S3ConfigMap {
    private let configMaps = ArrayList<S3ConfigMap>()

    public init(configMaps: ArrayList<S3ConfigMap>) {
        for (configMap in configMaps) {
            match (configMap as CompositeConfigMap) {
                case Some(v) => this.configMaps.add(all: v.configMaps)
                case None => this.configMaps.add(configMap)
            }
        }
    }

    public func get(key: String): ?Any {
        for (configMap in configMaps) {
            let v = configMap.get(key)
            if (v.isSome()) {
                return v
            }
        }
        return None
    }

    public func toString(): String {
        let str = configMaps |> map<S3ConfigMap, String> {
            configMap => "    " + configMap.toString()
        } |> collectString<(String)>(delimiter: ", " + IOUtils.LINE_SEPARATOR)
        return "[" + IOUtils.LINE_SEPARATOR + str + IOUtils.LINE_SEPARATOR + "]"
    }
}

class ReadableConfigMap <: S3ConfigMap {
    private let kvs = HashMap<String, Any>()

    public init(kvs: Map<String, Any>) {
        this.kvs.add(all: kvs)
    }

    public func get(key: String): ?Any {
        let value = kvs.get(key)
        return value
    }

    public func getAll(): Map<String, Any> {
        return kvs
    }

    public func toString(): String {
        return ToStringUtils.mapToString(kvs)
    }
}

public class S3ConfigKey<T> <: ToString {
    public let namespace: String
    public let name: String
    public let cast_fn: (Any) -> ?T
    public let qname: String

    public static func stringType(namespace: String, name: String): S3ConfigKey<String> {
        return S3ConfigKey<String>(namespace, name, {v => v as String})
    }

    public static func boolType(namespace: String, name: String): S3ConfigKey<Bool> {
        return S3ConfigKey<Bool>(namespace, name, {v => v as Bool})
    }

    public static func intType(namespace: String, name: String): S3ConfigKey<Int64> {
        return S3ConfigKey<Int>(namespace, name, {v => v as Int64})
    }

    public static func urlType(namespace: String, name: String): S3ConfigKey<URL> {
        return S3ConfigKey<URL>(namespace, name, {v => v as URL})
    }

    public static func durationType(namespace: String, name: String): S3ConfigKey<Duration> {
        return S3ConfigKey<Duration>(namespace, name, {v => v as Duration})
    }

    public init(namespace: String, name: String, cast_fn: (Any) -> ?T) {
        this.namespace = namespace
        this.name = name
        this.cast_fn = cast_fn
        this.qname = "${namespace}.${name}"
    }

    public func get(configMap: S3ConfigMap): ?T {
        match (configMap.get(this.qname)) {
            case Some(v) => this
                .cast_fn(v)
                .getOrThrow() {
                    IllegalArgumentException("Cast [${this}] to expected type failed")
                }
            case None => Option<T>.None
        }
    }

    public func getOrDefault(configMap: S3ConfigMap, defaultValue: T): T {
        return get(configMap).getOrDefault() {defaultValue}
    }

    public func getOrThrow(configMap: S3ConfigMap): T {
        get(configMap).getOrThrow() {NoneValueException("Not found the key: ${this}")}
    }

    public func toString(): String {
        return this.qname
    }
}
