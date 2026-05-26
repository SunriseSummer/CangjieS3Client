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

import std.unittest.*
import std.unittest.testmacro.*

/*
 *
 * @author: wangwb
 * @date: 2024-01-12
 */

// DEPENDENCE: _config.cj _config.properties
// EXEC: cjc %import-path %L %l %f _config.cj _config.properties
// EXEC: ./main
main(): Int64 {
    let tester = PresignTest()
    let report = tester.asTestSuite().runTests()
    report.reportTo(ConsoleReporter())
    0
}

@Test
public class PresignTest {
    @TestCase
    public func testGetObject(): Unit {
        printTestCase("Presign_testGetObject")
        let getReq = GetObjectRequest(
            bucket: "cj-test1",
            key: "2"
        )
        let presignedGetReq = s3.presignGetObject(getReq, Duration.hour * 1)
        println(presignedGetReq)
    }
}
