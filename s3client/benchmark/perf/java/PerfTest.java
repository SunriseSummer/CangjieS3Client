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

 package test;

 import java.net.URI;
 import java.util.ArrayList;
 import java.util.List;
 import java.util.concurrent.BrokenBarrierException;
 import java.util.concurrent.CountDownLatch;
 import java.util.concurrent.CyclicBarrier;
 import java.util.concurrent.Future;
 import java.util.concurrent.LinkedBlockingQueue;
 import java.util.concurrent.ThreadPoolExecutor;
 import java.util.concurrent.TimeUnit;
 import java.util.concurrent.atomic.AtomicInteger;
 
 import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
 import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
 import software.amazon.awssdk.core.ResponseInputStream;
 import software.amazon.awssdk.core.sync.RequestBody;
 import software.amazon.awssdk.regions.Region;
 import software.amazon.awssdk.services.s3.S3Client;
 import software.amazon.awssdk.services.s3.model.CreateBucketRequest;
 import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
 import software.amazon.awssdk.services.s3.model.GetObjectRequest;
 import software.amazon.awssdk.services.s3.model.GetObjectResponse;
 import software.amazon.awssdk.services.s3.model.HeadBucketRequest;
 import software.amazon.awssdk.services.s3.model.PutObjectRequest;
 import software.amazon.awssdk.utils.IoUtils;
 
 /**
  * TODO 此处填写 class 信息
  *
  * @author wangwb (mailto:wangwb@primeton.com)
  */
 
 public class PerfTest {
 
     private static final String ENDPOINT = "http://localhost:9000";
     private static final String ACCESS_KEY_ID = "1";
     private static final String SECRET_ACCESS_KEY = "1";
     private static final int THREADS = 100;
     private static final int LOOP_COUNT = 1000;
 
     private static S3Client S3 = S3Client.builder() //
             .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create(ACCESS_KEY_ID, SECRET_ACCESS_KEY))) //
             .region(Region.CN_NORTH_1) //
             .endpointOverride(URI.create(ENDPOINT)) //
             .forcePathStyle(true) //
             .build();
     private static final AtomicInteger LOOP_ID_GEN = new AtomicInteger(0);
     private static final ThreadPoolExecutor EXECUTOR = new ThreadPoolExecutor(THREADS, THREADS, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>());
     private static final String BUCKET = "bucket-02";
 
     public static void main(String[] args) throws InterruptedException, BrokenBarrierException {
         try {
             S3.headBucket(HeadBucketRequest.builder().bucket(BUCKET).build());
         } catch (Exception ex) {
             System.out.println(ex);
             S3.createBucket(CreateBucketRequest.builder().bucket(BUCKET).build());
         }
 
         CyclicBarrier barrier = new CyclicBarrier(THREADS + 1);
         CountDownLatch countDown = new CountDownLatch(THREADS);
 
         List<Future<RunResult>> futures = new ArrayList<Future<RunResult>>();
         for (int i = 0; i < THREADS; i++) {
             final int threadId = i;
             Future<RunResult> future = EXECUTOR.submit(() -> {
                 barrier.await();
                 System.out.println("    Begin thread: " + threadId);
                 try {
                     RunResult result = run(threadId);
                     System.out.println("    End thread: " + threadId + " => FinishedLoops: " + result.finishedLoops + ", Duration: " + result.duration);
                     return result;
                 } finally {
                     countDown.countDown();
                 }
             });
             futures.add(future);
         }
 
         long beginTime = System.currentTimeMillis();
         System.out.println("Begin test");
         barrier.await();
         countDown.await();
         System.out.println("End test");
         long duration = System.currentTimeMillis() - beginTime;
         int finishedLoops = 0;
         for (Future<RunResult> future : futures) {
             RunResult result;
             try {
                 result = future.get();
                 finishedLoops += result.finishedLoops;
             } catch (Throwable e) {
                 e.printStackTrace();
             }
         }
         System.out.println("FinishedLoops: " + finishedLoops + ", Duration: " + duration);
         EXECUTOR.shutdown();
         S3.close();
     }
 
     private static RunResult run(int threadId) {
         long beginTime = System.currentTimeMillis();
         int finishedLoops = 0;
         for (int i = 0; i < LOOP_COUNT; i++) {
             int reqId = LOOP_ID_GEN.getAndIncrement();
             String objectId = "" + reqId;
             String str = "线程Id[" + threadId + "], 迭代Id[" + reqId + "]: 测试数据";
             try {
                 S3.putObject(PutObjectRequest.builder().bucket(BUCKET).key(objectId).build(), RequestBody.fromString(str));
 
                 ResponseInputStream<GetObjectResponse> stream = S3.getObject(GetObjectRequest.builder().bucket(BUCKET).key(objectId).build());
                 String getStr = IoUtils.toUtf8String(stream);
                 if (!str.equals(getStr)) {
                     throw new RuntimeException("Expectd [" + str + "], actual [" + getStr + "]");
                 }
 
                 S3.deleteObject(DeleteObjectRequest.builder().bucket(BUCKET).key(objectId).build());
 
                 finishedLoops += 1;
             } catch (Exception ex) {
                 System.out.println("ThreadId [" + threadId + "], loopId [" + reqId + "]: " + ex);
                 break;
             }
         }
         return new RunResult(finishedLoops, System.currentTimeMillis() - beginTime);
     }
 
     private static class RunResult {
         public int finishedLoops;
         public long duration;
 
         public RunResult(int finishedLoops, long duration) {
             this.finishedLoops = finishedLoops;
             this.duration = duration;
         }
     }
 }
