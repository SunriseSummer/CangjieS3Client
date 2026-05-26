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

 import java.io.ByteArrayInputStream;
 import java.io.IOException;
 import java.util.HashMap;
 import java.util.Map;
 import java.util.concurrent.TimeUnit;
 
 import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
 import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
 import software.amazon.awssdk.http.AbortableInputStream;
 import software.amazon.awssdk.http.ExecutableHttpRequest;
 import software.amazon.awssdk.http.HttpExecuteRequest;
 import software.amazon.awssdk.http.HttpExecuteResponse;
 import software.amazon.awssdk.http.SdkHttpClient;
 import software.amazon.awssdk.http.SdkHttpResponse;
 import software.amazon.awssdk.regions.Region;
 import software.amazon.awssdk.services.s3.S3Client;
 import software.amazon.awssdk.services.s3.model.AccessControlPolicy;
 import software.amazon.awssdk.services.s3.model.GetObjectAclRequest;
 import software.amazon.awssdk.services.s3.model.GetObjectAclResponse;
 import software.amazon.awssdk.services.s3.model.Grant;
 import software.amazon.awssdk.services.s3.model.Grantee;
 import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
 import software.amazon.awssdk.services.s3.model.ListObjectsV2Response;
 import software.amazon.awssdk.services.s3.model.Owner;
 import software.amazon.awssdk.services.s3.model.PutObjectAclRequest;
 import software.amazon.awssdk.services.s3.model.PutObjectAclResponse;
 import software.amazon.awssdk.services.s3.paginators.ListObjectsV2Iterable;
 
 /**
  * TODO 此处填写 class 信息
  *
  * @author wangwb (mailto:wangwb@primeton.com)
  */
 
 public class SimpleTest {
 
     public static void main(String[] args) {
         testGetObjectAcl();
         testPutObjectAcl();
         testListObjectsV2Paginator();
     }
 
     private static int WARMUP = 10000;
     private static int LOOP_COUNT = 100;
 
     private static S3Client s3 = S3Client.builder() //
             .credentialsProvider(StaticCredentialsProvider.create(AwsBasicCredentials.create("1", "2"))) //
             .region(Region.CN_NORTH_1) //
             .httpClient(new MockHttpClient()) //
             .build();
 
     public static void testGetObjectAcl() {
         for (int i = 0; i < WARMUP; i++) {
             s3.getObjectAcl( //
                     GetObjectAclRequest.builder() //
                             .bucket("oldsix") //
                             .key("oldsix")//
                             .build() //
             );
         }
 
         long beginTime = System.nanoTime();
         for (int i = 0; i < LOOP_COUNT; i++) {
             GetObjectAclResponse rsp = s3.getObjectAcl( //
                     GetObjectAclRequest.builder() //
                             .bucket("oldsix") //
                             .key("oldsix") //
                             .build() //
             );
             // System.out.println(rsp.owner().id());
         }
         System.out.println("===== GetObjectAcl: " + TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - beginTime) + "ms");
     }
 
     public static void testPutObjectAcl() {
         for (int i = 0; i < WARMUP; i++) {
             AccessControlPolicy policy = AccessControlPolicy.builder() //
                     .owner(Owner.builder().id("1").build()) //
                     .grants(Grant.builder().permission("FULL_CONTROL").grantee(Grantee.builder().id("1").type("CanonicalUser").build()).build()) //
                     .build();
             s3.putObjectAcl( //
                     PutObjectAclRequest.builder() //
                             .bucket("oldsix") //
                             .key("oldsix") //
                             .accessControlPolicy(policy) //
                             .build() //
             );
         }
 
         long beginTime = System.nanoTime();
         for (int i = 0; i < LOOP_COUNT; i++) {
             AccessControlPolicy policy = AccessControlPolicy.builder() //
                     .owner(Owner.builder().id("1").build()) //
                     .grants(Grant.builder().permission("FULL_CONTROL").grantee(Grantee.builder().id("1").type("CanonicalUser").build()).build()) //
                     .build();
             PutObjectAclResponse rsp = s3.putObjectAcl( //
                     PutObjectAclRequest.builder() //
                             .bucket("oldsix") //
                             .key("oldsix") //
                             .accessControlPolicy(policy) //
                             .build() //
             );
             // System.out.println(rsp.requestCharged());
         }
         System.out.println("===== PutObjectAcl: " + TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - beginTime) + "ms");
     }
 
     public static void testListObjectsV2Paginator() {
         for (int i = 0; i < WARMUP; i++) {
             ListObjectsV2Iterable it = s3.listObjectsV2Paginator( //
                     ListObjectsV2Request.builder() //
                             .bucket("cj-test11") //
                             .build() //
             );
             // int count = it.stream().mapToInt(rsp -> rsp.contents().size()).sum();
             int count = 0;
             for (ListObjectsV2Response rsp : it) {
                 count += rsp.contents().size();
             }
         }
 
         long beginTime = System.nanoTime();
         for (int i = 0; i < LOOP_COUNT; i++) {
             ListObjectsV2Iterable it = s3.listObjectsV2Paginator( //
                     ListObjectsV2Request.builder() //
                             .bucket("cj-test11") //
                             .build() //
             );
             int count = 0;
             for (ListObjectsV2Response rsp : it) {
                 count += rsp.contents().size();
             }
         }
         System.out.println("===== ListObjectsV2Paginator: " + TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - beginTime) + "ms");
     }
 
     public static class MockHttpClient implements SdkHttpClient {
         public ExecutableHttpRequest prepareRequest(HttpExecuteRequest request) {
             String query = request.httpRequest().getUri().getQuery();
             return new ExecutableHttpRequest() {
                 public void abort() {
                 }
 
                 public HttpExecuteResponse call() throws IOException {
                     SdkHttpResponse response = SdkHttpResponse.builder().statusCode(200).build();
                     ByteArrayInputStream bais = new ByteArrayInputStream(mock_data_map.get(query).getBytes());
                     return HttpExecuteResponse.builder().response(response).responseBody(AbortableInputStream.create(bais)).build();
                 }
             };
         }
 
         public void close() {
         }
 
         public static Map<String, String> mock_data_map = new HashMap<String, String>();
         static {
             // @formatter:off
             mock_data_map.put("acl", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                     + "<AccessControlPolicy>\n"
                     + "   <Owner>\n"
                     + "      <DisplayName>DisplayName</DisplayName>\n"
                     + "      <ID>ID</ID>\n"
                     + "   </Owner>\n"
                     + "   <AccessControlList>\n"
                     + "      <Grant>\n"
                     + "         <Grantee xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:type=\"xsi:type\">\n"
                     + "            <DisplayName>DisplayName</DisplayName>\n"
                     + "            <EmailAddress>EmailAddress</EmailAddress>\n"
                     + "            <ID>ID</ID>\n"
                     + "            <xsi:type>xsi:type</xsi:type>\n"
                     + "            <URI>URI</URI>\n"
                     + "         </Grantee>\n"
                     + "         <Permission>Permission</Permission>\n"
                     + "      </Grant>\n"
                     + "   </AccessControlList>\n"
                     + "</AccessControlPolicy>");
             mock_data_map.put("list-type=2", mock_data_ListObjectsV2());
             // @formatter:on
         }
 
         private static String mock_data_ListObjectsV2() {
             String contents = "";
             for (int i = 0; i < 100; i++) {
                 // @formatter:off
                 contents += "<Contents>\n" 
                         + "        <Key>mock_key_"+i+"</Key>\n"
                         + "        <!--<LastModified>2024-03-22T08:04:59.000Z</LastModified>-->\n"
                         + "        <ETag>&quot;1d0f249c316092c34288a77d779eeaba-"+i+"&quot;</ETag>\n"
                         + "        <ChecksumAlgorithm>SHA256</ChecksumAlgorithm>\n"
                         + "        <Size>5</Size>\n"
                         + "        <StorageClass>STANDARD</StorageClass>\n"
                         + "    </Contents>";
                 // @formatter:on
             }
             // @formatter:off
             return "<ListBucketResult\n"
                     + "    xmlns=\"http://s3.amazonaws.com/doc/2006-03-01/\">\n"
                     + "    <Name>cj-test11</Name>\n"
                     + "    <Prefix></Prefix>\n"
                     + "    <KeyCount>100</KeyCount>\n"
                     + "    <MaxKeys>100</MaxKeys>\n"
                     + "    <IsTruncated>false</IsTruncated>\n"
                     + contents.toString()
                     + "</ListBucketResult>";
             // @formatter:on
         }
     }
 
 }
