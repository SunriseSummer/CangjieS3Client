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
 * @date: 2023-12-15
 */
public class RestoreRequest <: ToString {
    public RestoreRequest(
        public let days!: ?Int32 = None,
        public let glacierJobParameters!: ?GlacierJobParameters = None,
        public let _type!: ?String = None,
        public let tier!: ?String = None,
        public let description!: ?String = None,
        public let selectParameters!: ?SelectParameters = None,
        public let outputLocation!: ?OutputLocation = None
    ) {
    }

    public func toString(): String {
        return "RestoreRequest(" +
            "days=${days}, glacierJobParameters=${glacierJobParameters}, _type=${_type}, tier=${tier}, " +
            "description=${description}, selectParameters=${selectParameters}, outputLocation=${outputLocation} " + ")"
    }
}

public class GlacierJobParameters <: ToString {
    public GlacierJobParameters(public let tier!: String) {
    }

    public func toString(): String {
        return "GlacierJobParameters(tier=${tier})"
    }
}

public class SelectParameters <: ToString {
    public SelectParameters(
        public let inputSerialization!: InputSerialization,
        public let expressionType!: String,
        public let expression!: String,
        public let outputSerialization!: OutputSerialization
    ) {
    }

    public func toString(): String {
        return "SelectParameters(" +
            "inputSerialization=${inputSerialization}, expressionType=${expressionType}, expression=${expression}, outputSerialization=${outputSerialization}" +
            ")"
    }
}

public class InputSerialization <: ToString {
    public InputSerialization(
        public let csv!: ?CSVInput = None,
        public let compressionType!: ?String = None,
        public let json!: ?JSONInput = None,
        public let parquet!: ?ParquetInput = None
    ) {
    }

    public func toString(): String {
        return "InputSerialization(" + //
            "csv=${csv}, compressionType=${compressionType}, json=${json}, parquet=${parquet}" +
            ")"
    }
}

public class CSVInput <: ToString {
    public CSVInput(
        public let fileHeaderInfo!: ?String = None,
        public let comments!: ?String = None,
        public let quoteEscapeCharacter!: ?String = None,
        public let recordDelimiter!: ?String = None,
        public let fieldDelimiter!: ?String = None,
        public let quoteCharacter!: ?String = None,
        public let allowQuotedRecordDelimiter!: ?Bool = None
    ) {
    }

    public func toString(): String {
        return "CSVInput(" + //
            "fileHeaderInfo=${fileHeaderInfo}, comments=${comments}, quoteEscapeCharacter=${quoteEscapeCharacter}, recordDelimiter=${recordDelimiter}, " +
            "fieldDelimiter=${fieldDelimiter}, quoteCharacter=${quoteCharacter}, allowQuotedRecordDelimiter=${allowQuotedRecordDelimiter}" +
            ")"
    }
}

public class JSONInput <: ToString {
    public JSONInput(public let _type!: ?String = None) {
    }

    public func toString(): String {
        return "JSONInput(_type=${_type})"
    }
}

public class ParquetInput <: ToString {
    public ParquetInput() {
    }

    public func toString(): String {
        return "ParquetInput()"
    }
}

public class OutputSerialization <: ToString {
    public OutputSerialization(
        public let csv!: ?CSVOutput = None,
        public let json!: ?JSONOutput = None
    ) {
    }

    public func toString(): String {
        return "OutputSerialization(csv=${csv}, json=${json})"
    }
}

public class CSVOutput <: ToString {
    public CSVOutput(
        public let quoteFields!: ?String = None,
        public let quoteEscapeCharacter!: ?String = None,
        public let recordDelimiter!: ?String = None,
        public let fieldDelimiter!: ?String = None,
        public let quoteCharacter!: ?String = None
    ) {
    }

    public func toString(): String {
        return "CSVOutput(" + //
            "quoteFields=${quoteFields}, quoteEscapeCharacter=${quoteEscapeCharacter}, recordDelimiter=${recordDelimiter}, fieldDelimiter=${fieldDelimiter}, " +
            "quoteCharacter=${quoteCharacter}" + ")"
    }
}

public class JSONOutput <: ToString {
    public JSONOutput(public let recordDelimiter!: ?String = None) {
    }

    public func toString(): String {
        return "JSONOutput(recordDelimiter=${recordDelimiter})"
    }
}

public class OutputLocation <: ToString {
    public OutputLocation(public let s3!: ?S3Location = None) {
    }

    public func toString(): String {
        return "OutputLocation(s3=${s3})"
    }
}

public class S3Location <: ToString {
    public S3Location(
        public let bucketName!: String,
        public let prefix!: String,
        public let encryption!: ?Encryption = None,
        public let cannedACL!: ?String = None,
        public let accessControlList!: ?ArrayList<Grant> = None,
        public let tagging!: ?Tagging = None,
        public let userMetadata!: ?ArrayList<MetadataEntry> = None,
        public let storageClass!: ?String = None
    ) {
    }

    public func toString(): String {
        return "S3Location(" +
            "bucketName=${bucketName}, prefix=${prefix}, encryption=${encryption}, cannedACL=${cannedACL}, " +
            "accessControlList=${accessControlList}, tagging=${tagging}, userMetadata=${userMetadata}, storageClass=${storageClass}" +
            ")"
    }
}

public class Encryption <: ToString {
    public Encryption(
        public let encryptionType!: ?String = None,
        public let kmsKeyId!: ?String = None,
        public let kmsContext!: ?String = None
    ) {
    }

    public func toString(): String {
        return "Encryption(encryptionType=${encryptionType}, kmsKeyId=${kmsKeyId}, kmsContext=${kmsContext})"
    }
}

public class MetadataEntry <: ToString {
    public MetadataEntry(
        public let name!: ?String = None,
        public let value!: ?String = None
    ) {
    }

    public func toString(): String {
        return "MetadataEntry(name=${name}, value=${value})"
    }
}

// -----
//
// -----
extend RestoreRequest <: S3XmlObject<RestoreRequest> {
    public static prop ELE_NAME: String {
        get() {
            "RestoreRequest"
        }
    }

    public func toXml(eleName: String, isRoot: Bool): String {
        let days = this.days?.toString().toXml("Days") ?? ""
        let glacierJobParameters = this.glacierJobParameters?.toXml() ?? ""
        let _type = this._type?.toXml("Type") ?? ""
        let tier = this.tier?.toXml("Tier") ?? ""
        let description = this.description?.toXml("Description") ?? ""
        let selectParameters = this.selectParameters?.toXml() ?? ""
        let outputLocation = this.outputLocation?.toXml() ?? ""
        return "<${eleName} ${namespace(isRoot)}>${days}${glacierJobParameters}${_type}${tier}${description}" +
            "${selectParameters}${outputLocation}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): RestoreRequest {
        throw UnsupportedException()
    }
}

extend GlacierJobParameters <: S3XmlObject<GlacierJobParameters> {
    public static prop ELE_NAME: String {
        get() {
            "GlacierJobParameters"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let tier = this.tier.toXml("Tier")
        return "<${eleName}>${tier}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): GlacierJobParameters {
        throw UnsupportedException()
    }
}

extend SelectParameters <: S3XmlObject<SelectParameters> {
    public static prop ELE_NAME: String {
        get() {
            "SelectParameters"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let inputSerialization = this.inputSerialization.toXml()
        let expressionType = this.expressionType.toXml("ExpressionType")
        let expression = this.expression.toXml("Expression")
        let outputSerialization = this.outputSerialization.toXml()
        return "<${eleName}>${expression}${expressionType}${inputSerialization}${outputSerialization}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): SelectParameters {
        throw UnsupportedException()
    }
}

extend InputSerialization <: S3XmlObject<InputSerialization> {
    public static prop ELE_NAME: String {
        get() {
            "InputSerialization"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let csv = this.csv?.toXml() ?? ""
        let compressionType = this.compressionType?.toXml("CompressionType") ?? ""
        let json = this.json?.toXml() ?? ""
        let parquet = this.parquet?.toXml() ?? ""
        return "<${eleName}>${csv}${compressionType}${json}${parquet}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): InputSerialization {
        throw UnsupportedException()
    }
}

extend CSVInput <: S3XmlObject<CSVInput> {
    public static prop ELE_NAME: String {
        get() {
            "CSV"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let fileHeaderInfo = this.fileHeaderInfo?.toXml("FileHeaderInfo") ?? ""
        let comments = this.comments?.toXml("Comments") ?? ""
        let quoteEscapeCharacter = this.quoteEscapeCharacter?.toXml("QuoteEscapeCharacter") ?? ""
        let recordDelimiter = this.recordDelimiter?.toXml("RecordDelimiter") ?? ""
        let fieldDelimiter = this.fieldDelimiter?.toXml("FieldDelimiter") ?? ""
        let quoteCharacter = this.quoteCharacter?.toXml("QuoteCharacter") ?? ""
        let allowQuotedRecordDelimiter = this.quoteCharacter?.toString().toXml("AllowQuotedRecordDelimiter") ?? ""
        return "<${eleName}>${fileHeaderInfo}${comments}${quoteEscapeCharacter}" +
            "${recordDelimiter}${fieldDelimiter}${quoteCharacter}${allowQuotedRecordDelimiter}" + //
                "</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): CSVInput {
        throw UnsupportedException()
    }
}

extend JSONInput <: S3XmlObject<JSONInput> {
    public static prop ELE_NAME: String {
        get() {
            "JSON"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let _type = this._type?.toXml("Type") ?? ""
        return "<${eleName}>${_type}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): JSONInput {
        throw UnsupportedException()
    }
}

extend ParquetInput <: S3XmlObject<ParquetInput> {
    public static prop ELE_NAME: String {
        get() {
            "Parquet"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        return "<${eleName}></${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): ParquetInput {
        throw UnsupportedException()
    }
}

extend OutputSerialization <: S3XmlObject<OutputSerialization> {
    public static prop ELE_NAME: String {
        get() {
            "OutputSerialization"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let csv = this.csv?.toXml() ?? ""
        let json = this.json?.toXml() ?? ""
        return "<${eleName}>${csv}${json}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): OutputSerialization {
        throw UnsupportedException()
    }
}

extend CSVOutput <: S3XmlObject<CSVOutput> {
    public static prop ELE_NAME: String {
        get() {
            "CSV"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let quoteFields = this.quoteFields?.toXml("QuoteFields") ?? ""
        let quoteEscapeCharacter = this.quoteEscapeCharacter?.toXml("QuoteEscapeCharacter") ?? ""
        let recordDelimiter = this.recordDelimiter?.toXml("RecordDelimiter") ?? ""
        let fieldDelimiter = this.fieldDelimiter?.toXml("FieldDelimiter") ?? ""
        let quoteCharacter = this.quoteCharacter?.toXml("QuoteCharacter") ?? ""

        return "<${eleName}>${quoteFields}${quoteEscapeCharacter}${recordDelimiter}" +
            "${fieldDelimiter}${quoteCharacter}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): CSVOutput {
        throw UnsupportedException()
    }
}

extend JSONOutput <: S3XmlObject<JSONOutput> {
    public static prop ELE_NAME: String {
        get() {
            "JSON"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let recordDelimiter = this.recordDelimiter?.toXml("RecordDelimiter") ?? ""
        return "<${eleName}>${recordDelimiter}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): JSONOutput {
        throw UnsupportedException()
    }
}

extend OutputLocation <: S3XmlObject<OutputLocation> {
    public static prop ELE_NAME: String {
        get() {
            "OutputLocation"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let s3 = this.s3?.toXml(S3Location.ELE_NAME) ?? ""
        return "<${eleName}>${s3}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): OutputLocation {
        throw UnsupportedException()
    }
}

extend S3Location <: S3XmlObject<S3Location> {
    public static prop ELE_NAME: String {
        get() {
            "S3"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let bucketName = this.bucketName.toXml("BucketName")
        let prefix = this.bucketName.toXml("Prefix")
        let encryption = this.encryption?.toXml(Encryption.ELE_NAME) ?? ""
        let cannedACL = this.cannedACL?.toXml("CannedACL") ?? ""
        let accessControlList = match (this.accessControlList) {
            case Some(v) =>
                let grants = v |> map<Grant, String> {grant => grant.toXml(Grant.ELE_NAME)} |> collectString<String>()
                "<AccessControlList>${grants}</AccessControlList>"
            case None => ""
        }
        let tagging = this.tagging?.toXml(Tagging.ELE_NAME) ?? ""
        let userMetadata = match (this.userMetadata) {
            case Some(v) =>
                let entrys = v |> map<MetadataEntry, String> {entry => entry.toXml(MetadataEntry.ELE_NAME)} |>
                    collectString<String>()
                "<UserMetadata>${entrys}</UserMetadata>"
            case None => ""
        }
        let storageClass = this.storageClass?.toXml("StorageClass") ?? ""

        return "<${eleName}>${bucketName}${prefix}${encryption}${cannedACL}" +
            "${accessControlList}${tagging}${userMetadata}${storageClass}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): S3Location {
        throw UnsupportedException()
    }
}

extend Encryption <: S3XmlObject<Encryption> {
    public static prop ELE_NAME: String {
        get() {
            "Encryption"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let encryptionType = this.encryptionType?.toXml("EncryptionType") ?? ""
        let kmsKeyId = this.kmsKeyId?.toXml("KMSKeyId") ?? ""
        let kmsContext = this.kmsContext?.toXml("KMSContext") ?? ""
        return "<${eleName}>${encryptionType}${kmsKeyId}${kmsContext}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): Encryption {
        throw UnsupportedException()
    }
}

extend MetadataEntry <: S3XmlObject<MetadataEntry> {
    public static prop ELE_NAME: String {
        get() {
            "MetadataEntry"
        }
    }

    public func toXml(eleName: String, _: Bool): String {
        let name = this.name?.toXml("Name") ?? ""
        let value = this.value?.toXml("Value") ?? ""
        return "<${eleName}>${name}${value}</${eleName}>"
    }

    public static func fromXml(_: S3XmlElement): MetadataEntry {
        throw UnsupportedException()
    }
}
