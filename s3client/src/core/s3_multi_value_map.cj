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
 * @date: 2023-11-17
 */
public interface S3MultiValueMap<K, V> <: ToString & Collection<(K, Collection<V>)> //
    where K <: ToString & Hashable & Comparable<K> & Equatable<K>,
    V <: ToString {
    func keys(): Collection<K>
    func getFirst(key: K): Option<V>
    func get(key: K): Collection<V>
    func contains(key: K): Bool
    func add(key: K, value: V): Unit
    func addAll(key: K, values: Collection<V>): Unit
    func set(key: K, value: V): Unit
    func setAll(key: K, values: Collection<V>): Unit
    func remove(key: K): Unit
    func removeAll(keys: Collection<K>): Unit
    func clear(): Unit
    func clone(): S3MultiValueMap<K, V>

    static func create(): S3MultiValueMap<K, V> {
        return DefaultS3MultiValueMap<K, V>()
    }
}

class DefaultS3MultiValueMap<K, V> <: S3MultiValueMap<K, V> //
    where K <: ToString & Hashable & Comparable<K> & Equatable<K>,
    V <: ToString {
    private let kvs = HashMap<K, Collection<V>>()

    init() {
    }

    public prop size: Int64 {
        get() {
            kvs.size
        }
    }

    public func clone(): S3MultiValueMap<K, V> {
        let cloned = DefaultS3MultiValueMap<K, V>()
        for ((k, values) in this) {
            cloned.setAll(k, values)
        }
        return cloned
    }

    public func isEmpty(): Bool {
        return kvs.isEmpty()
    }

    public func iterator(): Iterator<(K, Collection<V>)> {
        return kvs.iterator()
    }

    public func keys(): Collection<K> {
        return kvs.keys()
    }

    public func getFirst(key: K): Option<V> {
        return match (kvs.get(key)) {
            case Some(values) =>
                let list = (values as ArrayList<V>).getOrThrow()
                if (list.size == 0) {
                    None
                } else {
                    list.get(0)
                }
            case None => None
        }
    }

    public func get(key: K): Collection<V> {
        return match (kvs.get(key)) {
            case Some(values) => values
            case None => ArrayList<V>()
        }
    }

    public func contains(key: K): Bool {
        return kvs.contains(key)
    }

    public func add(key: K, value: V): Unit {
        let values = createIfAbsent(key)
        values.add(value)
    }

    public func addAll(key: K, values: Collection<V>) {
        let existingValues = createIfAbsent(key)
        existingValues.add(all: values)
    }

    public func set(key: K, value: V): Unit {
        let values = ArrayList<V>()
        values.add(value)
        this.kvs.add(key, values)
    }

    public func setAll(key: K, values: Collection<V>): Unit {
        this.kvs.add(key, collectArrayList(values))
    }

    public func remove(key: K): Unit {
        this.kvs.remove(key)
    }

    public func removeAll(keys: Collection<K>): Unit {
        this.kvs.remove(all: keys)
    }

    public func clear(): Unit {
        this.kvs.clear()
    }

    private func createIfAbsent(key: K): ArrayList<V> {
        return match (kvs.get(key)) {
            case Some(values) => (values as ArrayList<V>).getOrThrow()
            case None =>
                let values = ArrayList<V>()
                kvs.add(key, values)
                values
        }
    }

    public func toString(): String {
        return ToStringUtils.mapToString(kvs)
        // var str = kvs |> //
        //     map<(K, Collection<V>), String> {kv => kv[0].toString() + ":" + ToStringUtils.listToString(kv[1])} |> //
        //     collectString<String>(delimiter: ", ")
        // return "{" + str + "}"
    }
}

// public class CaseInsensitiveString <: ToString & Hashable & Comparable<CaseInsensitiveString> & Equatable<CaseInsensitiveString> {
//     public let originalStr: String
//     private let lowerCaseStr: String

//     public init(str: String) {
//         this.originalStr = str
//         this.lowerCaseStr = StringUtils.toLowerCase(str)
//     }

//     public operator func ==(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr == rhs.lowerCaseStr
//     }

//     public operator func !=(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr != rhs.lowerCaseStr
//     }

//     public operator func <(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr < rhs.lowerCaseStr
//     }

//     public operator func <=(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr <= rhs.lowerCaseStr
//     }

//     public operator func >(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr > rhs.lowerCaseStr
//     }

//     public operator func >=(rhs: CaseInsensitiveString): Bool {
//         return this.lowerCaseStr >= rhs.lowerCaseStr
//     }

//     public func hashCode(): Int64 {
//         return lowerCaseStr.hashCode()
//     }

//     public func compare(other: CaseInsensitiveString): Ordering {
//         return this.lowerCaseStr.compare(other.lowerCaseStr)
//     }

//     public func toString(): String {
//         return "CaseInsensitiveString(${originalStr}:${lowerCaseStr})"
//     }
// }
