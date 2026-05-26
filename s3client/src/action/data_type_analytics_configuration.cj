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

package s3client.action

/*
 *
 * @author: wangwb
 * @date: 2023-12-04
 */
public class AnalyticsConfiguration <: ToString {
    public AnalyticsConfiguration(
        public let id!: String,
        public let filter!: ?AnalyticsFilter = None,
        public let storageClassAnalysis!: StorageClassAnalysis
    ) {
    }

    public func toString(): String {
        return "AnalyticsConfiguration(id=${id}, filter=${filter}, storageClassAnalysis=${storageClassAnalysis})"
    }
}

public class AnalyticsFilter <: ToString {
    public AnalyticsFilter(
        public let prefix!: ?String = None,
        public let tag!: ?Tag = None,
        public let and!: ?AnalyticsAndOperator = None
    ) {
    }

    public func toString(): String {
        return "AnalyticsFilter(prefix=${prefix}, tag=${tag}, and=${and})"
    }
}

public class AnalyticsAndOperator <: ToString {
    public AnalyticsAndOperator(
        public let prefix!: ?String = None,
        public let tags!: ?ArrayList<Tag> = None
    ) {
    }

    public func toString(): String {
        return "AnalyticsAndOperator(prefix=${prefix}, tags=${tags})"
    }
}

public class StorageClassAnalysis <: ToString {
    public StorageClassAnalysis(public let dataExport!: StorageClassAnalysisDataExport) {
    }

    public func toString(): String {
        return "StorageClassAnalysis(dataExport=${dataExport})"
    }
}

public class StorageClassAnalysisDataExport <: ToString {
    public StorageClassAnalysisDataExport(
        public let outputSchemaVersion!: String,
        public let destination!: AnalyticsExportDestination
    ) {
    }

    public func toString(): String {
        return "StorageClassAnalysisDataExport(outputSchemaVersion=${outputSchemaVersion}, destination=${destination})"
    }
}

public class AnalyticsExportDestination <: ToString {
    public AnalyticsExportDestination(public let s3BucketDestination!: AnalyticsS3BucketDestination) {
    }

    public func toString(): String {
        return "AnalyticsExportDestination(s3BucketDestination=${s3BucketDestination})"
    }
}

public class AnalyticsS3BucketDestination <: ToString {
    public AnalyticsS3BucketDestination(
        public let bucket!: String,
        public let bucketAccountId!: ?String = None,
        public let format!: String,
        public let prefix!: ?String = None
    ) {
    }

    public func toString(): String {
        return "AnalyticsS3BucketDestination(format=${format}, bucketAccountId=${bucketAccountId}, bucket=${bucket}, prefix=${prefix})"
    }
}

// ------------
// 
// ------------

extend AnalyticsConfiguration <: S3XmlObject<AnalyticsConfiguration> {
    public static prop ELE_NAME: String {
        get() {
            "AnalyticsConfiguration"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let id = this.id.toXml("Id")
        let filter = this.filter?.toXml(AnalyticsFilter.ELE_NAME) ?? ""
        let storageClassAnalysis = this.storageClassAnalysis.toXml(StorageClassAnalysis.ELE_NAME)
        return "<${eleName} ${namespace(isRoot)}>${id}${filter}${storageClassAnalysis}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AnalyticsConfiguration {
        return AnalyticsConfiguration(
            id: ele.childContentRequired("Id"),
            filter: ele.child(AnalyticsFilter.ELE_NAME, AnalyticsFilter.fromXml),
            storageClassAnalysis: ele.childRequired(StorageClassAnalysis.ELE_NAME, StorageClassAnalysis.fromXml)
        )
    }
}

extend AnalyticsFilter <: S3XmlObject<AnalyticsFilter> {
    public static prop ELE_NAME: String {
        get() {
            "Filter"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tag = this.tag?.toXml(Tag.ELE_NAME) ?? ""
        let and = this.and?.toXml(AnalyticsAndOperator.ELE_NAME) ?? ""
        return "<${eleName}>${prefix}${tag}${and}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AnalyticsFilter {
        return AnalyticsFilter(
            prefix: ele.childContentRequired("Prefix"),
            tag: ele.child(Tag.ELE_NAME, Tag.fromXml),
            and: ele.child(AnalyticsAndOperator.ELE_NAME, AnalyticsAndOperator.fromXml)
        )
    }
}

extend AnalyticsAndOperator <: S3XmlObject<AnalyticsAndOperator> {
    public static prop ELE_NAME: String {
        get() {
            "And"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        let tags = match (this.tags) {
            case Some(v) => v |> map<Tag, String> {tag => tag.toXml(Tag.ELE_NAME)} |> collectString<String>()
            case None => ""
        }
        return "<${eleName}>${prefix}${tags}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AnalyticsAndOperator {
        return AnalyticsAndOperator(
            prefix: ele.childContent("Prefix"),
            tags: ele.childs(Tag.ELE_NAME, Tag.fromXml)
        )
    }
}

extend StorageClassAnalysis <: S3XmlObject<StorageClassAnalysis> {
    public static prop ELE_NAME: String {
        get() {
            "StorageClassAnalysis"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let dataExport = this.dataExport.toXml(StorageClassAnalysisDataExport.ELE_NAME)
        return "<${eleName}>${dataExport}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): StorageClassAnalysis {
        return StorageClassAnalysis(
            dataExport: ele.childRequired(
                StorageClassAnalysisDataExport.ELE_NAME,
                StorageClassAnalysisDataExport.fromXml
            )
        )
    }
}

extend StorageClassAnalysisDataExport <: S3XmlObject<StorageClassAnalysisDataExport> {
    public static prop ELE_NAME: String {
        get() {
            "DataExport"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let outputSchemaVersion = this.outputSchemaVersion.toXml("OutputSchemaVersion")
        let destination = "<Destination>${this.destination.s3BucketDestination.toXml(AnalyticsS3BucketDestination.ELE_NAME)}</Destination>"
        return "<${eleName}>${outputSchemaVersion}${destination}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): StorageClassAnalysisDataExport {
        return StorageClassAnalysisDataExport(
            outputSchemaVersion: ele.childContentRequired("OutputSchemaVersion"),
            destination: ele.childRequired(
                "Destination",
                {
                    child => AnalyticsExportDestination(
                        s3BucketDestination: child.childRequired(
                            AnalyticsS3BucketDestination.ELE_NAME,
                            AnalyticsS3BucketDestination.fromXml
                        )
                    )
                }
            )
        )
    }
}

extend AnalyticsS3BucketDestination <: S3XmlObject<AnalyticsS3BucketDestination> {
    public static prop ELE_NAME: String {
        get() {
            "S3BucketDestination"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let bucket = this.bucket.toXml("Bucket")
        let bucketAccountId = this.bucketAccountId?.toXml("BucketAccountId") ?? ""
        let format = this.format.toXml("Format")
        let prefix = this.prefix?.toXml("Prefix") ?? ""
        return "<${eleName}>${bucket}${bucketAccountId}${format}${prefix}</${eleName}>"
    }

    public static func fromXml(ele: S3XmlElement): AnalyticsS3BucketDestination {
        return AnalyticsS3BucketDestination(
            bucket: ele.childContentRequired("Bucket"),
            bucketAccountId: ele.childContent("BucketAccountId"),
            format: ele.childContentRequired("Format"),
            prefix: ele.childContent("Prefix")
        )
    }
}
