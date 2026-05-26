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
 * @date: 2024-01-04
 */
public interface S3MetricCollection <: ToString {
    prop name: String
    prop creationTime: DateTime
    func getRecords(): ArrayList<S3MetricRecord>
    func getChildren(): ArrayList<S3MetricCollection>
    func addRecord(metric: String, data: ToString): Unit
    func createChild(name: String): S3MetricCollection

    static prop EMPTY_COLLECTION: S3MetricCollection {
        get() {
            EmptyS3MetricCollection.INSTANCE
        }
    }
    static func create(name: String): S3MetricCollection {
        return DefaultS3MetricCollection(name)
    }
}

class DefaultS3MetricCollection <: S3MetricCollection {
    private let _name: String
    private let _metrics: Map<String, ArrayList<S3MetricRecord>>
    private let _children: ArrayList<S3MetricCollection>
    private let _creationTime: DateTime

    public init(name: String) {
        this._name = name
        this._creationTime = DateTime.nowUTC()
        this._metrics = HashMap<String, ArrayList<S3MetricRecord>>()
        this._children = ArrayList<S3MetricCollection>()
    }

    public prop name: String {
        get() {
            return _name
        }
    }

    public prop creationTime: DateTime {
        get() {
            return _creationTime
        }
    }

    public func getRecords(): ArrayList<S3MetricRecord> {
        let records = ArrayList<S3MetricRecord>()
        for (v in _metrics.values()) {
            records.add(all: v)
        }
        return records
    }

    public func getChildren(): ArrayList<S3MetricCollection> {
        return _children
    }

    public func addRecord(metric: String, data: ToString): Unit {
        var records = _metrics.get(metric).getOrDefault() {ArrayList<S3MetricRecord>()}
        if (records.size == 0) {
            _metrics.add(metric, records)
        }
        records.add(S3MetricRecord(metric, data))
    }

    public func createChild(name: String): S3MetricCollection {
        let child = DefaultS3MetricCollection(name)
        _children.add(child)
        return child
    }

    public func toString(): String {
        return "S3MetricCollection(name=${_name}, creationTime=${creationTime}, records=${ToStringUtils.listToString(getRecords())}, children=${ToStringUtils.listToString(_children)})"
    }
}

class EmptyS3MetricCollection <: S3MetricCollection {
    static let INSTANCE = EmptyS3MetricCollection()

    private let _creationTime = DateTime.nowUTC()
    private static let EMPTY_RECORDS = ArrayList<S3MetricRecord>(0)
    private static let EMPTY_COLLECTIONS = ArrayList<S3MetricCollection>(0)

    public prop name: String {
        get() {
            return "EmptyS3MetricCollection"
        }
    }

    public prop creationTime: DateTime {
        get() {
            return _creationTime
        }
    }

    public func getRecords(): ArrayList<S3MetricRecord> {
        return EMPTY_RECORDS
    }

    public func getChildren(): ArrayList<S3MetricCollection> {
        return EMPTY_COLLECTIONS
    }

    public func addRecord(_: String, _: ToString): Unit {
        return
    }

    public func createChild(_: String): S3MetricCollection {
        return this
    }

    public func toString(): String {
        return "EmptyS3MetricCollection()"
    }
}
