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

package s3client.util

/*
 *
 * @author: wangwb
 * @date: 2023-10-31
 */
public class IOUtils {
    private static let BUFFER_SIZE = 4096
    public static let LINE_SEPARATOR = {
        =>
        let bas = ByteBuffer(2)
        let sw = StringWriter(bas)
        sw.writeln()
        sw.flush()
        return String.fromUtf8(bas.bytes())
    }()

    public static func copyToBytes(input: InputStream): Array<Byte> {
        let output = ByteBuffer()
        copyToStream(input, output)
        return output.bytes()
    }

    public static func copyToString(input: InputStream): String {
        match (input as ByteBuffer) {
            case Some(bas) => return String.fromUtf8(bas.bytes())
            case None => ()
        }
        let output = ByteBuffer()
        copyToStream(input, output)
        return String.fromUtf8(output.bytes())
    }

    public static func copyToStream(input: InputStream, output: OutputStream): Int64 {
        let size = readAndDo(input, {bytes => output.write(bytes)})
        output.flush()
        return size
    }

    public static func readAndDo(input: InputStream, action: (Array<Byte>) -> Unit): Int64 {
        var size = 0
        let buffer = Array<Byte>(BUFFER_SIZE, repeat: 0)
        var read = 0
        do {
            read = input.read(buffer)
            action(buffer.slice(0, read))
            size += read
        } while (read != 0)
        return size
    }

    public static func readLines(input: InputStream): ArrayList<String> {
        let lines = ArrayList<String>()
        let reader = StringReader(input)
        while (true) {
            let line = reader.readln()
            match (line) {
                case Some(v) => lines.add(v)
                case None => break
            }
        }
        return lines
    }
}
