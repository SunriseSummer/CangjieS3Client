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
 * @date: 2023-12-07
 */
public let NS_AWS_S3 = "http://s3.amazonaws.com/doc/2006-03-01/"

public interface S3XmlObject<T> {
    static prop ELE_NAME: String
    func toXml(eleName: String, isRoot: Bool): String
    static func fromXml(ele: S3XmlElement): T
    // -----
    func toXml(): String {
        return toXml(ELE_NAME, true)
    }

    func toXml(eleName: String): String {
        return toXml(eleName, true)
    }

    func namespace(isRoot: Bool): String {
        if (!isRoot) {
            return ""
        }
        return "xmlns=\"${NS_AWS_S3}\""
    }
}

// https://e.gitee.com/HW-PLLab-pro/dashboard?issue=I9FP7X
public class S3XmlElement <: ToString {
    /*
        cd /home/wangwb/cangjie/s3client4cj/test/LLT/benchmark
        cp /home/wangwb/cangjie/s3client4cj/target/release/s3client4cj/ 的 .so 文件
        cjc  --import-path /home/wangwb/cangjie/s3client4cj/target/release  -L /home/wangwb/cangjie/s3client4cj/target/release/s3client4cj -l s3client4cj_s3client.util -l s3client4cj_s3client.core -l s3client4cj_s3client -l s3client4cj_s3client.action -l -macro_s3client.macros  xml_parse_test.cj --test -O2
        ./main --bench
     */
    /*
    --------------------------------------------------------------------------------------------------
    TP: benchmark, time elapsed: 46218483444 ns, Result:
        TCS: XmlParseTest, time elapsed: 46218277087 ns, RESULT:
        | Case                   |   Median |         Err |   Err% |     Mean |
        |:-----------------------|---------:|------------:|-------:|---------:|
        | testS3XmlElement1_xml1 | 58.54 ms |   ±51.12 ms | ±87.3% | 60.77 ms |
        | testS3XmlElement2_xml1 | 9.506 ms |  ±0.0393 ms |  ±0.4% | 9.523 ms |
        | testStdDomParse_xml1   | 55.70 ms |   ±34.06 ms | ±61.1% | 54.74 ms |
        | testStdSaxParse_xml1   | 34.86 ms |   ±0.314 ms |  ±0.9% | 34.86 ms |
        | testS3XmlElement1_xml2 | 0.990 ms | ±0.00245 ms |  ±0.2% | 0.980 ms |
        | testS3XmlElement2_xml2 | 0.195 ms |  ±0.0008 ms |  ±0.4% | 0.201 ms |
        | testStdDomParse_xml2   | 1.035 ms | ±0.00353 ms |  ±0.3% | 1.030 ms |
        | testStdSaxParse_xml2   | 0.814 ms | ±0.00217 ms |  ±0.3% | 0.816 ms |
        Summary: TOTAL: 8
        PASSED: 8, SKIPPED: 0, ERROR: 0
        FAILED: 0
    --------------------------------------------------------------------------------------------------
     */
    // 使用 PARSER_SIMPLE (testS3XmlElement2_) 要比 PARSER_SAX (testS3XmlElement1_) 快一些
    public static let PARSER_SAX = 1
    public static let PARSER_SIMPLE = 2
    public static var DEFAULT_PARSER = PARSER_SIMPLE
    public static func fromXml(xml: String, parser!: ?Int64 = None): S3XmlElement {
        match (parser.getOrDefault({=> DEFAULT_PARSER})) {
            case 1 => SaxParser.parse(xml)
            case 2 => SimpleParser.parse(xml)
            case _ => SimpleParser.parse(xml)
        }
    }

    var _name: String = ""
    var _content: String = ""
    var _attrs: ?ArrayList<XmlAttr> = None
    var _childs: ?ArrayList<S3XmlElement> = None
    var _parent: ?S3XmlElement = None

    init() {
    }

    public prop name: String {
        get() {
            return _name
        }
    }

    public prop content: String {
        get() {
            return _content
        }
    }

    func addChild(child: S3XmlElement): Unit {
        child._parent = this
        match (_childs) {
            case Some(v) => v
            case None =>
                let v = ArrayList<S3XmlElement>(4)
                _childs = v
                v
        }.add(child)
    }

    func addAttr(name: String, value: String): Unit {
        match (_attrs) {
            case Some(v) => v
            case None =>
                let v = ArrayList<XmlAttr>(4)
                _attrs = v
                v
        }.add(XmlAttr(name, value))
    }

    public func toString(): String {
        let childsXml = _childs.getOrDefault({=> ArrayList<S3XmlElement>(0)}) |>
            map<S3XmlElement, String> {child => child.toString()} |> collectString<String>()
        let attrsXml = _attrs.getOrDefault({=> ArrayList<XmlAttr>(0)}) |>
            map<XmlAttr, String> {attr => attr.name + "=\"" + attr.content + "\""} |> collectString<(String)>(
            delimiter: " ")
        if (attrsXml != "") {
            return "<${_name} ${attrsXml}>${_content}${childsXml}</${_name}>"
        } else {
            return "<${_name}>${_content}${childsXml}</${_name}>"
        }
    }

    public func child(name: String): ?S3XmlElement {
        if (let Some(childs) <- _childs) {
            for (child in childs) {
                if (child._name == name) {
                    return child
                }
            }
        }
        return None
    }

    public func child<T>(name: String, action: (S3XmlElement) -> T): ?T {
        if (let Some(ele) <- child(name)) {
            return action(ele)
        }
        return None
    }

    public func childRequired(name: String): S3XmlElement {
        return child(name).getOrThrow() {=> NoneValueException("Missing element with name: ${name}")}
    }

    public func childRequired<T>(name: String, action: (S3XmlElement) -> T): T {
        return action(childRequired(name))
    }

    public func childContent(name: String): ?String {
        if (let Some(childs) <- _childs) {
            for (child in childs) {
                if (child._name == name) {
                    return child._content
                }
            }
        }
        return None
    }

    public func childContentRequired(name: String): String {
        return childContent(name).getOrThrow() {=> NoneValueException("Missing element with name: ${name}")}
    }

    private func childs(name: String): ArrayList<S3XmlElement> {
        let result = ArrayList<S3XmlElement>()
        if (let Some(childs) <- _childs) {
            for (child in childs) {
                if (child._name == name) {
                    result.add(child)
                }
            }
        }
        return result
    }

    public func childsContents(name: String): ArrayList<String> {
        let contents = ArrayList<String>()
        if (let Some(childs) <- _childs) {
            for (child in childs) {
                if (child._name == name) {
                    contents.add(child._content)
                }
            }
        }
        return contents
    }

    public func childs<T>(name: String, action: (S3XmlElement) -> T): ArrayList<T> {
        let result = ArrayList<T>()
        for (child in childs(name)) {
            result.add(action(child))
        }
        return result
    }

    public func attrContent(name: String): ?String {
        if (let Some(attrs) <- _attrs) {
            for (attr in attrs) {
                if (name == attr.name) {
                    return attr.content
                }
            }
        }
        return None
    }

    public func attrContentRequired(name: String): String {
        return attrContent(name).getOrThrow() {=> NoneValueException("Missing attribute with name: ${name}")}
    }
}

public class XmlAttr {
    public XmlAttr(
        public let name: String,
        public let content: String
    ) {
    }
}

class SaxParser {
    static func parse(_: String): S3XmlElement {
        throw UnsupportedException("The package 'stdx.encoding.xml.*' is removed from std lib since Cangjie 0.53.13")
    }
}

// 基本能处理 S3返回的xml
class SimpleParser {
    static func parse(xml: String): S3XmlElement {
        var root = S3XmlElement()
        var current = root

        let TOKEN_TYPE_UNKONWN = 0
        // let TOKEN_TYPE_DOCUMENT_START = 1
        // let TOKEN_TYPE_DOCUMENT_END = 2
        let TOKEN_TYPE_ELEMENET_START = 3
        let TOKEN_TYPE_ELEMENT_END = 4
        let TOKEN_TYPE_ATTR = 5
        // let TOKEN_TYPE_CHARACTERS = 6 // 要不要区分CDATA?
        // let TOKEN_TYPE_DECLARE = 100 
        // let TOKEN_TYPE_COMMENT = 101
        var tokenType = TOKEN_TYPE_UNKONWN
        var tokenBegin = 0
        var attrName = ""
        var attrValue = ""
        var quotes: Byte = 0 // b'\''; b'"'
        var pos = 0
        let len = xml.size
        while (pos < len) {
            let cb = xml[pos]
            pos++

            if (quotes != 0) {
                if (cb == quotes) {
                    // 属性值, 匹配到结束引号, 引号内字符暂不考虑转义处理
                    attrValue = xml[tokenBegin + 1..pos - 1]
                    current.addAttr(attrName, attrValue)
                    quotes = 0
                    tokenType = TOKEN_TYPE_ELEMENET_START
                    tokenBegin = pos
                }
            } else {
                match (cb) {
                    case b'<' =>
                        if (xml[pos] == b'?' && subsequent(xml, pos, "?xml")) {
                            // 声明: <?xml version="1.0" encoding="UTF-8"?>
                            pos = skip(xml, pos, "?>")
                        } else if (xml[pos] == b'!' && subsequent(xml, pos, "!--")) {
                            // 注释: <!-- -->
                            pos = skip(xml, pos, "-->")
                        } else if (xml[pos] == b'/') {
                            // 结束节点: </foo>
                            if ((current._childs?.size ?? 0) == 0) {
                                // 没有子节点的情况下, 才猜测前面可能有content
                                // 如果有子节点, 这种content基本就是换行以及缩进空格
                                current._content = unescape(xml[tokenBegin..pos - 1])
                            }
                            current = current._parent.getOrThrow()
                            pos = skip(xml, pos, ">")
                            tokenType = TOKEN_TYPE_ELEMENT_END
                        } else {
                            // 开始节点
                            let child = S3XmlElement()
                            current.addChild(child)
                            current = child
                            tokenType = TOKEN_TYPE_ELEMENET_START
                            tokenBegin = pos
                        }
                    case b'>' =>
                        if (tokenType == TOKEN_TYPE_ELEMENET_START) {
                            if (current._name == "") {
                                current._name = xml[tokenBegin..pos - 1]
                            }
                        }
                        tokenBegin = pos
                        tokenType = TOKEN_TYPE_UNKONWN // 加个闭合的token type??
                    case b'/' =>
                        if (xml[pos] == b'>') {
                            // 结束节点: <foo />
                            if (current._name == "") {
                                // 说明结束节点没有空格 <foo/>, 如果有空格, 就会走到 case ' ' 
                                current._name = xml[tokenBegin..pos - 2]
                            }
                            current = current._parent.getOrThrow()
                            tokenType = TOKEN_TYPE_ELEMENT_END
                            tokenBegin = pos
                        }
                    case b' ' =>
                        if (tokenType == TOKEN_TYPE_ELEMENET_START) {
                            // 开始节点带空格: <foo a="b", 或者<foo />
                            if (current._name == "") {
                                // 防止多属性会重复设置节点名称
                                current._name = xml[tokenBegin..pos - 1].trimAscii() //设置节点名, 可能是先换行, 再有空格
                            }
                            tokenBegin = pos
                        }
                    case b'=' =>
                        if (tokenType == TOKEN_TYPE_ELEMENET_START) {
                            tokenType = TOKEN_TYPE_ATTR
                            let next = xml[pos] // 可能会有空格
                            if (next == b'\'') {
                                quotes = next
                                attrName = xml[tokenBegin..pos - 1]
                                tokenBegin = pos
                                pos++
                            } else if (next == b'"') {
                                quotes = next
                                attrName = xml[tokenBegin..pos - 1]
                                tokenBegin = pos
                                pos++
                            }
                        }
                    case _ => ()
                }
            }
        }
        return root._childs.getOrThrow()[0]
    }

    private static func subsequent(xml: String, pos: Int64, excepted: String): Bool {
        for (i in 0..excepted.size) {
            if (xml[pos + i] != excepted[i]) {
                return false
            }
        }
        return true
    }

    private static func skip(xml: String, pos: Int64, excepted: String): Int64 {
        return match (xml.indexOf(excepted, pos)) {
            case Some(v) => v + excepted.size
            case None => -1
        }
    }

    /*
        ("&amp;", "&"),
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&quot;", "\""),
        ("&#39;", "'")
     */
    private static func unescape(xml: String): String {
        var pos = skip(xml, 0, "&")
        if (pos == -1) {
            return xml
        }
        var pos2 = skip(xml, pos, ";")
        if (pos2 == -1) {
            return xml
        }
        var newXml: StringBuilder = StringBuilder(xml.size)
        let len = xml.size
        var lastPos = 0
        do {
            newXml.append(xml[lastPos..pos - 1])

            let entity = xml[pos..pos2 - 1]
            let unescapeEntity = if (entity.startsWith("#")) { // Character Entity
                unescapeCharacterEntity(entity)
            } else { // Named Entity
                unescapeNamedEntity(entity)
            }
            newXml.append(unescapeEntity)

            lastPos = pos2
            pos = skip(xml, pos2, "&")
            if (pos != -1) {
                pos2 = skip(xml, pos, ";")
            }
        } while (pos < len && pos != -1 && pos2 != -1)

        newXml.append(xml[lastPos..xml.size])
        return newXml.toString()
    }

    private static func unescapeCharacterEntity(entity: String): String {
        // if (entity.startsWith("#x")) {
        //     return Integer.parseInt(entity.substring(2), 16);
        // } else if (entity.startsWith("#")) {
        //     return Integer.parseInt(entity.substring(1), 10);
        // } else {
        //     throw new NumberFormatException("Invalid character entity: " + entity);
        // }
        return "&#${entity};"
    }

    private static func unescapeNamedEntity(entity: String): String {
        match (entity) {
            case "amp" => return "&"
            case "lt" => return "<"
            case "gt" => return ">"
            case "quot" => return "\""
            case "apos" => return "'"
            case _ => "&${entity};"
        }
    }
}
