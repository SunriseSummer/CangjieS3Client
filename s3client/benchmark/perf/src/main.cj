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

package benchmark_perf

import std.collection.{Map, HashMap, ArrayList, LinkedList, forEach, collectString, collectArrayList, map}
import std.time.{DateTime, TimeZone}
import std.sync.{AtomicBool, AtomicInt64, Barrier, SyncCounter}
import std.argopt.ArgOpt
import std.process.Process
import std.convert.*
import s3client.*
import s3client.action.*
import s3client.core.*

/*
 *
 * @author: wangwb
 * @date: 2024-04-25
 */
main(): Int64 {

    // 参数处理
    let argOpt = ArgOpt(Process.current.arguments, "", //
        ["endpoint=", "accessKeyId=", "secretAccessKey=", "connections=", "threads=", "loopCount="])
    let endpoint = argOpt.getArg("endpoint").getOrDefault({=> "http://127.0.0.1:9000"})
    let accessKeyId = argOpt.getArg("accessKeyId").getOrThrow({=> NoneValueException("Missing accessKeyId")})
    let secretAccessKey = argOpt
        .getArg("secretAccessKey")
        .getOrThrow({=> NoneValueException("Missing secretAccessKey")})
    let connections = Int64.parse(argOpt.getArg("connections").getOrDefault({=> "100"}))
    let threads = Int64.parse(argOpt.getArg("threads").getOrDefault({=> "100"}))
    let loopCount = Int64.parse(argOpt.getArg("loopCount").getOrDefault({=> "1000"}))

    println(
        "Running with: --endpoint=${endpoint} --accessKeyId=${accessKeyId} --secretAccessKey=${secretAccessKey} --connections=${connections} --threads=${threads} --loopCount=${loopCount}")

    // 构建client
    let httpClient = DefaultS3HttpClient.builder() //
        .setMaxPerHost(connections) // 
        .build()

    let s3 = S3Client
        .builder() //
        .endpoint(endpoint) //
        .credentials(accessKeyId, secretAccessKey) //
        .forcePathStyle(true) //
        .httpClient(httpClient) //
        .build()

    let bucket = "bucket-01"
    try {
        s3.headBucket(HeadBucketRequest(bucket: bucket))
    } catch (ex: Exception) {
        // println(ex)
        s3.createBucket(CreateBucketRequest(bucket: bucket))
    }

    let barrier = Barrier(threads + 1)
    let countDown = SyncCounter(threads)
    let loopIdGen = AtomicInt64(0)

    func run(threadId: Int64): (Int64 /*完成的迭代数*/ , Duration /*耗时*/ ) {
        barrier.wait()
        println("    Begin thread: ${threadId}")
        let beginTime = DateTime.nowUTC()
        var finishedLoops = 0
        for (i in 0..loopCount) {
            let loopId = loopIdGen.fetchAdd(1)
            let objectId = loopId.toString()
            let str = "线程Id[${threadId}], 迭代Id[${loopId}]: 测试数据"
            try {
                s3.putObject(
                    PutObjectRequest(
                        bucket: bucket,
                        key: objectId
                    ),
                    S3Content.fromString(str)
                )

                let getStr = s3.getObject(
                    GetObjectRequest(
                        bucket: bucket,
                        key: objectId
                    )
                )[1].toStringUtf8()
                if (str != getStr) {
                    throw Exception("Expectd [${str}], actual [${getStr}]")
                }

                s3.deleteObject(
                    DeleteObjectRequest(
                        bucket: bucket,
                        key: objectId
                    )
                )

                finishedLoops += 1
            } catch (ex: Exception) {
                println("ThreadId [${threadId}], loopId [${loopId}]: ${ex}")
                break
            }
        }

        countDown.dec()
        let duration = DateTime.nowUTC() - beginTime
        println("    End thread: ${threadId} => FinishedLoops: ${finishedLoops}, Duration: ${duration}")
        (finishedLoops, duration)
    }

    let futures = ArrayList<Future<(Int64, Duration)>>()
    for (i in 0..threads) {
        let future = spawn {
            => run(i)
        }
        futures.add(future)
    }

    let beginTime = DateTime.nowUTC()
    println("Begin test")
    barrier.wait()
    countDown.waitUntilZero()
    if (countDown.count != 0) {
        println("Why?? finishedThreads.count != 0")
        return -1
    }
    println("End test")
    let duration = DateTime.nowUTC() - beginTime
    var finishedLoops = 0
    for (future in futures) {
        let result = future.get()
        finishedLoops += result[0]
    }
    println("FinishedLoops: ${finishedLoops}, Duration: ${duration}")
    return 0
}
