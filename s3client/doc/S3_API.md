

# 1、判断bucket是否存在

## HeadBucket

您可以使用此操作来确定bucket是否存在以及您是否有权访问它。如果bucket存在并且您有权访问，此操作将返回200 OK。



### 示例代码

```java


package s3client_test.action


@Tests
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let headReq = HeadBucketRequest(bucket: bucket1)
        println(headReq)
        let headRsp = s3.headBucket(headReq)
        println(headRsp)
        println(headRsp.responseMetadata)
    }
}

```



### 请求参数列表

| **参数名称** |               **参数类型**               | **是否必选** | **描述** |
| :----------: | :--------------------------------------: | :----------: | :------: |
|   headReq    | [HeadBucketRequest](# HeadBucketRequest) |      是      | 请求参数 |



#### HeadBucketRequest

| **参数名称**        | 参数类型 | **是否必填** | **默认值** | **描述**     |
| ------------------- | -------- | ------------ | ---------- | ------------ |
| bucket              | String   | 是           |            | 存储桶名称。 |
| expectedBucketOwner | String   | 否           |            | account      |



### 响应参数

无

# 2、创建一个新的S3存储桶



## CreateBucket

创建一个新的S3存储桶。要创建bucket，必须设置Amazon S3，并具有有效的AWS访问密钥ID来验证请求。从不允许匿名请求创建bucket。通过创建bucket



###  示例代码

```java


package s3client_test.action


@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let createReq = CreateBucketRequest(bucket: "cj-zzz")
        println(createReq)
        let createRsp = s3.createBucket(createReq)
        println(createRsp)
    }
}

```



### 请求参数列表

| 参数名称  |                  参数类型                   | 是否必选 |   描述   |
| :-------: | :-----------------------------------------: | :------: | :------: |
| createReq | [CreateBucketRequest](#CreateBucketRequest) |    是    | 请求参数 |



#### CreateBucketRequest

|                          参数                           |  类型  | **是否必填** | 默认值 | 描述                                                         |
| :-----------------------------------------------------: | :----: | :----------: | ------ | ------------------------------------------------------------ |
|                         bucket                          | String |      是      |        | 名称                                                         |
|                           acl                           | String |      否      |        | 存储桶的固定  有效值:ACLprivate \|public-read \|public-read-write \|authenticated-read |
|                    grantFullControl                     | String |      否      |        | 允许对桶授予读、写、读ACP和写ACP权限。                       |
|                        grantRead                        | String |      否      |        | 允许受让人列出bucket中的对象。                               |
|                       grantWrite                        | String |      否      |        | 允许被授权人创建、覆盖和删除桶中的任何对象。                 |
|                      grantReadACP                       | String |      否      |        | 允许被授权人读取桶ACL                                        |
|                      grantWriteACP                      | String |      否      |        | 允许被授予者为适用的桶写ACL                                  |
|               objectLockEnabledForBucket                | String |      否      |        | 指定是否为新桶启用S3对象锁定                                 |
|                     objectOwnership                     | String |      否      |        | 容器元素用于存储桶的所有权控件的对象所有权。                 |
| [CreateBucketConfiguration](#CreateBucketConfiguration) | String |      是      |        | 该请求接受以下XML格式的数据。                                |

#### CreateBucketConfiguration

| 参数                | 类型 | **是否必填** | 默认值 | 描述                                                         |
| ------------------- | ---- | ------------ | ------ | ------------------------------------------------------------ |
| bucket              |      | 是           |        | 要设置其OwnershipControls的Amazon S3存储桶的名称。           |
| expectedBucketOwner |      | 否           |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| contentMD5          |      | 否           |        | OwnershipControls请求主体的MD5哈希。                         |





### 响应参数

| 参数名称 | 类型   | **是否必填** | 默认值 | 描述                           |
| -------- | ------ | ------------ | ------ | ------------------------------ |
| location | String | 是           |        | 一个正斜杠，后面跟着桶的名称。 |



# 3、返回所有存储桶的列表。



## ListBuckets

返回经过身份验证的请求发送方所拥有的所有存储桶的列表。

### 示例代码

```java	


package s3client_test.action


@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListBucketsRequest()
        println(listReq)
        let listRsp = s3.listBuckets(listReq)
        println(listRsp)
    }
}

```

### 请求参数列表

无



### 响应参数

| 参数名称 | 类型                         | **是否必填** | 默认值 | 描述                     |
| -------- | ---------------------------- | ------------ | ------ | ------------------------ |
| owner    | [Owner](#Owner)              | 是           |        | 列出的桶的所有者。       |
| buckets  | ArrayList<[Bucket](#Bucket)> | 是           |        | 请求者拥有的存储桶列表。 |



#### Bucket

| 参数名称     | 类型     | **是否必填** | 默认值 | 描述                                                         |
| ------------ | -------- | ------------ | ------ | ------------------------------------------------------------ |
| name         | String   | 否           |        | 存储桶的名称。                                               |
| creationDate | DateTime | 否           |        | 存储桶的创建日期。在对存储桶进行更改（例如编辑其存储桶策略）时，此日期可能会更改。 |



# 4、删除S3存储桶

## DeleteBucket

删除S3存储桶。在删除bucket之前，必须删除bucket中的所有对象（包括所有对象版本和删除标记） 

### 示例代码

```java	


package s3client_test.action


@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let deleteReq = DeleteBucketRequest(bucket: "cj-zzz")
        println(deleteReq)
        let deleteRsp = s3.deleteBucket(deleteReq)
        println(deleteRsp)
    }
}

```



### 请求参数列表

|      参数名称       |                  参数类型                   | 是否必选 |   描述   |
| :-----------------: | :-----------------------------------------: | :------: | :------: |
| DeleteBucketRequest | [DeleteBucketRequest](#DeleteBucketRequest) |    是    | 请求参数 |



#### DeleteBucketReques

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 要删除的桶。                                                 |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果您提供的帐户ID与桶的实际所有者不匹配，则请求失败，HTTP状态码为403 Forbidden(访问被拒绝)。 |



### 响应参数

无



# 5、删除存储桶的分析配置

## DeleteBucketAnalyticsConfiguration

删除存储桶的分析配置（由分析配置ID指定）。

### 示例代码

```java


package s3client_test.action


@Test
public class BucketAnalyticsTest {
    @TestCase
    public func testBucket_analytics(): Unit {
        let id = "report2"
        let delReq = DeleteBucketAnalyticsConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketAnalyticsConfiguration(delReq)
        println(delRsp)
    }
}

```





### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketAnalyticsConfigurationRequest](#DeleteBucketAnalyticsConfigurationRequest) |    是    | 请求参数 |





#### DeleteBucketAnalyticsConfigurationRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       Bucket        |  String  |      是      |        | 从其中删除分析配置的桶的名称。                               |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |
|         id          |  String  |      是      |        | 标识分析配置的ID。                                           |



### 响应参数

无



# 6、删除bucket的cors配置信息集

## DeleteBucketCors

删除bucket的cors配置信息集。

### 示例代码

```java 


package s3client_test.action


@Test
public class BucketCorsTest {
    @TestCase
    public func testBucket_cors(): Unit {
        let delReq = DeleteBucketCorsRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketCors(delReq)
        println(delRsp)
    }
}
```



### 请求参数列表

| 参数名称 |                      参数类型                       | 是否必选 |   描述   |
| :------: | :-------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketCorsRequest](#DeleteBucketCorsRequest) |    是    | 请求参数 |



#### DeleteBucketCorsRequest

| 参数                | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| ------------------- | :------: | :----------: | ------ | ------------------------------------------------------------ |
| bucket              |  String  |      是      |        | 要删除cors配置的桶。                                         |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |

### 响应参数

无

​	

# 7、bucket重置秘钥

## DeleteBucketEncryption

DELETE操作的此实现将bucket的默认加密重置为使用AmazonS3托管密钥（SSE-S3）的服务器端加密

### 示例代码

```java	


package s3client_test.action


@Test
public class BucketEncryptionTest {
    @TestCase
    public func testBucket_encryption(): Unit {
        let delReq = DeleteBucketEncryptionRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketEncryption(delReq)
        println(delRsp)
    }
}

```



### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketEncryptionRequest](#DeleteBucketEncryptionRequest) |    是    | 请求参数 |





#### DeleteBucketEncryptionRequest

| 参数                | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| ------------------- | -------- | ------------ | :----: | ------------------------------------------------------------ |
| bucket              | String   | 是           |        | 包含要删除的服务器端加密配置的桶的名称。                     |
| expectedBucketOwner | String   | 否           |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，请求失败，HTTP状态码403 Forbidden(访问被拒绝) |



### 响应参数

无



# 8、从指定的存储桶中删除S3智能分层配置

## DeleteBucketIntelligentTieringConfiguration

从指定的存储桶中删除S3智能分层配置。

### 示例代码

```java


package s3client_test.action


@Test
public class BucketIntelligentTest {
    @TestCase
    public func testBucket_intelligent(): Unit {
        let delReq = DeleteBucketIntelligentTieringConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketIntelligentTieringConfiguration(delReq)
        println(delRsp)
    }
}

```

### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketIntelligentTieringConfigurationRequest](#DeleteBucketIntelligentTieringConfigurationRequest) |    是    | 请求参数 |



#### DeleteBucketIntelligentTieringConfigurationRequest

|  参数  | 参数类型 | **是否必填** | 默认值 | 描述                         |
| :----: | :------: | :----------: | ------ | ---------------------------- |
| bucket |  String  |      是      |        | 名称                         |
|   id   |  String  |      是      |        | 用于标识S3智能分级配置的ID。 |



### 响应参数

无



# 9、从存储桶中删除库存配置

## DeleteBucketInventoryConfiguration

从存储桶中删除库存配置（由库存ID标识）

### 示例代码

```java


package s3client_test.action


@Test
public class BucketInventoryTest {
    @TestCase
    public func testBucket_inventory(): Unit {
        let delReq = DeleteBucketInventoryConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketInventoryConfiguration(delReq)
        println(delRsp)
    }
}
```



### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketInventoryConfigurationRequest](#DeleteBucketInventoryConfigurationRequest) |    是    | 请求参数 |

### DeleteBucketInventoryConfigurationRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       Bucket        |  String  |      是      |        | 包含要删除的库存配置的桶的名称                               |
|         id          |  String  |      是      |        | 用于标识库存配置的ID                                         |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |



### 响应参数

无



# 10、从指定桶中删除生命周期配置。

## DeleteBucketLifecycle

### 示例代码

```java


package s3client_test.action


@Test
public class BucketLifecycleTest {
    @TestCase
    public func testBucket_lifecycle(): Unit {
        let delReq = DeleteBucketLifecycleRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketLifecycle(delReq)
        println(delRsp)
    }
}

```

### 请求参数列表

| 参数名称 |           参数类型           | 是否必选 |   描述   |
| :------: | :--------------------------: | :------: | :------: |
|  delReq  | DeleteBucketLifecycleRequest |    是    | 请求参数 |

### DeleteBucketLifecycleRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 要删除的生命周期的存储桶名称。                               |
| expectedBucketOwner |  String  |      否      |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |

### 响应参数

无







# 11、 从存储桶中删除Amazon CloudWatch请求度量的度量配置

##  DeleteBucketMetricsConfiguration

### 示例代码

```java


package s3client_test.action


@Test
public class BucketMetricsTest {
    @TestCase
    public func testBucket_metrics(): Unit {
        let delReq = DeleteBucketMetricsConfigurationRequest(bucket: bucket1, id: id)
        println(delReq)
        let delRsp = s3.deleteBucketMetricsConfiguration(delReq)
        println(delRsp)
    }
}

```

### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketMetricsConfigurationRequest](#DeleteBucketMetricsConfigurationRequest) |    是    | 请求参数 |

### DeleteBucketMetricsConfigurationRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 包含要删除的度量配置的桶的名称。                             |
|         id          |  String  |      是      |        | 用于标识度量配置的ID。ID长度限制为64个字符，只能包含字母、数字、“。”、“-”和“_”。 |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |



### 响应参数

无







# 12、移除Amazon S3 bucket的OwnershipControls。

## DeleteBucketOwnershipControls

### 示例代码

```java


package s3client_test.action


@Test
public class BucketOwnershipsTest {
    @TestCase
    public func testBucket_ownerships(): Unit {        
        let delReq = DeleteBucketOwnershipControlsRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketOwnershipControls(delReq)
        println(delRsp)
    }
}
```





### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketOwnershipControlsRequest](#DeleteBucketOwnershipControlsRequest) |    是    | 请求参数 |

### DeleteBucketOwnershipControlsRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 要删除其OwnershipControls的Amazon S3存储桶。                 |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |

### 响应参数

无



# 13、删除指定存储桶的策略。



## DeleteBucketPolicy

### 示例代码

```java


package s3client_test.action


@Test
public class BucketPolicyTest {
    @TestCase
    public func testBucket_policy(): Unit {
        let delReq = DeleteBucketPolicyRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketPolicy(delReq)
        println(delRsp)
    }
}

```



### 请求参数列表

| 参数名称 |         参数类型          | 是否必选 |   描述   |
| :------: | :-----------------------: | :------: | :------: |
|  delReq  | DeleteBucketPolicyRequest |    是    | 请求参数 |

### DeleteBucketPolicyRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 桶名                                                         |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |



### 响应参数

无





# 14、从存储桶中删除复制配置。



## DeleteBucketReplication

### 示例代码

```java


package s3client_test.action


@Test
public class BucketReplicationTest {
    @TestCase
    public func testBucket_replication(): Unit {
        let delReq = DeleteBucketReplicationRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketReplication(delReq)
        println(delRsp)
    }
}

```



### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketReplicationRequest](#DeleteBucketReplicationRequest) |    是    | 请求参数 |

### DeleteBucketReplicationRequest

|        参数         | 参数类型 | **是否必填**值 | 默认值 | 描述                                                         |
| :-----------------: | :------: | :------------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |       是       |        | 存储桶名称。                                                 |
| expectedBucketOwner |  String  |       否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |

### 响应参数

无

# 15、从存储桶中删除标记。



## DeleteBucketTagging

### 示例代码

```java


package s3client_test.action


@Test
public class BucketTaggingTest {
    @TestCase
    public func testBucket_tagging(): Unit {
        let delReq = DeleteBucketTaggingRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketTagging(delReq)
        println(delRsp)
    }
}

```

### 请求参数列表

| 参数名称 |                         参数类型                          | 是否必选 |   描述   |
| :------: | :-------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketTaggingRequest](#DeleteBucketTaggingRequest) |    是    | 请求参数 |

### DeleteBucketTaggingRequest

|        参数         | 参数类型 | 是否必填 | 默认值                                                       | 描述                                                         |
| :-----------------: | :------: | :------: | ------------------------------------------------------------ | ------------------------------------------------------------ |
|       bucket        |  String  |          | 桶名。                                                       | 桶名。                                                       |
| expectedBucketOwner |  String  |          | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |

### 响应参数

无



# 16、此操作将删除bucket的网站配置



## DeleteBucketWebsite

### 示例代码

```java


package s3client_test.action


@Test
public class BucketWebsiteTest {
    @TestCase
    public func testBucket_website(): Unit {
        let delReq = DeleteBucketWebsiteRequest(bucket: bucket1)
        println(delReq)
        let delRsp = s3.deleteBucketWebsite(delReq)
        println(delRsp)
    }
}

```



### 请求参数列表

| 参数名称 |                         参数类型                          | 是否必选 |   描述   |
| :------: | :-------------------------------------------------------: | :------: | :------: |
|  delReq  | [DeleteBucketWebsiteRequest](#DeleteBucketWebsiteRequest) |    是    | 请求参数 |

### DeleteBucketWebsiteRequest

|        参数         | 参数类型 | **是否必填** | 默认值 | 描述                                                         |
| :-----------------: | :------: | :----------: | ------ | ------------------------------------------------------------ |
|       bucket        |  String  |      是      |        | 要删除网站配置的桶名                                         |
| expectedBucketOwner |  String  |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，请求失败，HTTP状态码403 Forbidden(访问被拒绝) |

### 响应参数

无



# 17、设置现有桶的加速配置



## PutBucketAccelerateConfiguration

### 示例代码

```java


package s3client_test.action


@Test
public class BucketAccelerateTest {
    @TestCase
    public func testBucket_accelerate(): Unit {
        let config = AccelerateConfiguration(status: "Enabled")
        let putReq = PutBucketAccelerateConfigurationRequest(
            bucket: bucket1,
            configuration: config
        )
        try {
            let putRsp = s3.putBucketAccelerateConfiguration(putReq)
            println(putRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [putBucketAccelerateConfiguration]: ${ex}")
        }
    }
}

```



### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  putRsp  | [putBucketAccelerateConfiguration](#putBucketAccelerateConfiguration) |    是    | 请求参数 |



### putBucketAccelerateConfiguration

|                   参数                    |        参数类型         | **是否必填** | 默认值 | 描述                                                         |
| :---------------------------------------: | :---------------------: | :----------: | ------ | ------------------------------------------------------------ |
|                  bucket                   |         String          |      是      |        | 要为其设置加速配置的桶的名称。                               |
| [configuration](#AccelerateConfiguration) | AccelerateConfiguration |      是      |        |                                                              |
|            expectedBucketOwner            |         String          |      否      |        | 预期桶所有者的帐户ID。如果桶由不同的帐户拥有，则请求失败，HTTP状态码403 Forbidden(访问被拒绝)。 |
|             checksumAlgorithm             |         String          |      否      |        | 使用SDK时为对象创建校验和时使用的算法。如果不使用SDK，这个头将不会提供任何额外的功能。当发送此报头时，必须发送相应的x-amz-checksum或x-amz-trailer报头。否则，Amazon S3请求失败，HTTP状态码为400 Bad request。<br />如果提供单独的校验和，Amazon S3将忽略任何提供的ChecksumAlgorithm<br />Valid Values: CRC32 \|CRC32C \|SHA1 \|SHA256 |

### AccelerateConfiguration

| 参数   | 类型   | 描述状态               |
| ------ | ------ | ---------------------- |
| status | String | 状态Enabled -Suspended |



### 响应参数 

无







# 18、使用访问控制列表（ACL）设置对现有存储桶的权限



## PutBucketAcl

### 示例代码

```java


package s3client_test.action


@Test
public class BucketAclTest {
    @TestCase
    public func testBucket_acl(): Unit {
        printTestCase("testBucket_acl")
        let policy = AccessControlPolicy(
            owner: Owner(id: ownerId),
            grants: ArrayList<Grant>(
                [
                    Grant(
                        permission: "FULL_CONTROL",
                        grantee: Grantee(id: ownerId, type_: "CanonicalUser")
                    )
                ]
            )
        )
        println(policy.toXml())
        let putReq = PutBucketAclRequest(
            bucket: bucket2,
            accessControlPolicy: policy
        )
        println(putReq)
        let putRsp = s3.putBucketAcl(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```



### 请求参数类型

| 参数名称 |           参数类型            | 是否必选 |   描述   |
| :------: | :---------------------------: | :------: | :------: |
|  putRsp  | [putBucketAcl](#putBucketAcl) |    是    | 请求参数 |



### putBucketAcl

|        参数         |                **参数类型**                 | 是否必填 | 默认值 | 描述                                                         |
| :-----------------: | :-----------------------------------------: | :------: | ------ | ------------------------------------------------------------ |
|       bucket        |                   String                    |    是    |        | 要应用ACL的存储桶。                                          |
|         acl         |                   String                    |    否    |        | 要应用于存储桶的固定ACL。private \|public-read \| public-read-write\|authenticated-read |
| accessControlPolicy | [AccessControlPolicy](#AccessControlPolicy) |    是    |        | AccessControlPolicy参数的根级别标记。                        |
|     contentMD5      |                   String                    |    否    |        | base64编码的128位MD5数据摘要                                 |
|  checksumAlgorithm  |                   String                    |    否    |        | 指示使用SDK时用于为对象创建校验和的算法CRC32 \| CRC32C\|SHA1\|SHA256 |
|  grantFullControl   |                   String                    |    否    |        | 允许被授予者对存储桶的读取、写入、读取ACP和写入ACP权限。     |
|      grantRead      |                   String                    |    否    |        | 允许被授予者列出存储桶中的对象。                             |
|     grantWrite      |                   String                    |    否    |        | 允许被授予者在存储桶中创建新对象。                           |
|    grantReadACP     |                   String                    |    否    |        | 允许被授予者读取桶 ACL。                                     |
|    grantWriteACP    |                   String                    |    否    |        | 允许被授予者写入适用存储桶的ACL。                            |
| expectedBucketOwner |                   String                    |    否    |        | 允许被授予者在存储桶中创建新对象。                           |

### Owner

| 参数名称    | 参数类型 | 是否必填 | 描述                   |
| ----------- | -------- | -------- | ---------------------- |
| id          | String   | 否       | 所有者ID的容器。       |
| displayName | String   | 否       | 所有者显示名称的容器。 |



### AccessControlPolicy

| 参数名称 | **参数类型**               | 是否必填 | 描述                               |
| -------- | -------------------------- | -------- | ---------------------------------- |
| grants   | ArrayList<[Grant](#Grant)> | 否       | 赠款清单。                         |
| owner    | [Owner](#Owner)            | 否       | 存储桶所有者的显示名称和ID的容器。 |

#### Grant

|  参数名称  |      参数类型       | 是否必填 |                             描述                             |
| :--------: | :-----------------: | :------: | :----------------------------------------------------------: |
|  grantee   | [Grantee](#Grantee) |    否    |                       被授予权限的人。                       |
| permission |       String        |    否    | 指定授予被授予者的权限。有效值：FULL_CONTROL \|WRITE \|WRITE_ACP \| READ \|READ_ACP |

#### Grantee

|   参数名称   | 参数类型 | 是否必填 |           描述           |
| :----------: | :------: | :------: | :----------------------: |
|      id      |  String  |    否    |  被授予者的规范用户ID。  |
|    type_     |  String  |    是    |           类型           |
|     uri      |  String  |    否    |    被授予者组的URI。     |
| displayName  |  String  |    否    |   被授予者的屏幕名称。   |
| emailAddress |  String  |    否    | 被授予人的电子邮件地址。 |



### 响应体

```
HTTP/1.1 200
```

### 响应参数

无









# 19、设置bucket的cors配置



## PutBucketCors

如果配置存在，AmazonS3会替换它。



### 示例代码

```java
    @Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
 let corsRules = [
            CORSRule(
                allowedMethods: ArrayList<String>(["PUT", "GET"]),
                allowedOrigins: ArrayList<String>(["http://example.com"])
            )
        ]
        let putReq = PutBucketCorsRequest(
            bucket: bucket1,
            configuration: CORSConfiguration(corsRules: ArrayList<CORSRule>(corsRules))
        )
        println(putReq)
        let putRsp = s3.putBucketCors(putReq)
        println(putRsp)
    }
}

```



### 请求参数列表

| 参数名称 |                   参数类型                    | 是否必选 |   描述   |
| :------: | :-------------------------------------------: | :------: | :------: |
|  putReq  | [PutBucketCorsRequest](#PutBucketCorsRequest) |    是    | 请求参数 |





### PutBucketCorsRequest

|      参数名称       |              **参数类型**               | 是否必填 | 默认值 | 描述                                                         |
| :-----------------: | :-------------------------------------: | :------: | ------ | ------------------------------------------------------------ |
|       bucket        |                 String                  |    是    |        | 存储桶名称。                                                 |
|    configuration    | [CORSConfiguration](#CORSConfiguration) |    是    |        | CORS配置参数的根级别标记。                                   |
|     contentMD5      |                 String                  |    否    |        | base64编码的128位MD5数据摘要                                 |
|  checksumAlgorithm  |                 String                  |    否    |        | 指示使用SDK时用于为对象创建校验和的算法                      |
| expectedBucketOwner |                 String                  |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



#### CORSConfiguration

|   参数    |             参数类型             | 是否必填 |                             描述                             |      |
| :-------: | :------------------------------: | :------: | :----------------------------------------------------------: | :--: |
| corsRules | ArrayList<[CORSRule](#CORSRule)> |    是    | 一组原点和方法（要允许的跨原点访问）。您最多可以向配置中添加100条规则。 |      |



##### CORSRule

| 参数名称       | 参数类型          | 是否必填 | 描述                                                         |
| -------------- | ----------------- | -------- | ------------------------------------------------------------ |
| id             | String            | 否       | 规则的唯一标识符。该值的长度不能超过255个字符。              |
| allowedHeaders | ArrayList<String> | 否       | 在访问控制请求标头中指定的标头                               |
| allowedMethods | ArrayList<String> | 是       | 允许源执行的HTTP方法。有效值为GET、PUT、HEAD、POST和DELETE。 |
| allowedOrigins | ArrayList<String> | 是       | 客户能够从一个或多个来源访问bucket。                         |
| exposeHeaders  | ArrayList<String> | 否       | 响应中的一个或多个标头，                                     |
| maxAgeSeconds  | Int32             | 否       | 浏览器缓存指定资源的飞行前响应的时间（以秒为单位）。         |

### 响应参数

无













# 20、设置存储桶的分析配置（由分析配置ID指定）



## PutBucketAnalyticsConfiguration

每个存储桶最多可以有1000个分析配置。





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let id = "report2"
        let config = AnalyticsConfiguration(
            id: id,
            storageClassAnalysis: StorageClassAnalysis(
                dataExport: StorageClassAnalysisDataExport(
                    outputSchemaVersion: "V_1",
                    destination: AnalyticsExportDestination(
                        s3BucketDestination: AnalyticsS3BucketDestination(
                            format: "CSV",
                            bucket: bucket1_arn
                        )
                    )
                )
            )
        )
        println(config.toXml())
        let putReq = PutBucketAnalyticsConfigurationRequest(
            bucket: bucket1,
            id: id,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketAnalyticsConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 |                           参数类型                           | 是否必选 |   描述   |
| :------: | :----------------------------------------------------------: | :------: | :------: |
|  putReq  | [PutBucketAnalyticsConfigurationRequest](#PutBucketAnalyticsConfigurationRequest) |    是    | 请求参数 |



### PutBucketAnalyticsConfigurationRequest

|      参数名称       |                   **参数类型**                    | 是否必填 | 默认值 | 描述                                     |
| :-----------------: | :-----------------------------------------------: | :------: | ------ | ---------------------------------------- |
|       bucket        |                      String                       |    是    |        | 存储分析配置的存储桶的名称。             |
|         id          |                      String                       |    是    |        | 标识分析配置的ID。                       |
|    configuration    | [AnalyticsConfiguration](#AnalyticsConfiguration) |    是    |        | AnalyticsConfiguration参数的根级别标记。 |
| expectedBucketOwner |                      String                       |    否    |        | 预期存储桶所有者的帐户ID。               |



#### AnalyticsConfiguration

|       参数名称       |                 **参数类型**                  | 是否必填 | 默认值 |                             描述                             |      |
| :------------------: | :-------------------------------------------: | :------: | :----: | :----------------------------------------------------------: | :--: |
|          id          |                    String                     |    是    |        |                      标识分析配置的ID。                      |      |
|        filter        |      [AnalyticsFilter](#AnalyticsFilter)      |    否    |        |                用于描述一组分析对象的筛选器。                |      |
| storageClassAnalysis | [StorageClassAnalysis](#StorageClassAnalysis) |    是    |        | 包含与访问模式相关的数据，这些数据将被收集并可用于分析不同存储类之间的权衡。 |      |





##### AnalyticsFilter

| 参数名称 |                 **参数类型**                  | 是否必填 | 默认值 |                             描述                             |
| :------: | :-------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|  prefix  |                    String                     |    否    |        |                评估分析筛选器时要使用的前缀。                |
|   tag    |                  [Tag](#Tag)                  |    否    |        |                评估分析筛选器时要使用的标记。                |
|   and    | [AnalyticsAndOperator](#AnalyticsAndOperator) |    否    |        | 谓词的连接（逻辑AND），用于评估分析过滤器。运算符必须至少有两个谓词。 |





##### StorageClassAnalysis

| 参数名称   | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                   |
| ---------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------------------ |
| dataExport | [StorageClassAnalysisDataExport](#StorageClassAnalysisDataExport) | 否       |        | 指定应如何导出与AmazonS3存储桶的存储类分析相关的数据。 |



###### StorageClassAnalysisDataExport

| 参数名称            | **参数类型**                                              | 是否必填 | 默认值 | 描述                                        |
| ------------------- | --------------------------------------------------------- | -------- | ------ | ------------------------------------------- |
| outputSchemaVersion | String                                                    | 是       |        | 用于存储分析数据的位置。                    |
| destination         | [AnalyticsExportDestination](#AnalyticsExportDestination) | 是       |        | 导出数据时要使用的输出架构的版本。必须是V_1 |



###### AnalyticsExportDestination

| 参数名称            | **参数类型**                                                 | 是否必填 | 默认值 | 描述                           |
| ------------------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------ |
| s3BucketDestination | [AnalyticsS3BucketDestination](#AnalyticsS3BucketDestination) | 是       |        | 一个表示S3存储桶输出的目的地。 |



###### AnalyticsS3BucketDestination

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                                        |
| --------------- | ------------ | -------- | ------ | ------------------------------------------- |
| format          | String       | 是       |        | 指定将数据导出到Amazon S3时使用的文件格式。 |
| bucketAccountId | String       | 否       |        | 拥有目标S3存储桶的帐户ID                    |
| bucket          | String       | 是       |        | 数据导出到的存储桶的亚马逊资源名称（ARN）。 |
| prefix          | String       | 否       |        | 导出数据时要使用的前缀。                    |



###### Tag

| 参数名称 | **参数类型** | 是否必填 | 默认值 |                描述                 |
| -------- | :----------: | :------: | :----: | :---------------------------------: |
| key      |    String    |    是    |        | 类型：字符串长度限制：最小长度为1。 |
| value    |    String    |    是    |        |             标记的值。              |



###### AnalyticsAndOperator

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述                                                      |
| -------- | ---------------------- | -------- | ------ | --------------------------------------------------------- |
| prefix   | String                 | 否       |        | 评估AND谓词时要使用的前缀：度量结果中必须包含对象的前缀。 |
| tags     | ArrayList<[Tag](#Tag)> | 否       |        | 评估分析筛选器时要使用的标记。                            |



### 响应参数

无



# 21、此操作使用加密子资源为现有存储桶配置默认加密和Amazon S3存储桶密钥。

## PutBucketEncryption



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        printTestCase("testBucket_encryption")
        let config = ServerSideEncryptionConfiguration(
            rules: ArrayList<ServerSideEncryptionRule>(
                [
                    ServerSideEncryptionRule(
                        bucketKeyEnabled: true,
                        applyServerSideEncryptionByDefault: ServerSideEncryptionByDefault(sseAlgorithm: "AES256")
                    )
                ]
            )
        )
        println(config.toXml())
       	 let putReq = PutBucketEncryptionRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketEncryption(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketEncryptionRequest](#PutBucketEncryptionRequest) | 是       |        | 请求参数 |



### PutBucketEncryptionRequest

|      参数名称       |           **参数类型**            | 是否必填 | 默认值 |                             描述                             |
| :-----------------: | :-------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|       bucket        |              String               |    是    |        |    使用具有不同密钥选项的服务器端加密为存储桶指定默认加密    |
|     contentMD5      |              String               |    否    |        |         服务器端加密配置的base64编码的128位MD5摘要。         |
|  checksumAlgorithm  |              String               |    否    |        |          指示使用SDK时用于为对象创建校验和的算法。           |
|    configuration    | ServerSideEncryptionConfiguration |    否    |        |                      参数的根级别标记。                      |
| expectedBucketOwner |              String               |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### ServerSideEncryptionConfiguration

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                       |
| -------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------ |
| rules    | ArrayList<[ServerSideEncryptionRule](#ServerSideEncryptionRule)> | 是       |        | 有关特定服务器端加密配置规则的信息的容器。 |





#### ServerSideEncryptionRule

|              参数名称              |                         **参数类型**                         | 是否必填 | 默认值 |                             描述                             |
| :--------------------------------: | :----------------------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
| applyServerSideEncryptionByDefault | [ServerSideEncryptionByDefault](#ServerSideEncryptionByDefault) |    否    |        |        指定要应用于存储桶中新对象的默认服务器端加密。        |
|          bucketKeyEnabled          |                             Bool                             |    否    |        | 指定AmazonS3是否应使用服务器端加密的S3存储桶密钥，该密钥使用KMS（SSE-KMS）对存储桶中的新对象进行加密 |

##### ServerSideEncryptionByDefault

|    参数名称    | **参数类型** | 是否必填 | 默认值 |                        描述                         |
| :------------: | :----------: | :------: | :----: | :-------------------------------------------------: |
|  sseAlgorithm  |    String    |    是    |        |          用于默认加密的服务器端加密算法。           |
| kmsMasterKeyID |    String    |    否    |        | AWS密钥管理服务（KMS）客户AWS KMS密钥ID用于默认加密 |



### 响应参数

无



# 22、将S3智能分层配置放入指定的存储桶



## PutBucketIntelligentTieringConfiguration



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let id = "config_1"
        let config = IntelligentTieringConfiguration(
            id: id,
            status: "Enabled",
            tierings: ArrayList<Tiering>([Tiering(days: 100, accessTier: "ARCHIVE_ACCESS")])
        )
        let putReq = PutBucketIntelligentTieringConfigurationRequest(
            id: id,
            bucket: bucket1,
            configuration: config
        )
        println(config.toXml())
        println(putReq)
        let putRsp = s3.putBucketIntelligentTieringConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketIntelligentTieringConfigurationRequest](#PutBucketIntelligentTieringConfigurationRequest) | 是       |        | 请求参数 |

### PutBucketIntelligentTieringConfigurationRequest

| 参数名称      | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                       |
| ------------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------ |
| bucket        | String                                                       | 是       |        | 要修改或检索其配置的AmazonS3存储桶的名称。 |
| id            | String                                                       | 是       |        | 用于标识S3智能分层配置的ID。               |
| configuration | [IntelligentTieringConfiguration](#IntelligentTieringConfiguration) | 是       |        | 智能分层配置参数的根级别标记。             |



### IntelligentTieringConfiguration



| 参数名称 |                     **参数类型**                      | 是否必填 | 默认值 |                        描述                        |
| :------: | :---------------------------------------------------: | :------: | :----: | :------------------------------------------------: |
|    id    |                        String                         |    是    |        |            用于标识S3智能分级配置的ID。            |
|  filter  | [IntelligentTieringFilter](#IntelligentTieringFilter) |    否    |        | 指定bucket筛选器。配置仅包括符合筛选器条件的对象。 |
|  status  |                        String                         |    是    |        |            用于标识S3智能分层配置的ID。            |
| tierings |                        String                         |    是    |        |           指定配置的S3智能分层存储类层。           |

#### IntelligentTieringFilter

| 参数名称 |                         **参数类型**                         | 是否必填 | 默认值 |                        描述                        |
| :------: | :----------------------------------------------------------: | :------: | :----: | :------------------------------------------------: |
|  prefix  |                            String                            |    否    |        | 对象关键字名称前缀，用于标识规则所应用的对象子集。 |
|   tag    |                         [Tag](#Tag)                          |    否    |        |                键值-名称对的容器。                 |
|   and    | [IntelligentTieringAndOperator](#IntelligentTieringAndOperator) |    否    |        |    谓词的连接（逻辑AND），用于评估度量过滤器。     |



##### IntelligentTieringAndOperator

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述                                                   |
| -------- | ---------------------- | -------- | ------ | ------------------------------------------------------ |
| prefix   | String                 | 否       |        | 对象密钥名称前缀，用于标识应用配置的对象子集。         |
| tags     | ArrayList<[Tag](#Tag)> | 否       |        | 所有这些标记都必须存在于对象的标记集中，才能应用配置。 |



### 响应参数

无







# 23、PUT操作的这个实现将一个库存配置（由库存ID标识）添加到bucket中。

## PutBucketInventoryConfiguration

每个存储桶最多可以有1000个库存配置。



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let id = "report_1"
        let config = InventoryConfiguration(
            id: id,
            isEnabled: true,
            includedObjectVersions: "All",
            filter: InventoryFilter(prefix: "filterPrefix"),
            schedule: InventorySchedule(frequency: "Daily"),
            destination: InventoryDestination(
                s3BucketDestination: InventoryS3BucketDestination(
                    accountId: accountId,
                    bucket: bucket1_arn,
                    format: "CSV",
                    prefix: "prefix1",
                    encryption: InventoryEncryption(
                        ssekms: SSEKMS(
                            keyId: "arn:aws:kms:uswest-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab")
                    )
                )
            ),
            optionalFields: ArrayList<String>(["Size", "LastModifiedDate"])
        )
        let xml = config.toXml()
        println(xml)
        let putReq = PutBucketInventoryConfigurationRequest(
            bucket: bucket1,
            id: id,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketInventoryConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketInventoryConfigurationRequest](#PutBucketInventoryConfigurationRequest) | 是       |        | 请求参数 |



### PutBucketInventoryConfigurationRequest

|      参数名称       | **参数类型**                                      | 是否必填 | 默认值 | 描述                                                         |
| :-----------------: | ------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
|       bucket        | String                                            | 是       |        | 存储库存配置的存储桶的名称。                                 |
|         id          | String                                            | 是       |        | 用于标识库存配置的ID。                                       |
|    configuration    | [InventoryConfiguration](#InventoryConfiguration) | 是       |        | 参数的根级别标记。                                           |
| expectedBucketOwner | String                                            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### InventoryConfiguration

|        参数名称        |                 **参数类型**                  | 是否必填 | 默认值 |                             描述                             |
| :--------------------: | :-------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|      destination       | [InventoryDestination](#InventoryDestination) |    是    |        |              包含有关在何处发布清单结果的信息。              |
|       isEnabled        |                     Bool                      |    是    |        |                                                              |
|         filter         |      [InventoryFilter](#InventoryFilter)      |    否    |        |     指定资源清册筛选器。清单仅包括符合筛选器条件的对象。     |
|           id           |                    String                     |    是    |        |                    用于标识库存配置的ID。                    |
| includedObjectVersions |                    String                     |    是    |        |     要包括在库存列表中的对象版本。 有效值: All\| Current     |
|     optionalFields     |               ArrayList<String>               |    否    |        | 包含清单结果中包含的可选字段。Size \|LastModifiedDate\|StorageClass\|ETag\|IsMultipartUploaded\|\|ReplicationStatus \|EncryptionStatus\|ObjectLockRetainUntilDate\|ObjectLockMode\|ObjectLockLegalHoldStatus\|<br />IntelligentTieringAccessTier\|BucketKeyStatus\|<br />ChecksumAlgorithm\|ObjectAccessControlList\|ObjectOwner |
|        schedule        |    [InventorySchedule](#InventorySchedule)    |    是    |        |                   指定生成库存结果的计划。                   |





#### InventoryFilter

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                           |
| -------- | ------------ | -------- | ------ | ------------------------------ |
| prefix   | String       | 是       |        | 库存结果中必须包含对象的前缀。 |





#### InventoryDestination

|  参数名称  |                **参数类型**                 | 是否必填 | 默认值 |                   描述                   |
| :--------: | :-----------------------------------------: | :------: | :----: | :--------------------------------------: |
| accountId  |                   String                    |    否    |        |          目标S3桶所属的帐户ID。          |
|   bucket   |                   String                    |    是    |        |                  桶名称                  |
|   format   |                   String                    |    是    |        |         指定清单结果的输出格式。         |
|   prefix   |                   String                    |    否    |        |       附加在所有库存结果前的前缀。       |
| encryption | [InventoryEncryption](#InventoryEncryption) |    否    |        | 包含用于加密清单结果的服务器端加密类型。 |



#### InventorySchedule

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                                         |
| --------- | ------------ | -------- | ------ | -------------------------------------------- |
| frequency | String       | 是       |        | 指定生成库存结果的频率。有效值:Daily\|Weekly |





##### InventoryEncryption

| 参数名称 |   **参数类型**    | 是否必填 | 默认值 |                 描述                  |
| :------: | :---------------: | :------: | :----: | :-----------------------------------: |
|  sses3   |      String       |    否    |        | 指定使用SSE-KMS加密已交付的库存报告。 |
|  ssekms  | [SSEKMS](#SSEKMS) |    否    |        |  指定使用SSE-S3加密交付的库存报告。   |

​	



###### SSEKMS

| 参数名称 | **参数类型** | 是否必填 | 默认值 |                    描述                    |
| :------: | :----------: | :------: | :----: | :----------------------------------------: |
|  keyId   |    String    |    是    |   否   | 指定AWS密钥管理服务（AWS KMS）对称加密的ID |

### 响应参数

无











# 24、为存储桶创建新的生命周期配置或替换现有的生命周期设置

## PutBucketLifecycleConfiguration



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let config = LifecycleConfiguration(
            rules: ArrayList<LifecycleRule>(
                [
                    LifecycleRule(
                        id: "id1",
                        filter: LifecycleRuleFilter(prefix: "documents"),
                        status: "Enabled",
                        transitions: ArrayList<Transition>(
                            [
                                Transition(
                                    date: DateTime.nowUTC(),
                                    // days: 30,
                                    storageClass: "GLACIER"
                                )
                            ]
                        )
                    ),
                    LifecycleRule(
                        id: "id2",
                        filter: LifecycleRuleFilter(prefix: "logs"),
                        status: "Enabled",
                        expiration: LifecycleExpiration(date: DateTime.nowUTC())
                    )
                ]
            )
        )
        println(config.toXml())
        let putReq = PutBucketLifecycleConfigurationRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketLifecycleConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```







### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketLifecycleConfigurationRequest](#PutBucketLifecycleConfigurationRequest) | 是       |        | 请求参数 |



### PutBucketLifecycleConfigurationRequest

| 参数名称            | **参数类型**                                      | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                            | 是       |        | 要为其设置配置的存储桶的名称。                               |
| checksumAlgorithm   | String                                            | 否       |        | 指示使用SDK时用于为对象创建校验和的算法 CRC32 \| CRC32C  \|SHA1 \|SHA256 |
| configuration       | [LifecycleConfiguration](#LifecycleConfiguration) | 是       |        | 参数的根级别标记                                             |
| expectedBucketOwner | String                                            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### LifecycleConfiguration

| 参数名称 | **参数类型**                    | 是否必填 | 默认值 | 描述             |
| -------- | ------------------------------- | -------- | ------ | ---------------- |
| rules    | [LifecycleRule](#LifecycleRule) | 是       |        | 参数的根级别标记 |





#### LifecycleRule

| 参数名称                       | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                         |
| ------------------------------ | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| expiration                     | [LifecycleExpiration](#LifecycleExpiration)                  | 否       |        | 以日期、天数以及对象是否具有删除标记的形式指定对象生命周期的截止日期。 |
| id                             | String                                                       | 否       |        | 规则的唯一标识符。该值的长度不能超过255个字符。              |
| prefix                         | String                                                       | 否       |        | 标识规则所应用的一个或多个对象的前缀。                       |
| filter                         | [LifecycleRuleFilter](#LifecycleRuleFilter)                  | 否       |        | 筛选器用于标识生命周期规则应用于的对象                       |
| status                         | String                                                       | 是       |        | 如果“已启用”，则当前正在应用该规则 有效值：Enabled \|Disabled |
| transitions                    | ArrayList<[Transition](#Transition)>                         | 否       |        | 指定AmazonS3对象何时转换到指定的存储类。                     |
| noncurrentVersionTransitions   | ArrayList<[NoncurrentVersionTransition](#NoncurrentVersionTransition)> | 否       |        | 指定生命周期规则的转换规则，该规则描述非当前对象何时转换到特定存储类。 |
| noncurrentVersionExpiration    | [NoncurrentVersionExpiration](#NoncurrentVersionExpiration)  | 否       |        | 指定非当前对象版本何时过期                                   |
| abortIncompleteMultipartUpload | [AbortIncompleteMultipartUpload](#AbortIncompleteMultipartUpload) | 否       |        | 指定自启动不完整的多部分上传以来，AmazonS3在永久删除上传的所有部分之前将等待的天数 |



##### LifecycleExpiration

|         参数名称          | **参数类型** | 是否必填 | 默认值 |                             描述                             |
| :-----------------------: | :----------: | :------: | :----: | :----------------------------------------------------------: |
|           date            |   DateTime   |    否    |        |                  指示移动或删除对象的日期。                  |
|           days            |    Int32     |    否    |        | 指示受规则约束的对象的生存期（以天为单位）。该值必须是非零正整数。 |
| expiredObjectDeleteMarker |     Bool     |    否    |        |       指示AmazonS3是否会删除没有非当前版本的删除标记。       |



##### NoncurrentVersionExpiration

| 参数名称                | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ----------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| noncurrentDays          | Int32        | 否       |        | 指定在Amazon S3可以对给定版本执行关联操作之前，必须存在多少较新的非当前版本 |
| newerNoncurrentVersions | Int32        | 否       |        | 指定在AmazonS3可以执行相关操作之前，对象处于非当前状态的天数。 |



##### AbortIncompleteMultipartUpload

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                        |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------- |
| daysAfterInitiation | Int32        | 否       |        | 指定Amazon S3中止不完整的多部分上载的天数。 |



##### LifecycleRuleFilter

|       参数名称        |                     **参数类型**                      | 是否必填 | 默认值 |                            描述                             |
| :-------------------: | :---------------------------------------------------: | :------: | :----: | :---------------------------------------------------------: |
|        prefix         |                        String                         |    否    |        |           标识规则所应用的一个或多个对象的前缀。            |
|          tag          |                      [Tag](#Tag)                      |    否    |        |       此标记必须存在于对象的标记集中，才能应用规则。        |
| objectSizeGreaterThan |                         Int64                         |    否    |        |                  规则应用的最小对象大小。                   |
|  objectSizeLessThan   |                         Int64                         |    否    |        |                  规则应用的最大对象大小。                   |
|          and          | [LifecycleRuleAndOperator](#LifecycleRuleAndOperator) |    否    |        | 这在生命周期规则筛选器中用于将逻辑AND应用于两个或多个谓词。 |



###### LifecycleRuleAndOperator

| 参数名称              | **参数类型**           | 是否必填 | 默认值 | 描述                                                   |
| --------------------- | ---------------------- | -------- | ------ | ------------------------------------------------------ |
| prefix                | String                 | 否       |        | 标识规则所应用的一个或多个对象的前缀。                 |
| tags                  | ArrayList<[Tag](#Tag)> | 否       |        | 所有这些标记都必须存在于对象的标记集中，才能应用规则。 |
| objectSizeGreaterThan | Int64                  | 否       |        | 规则应用的最小对象大小。                               |
| objectSizeLessThan    | Int64                  | 否       |        | 规则应用的最大对象大小。                               |





##### Transition

| 参数名称     | **参数类型** | 是否必填 | 默认值 | 描述                                     |
| ------------ | ------------ | -------- | ------ | ---------------------------------------- |
| date         | DateTime     | 否       |        | 指示何时将对象转换到指定的存储类。       |
| days         | Int32        | 否       |        | 指示创建后将对象转换到指定存储类的天数。 |
| storageClass | String       | 否       |        | 要将对象转换到的存储类。                 |







##### NoncurrentVersionTransition

|        参数名称         | **参数类型** | 是否必填 | 默认值 |                             描述                             |
| :---------------------: | :----------: | :------: | :----: | :----------------------------------------------------------: |
|     noncurrentDays      |    Int32     |    否    |        | 指定在AmazonS3可以执行相关操作之前，对象处于非当前状态的天数。 |
|      storageClass       |    String    |    否    |        |                    用于存储对象的存储类。                    |
| newerNoncurrentVersions |    Int32     |    否    |        | 指定在Amazon S3可以对给定版本执行关联操作之前，必须存在多少较新的非当前版本 |

### 响应参数

无







# 25、设置存储桶的日志记录参数

## PutBucketLogging

并指定查看和修改日志记录参数的权限



### 示例代码

```
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketLoggingRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketLogging(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)

        let loggingStatus = LoggingStatus(
            loggingEnabled: LoggingEnabled(
                targetBucket: bucket1,
                targetPrefix: "cj-test1-access_log-"
            )
        )
        println(loggingStatus.toXml())
        let putReq = PutBucketLoggingRequest(
            bucket: bucket1,
            loggingStatus: loggingStatus
        )
        println(putReq)
        let putRsp = s3.putBucketLogging(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketLoggingRequest](#PutBucketLoggingRequest) | 是       |        | 请求参数 |



### PutBucketLoggingRequest

| 参数名称            | **参数类型**                    | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                          | 是       |        | 要为其设置日志记录参数的存储桶的名称。                       |
| contentMD5          | String                          | 否       |        | PutBucketLogging请求主体的MD5哈希。                          |
| checksumAlgorithm   | String                          | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。CRC32\|CRC32C\|SHA1\|SHA256 |
| loggingStatus       | [LoggingStatus](#LoggingStatus) | 是       |        | 参数的根级别标记。                                           |
| expectedBucketOwner | String                          | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



#### LoggingStatus

| 参数名称       | **参数类型**                      | 是否必填 | 默认值 | 描述                                                         |
| -------------- | --------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| loggingEnabled | [loggingEnabled](#loggingEnabled) | 否       |        | 描述日志的存储位置以及AmazonS3为存储桶的所有日志对象键分配的前缀。 |



##### loggingEnabled

| 参数名称     | **参数类型**                           | 是否必填 | 默认值 | 描述                         |
| ------------ | -------------------------------------- | -------- | ------ | ---------------------------- |
| targetBucket | String                                 | 否       |        | 日志对象的AmazonS3密钥格式。 |
| targetGrants | ArrayList<[TargetGrant](#TargetGrant)> | 否       |        | 用于授予信息的容器。         |
| targetPrefix | String                                 | 是       |        | 所有日志对象键的前缀。       |





###### TargetGrant

|  参数名称  | **参数类型** | 是否必填 | 默认值 |                             描述                             |
| :--------: | :----------: | :------: | :----: | :----------------------------------------------------------: |
|  grantee   |   Grantee    |    否    |        |                   被授予权限的人员的容器。                   |
| permission |    String    |    否    |        | 为存储桶分配给被授予者的日志记录权限。FULL_CONTROL\|READ\|WRITE |

### 响应参数

无









# 26、设置存储桶的度量配置（由度量配置ID指定）



## PutBucketMetricsConfiguration

### 示例代码

```
let id = "id_01"
let configuration = MetricsConfiguration(
    id: id,
    filter: MetricsFilter(
        and: MetricsAndOperator(
            prefix: "documents",
            tags: ArrayList<Tag>(
                [
                    Tag(key: "priority", value: "high"),
                    Tag(key: "class", value: "blue")
                ]
            )
        )
    )
)
println(configuration.toXml())

let putReq = PutBucketMetricsConfigurationRequest(
    bucket: bucket1,
    id: id,
    configuration: configuration
)
println(putReq)
let putRsp = s3.putBucketMetricsConfiguration(putReq)
println(putRsp)
println(putRsp.responseMetadata)
```





### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketMetricsConfigurationRequest](#PutBucketMetricsConfigurationRequest) | 是       |        | 请求参数 |





### PutBucketMetricsConfigurationRequest

|      参数名称       |                 **参数类型**                  | 是否必填 | 默认值 |                             描述                             |
| :-----------------: | :-------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|       bucket        |                    String                     |    是    |        |               为其设置度量配置的存储桶的名称。               |
|         id          |                    String                     |    是    |        | 用于标识度量配置的ID。ID有64个字符的限制，并且只能包含字母、数字、句点、短划线和下划线。 |
|    configuration    | [MetricsConfiguration](#MetricsConfiguration) |    是    |        |                      参数的根级别标记。                      |
| expectedBucketOwner |                    String                     |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### MetricsConfiguration

| 参数名称 | **参数类型**  | 是否必填 | 默认值 |          描述          |
| :------: | :-----------: | :------: | :----: | :--------------------: |
|    id    |    String     |    是    |        | 用于标识度量配置的ID。 |
|  filter  | MetricsFilter |    否    |        |  指定度量配置筛选器。  |

### 响应参数

无









# 27、为存储桶启用指定事件的通知。

## PutBucketNotificationConfiguration



### 示例代码

```
let config1 = NotificationConfiguration(
    topicConfigurations: ArrayList<TopicConfiguration>(
        [
            TopicConfiguration(
                id: "id555",
                topicArn: "arn:aws-cn:sns:cn-north-1:444455556666:s3notificationtopic",
                events: ArrayList<String>(["s3:ObjectCreated:Put", "s3:ObjectCreated:Post"]),
                filter: NotificationConfigurationFilter(
                    key: S3KeyFilter(
                        filterRules: ArrayList<FilterRule>(
                            [
                                FilterRule(name: "prefix", value: "images/"),
                                FilterRule(name: "suffix", value: "jpg")
                            ]
                        )
                    )
                )
            )
        ]
    ),
    queueConfigurations: ArrayList<QueueConfiguration>(
        [
            QueueConfiguration(
                id: "id666",
                queueArn: "arn:aws-cn:sqs:cn-north-1:444455556666:s3notificationqueue",
                events: ArrayList<String>(["s3:ObjectRemoved:DeleteMarkerCreated"])
            )
        ]
    ),
    lambdaFunctionConfigurations: ArrayList<LambdaFunctionConfiguration>(
        [
            LambdaFunctionConfiguration(
                id: "id777",
                lambdaFunctionArn: "arn:aws-cn:lambda:cn-north-1:444455556666:function:s3notificationlambda",
                events: ArrayList<String>(["s3:Replication:*"])
            )
        ]
    ),
)
println(config1.toXml())

let putReq = PutBucketNotificationConfigurationRequest(
    bucket: bucket1,
    configuration: config1
)
println(putReq)
// TODO JavaClient 也没调通, 需要指定的资源确实存在
try {
    let putRsp = s3.putBucketNotificationConfiguration(putReq)
    println(putRsp)
} catch (ex: Exception) {
    println("${KNOWN_ISSUES_1} [putBucketNotificationConfiguration]: ${ex}")
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketNotificationConfigurationRequest](#PutBucketNotificationConfigurationRequest) | 是       |        | 请求参数 |



### PutBucketNotificationConfigurationRequest

| 参数名称                  | **参数类型**                                            | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket                    | String                                                  | 是       |        | 存储桶的名称。                                               |
| configuration             | [NotificationConfiguration](#NotificationConfiguration) | 否       |        | 参数的根级别标记。                                           |
| expectedBucketOwner       | String                                                  | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| skipDestinationValidation | Bool                                                    | 是       |        | 跳过亚马逊SQS、亚马逊SNS和AWS Lambda目的地的验证。True或false值。 |







### NotificationConfiguration

| 参数名称                     | **参数类型**                                                | 是否必填 | 默认值 | 描述                                                         |
| ---------------------------- | ----------------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| topicConfigurations          | [TopicConfiguration](#TopicConfiguration)                   | 否       |        | 向其发送通知的主题以及为其生成通知的事件。                   |
| queueConfigurations          | [QueueConfiguration](#QueueConfiguration)                   | 否       |        | Amazon简单队列服务排队以向其发布消息，以及为其发布消息的事件。 |
| lambdaFunctionConfigurations | [LambdaFunctionConfiguration](#LambdaFunctionConfiguration) | 否       |        | 描述要调用的AWS Lambda函数以及要调用它们的事件。             |
| eventBridgeConfiguration     | String                                                      | 否       |        | 允许将活动传递到Amazon EventBridge。                         |



### LambdaFunctionConfiguration

| 参数名称          | **参数类型**                    | 是否必填 | 默认值 | 描述                                                         |
| ----------------- | ------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| id                | String                          | 否       |        | 通知配置中配置的可选唯一标识符。如果您不提供ID，Amazon S3将分配一个ID。 |
| lambdaFunctionArn | String                          | 是       |        | 当指定的事件类型发生时，AmazonS3调用的AWS Lambda函数的亚马逊资源名称（ARN）。 |
| events            | ArrayList<String>               | 是       |        | 要为其调用AWS Lambda函数的Amazon S3存储桶事件。 [有效值](#有效值-LambdaFunctionConfiguration) |
| filter            | NotificationConfigurationFilter | 否       |        | 指定对象密钥名称筛选规则。                                   |



##### 有效值-LambdaFunctionConfiguration

s3:ReducedRedundancyLostObject | s3:ObjectCreated:* | s3:ObjectCreated:Put | s3:ObjectCreated:Post | s3:ObjectCreated:Copy | s3:ObjectCreated:CompleteMultipartUpload | s3:ObjectRemoved:* | s3:ObjectRemoved:Delete | s3:ObjectRemoved:DeleteMarkerCreated | s3:ObjectRestore:* | s3:ObjectRestore:Post | s3:ObjectRestore:Completed | s3:Replication:* | s3:Replication:OperationFailedReplication | s3:Replication:OperationNotTracked | s3:Replication:OperationMissedThreshold | s3:Replication:OperationReplicatedAfterThreshold | s3:ObjectRestore:Delete | s3:LifecycleTransition | s3:IntelligentTiering | s3:ObjectAcl:Put | s3:LifecycleExpiration:* | s3:LifecycleExpiration:Delete | s3:LifecycleExpiration:DeleteMarkerCreated | s3:ObjectTagging:* | s3:ObjectTagging:Put | s3:ObjectTagging:Delete



### QueueConfiguration

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                         |
| -------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| id       | String                                                       | 否       |        | 通知配置中配置的可选唯一标识符。如果您不提供ID，Amazon S3将分配一个ID。 |
| queueArn | String                                                       | 是       |        | Amazon S3在检测到指定类型的事件时向其发布消息的Amazon SQS队列的Amazon资源名称（ARN）。 |
| events   | ArrayList<String>                                            | 是       |        | 要发送通知的bucket事件的集合  [有效值](#有效值-QueueConfiguration) |
| filter   | [NotificationConfigurationFilter](#NotificationConfigurationFilter) | 否       |        | 指定对象密钥名称筛选规则。                                   |



##### 有效值-QueueConfiguration

s3:ReducedRedundancyLostObject | s3:ObjectCreated:* | s3:ObjectCreated:Put | s3:ObjectCreated:Post | s3:ObjectCreated:Copy | s3:ObjectCreated:CompleteMultipartUpload | s3:ObjectRemoved:* | s3:ObjectRemoved:Delete | s3:ObjectRemoved:DeleteMarkerCreated | s3:ObjectRestore:* | s3:ObjectRestore:Post | s3:ObjectRestore:Completed | s3:Replication:* | s3:Replication:OperationFailedReplication | s3:Replication:OperationNotTracked | s3:Replication:OperationMissedThreshold | s3:Replication:OperationReplicatedAfterThreshold | s3:ObjectRestore:Delete | s3:LifecycleTransition | s3:IntelligentTiering | s3:ObjectAcl:Put | s3:LifecycleExpiration:* | s3:LifecycleExpiration:Delete | s3:LifecycleExpiration:DeleteMarkerCreated | s3:ObjectTagging:* | s3:ObjectTagging:Put | s3:ObjectTagging:Delete





#### TopicConfiguration

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                         |
| -------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| id       | String                                                       | 否       |        | 通知配置中配置的可选唯一标识符。如果您不提供ID，Amazon S3将分配一个ID。 |
| topicArn | String                                                       | 是       |        | 亚马逊S3在检测到指定类型的事件时向其发布消息的亚马逊SNS主题的亚马逊资源名称（ARN）。 |
| events   | ArrayList<String>                                            | 是       |        | 关于发送通知的AmazonS3存储桶事件。[有效值](#有效值-TopicConfiguration) |
| filter   | [NotificationConfigurationFilter](#NotificationConfigurationFilter) | 否       |        | 指定对象密钥名称筛选规则。                                   |





##### 有效值-TopicConfiguration

s3:ReducedRedundancyLostObject | s3:ObjectCreated:* | s3:ObjectCreated:Put | s3:ObjectCreated:Post | s3:ObjectCreated:Copy | s3:ObjectCreated:CompleteMultipartUpload | s3:ObjectRemoved:* | s3:ObjectRemoved:Delete | s3:ObjectRemoved:DeleteMarkerCreated | s3:ObjectRestore:* | s3:ObjectRestore:Post | s3:ObjectRestore:Completed | s3:Replication:* | s3:Replication:OperationFailedReplication | s3:Replication:OperationNotTracked | s3:Replication:OperationMissedThreshold | s3:Replication:OperationReplicatedAfterThreshold | s3:ObjectRestore:Delete | s3:LifecycleTransition | s3:IntelligentTiering | s3:ObjectAcl:Put | s3:LifecycleExpiration:* | s3:LifecycleExpiration:Delete | s3:LifecycleExpiration:DeleteMarkerCreated | s3:ObjectTagging:* | s3:ObjectTagging:Put | s3:ObjectTagging:Delete









###### NotificationConfigurationFilter

| 参数名称 | **参数类型**                | 是否必填 | 默认值 | 描述                                   |
| -------- | --------------------------- | -------- | ------ | -------------------------------------- |
| key      | [S3KeyFilter](#S3KeyFilter) | 否       |        | 对象密钥名称前缀和后缀筛选规则的容器。 |



###### S3KeyFilter

| 参数名称    | **参数类型**                         | 是否必填 | 默认值 | 描述                                       |
| ----------- | ------------------------------------ | -------- | ------ | ------------------------------------------ |
| filterRules | ArrayList<[FilterRule](#FilterRule)> | 否       |        | 键值对的容器列表，用于定义筛选规则的条件。 |



###### FilterRule

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| name     | String       | 否       |        | 对象关键字名称前缀或后缀，用于标识筛选规则所应用的一个或多个对象。有效值 prefix \|suffix |
| value    | String       | 否       |        | 筛选器在对象关键字名称中搜索的值。                           |



### 响应体

```
HTTP/1.1 200
```



### 响应参数

无







# 28、为Amazon S3存储桶创建或修改OwnershipControls。

## PutBucketOwnershipControls



### 示例代码

```
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let controls = OwnershipControls(
            rules: ArrayList<OwnershipControlsRule>([OwnershipControlsRule(objectOwnership: "BucketOwnerEnforced")]))
        println(controls.toXml())
        
        let putReq = PutBucketOwnershipControlsRequest(
            bucket: bucket1,
            ownershipControls: controls
        )
        println(putReq)
        let putRsp = s3.putBucketOwnershipControls(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutBucketOwnershipControlsRequest](#PutBucketOwnershipControlsRequest) | 是       |        | 请求参数 |



### PutBucketOwnershipControlsRequest

|      参数名称       |              **参数类型**               | 是否必填 | 默认值 |                             描述                             |
| :-----------------: | :-------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|       bucket        |                 String                  |    是    |        |      要设置其OwnershipControls的Amazon S3存储桶的名称。      |
|  ownershipControls  | [OwnershipControls](#OwnershipControls) |    是    |        |                       参数的根级别标记                       |
| expectedBucketOwner |                 String                  |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
|     contentMD5      |                 String                  |    否    |        |             OwnershipControls请求主体的MD5哈希。             |



#### OwnershipControls

| 参数名称 | **参数类型**                                               | 是否必填 | 默认值 | 描述                       |
| -------- | ---------------------------------------------------------- | -------- | ------ | -------------------------- |
| rules    | ArrayList<[OwnershipControlsRule](#OwnershipControlsRule)> | 是       |        | 所有权控制规则的容器元素。 |





##### OwnershipControlsRule

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| objectOwnership | String       | 是       |        | 桶的所有权控件的对象所有权的容器元素。 有效值: BucketOwnerPreferred \| ObjectWriter \| BucketOwnerEnforced |



### 响应参数

无









# 29、将AmazonS3存储桶策略应用于AmazonS3的存储桶。

## PutBucketPolicy



### 示例代码

```
        let policy = """
{
    "Version": "2008-10-17",
    "Id": "aaaa-bbbb-cccc-dddd",
    "Statement": [
        {
            "Effect": "Allow",
            "Sid": "1",
            "Principal": {
                "AWS": [
                    "${accountId}"
                ]
            },
            "Action": [
                "s3:*"
            ],
            "Resource": "${bucket1_arn}"
        }
    ]
}
        """
        let putReq = PutBucketPolicyRequest(
            bucket: bucket1,
            policy: policy
        )
        println(putReq)
        let putRsp = s3.putBucketPolicy(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
```





### 请求参数列表

| 参数名称 | **参数类型**                                      | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketPolicyRequest](#PutBucketPolicyRequest) | 是       |        | 请求参数 |



### PutBucketPolicyRequest

|           参数名称            | **参数类型** | 是否必填 | 默认值 |                             描述                             |
| :---------------------------: | :----------: | :------: | :----: | :----------------------------------------------------------: |
|            bucket             |    String    |    是    |        |                        存储桶的名称。                        |
|          contentMD5           |    String    |    否    |        |                     请求主体的MD5哈希。                      |
|       checksumAlgorithm       |    String    |    否    |        |          指示使用SDK时用于为对象创建校验和的算法。           |
| confirmRemoveSelfBucketAccess |     Bool     |    否    |        | 将此参数设置为true以确认您希望删除您的权限以在将来更改此存储桶策略 |
|      expectedBucketOwner      |    String    |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
|       [policy](#policy)       |    String    |    否    |        |                该请求接受以下JSON格式的数据。                |







#### policy

|           参数名称            | **参数类型** | 是否必填 | 默认值 |                             描述                             |
| :---------------------------: | :----------: | :------: | :----: | :----------------------------------------------------------: |
|            bucket             |    String    |    是    |        |                        存储桶的名称。                        |
|          contentMD5           |    String    |    是    |        |                     请求主体的MD5哈希。                      |
| confirmRemoveSelfBucketAccess |     Bool     |    否    |        | 将此参数设置为true以确认您希望删除您的权限以在将来更改此存储桶策略。 |
|      expectedBucketOwner      |    String    |    否    |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
|       checksumAlgorithm       |    String    |    否    |        | 使用SDK时为对象创建校验和时使用的算法。有效值:CRC32\|CRC32C\|SHA1\|SHA256 |



### 响应参数

无







# 30、创建复制配置或替换现有配置

## PutBucketReplication





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let config = ReplicationConfiguration(
            role: "${role_arn}",
            rules: ArrayList<ReplicationRule>(
                [
                    ReplicationRule(
                        id: "rule1",
                        status: "Enabled",
                        priority: 1,
                        deleteMarkerReplication: DeleteMarkerReplication(status: "Disabled"),
                        filter: ReplicationRuleFilter(
                            and: ReplicationRuleAndOperator(
                                prefix: "TaxDocs",
                                tags: ArrayList<Tag>(
                                    [
                                        Tag(key: "key1", value: "value1"),
                                        Tag(key: "key2", value: "value2")
                                    ]
                                )
                            )
                        ),
                        destination: Destination(bucket: bucket2_arn)
                    )
                ]
            )
        )
        println(config.toXml())
        let putReq = PutBucketReplicationRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketReplication(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```







##### 请求参数列表

| 参数名称 | **参数类型**                                                | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketReplicationRequest](#PutBucketReplicationRequest) | 是       |        | 请求描述 |



### PutBucketReplicationRequest

| 参数名称            | **参数类型**                                          | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ----------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                                | 是       |        | 桶的名称                                                     |
| contentMD5          | String                                                | 否       |        | base64编码的128位MD5数据摘要。                               |
| checksumAlgorithm   | String                                                | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值:CRC32 \|CRC32C \| SHA1 \|SHA256 |
| configuration       | [ReplicationConfiguration](#ReplicationConfiguration) | 是       |        | 参数的根级别标记。                                           |
| expectedBucketOwner | String                                                | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| token               | String                                                | 否       |        | 允许为现有存储桶启用对象锁定的令牌。                         |



#### ReplicationConfiguration

| 参数名称 |        **参数类型**        | 是否必填 | 默认值 |                             描述                             |
| :------: | :------------------------: | :------: | :----: | :----------------------------------------------------------: |
|   role   |           String           |    是    |        | 亚马逊S3在复制对象时承担的AWS身份和访问管理（IAM）角色的亚马逊资源名称（ARN） |
|  rules   | ArrayList<ReplicationRule> |    是    |        | 一个或多个复制规则的容器。复制配置必须至少有一个规则，并且最多可以包含1000个规则。 |







##### ReplicationRule

|         参数名称          |                      **参数类型**                       | 是否必填 | 默认值 |                             描述                             |
| :-----------------------: | :-----------------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|            id             |                         String                          |    否    |        |            规则的唯一标识符。最大值为255个字符。             |
|         priority          |                          Int32                          |    否    |        | 优先级指示当两个或多个复制规则发生冲突时哪个规则具有优先级。 |
|          prefix           |                         String                          |    否    |        |   对象关键字名称前缀，用于标识规则所应用的一个或多个对象。   |
|          filter           |     [ReplicationRuleFilter](#ReplicationRuleFilter)     |    否    |        |       一个筛选器，用于标识复制规则所应用的对象的子集。       |
|          status           |                         String                          |    是    |        |        指定是否启用规则。  有效值：Enabled \|Disabled        |
|  sourceSelectionCriteria  |   [SourceSelectionCriteria](#SourceSelectionCriteria)   |    否    |        |                                                              |
| existingObjectReplication | [ExistingObjectReplication](#ExistingObjectReplication) |    否    |        |               复制现有源存储桶对象的可选配置。               |
|        destination        |               [Destination](#Destination)               |    是    |        | 一个容器，用于存储有关复制目标及其配置的信息，包括启用S3复制时间控制（S3 RTC）。 |
|  deleteMarkerReplication  |   [DeleteMarkerReplication](#DeleteMarkerReplication)   |    否    |        |               指定Amazon S3是否复制删除标记。                |





###### ReplicationRuleFilter

| 参数名称 |                       **参数类型**                        | 是否必填 | 默认值 |                            描述                            |
| :------: | :-------------------------------------------------------: | :------: | :----: | :--------------------------------------------------------: |
|  prefix  |                          String                           |    否    |        |     对象关键字名称前缀，用于标识规则所应用的对象子集。     |
|   tag    |                        [Tag](#Tag)                        |    否    |        |                 用于指定标记键和值的容器。                 |
|   and    | [ReplicationRuleAndOperator](#ReplicationRuleAndOperator) |    否    |        | 用于指定规则筛选器的容器。过滤器确定应用规则的对象的子集。 |



###### ReplicationRuleAndOperator

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述                                               |
| -------- | ---------------------- | -------- | ------ | -------------------------------------------------- |
| prefix   | String                 | 否       |        | 对象关键字名称前缀，用于标识规则所应用的对象子集。 |
| tags     | ArrayList<[Tag](#Tag)> | 否       |        | 包含键和值对的标记数组。                           |





###### SourceSelectionCriteria

| 参数名称               | **参数类型**                                      | 是否必填 | 默认值 | 描述                                                      |
| ---------------------- | ------------------------------------------------- | -------- | ------ | --------------------------------------------------------- |
| sseKmsEncryptedObjects | [SseKmsEncryptedObjects](#SseKmsEncryptedObjects) | 否       |        | 用于筛选使用AWS KMS加密的AmazonS3对象的过滤器信息的容器。 |
| replicaModifications   | [ReplicaModifications](#ReplicaModifications)     | 否       |        | 一个筛选器，您可以为复制副本上的修改选择指定该筛选器。    |



###### SseKmsEncryptedObjects

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| status   | String       | 是       |        | 指定Amazon S3是否使用存储在AWS密钥管理服务中的AWS KMS密钥复制通过服务器端加密创建的对象。有效值： Enabled\|Disabled |





###### ReplicaModifications

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                |
| -------- | ------------ | -------- | ------ | ----------------------------------- |
| status   | String       | 是       |        | 指定Amazon S3是否在副本上复制修改。 |





###### ExistingObjectReplication

| 参数名称 | **参数类型** | 是否必填 | 默认值 |                 描述                 |
| :------: | :----------: | -------- | :----: | :----------------------------------: |
|  status  |    String    | 是       |        | 指定AmazonS3是否复制现有的源桶对象。 |



###### Destination

|         参数名称         |                     **参数类型**                      | 是否必填 | 默认值 |                             描述                             |
| :----------------------: | :---------------------------------------------------: | :------: | :----: | :----------------------------------------------------------: |
|          bucket          |                        String                         |    是    |        |   您希望AmazonS3存储结果的存储桶的Amazon资源名称（ARN）。    |
|         account          |                        String                         |    否    |        |                   目标存储桶所有者帐户ID。                   |
|       storageClass       |                        String                         |    否    |        | 复制对象时要使用的存储类，如S3标准或减少冗余。有效值：STANDARD\|REDUCED_REDUNDANCY\|STANDARD_IA\|ONEZONE_IA\|<br />INTELLIGENT_TIERING\|GLACIER\|DEEP_ARCHIVE\|OUTPOSTS\|GLACIER_IR<br />SNOW\|EXPRESS_ONEZONE |
| accessControlTranslation | [AccessControlTranslation](#AccessControlTranslation) |    否    |        | 仅在跨帐户场景中指定此项（其中源和目标存储桶所有者不相同），并且您希望将副本所有权更改为拥有目标存储桶的AWS帐户。 |
| encryptionConfiguration  |  [EncryptionConfiguration](#EncryptionConfiguration)  |    否    |        |                   提供有关加密信息的容器。                   |
|     replicationTime      |          [ReplicationTime](#ReplicationTime)          |    否    |        | 指定S3复制时间控制（S3 RTC）的容器，包括是否启用S3 RTC以及必须复制所有对象和对象上的操作的时间。 |
|         metrics          |                  [Metrics](#Metrics)                  |    否    |        |  一个容器，指定与复制度量相关的设置，以启用复制度量和事件。  |



###### AccessControlTranslation

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                     |
| -------- | ------------ | -------- | ------ | ---------------------------------------- |
| owner    | String       | 是       |        | 指定复制副本的所有权。有效值:Destination |



###### EncryptionConfiguration

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| replicaKmsKeyID | String       | 否       |        | 指定存储在目标存储桶的AWS密钥管理服务（KMS）中的客户管理的AWS KMS密钥的ID（密钥ARN或别名ARN）。 |



###### Metrics

| 参数名称       | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                         |
| -------------- | --------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| status         | String                                        | 是       |        | 指定是否启用复制指标。有效值:Enabled\|Disabled               |
| eventThreshold | [ReplicationTimeValue](#ReplicationTimeValue) | 否       |        | 指定发出s3:Replication:OperationMissedThreshold事件的时间阈值的容器。 |



###### ReplicationTimeValue

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| -------- | ------------ | -------- | ------ | ------------------------------------ |
| minutes  | Int32        | 否       |        | 包含一个以分钟为单位指定时间的整数。 |



###### ReplicationTime

| 参数名称 | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                 |
| -------- | --------------------------------------------- | -------- | ------ | ---------------------------------------------------- |
| status   | String                                        | 是       |        | 指定是否启用复制时间。 有效值：Enabled\|Disabled     |
| time     | [ReplicationTimeValue](#ReplicationTimeValue) | 是       |        | 一个容器，指定所有对象和对象上的操作的复制完成时间。 |





###### DeleteMarkerReplication

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                             |
| -------- | ------------ | -------- | ------ | ------------------------------------------------ |
| status   | String       | 否       |        | 指示是否复制删除标记。 有效值：Enabled\|Disabled |

### 响应参数

无





# 31、设置存储桶的请求付款配置。



## PutBucketRequestPayment



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let config = RequestPaymentConfiguration(payer: "Requester")
        println(config.toXml())
        let putReq = PutBucketRequestPaymentRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketRequestPayment(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                               | 是否必填 | 默认值 | 描述     |
| -------- | ---------------------------------------------------------- | -------- | ------ | -------- |
| putRsp   | [putBucketRequestPayment](#PutBucketRequestPaymentRequest) | 是       |        | 请求参数 |



### PutBucketRequestPaymentRequest

| 参数名称            | **参数类型**                                                | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ----------------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                                      | 是       |        | 存储桶名称。                                                 |
| contentMD5          | String                                                      | 否       |        | base64编码的128位MD5数据摘要。                               |
| checksumAlgorithm   | String                                                      | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值：CRC32\|CRC32C\|SHA1\|SHA256 |
| configuration       | [RequestPaymentConfiguration](#RequestPaymentConfiguration) | 否       |        | 参数的根级别标记                                             |
| expectedBucketOwner | String                                                      | 否       |        | 预期存储桶所有者的帐户ID。                                   |



#### RequestPaymentConfiguration

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                           |
| -------- | ------------ | -------- | ------ | ------------------------------ |
| payer    | String       | 是       |        | 有效值为Requester\|BucketOwner |

### 响应参数

无







# 31、设置存储桶的标记。

## PutBucketTagging



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let tagging = Tagging(
            tagSet: ArrayList<Tag>(
                [
                    Tag(key: "key1", value: "value1"),
                    Tag(key: "key2", value: "value2")
                ]
            )
        )
        println(tagging.toXml())
        let putReq = PutBucketTaggingRequest(
            bucket: bucket1,
            tagging: tagging
        )
        println(putReq)
        let putRsp = s3.putBucketTagging(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketTaggingRequest](#PutBucketTaggingRequest) | 是       |        | 请求参数 |



###### PutBucketTaggingRequest

| 参数名称            | **参数类型**        | 是否必填 | 默认值 | 描述                                    |
| ------------------- | ------------------- | -------- | ------ | --------------------------------------- |
| bucket              | String              | 是       |        | 存储桶名称。                            |
| contentMD5          | String              | 否       |        | base64编码的128位MD5数据摘要。          |
| checksumAlgorithm   | String              | 否       |        | 指示使用SDK时用于为对象创建校验和的算法 |
| tagging             | [Tagging](#Tagging) | 否       |        | 标记参数的根级别标记。                  |
| expectedBucketOwner | String              | 否       |        | 预期存储桶所有者的帐户ID。              |



###### Tagging

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述                   |
| -------- | ---------------------- | -------- | ------ | ---------------------- |
| tagSet   | ArrayList<[Tag](#Tag)> | 是       |        | 标记参数的根级别标记。 |

### 响应参数

无









# 32、设置现有存储桶的版本控制状态。



## PutBucketVersioning





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let config = VersioningConfiguration(
            // mfaDelete: "Enabled",
            status: "Enabled")
        println(config.toXml())
        let putReq = PutBucketVersioningRequest(
            bucket: bucket2,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketVersioning(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketVersioningRequest](#PutBucketVersioningRequest) | 是       |        | 请求参数 |



### PutBucketVersioningRequest

| 参数名称            | **参数类型**                                        | 是否必填 | 默认值 | 描述                                                       |
| ------------------- | --------------------------------------------------- | -------- | ------ | ---------------------------------------------------------- |
| bucket              | String                                              | 是       |        | 存储桶名称。                                               |
| contentMD5          | String                                              | 否       |        | base64编码的128位MD5数据摘要。                             |
| checksumAlgorithm   | String                                              | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。                  |
| mfa                 | String                                              | 否       |        | 身份验证设备的序列号、空格和身份验证设备上显示的值的串联。 |
| configuration       | [VersioningConfiguration](#VersioningConfiguration) | 是       |        | 参数的根级别标记。                                         |
| expectedBucketOwner | String                                              | 否       |        | 预期存储桶所有者的帐户ID。                                 |





#### VersioningConfiguration

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| status    | String       | 否       |        | 存储桶的版本控制状态。有效值：Enabled\|Suspended             |
| mfaDelete | String       | 否       |        | 指定是否在存储段版本控制配置中启用MFA删除。有效值：Enabled\|Disabled |

### 响应参数

无









# 33、设置在网站子资源中指定的网站的配置。

## PutBucketWebsite



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
let config = WebsiteConfiguration(
            errorDocument: ErrorDocument(key: "SomeErrorDocument.html"),
            indexDocument: IndexDocument(suffix: "index.html"),
             redirectAllRequestsTo: RedirectAllRequestsTo(hostName: "baidu.com"),
             routingRules: ArrayList<RoutingRule>(
                 [
                     RoutingRule(
                         redirect: Redirect(
                             hostName: "hostName",
                             httpRedirectCode: "302",
                             protocol: "http",
                             replaceKeyPrefixWith: "prefixWith",
                             replaceKeyWith: "with"
                         )
                     )
                 ]
            )
        )
        println(config.toXml())
        let putReq = PutBucketWebsiteRequest(
            bucket: bucket1,
            configuration: config
        )
        println(putReq)
        let putRsp = s3.putBucketWebsite(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutBucketWebsiteRequest](#PutBucketWebsiteRequest) | 是       |        | 请求参数 |





### PutBucketWebsiteRequest

| 参数名称            | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | --------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                        | 否       |        | 存储桶名称。                                                 |
| contentMD5          | String                                        | 是       |        | base64编码的128位MD5数据摘要                                 |
| checksumAlgorithm   | String                                        | 是       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值：CRC32\|CRC32C\|SHA1 \| SHA256 |
| configuration       | [WebsiteConfiguration](#WebsiteConfiguration) | 是       |        | 网站配置参数的根级别标记。                                   |
| expectedBucketOwner | String                                        | 是       |        | 预期存储桶所有者的帐户ID。                                   |





#### WebsiteConfiguration

| 参数名称              | **参数类型**                                    | 是否必填 | 默认值 | 描述                                         |
| --------------------- | ----------------------------------------------- | -------- | ------ | -------------------------------------------- |
| errorDocument         | [ErrorDocument](#ErrorDocument)                 | 否       |        | 网站的错误文档的名称。                       |
| indexDocument         | [IndexDocument](#IndexDocument)                 | 否       |        | 网站的索引文档的名称。                       |
| redirectAllRequestsTo | [RedirectAllRequestsTo](#RedirectAllRequestsTo) | 否       |        | 将每个请求重定向到此bucket的网站端点的行为。 |
| routingRules          | ArrayList<[RoutingRule](#RoutingRule)>          | 否       |        | 定义何时应用重定向以及重定向行为的规则。     |





##### ErrorDocument

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                  |
| -------- | ------------ | -------- | ------ | ------------------------------------- |
| key      | String       | 是       |        | 发生4XX类错误时要使用的对象密钥名称。 |





##### IndexDocument

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述               |
| -------- | ------------ | -------- | ------ | ------------------ |
| suffix   | String       | 是       |        | Suffix元素的容器。 |



##### RedirectAllRequestsTo

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                     |
| -------- | ------------ | -------- | ------ | ------------------------ |
| hostName | String       | 是       |        | 重定向请求的主机的名称。 |
| protocol | String       | 否       |        | 重定向请求时要使用的协议 |



##### RoutingRule

| 参数名称  | **参数类型**            | 是否必填 | 默认值 | 描述                                             |
| --------- | ----------------------- | -------- | ------ | ------------------------------------------------ |
| condition | [Condition](#Condition) | 否       |        | 一个容器，用于描述要应用指定重定向必须满足的条件 |
| redirect  | [Redirect](#Redirect)   | 是       |        | 重定向信息的容器。                               |





###### Condition

| 参数名称                    | **参数类型** | 是否必填 | 默认值 | 描述                           |
| --------------------------- | ------------ | -------- | ------ | ------------------------------ |
| httpErrorCodeReturnedEquals | String       | 否       |        | 应用重定向时的HTTP错误代码     |
| keyPrefixEquals             | String       | 否       |        | 应用重定向时的对象密钥名称前缀 |





###### Redirect

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                         |
| -------------------- | ------------ | -------- | ------ | -------------------------------------------- |
| hostName             | String       | 否       |        | 要在重定向请求中使用的主机名。               |
| httpRedirectCode     | String       | 否       |        | 用于响应的HTTP重定向代码。                   |
| protocol             | String       | 否       |        | 重定向请求时要使用的协议,有效值：http\|https |
| replaceKeyPrefixWith | String       | 否       |        | 要在重定向请求中使用的对象密钥前缀           |
| replaceKeyWith       | String       | 否       |        | 要在重定向请求中使用的特定对象密钥           |

### 响应参数

无





# 34、GET操作的此实现使用accelerate子资源来返回bucket的Transfer Acceleration状态

## GetBucketAccelerateConfiguration



### 示例代码

```json
        let rspXml = """
<AccelerateConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/"> 
 <Status>Enabled</Status>
</AccelerateConfiguration>
"""
        @Expect(AccelerateConfiguration.fromXml(S3XmlElement.fromXml(rspXml)).status == "Enabled")
        // TODO JavaClient 也没调通
        let getReq = GetBucketAccelerateConfigurationRequest(bucket: bucket1)
        println(getReq)
        try {
            let getRsp = s3.getBucketAccelerateConfiguration(getReq)
            println(getRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [getBucketAccelerateConfiguration]: ${ex}")
        }
```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketAccelerateConfigurationRequest](#GetBucketAccelerateConfigurationRequest) | 是       |        | 请求参数 |



#### GetBucketAccelerateConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                     |
| ------------------- | ------------ | -------- | ------ | ---------------------------------------- |
| bucket              | String       |          |        | 为其检索加速配置的存储桶的名称。         |
| expectedBucketOwner | String       |          |        | 预期存储桶所有者的帐户ID                 |
| requestPayer        | String       |          |        | 确认请求者知道他们将因请求而被收取费用。 |



### 响应参数

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                        |
| -------------- | ------------ | -------- | ------ | ----------------------------------------------------------- |
| requestCharged | String       | 是       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester |
| Status         | String       | 是       |        | 桶的加速配置。有效值：Enabled\|Suspended                    |







# 35、GET操作的此实现使用acl子资源来返回bucket的访问控制列表（acl）。

## GetBucketAcl



### 示例代码

```json
  @Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
      let getReq = GetBucketAclRequest(bucket: bucket2)
        println(getReq)
        let getRsp = s3.getBucketAcl(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketAclRequest](#GetBucketAclRequest) | 是       |        | 请求参数 |



#### GetBucketAclRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                          |
| ------------------- | ------------ | -------- | ------ | ----------------------------- |
| bucket              | String       | 是       |        | 指定正在请求其ACL的S3存储桶。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。    |





### 响应参数



### 响应参数

| 参数名称 | **参数类型**    | 是否必填 | 默认值 | 描述                               |
| -------- | --------------- | -------- | ------ | ---------------------------------- |
| Grants   | [Grant](#Grant) | 否       |        | 赠款清单。                         |
| Owner    | [Owner](#Owner) | 否       |        | 存储桶所有者的显示名称和ID的容器。 |



#### Owner

| 参数名称    | **参数类型** | 是否必填 | 默认值 | 描述                   |
| ----------- | ------------ | -------- | ------ | ---------------------- |
| DisplayName | String       | 否       |        | 所有者显示名称的容器。 |
| ID          | String       | 否       |        | 所有者ID的容器。       |



#### Grant

| 参数名称   | **参数类型**        | 是否必填 | 默认值 | 描述                     |
| ---------- | ------------------- | -------- | ------ | ------------------------ |
| Grantee    | [Grantee](#Grantee) | 否       |        | 被授予权限的人。         |
| Permission | String              | 否       |        | 指定授予被授予者的权限。 |





# 36、GET操作的此实现从bucket返回分析配置（由分析配置ID标识）。

## GetBucketAnalyticsConfiguration



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketAnalyticsConfigurationRequest(
            bucket: bucket1,
            id: id
        )
        println(getReq)
        let getRsp = s3.getBucketAnalyticsConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```



### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketAnalyticsConfigurationRequest](#GetBucketAnalyticsConfigurationRequest) | 是       |        | 请求参数 |

### GetBucketAnalyticsConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                             |
| ------------------- | ------------ | -------- | ------ | -------------------------------- |
| bucket              | String       | 是       |        | 从中检索分析配置的存储桶的名称。 |
| id                  | String       | 是       |        | 标识分析配置的ID。               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。       |





#### 响应体

```json
HTTP/1.1 200
<?xml version="1.0" encoding="UTF-8"?>
<AnalyticsConfiguration>
   <Id>string</Id>
   <Filter>
      <And>
         <Prefix>string</Prefix>
         <Tag>
            <Key>string</Key>
            <Value>string</Value>
         </Tag>
         ...
      </And>
      <Prefix>string</Prefix>
      <Tag>
         <Key>string</Key>
         <Value>string</Value>
      </Tag>
   </Filter>
   <StorageClassAnalysis>
      <DataExport>
         <Destination>
            <S3BucketDestination>
               <Bucket>string</Bucket>
               <BucketAccountId>string</BucketAccountId>
               <Format>string</Format>
               <Prefix>string</Prefix>
            </S3BucketDestination>
         </Destination>
         <OutputSchemaVersion>string</OutputSchemaVersion>
      </DataExport>
   </StorageClassAnalysis>
</AnalyticsConfiguration>
```





#### 响应参数

| 参数名称               | **参数类型**                                      | 是否必填 | 默认值 | 描述               |
| ---------------------- | ------------------------------------------------- | -------- | ------ | ------------------ |
| AnalyticsConfiguration | [AnalyticsConfiguration](#AnalyticsConfiguration) | 是       |        | 参数的根级别标记。 |



##### AnalyticsConfiguration

| 参数名称             | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | --------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| Filter               | [AnalyticsFilter](#AnalyticsFilter)           | 否       |        | 用于描述一组分析对象的筛选器。                               |
| id                   | String                                        | 否       |        | 标识分析配置的ID。                                           |
| StorageClassAnalysis | [StorageClassAnalysis](#StorageClassAnalysis) | 否       |        | 包含与访问模式相关的数据，这些数据将被收集并可用于分析不同存储类之间的权衡。 |











# 37、返回为存储桶设置的跨来源资源共享（CORS）配置信息。

## GetBucketCors



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketCorsRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketCors(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                  | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketCorsRequest](#GetBucketCorsRequest) | 是       |        | 请求参数 |



#### GetBucketCorsRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                           |
| ------------------- | ------------ | -------- | ------ | ------------------------------ |
| bucket              | String       | 是       |        | 要获取其cors配置的存储桶名称。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。     |



#### 响应体

```json
HTTP/1.1 200
<?xml version="1.0" encoding="UTF-8"?>
<CORSConfiguration>
   <CORSRule>
      <AllowedHeader>string</AllowedHeader>
      ...
      <AllowedMethod>string</AllowedMethod>
      ...
      <AllowedOrigin>string</AllowedOrigin>
      ...
      <ExposeHeader>string</ExposeHeader>
      ...
      <ID>string</ID>
      <MaxAgeSeconds>Int64</MaxAgeSeconds>
   </CORSRule>
   ...
</CORSConfiguration>
```



#### 响应参数

| 参数名称 | **参数类型**          | 是否必填 | 默认值 | 描述                                                         |
| -------- | --------------------- | -------- | ------ | ------------------------------------------------------------ |
| CORSRule | [CORSRule](#CORSRule) | 否       |        | 一组原点和方法（要允许的跨原点访问）。您最多可以向配置中添加100条规则。 |









# 38、返回AmazonS3存储桶的默认加密配置。

## GetBucketEncryption



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketEncryptionRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketEncryption(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述         |
| -------- | --------------------------------------------------------- | -------- | ------ | ------------ |
| getReq   | [GetBucketEncryptionRequest](#GetBucketEncryptionRequest) | 是       |        | 请求参数对象 |





### GetBucketEncryptionRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                     |
| ------------------- | ------------ | -------- | ------ | ---------------------------------------- |
| bucket              | String       | 是       |        | 从中检索服务器端加密配置的存储桶的名称。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。               |





### 响应体

```json
HTTP/1.1 200
<?xml version="1.0" encoding="UTF-8"?>
<ServerSideEncryptionConfiguration>
   <Rule>
      <ApplyServerSideEncryptionByDefault>
         <KMSMasterKeyID>string</KMSMasterKeyID>
         <SSEAlgorithm>string</SSEAlgorithm>
      </ApplyServerSideEncryptionByDefault>
      <BucketKeyEnabled>Bool</BucketKeyEnabled>
   </Rule>
   ...
</ServerSideEncryptionConfiguration>
```





### 响应参数



| 参数名称      | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                       |
| ------------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------ |
| configuration | [ServerSideEncryptionConfiguration](#ServerSideEncryptionConfiguration) | 否       |        | 有关特定服务器端加密配置规则的信息的容器。 |



#### ServerSideEncryptionConfiguration

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                       |
| -------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------ |
| rules    | ArrayList<[ServerSideEncryptionRule](#ServerSideEncryptionRule)> | 否       |        | 有关特定服务器端加密配置规则的信息的容器。 |







# 39、从指定的存储桶中获取S3智能分层配置。

## GetBucketIntelligentTieringConfiguration



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketIntelligentTieringConfigurationRequest(bucket: bucket1, id: id)
        println(getReq)
        let getRsp = s3.getBucketIntelligentTieringConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketIntelligentTieringConfigurationRequest](#GetBucketIntelligentTieringConfigurationRequest) | 是       |        | 参数对象 |



### GetBucketIntelligentTieringConfigurationRequest

| 参数名称      | **参数类型**                    | 是否必填 | 默认值 | 描述                                       |
| ------------- | ------------------------------- | -------- | ------ | ------------------------------------------ |
| configuration | IntelligentTieringConfiguration | 是       |        | 要修改或检索其配置的AmazonS3存储桶的名称。 |
| id            | String                          | 是       |        | 用于标识S3智能分层配置的ID。               |



### 响应参数

| 参数名称      | **参数类型**                                                 | 是否必填 | 默认值 | 描述       |
| ------------- | ------------------------------------------------------------ | -------- | ------ | ---------- |
| configuration | [IntelligentTieringConfiguration](#IntelligentTieringConfiguration) | 是       |        | 参数跟目录 |



#### IntelligentTieringConfiguration

| 参数名称 | **参数类型**                                          | 是否必填 | 默认值 | 描述                           |
| -------- | ----------------------------------------------------- | -------- | ------ | ------------------------------ |
| Filter   | [IntelligentTieringFilter](#IntelligentTieringFilter) | 否       |        | 指定bucket筛选器。             |
| Id       | String                                                | 否       |        | 用于标识S3智能分层配置的ID。   |
| Status   | String                                                | 否       |        | 指定配置的状态。               |
| Tiering  | [Tiering](#Tiering)                                   | 否       |        | 指定配置的S3智能分层存储类层。 |







#### Tiering

| 参数名称   | **参数类型** | 是否必填 | 默认值 | 描述                                                 |
| ---------- | ------------ | -------- | ------ | ---------------------------------------------------- |
| AccessTier | String       | 是       |        | S3智能分层访问层。                                   |
| Days       | Int64        | 是       |        | 连续无访问天数，在此之后对象将有资格转换到相应的层。 |









# 40、从存储桶中返回库存配置（由库存配置ID标识）。

## GetBucketInventoryConfiguration

### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketInventoryConfigurationRequest(
            bucket: bucket1,
            id: id
        )
        println(getReq)
        let getRsp = s3.getBucketInventoryConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```







### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketInventoryConfigurationRequest](#GetBucketInventoryConfigurationRequest) | 是       |        | 参数对象 |





#### GetBucketInventoryConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称。             |
| id                  | String       | 是       |        | 用于标识库存配置的ID。     |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

| 参数名称      | **参数类型**                                      | 是否必填 | 默认值 | 描述               |
| ------------- | ------------------------------------------------- | -------- | ------ | ------------------ |
| configuration | [InventoryConfiguration](#InventoryConfiguration) | 是       |        | 参数的根级别标记。 |











# 41、返回bucket上设置的生命周期配置信息



## GetBucketLifecycleConfiguration



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketLifecycleConfigurationRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketLifecycleConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketLifecycleConfigurationRequest](#GetBucketLifecycleConfigurationRequest) | 是       |        | 参数对象 |



#### GetBucketLifecycleConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称。             |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |





### 响应参数

| 参数名称 | **参数类型**                               | 是否必填 | 默认值 | 描述               |
| -------- | ------------------------------------------ | -------- | ------ | ------------------ |
| rules    | ArrayList<[LifecycleRule](#LifecycleRule)> | 是       |        | 参数的根级别标记。 |



##### LifecycleRule

| 参数名称 | **参数类型**                    | 是否必填 | 默认值 | 描述                 |
| -------- | ------------------------------- | -------- | ------ | -------------------- |
| Rule     | [LifecycleRule](#LifecycleRule) | 是       |        | 生命周期规则的容器。 |







# 42、返回桶所在的区域。



## GetBucketLocation



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketLocationRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.GetBucketLocation(getReq)
        println(getRsp)
        rintln(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称                 | **参数类型**                                          | 是否必填 | 默认值 | 描述     |
| ------------------------ | ----------------------------------------------------- | -------- | ------ | -------- |
| GetBucketLocationRequest | [GetBucketLocationRequest](#GetBucketLocationRequest) | 否       |        | 对象参数 |



### GetBucketLocationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 否       |        | 存储桶的名称               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

#### LocationConstraint

| 参数名称           | **参数类型** | 是否必填 | 默认值 | 描述                 |
| ------------------ | ------------ | -------- | ------ | -------------------- |
| locationConstraint | String       | 否       |        | 指定存储桶所在的区域 |















# 43、返回存储桶的日志记录状态以及用户查看和修改该状态的权限。

## GetBucketLogging



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketLoggingRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketLogging(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称                | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| ----------------------- | --------------------------------------------------- | -------- | ------ | -------- |
| GetBucketLoggingRequest | [GetBucketLoggingRequest](#GetBucketLoggingRequest) | 否       |        | 参数对象 |





#### GetBucketLoggingRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶名称                 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |





### 响应参数

| 参数名称       | **参数类型**                      | 是否必填 | 默认值 | 描述                                                         |
| -------------- | --------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| LoggingEnabled | [LoggingEnabled](#LoggingEnabled) | 否       |        | 描述日志的存储位置以及AmazonS3为存储桶的所有日志对象键分配的前缀 |







# 44、从存储桶中获取度量配置（由度量配置ID指定）。

## GetBucketMetricsConfiguration





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketMetricsConfigurationRequest(
            bucket: bucket1,
            id: id
        )
        println(getReq)
        let getRsp = s3.getBucketMetricsConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```





### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketMetricsConfigurationRequest](#GetBucketMetricsConfigurationRequest) | 是       |        | 参数对象 |







#### GetBucketMetricsConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称。             |
| id                  | String       | 是       |        | 用于标识度量配置的ID       |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数



| 参数名称             | **参数类型**                                  | 是否必填 | 默认值 | 描述               |
| -------------------- | --------------------------------------------- | -------- | ------ | ------------------ |
| MetricsConfiguration | [MetricsConfiguration](#MetricsConfiguration) | 是       |        | 参数的根级别标记。 |











# 45、返回桶的通知配置。

## GetBucketNotificationConfiguration





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketNotificationConfigurationRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketNotificationConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述               |
| -------- | ------------------------------------------------------------ | -------- | ------ | ------------------ |
| getReq   | [GetBucketNotificationConfigurationRequest](#GetBucketNotificationConfigurationRequest) | 否       |        | 返回桶的通知配置。 |





#### GetBucketNotificationConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       |          |        | 存储桶的名称               |
| expectedBucketOwner | String       |          |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

| 参数名称                  | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| ------------------------- | ------------------------------------------------------- | -------- | ------ | -------- |
| NotificationConfiguration | [NotificationConfiguration](#NotificationConfiguration) | 是       |        | 参数对象 |





#### NotificationConfiguration

| 参数名称                   | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                         |
| -------------------------- | ------------------------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| CloudFunctionConfiguration | ArrayList<[LambdaFunctionConfiguration](#LambdaFunctionConfiguration)> | 是       |        | 描述要调用的AWS Lambda函数以及要调用它们的事件。             |
| EventBridgeConfiguration   | [EventBridgeConfiguration](#EventBridgeConfiguration)        | 否       |        | 允许将活动传递到Amazon EventBridge。                         |
| QueueConfiguration         | ArrayList<[QueueConfiguration](#QueueConfiguration)>         | 否       |        | Amazon简单队列服务排队以向其发布消息，以及为其发布消息的事件。 |
| TopicConfiguration         | ArrayList<[TopicConfiguration](#TopicConfiguration)>         | 否       |        | 向其发送通知的主题以及为其生成通知的事件。                   |





# 46、检索AmazonS3存储桶的OwnershipControls。

## GetBucketOwnershipControls







### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketOwnershipControlsRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketOwnershipControls(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketOwnershipControlsRequest](#GetBucketOwnershipControlsRequest) | 是       |        | 参数对象 |





#### GetBucketOwnershipControlsRequest

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述           |
| -------- | ------------ | -------- | ------ | -------------- |
| bucket   | String       | 是       |        | 存储桶的名称。 |

### 响应参数

| 参数名称 | **参数类型**                                    | 是否必填 | 默认值 | 描述                       |
| -------- | ----------------------------------------------- | -------- | ------ | -------------------------- |
| Rule     | [OwnershipControlsRule](#OwnershipControlsRule) | 否       |        | 所有权控制规则的容器元素。 |









# 47、返回指定存储桶的策略。

## GetBucketPolicy





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketPolicyRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketPolicy(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                      | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketPolicyRequest](#GetBucketPolicyRequest) | 是       |        | 参数对象 |





#### GetBucketPolicyRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 否       |        | 存储桶名称                 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |







### 响应参数

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述 |
| -------- | ------------ | -------- | ------ | ---- |
| policy   | String       | 是       |        | json |







# 48、检索AmazonS3存储桶的策略状态，指示该存储桶是否为公共存储桶。

## GetBucketPolicyStatus



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq2 = GetBucketPolicyStatusRequest(bucket: bucket1)
        println(getReq2)
        let getRsp2 = s3.getBucketPolicyStatus(getReq2)
        println(getRsp2)
        println(getRsp2.responseMetadata)
    }
}

```





### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq2  | [GetBucketPolicyStatusRequest](#GetBucketPolicyStatusRequest) | 是       |        | 参数对象 |



#### GetBucketPolicyStatusRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数



| 参数名称     | **参数类型**                  | 是否必填 | 默认值 | 描述             |
| ------------ | ----------------------------- | -------- | ------ | ---------------- |
| policyStatus | [PolicyStatus](#PolicyStatus) | 是       |        | 参数的根级别标记 |



#### PolicyStatus

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述             |
| -------- | ------------ | -------- | ------ | ---------------- |
| IsPublic | Bool         | 是       |        | 参数的根级别标记 |





# 49、有关复制配置的信息

## GetBucketReplication



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketReplicationRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketReplication(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```







### 请求参数列表

| 参数名称 | **参数类型**                                                | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketReplicationRequest](#GetBucketReplicationRequest) | 是       |        | 参数对象 |





#### GetBucketReplicationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶名称。               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

| 参数名称                 | **参数类型**                                          | 是否必填 | 默认值 | 描述     |
| ------------------------ | ----------------------------------------------------- | -------- | ------ | -------- |
| ReplicationConfiguration | [ReplicationConfiguration](#ReplicationConfiguration) | 是       |        | 参数对象 |

#### ReplicationConfiguration

| 参数名称 | **参数类型**                        | 是否必填 | 默认值 | 描述                                                         |
| -------- | ----------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| Role     | String                              | 否       |        | 亚马逊S3在复制对象时承担的AWS身份和访问管理（IAM）角色的亚马逊资源名称（ARN）。 |
| Rule     | [ReplicationRule](#ReplicationRule) | 否       |        | 一个或多个复制规则的容器。                                   |











# 50、返回bucket的请求付款配置。

## GetBucketRequestPayment



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketRequestPaymentRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketRequestPayment(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetBucketRequestPaymentRequest](#GetBucketRequestPaymentRequest) | 是       |        | 参数对象 |



#### GetBucketRequestPaymentRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                       |
| -------- | ------------ | -------- | ------ | -------------------------- |
| Payer    | String       | 是       |        | 指定谁支付下载和请求费用。 |











# 51、返回与桶关联的标记集。

## GetBucketTagging





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketTaggingRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketTagging(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketTaggingRequest](#GetBucketTaggingRequest) | 是       |        | 参数对象 |





#### GetBucketTaggingRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 桶的名称。                 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数



#### Tagging

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述         |
| -------- | ---------------------- | -------- | ------ | ------------ |
| TagSet   | ArrayList<[Tag](#Tag)> | 否       |        | 包含标记集。 |





# 52、返回存储桶的版本控制状态。

## GetBucketVersioning





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketVersioningRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketVersioning(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketVersioningRequest](#GetBucketVersioningRequest) | 是       |        | 参数对象 |





#### GetBucketVersioningRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶的名称               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |







### 响应参数

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| MFADelete | String       | 否       |        | 指定是否在存储段版本控制配置中启用MFA删除 有效值：Enabled\|Disabled |
| Status    | String       | 否       |        | 存储桶的版本控制状态。 有效值：Enabled\|Suspended            |









# 53、返回存储桶的网站配置。

## GetBucketWebsite





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetBucketWebsiteRequest(bucket: bucket1)
        println(getReq)
        let getRsp = s3.getBucketWebsite(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表



| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetBucketWebsiteRequest](#GetBucketWebsiteRequest) | 是       |        | 参数对象 |



#### GetBucketWebsiteRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| bucket              | String       | 是       |        | 存储桶名称                 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。 |



### 响应参数

| 参数名称 | **参数类型**                                  | 是否必填 | 默认值 | 描述 |
| -------- | --------------------------------------------- | -------- | ------ | ---- |
|          | [WebsiteConfiguration](#WebsiteConfiguration) | 是       |        |      |









# 54、列出存储桶的分析配置。

## ListBucketAnalyticsConfigurations



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListBucketAnalyticsConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketAnalyticsConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| listReq  | [ListBucketAnalyticsConfigurationsRequest](#ListBucketAnalyticsConfigurationsRequest) | 是       |        | 参数对象 |





#### ListBucketAnalyticsConfigurationsRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                        |
| ------------------- | ------------ | -------- | ------ | ----------------------------------------------------------- |
| bucket              | String       |          |        | 存储桶的名称                                                |
| continuationToken   | String       |          |        | ContinuationToken表示一个占位符，该占位符应该从该请求开始。 |
| expectedBucketOwner | String       |          |        | 预期存储桶所有者的帐户ID。                                  |



### 响应参数

| 参数名称               | **参数类型**                                                 | 是否必填 | 默认值 | 描述                             |
| ---------------------- | ------------------------------------------------------------ | -------- | ------ | -------------------------------- |
| AnalyticsConfiguration | ArrayList<[AnalyticsConfiguration](#AnalyticsConfiguration)> | 否       |        | 存储桶的分析配置列表。           |
| ContinuationToken      | String                                                       | 否       |        | 用作此分析配置列表响应起点的标记 |
| IsTruncated            | Bool                                                         | 否       |        | 指示返回的分析配置列表是否完整。 |
| NextContinuationToken  | String                                                       | 否       |        | 当isTruncated为true时            |



##### AnalyticsConfiguration

| 参数名称             | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | --------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| Id                   | String                                        | 是       |        | 指定Amazon S3桶的分析筛选器的配置和任何分析。                |
| StorageClassAnalysis | [StorageClassAnalysis](#StorageClassAnalysis) | 是       |        | 包含与访问模式相关的数据，这些数据将被收集并可用于分析不同存储类之间的权衡。 |
| Filter               | [AnalyticsFilter](#AnalyticsFilter)           | 否       |        | 用于描述一组分析对象的筛选器。                               |













# 55、列出指定存储桶中的S3智能分层配置。

## ListBucketIntelligentTieringConfigurations



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListBucketIntelligentTieringConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketIntelligentTieringConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| listReq  | [ListBucketIntelligentTieringConfigurationsRequest](#ListBucketIntelligentTieringConfigurationsRequest) | 是       |        | 参数对象 |



#### ListBucketIntelligentTieringConfigurationsRequest

| 参数名称          | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ----------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket            | String       | 是       |        | 存储桶的名称                                                 |
| continuationToken | String       | 否       |        | ContinuationToken，它表示一个占位符，此请求应从该占位符开始。 |







### 响应参数

| 参数名称                        | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                        |
| ------------------------------- | ------------------------------------------------------------ | -------- | ------ | ----------------------------------------------------------- |
| ContinuationToken               | String                                                       | 否       |        | ContinuationToken表示一个占位符，该占位符应该从该请求开始。 |
| IntelligentTieringConfiguration | ArrayList<[IntelligentTieringConfiguration](#IntelligentTieringConfiguration)> | 否       |        | 存储桶的S3智能分层配置列表。                                |
| IsTruncated                     | Bool                                                         | 否       |        | 指示返回的分析配置列表是否完整。                            |
| NextContinuationToken           | String                                                       | 否       |        | 用于继续此库存配置列表的标记。                              |





# 56、返回存储桶的库存配置列表

## ListBucketInventoryConfigurations



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListBucketInventoryConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketInventoryConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| listReq  | [ListBucketInventoryConfigurationsRequest](#ListBucketInventoryConfigurationsRequest) | 是       |        | 参数对象 |





#### ListBucketInventoryConfigurationsRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| ------------------- | ------------ | -------- | ------ | ------------------------------------ |
| bucket              | String       | 是       |        | 存储桶的名称                         |
| continuationToken   | String       | 否       |        | 用于继续已截断的清单配置列表的标记。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。           |



### 响应参数



| 参数名称               | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                                     |
| ---------------------- | ------------------------------------------------------------ | -------- | ------ | -------------------------------------------------------- |
| ContinuationToken      | String                                                       | 否       |        | 如果在请求中发送，则是用作此库存配置列表响应起点的标记。 |
| InventoryConfiguration | ArrayList<[InventoryConfiguration](#InventoryConfiguration)> | 否       |        | 存储桶的库存配置列表。                                   |
| IsTruncated            | Bool                                                         | 否       |        | 告诉返回的库存配置列表是否完整。                         |
| NextContinuationToken  | String                                                       | 否       |        | 用于继续此库存配置列表的标记。                           |









# 57、列出存储桶的度量配置。

## ListBucketMetricsConfigurations





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListBucketMetricsConfigurationsRequest(bucket: bucket1)
        println(listReq)
        let listRsp = s3.listBucketMetricsConfigurations(listReq)
        println(listRsp)
        println(listRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| listReq  | [ListBucketMetricsConfigurationsRequest](#ListBucketMetricsConfigurationsRequest) | 是       |        | 参数对象 |



#### ListBucketMetricsConfigurationsRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| ------------------- | ------------ | -------- | ------ | ------------------------------------ |
| bucket              | String       | 是       |        | 存储桶的名称。                       |
| continuationToken   | String       | 否       |        | 用于继续已截断的度量配置列表的标记。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。           |





### 响应参数



| 参数名称                        | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| ------------------------------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| ListMetricsConfigurationsResult | [ListMetricsConfigurationsResult](#ListMetricsConfigurationsResult) | 是       |        | 参数对象 |





#### ListMetricsConfigurationsResult

| 参数名称              | **参数类型**                                             | 是否必填 | 默认值 | 描述                                 |
| --------------------- | -------------------------------------------------------- | -------- | ------ | ------------------------------------ |
| ContinuationToken     | String                                                   | 否       |        | 用作此度量配置列表响应起点的标记。   |
| IsTruncated           | Bool                                                     | 否       |        | 指示返回的度量配置列表是否完整。     |
| MetricsConfiguration  | ArrayList<[MetricsConfiguration](#MetricsConfiguration)> | 否       |        | 存储桶的度量配置列表。               |
| NextContinuationToken | String                                                   | 否       |        | 用于继续已截断的度量配置列表的标记。 |











# 58、创建或修改Amazon S3存储桶的PublicAccessBlock配置

## PutPublicAccessBlock



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let s3 = createS3Client()
            let config = PublicAccessBlockConfiguration(blockPublicPolicy: true)
            println(config.toXml())
            let putReq = PutPublicAccessBlockRequest(
                bucket: bucket1,
                configuration: config
            )
            println(putReq)
            let putRsp = s3.putPublicAccessBlock(putReq)
            println(putRsp)
            println(putRsp.responseMetadata)
    }
}
```



### 请求参数列表



| 参数名称 | **参数类型**                                                | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutPublicAccessBlockRequest](#PutPublicAccessBlockRequest) | 是       |        | 参数对象 |





#### PutPublicAccessBlockRequest

| 参数名称            | **参数类型**                                                 | 是否必填 | 默认值 | 描述                                      |
| ------------------- | ------------------------------------------------------------ | -------- | ------ | ----------------------------------------- |
| bucket              | String                                                       | 是       |        | 存储桶的名称                              |
| contentMD5          | String                                                       | 否       |        | PutPublicAccessBlock请求体的MD5哈希。     |
| checksumAlgorithm   | String                                                       | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。 |
| configuration       | [PublicAccessBlockConfiguration](#PublicAccessBlockConfiguration) | 否       |        | 参数的根级别标记                          |
| expectedBucketOwner | String                                                       | 否       |        | 预期存储桶所有者的帐户ID。                |





##### PublicAccessBlockConfiguration

| 参数名称              | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| BlockPublicAcls       | Bool         | 否       |        | 指定AmazonS3是否应阻止此存储桶和存储桶中对象的公共访问控制列表（ACL）。 |
| BlockPublicPolicy     | Bool         | 否       |        | 指定AmazonS3是否应阻止此存储桶的公共存储桶策略。             |
| IgnorePublicAcls      | Bool         | 否       |        | 指定AmazonS3是否应忽略此存储桶和存储桶中对象的公共ACL。      |
| RestrictPublicBuckets | Bool         | 否       |        | 指定Amazon S3是否应限制此存储桶的公共存储桶策略。            |



### 响应参数

无





# 59、检索Amazon S3存储桶的PublicAccessBlock配置。

## GetPublicAccessBlock



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let s3 = createS3Client()
            let getReq = GetPublicAccessBlockRequest(bucket: bucket1)
            println(getReq)
            let getRsp = s3.getPublicAccessBlock(getReq)
            println(getRsp)
            println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                                | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetPublicAccessBlockRequest](#GetPublicAccessBlockRequest) | 是       |        | 参数对象 |





#### GetPublicAccessBlockRequest

|      参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                     |
| :-----------------: | ------------ | -------- | ------ | ------------------------ |
|       bucket        | String       | 是       |        | 存储桶的名称。           |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID |







### 响应参数

|   参数名称    | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| :-----------: | ------------------------------------------------------------ | -------- | ------ | -------- |
| configuration | [PublicAccessBlockConfiguration](#PublicAccessBlockConfiguration) | 是       |        | 参数对象 |



#### PublicAccessBlockConfiguration

| 参数名称              | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| BlockPublicAcls       | Bool         | 否       |        | 指定AmazonS3是否应阻止此存储桶和存储桶中对象的公共访问控制列表（ACL） |
| BlockPublicPolicy     | Bool         | 否       |        | 指定AmazonS3是否应阻止此存储桶的公共存储桶策略。             |
| IgnorePublicAcls      | Bool         | 否       |        | 指定AmazonS3是否应忽略此存储桶和存储桶中对象的公共ACL。      |
| RestrictPublicBuckets | Bool         | 否       |        | 指定Amazon S3是否应限制此存储桶的公共存储桶策略。            |







# 60、删除Amazon S3存储桶的PublicAccessBlock配置。

## DeletePublicAccessBlock





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let s3 = createS3Client()
            let delReq = DeletePublicAccessBlockRequest(bucket: bucket1)
            println(delReq)
            let delRsp = s3.deletePublicAccessBlock(delReq)
            println(delRsp)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| delReq   | [DeletePublicAccessBlockRequest](#DeletePublicAccessBlockRequest) | 是       |        | 参考对象 |



#### DeletePublicAccessBlockRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                             |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------ |
| bucket              | String       | 是       |        | 要删除其PublicAccessBlock配置的Amazon S3存储桶。 |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。                       |



### 响应参数

无









# 61、HEAD操作从对象中检索元数据，而不返回对象本身。

## HeadObject



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let s3 = createS3Client()
        let headReq = HeadObjectRequest(
            bucket: bucket1,
            key: key
        )
        println(headReq)
        let headRsp = s3.headObject(headReq)
        println(headRsp)
        println(headRsp.responseMetadata)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                            | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------- | -------- | ------ | -------- |
| headReq  | [HeadObjectRequest](#HeadObjectRequest) | 是       |        | 参考对象 |





#### HeadObjectRequest

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket               | String       | 是       |        | 包含对象的存储桶的名称。                                     |
| key                  | String       | 是       |        |                                                              |
| ifMatch              | String       | 否       |        | 仅当对象的实体标记（ETag）与指定的实体标记相同时，才返回对象 |
| ifModifiedSince      | DateTime     | 否       |        | 仅当对象自指定时间以来已被修改时，才返回该对象；             |
| ifNoneMatch          | String       | 否       |        | 只有当对象的实体标记（ETag）与指定的不同时，才返回对象；     |
| ifUnmodifiedSince    | DateTime     | 否       |        | 仅当对象自指定时间以来未被修改时才返回该对象                 |
| partNumber           | Int32        | 否       |        | 正在读取的对象的部件号。这是一个介于1和10000之间的正整数。   |
| range                | String       | 否       |        | HeadObject只返回对象的元数据。如果Range是可满足的，则响应中仅ContentLength受到影响 |
| versionId            | String       | 否       |        | 用于引用对象的特定版本的版本ID。                             |
| checksumMode         | String       | 否       |        | 若要检索校验和，必须启用此参数。有效值：ENABLED              |
| expectedBucketOwner  | String       | 否       |        | 预期存储桶所有者的帐户ID                                     |
| requestPayer         | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。 有效值：requester   |
| sseCustomerAlgorithm | String       | 否       |        | 指定加密对象时要使用的算法（例如，AES256）。                 |
| sseCustomerKey       | String       | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
| sseCustomerKeyMD5    | String       | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |



### 



### 响应参数

| 参数名称                  | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| deleteMarker              | Bool                | 否       |        | 指定检索到的对象是（true）删除标记还是（false）删除标记。如果为false，则此响应标头不会出现在响应中。 |
| acceptRanges              | String              | 否       |        | 指示指定了一个字节范围。                                     |
| expiration                | String              | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法             |
| restore                   | String              | 否       |        | 如果对象是存档对象（存储类为GLACIER的对象），则如果正在进行存档恢复（请参阅RestoreObject或已恢复存档副本），则响应将包括此标头。 |
| archiveStatus             | String              | 否       |        | 头对象的存档状态。有效值:ARCHIVE_ACCESS  \|DEEP_ARCHIVE_ACCESS |
| lastModified              | DateTime            | 否       |        | 上次修改对象的日期和时间。                                   |
| contentLength             | Int64               | 否       |        | 正文的大小（以字节为单位）。                                 |
| checksumCRC32             | String              | 否       |        | 对象的base64编码的32位CRC32校验和。                          |
| checksumCRC32C            | String              | 否       |        | 对象的base64编码的32位CRC32C校验和                           |
| checksumSHA1              | String              | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| checksumSHA256            | String              | 否       |        | 对象的base64编码的256位SHA-256摘要。                         |
| etag                      | String              | 否       |        | 实体标签（ETag）是一种不透明的标识符，由网络服务器分配给在URL中找到的资源的特定版本。 |
| missingMeta               | Int32               | 否       |        | 这被设置为x-amz-meta标头中未返回的元数据条目数。             |
| versionId                 | String              | 否       |        | 对象的版本ID。                                               |
| cacheControl              | String              | 否       |        | 指定请求/回复链上的缓存行为。                                |
| contentDisposition        | String              | 否       |        | 指定对象的表示信息                                           |
| contentEncoding           | String              | 否       |        | 指示已将哪些内容编码应用于对象，因此必须应用哪些解码机制才能获得“内容类型”标头字段引用的媒体类型。 |
| contentLanguage           | String              | 否       |        | 内容使用的语言。                                             |
| contentType               | String              | 否       |        | 描述对象数据格式的标准MIME类型。                             |
| expires                   | DateTime            | 否       |        | 对象不再可缓存的日期和时间。                                 |
| websiteRedirectLocation   | String              | 否       |        | 如果bucket被配置为网站，则将对该对象的请求重定向到同一bucket中的另一个对象或外部URL |
| serverSideEncryption      | String              | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法             |
| metadata                  | Map<String, String> | 否       |        | 元数据。                                                     |
| sseCustomerAlgorithm      | String              | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头， |
| sseCustomerKeyMD5         | String              | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| ssekmsKeyId               | String              | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务                      |
| bucketKeyEnabled          | Bool                | 否       |        | 指示对象是否使用S3 Bucket Key与AWS密钥管理服务               |
| storageClass              | String              | 否       |        | 提供对象的存储类信息。有效值：STANDARD\|REDUCED_REDUNDANCY\|STANDARD_IA\|ONEZONE_IA\|INTELLIGENT_TIERING<br />GLACIER\|DEEP_ARCHIVE\|OUTPOSTS\|GLACIER_IR\|SNOW \|EXPRESS_ONEZONE |
| requestCharged            | String              | 否       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester  |
| replicationStatus         | String              | 否       |        | 如果您的请求涉及复制规则中的源或目标bucket，有效值：COMPLETE\| PENDING \|FAILED \|REPLICA \|COMPLETED |
| partsCount                | String              | 否       |        | 此对象包含的部分数。                                         |
| objectLockMode            | String              | 否       |        | 对象锁定模式（如果有）对此对象有效。有效值:GOVERNANCE\|COMPLIANCE |
| objectLockRetainUntilDate | DateTime            | 否       |        | 对象锁定保留期到期的日期和时间。                             |
| objectLockLegalHoldStatus | String              | 否       |        | 指定合法保留是否对此对象有效 有效值: ON \| OFF               |











# 62、将对象添加到存储桶中。

## PutObject



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        s3.createBucket(CreateBucketRequest(bucket: "bucket1"))
        let putObjRsp = s3.putObject(
            PutObjectRequest(bucket: "bucket1", key: "key1"),
            S3Content.fromString("Hello World!")
        )
    }
}
```





### 请求参数列行表

| 参数名称                  | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket                    | String       | 是       |        | 存储桶名称                                                   |
| key                       | String       | 是       |        | 为其启动PUT操作的对象键。                                    |
| acl                       | String       | 是       |        | 要应用于对象的固定ACL                                        |
| cacheControl              | String       | 否       |        | 赋予被授予者对对象的READ、READ_ACP和WRITE_ACP权限。          |
| contentDisposition        | String       | 否       |        | 指定对象的表示信息。                                         |
| contentEncoding           | String       | 否       |        | 指定对对象应用了哪些内容编码，从而指定必须应用哪些解码机制才能获得“内容类型”标头字段引用的媒体类型 |
| contentLanguage           | String       | 否       |        | 内容使用的语言。                                             |
| contentLength             | String       | 否       |        | 正文大小（以字节为单位）                                     |
| contentMD5                | String       | 否       |        | 根据RFC 1864，消息的base64编码的128位MD5摘要（没有报头）。   |
| contentType               | String       | 否       |        | 描述内容格式的标准MIME类型                                   |
| checksumAlgorithm         | String       | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值：CRC32\|\|CRC32C\|\|SHA1\|SHA256 |
| checksumCRC32             | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32C校验和。 |
| checksumCRC32C            | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32C校验和。 |
| checksumSHA1              | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的160位SHA-1摘要。 |
| checksumSHA256            | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的160位SHA-1摘要。 |
| expires                   | DateTime     | 否       |        | 对象不再可缓存的日期和时间。                                 |
| grantFullControl          | String       | 否       |        | 赋予被授予者对对象的READ、READ_ACP和WRITE_ACP权限。          |
| grantRead                 | String       | 否       |        | 允许被授予者读取对象数据及其元数据。                         |
| grantReadACP              | String       | 否       |        | 允许被授予者读取对象ACL。                                    |
| grantWriteACP             | String       | 否       |        | 允许被授予者写入适用对象的ACL。                              |
| serverSideEncryption      | String       | 否       |        | 在AmazonS3中存储此对象时使用的服务器端加密算法               |
| storageClass              | String       | 否       |        | 默认情况下，AmazonS3使用STANDARD存储类来存储新创建的对象     |
| websiteRedirectLocation   | String       | 否       |        | 如果bucket被配置为网站，则将对该对象的请求重定向到同一bucket中的另一个对象或外部URL。 |
| sseCustomerAlgorithm      | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKey            | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| sseCustomerKeyMD5         | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| ssekmsKeyId               | String       | 否       |        | 如果x-amz-server-side-encryption的有效值为aws:kms或aws:kms:dsse，则此标头指示用于对象的aws密钥管理服务（aws kms）对称加密客户管理密钥的ID。 |
| ssekmsEncryptionContext   | String       | 否       |        | 如果存在，则指示用于对象加密的AWS KMS加密上下文。这个头的值是一个base64编码的UTF-8字符串，包含JSON和加密上下文键值对。 |
| bucketKeyEnabled          | Bool         | 否       |        | 指定Amazon S3是否应使用S3桶密钥进行对象加密，并使用AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| requestPayer              | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| tagging                   | String       | 否       |        | 对象的标记集。标记集必须编码为URL查询参数。（例如，“Key1=值1”） |
| objectLockMode            | String       | 否       |        | 要应用于此对象的“对象锁定”模式。                             |
| objectLockRetainUntilDate | DateTime     | 否       |        | 您希望此对象的对象锁定到期的日期和时间。必须格式化为时间戳参数。 |
| objectLockLegalHoldStatus | String       | 否       |        | 指定是否对此对象应用合法保留。                               |
| expectedBucketOwner       | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### 响应参数

| 参数名称                | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ----------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| etag                    | String       | 否       |        | 已上载对象的实体标记。                                       |
| checksumCRC32           | String       | 否       |        | 对象的base64编码的32位CRC32校验和。只有当它与对象一起上传时，才会出现这种情况 |
| checksumCRC32C          | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。只有当它与对象一起上传时，才会出现这种情况。 |
| checksumSHA1            | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| checksumSHA256          | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。                         |
| serverSideEncryption    | String       | 否       |        | 如果在AmazonS3用户指南中为对象配置了过期（请参阅PutBucketLifecycleConfiguration），则响应包括此标头。 |
| versionId               | String       | 否       |        | 对象的版本ID。                                               |
| sseCustomerAlgorithm    | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKeyMD5       | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| ssekmsKeyId             | String       | 否       |        | 如果x-amz-server-side-encryption的有效值为aws:kms或aws:kms:dsse，则此标头指示用于对象的aws密钥管理服务（aws kms）对称加密客户管理密钥的ID。 |
| ssekmsEncryptionContext | String       | 否       |        | 如果存在，则指示用于对象加密的AWS KMS加密上下文。            |
| bucketKeyEnabled        | String       | 否       |        | 指示上传的对象是否使用S3 Bucket Key与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| requestCharged          | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |









# 63、使用acl子资源为S3存储桶中的新对象或现有对象设置访问控制列表（acl）权限

## PutObjectAcl



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let putReq = PutObjectAclRequest(
            bucket: bucket2,
            key: objectId,
            accessControlPolicy: policy
        )
        println(putReq)
        let putRsp = s3.putObjectAcl(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutObjectAclRequest](#PutObjectAclRequest) | 是       |        | 参数对象 |





#### PutObjectAclRequest

| 参数名称            | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String              | 是       |        | 桶的名称                                                     |
| key                 | String              | 是       |        | 为其启动PUT操作的密钥。                                      |
| acl                 | String              | 否       |        | 要应用于对象的固定ACL。有效值：private                       |
| accessControlPolicy | AccessControlPolicy | 是       |        | 根级别标记                                                   |
| contentMD5          | String              | 否       |        | base64编码的128位MD5数据摘要。                               |
| checksumAlgorithm   | String              | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。                    |
| grantFullControl    | String              | 否       |        | 允许被授予者对存储桶的读取、写入、读取ACP和写入ACP权限。     |
| grantRead           | String              | 否       |        | 允许被授予者列出存储桶中的对象。                             |
| grantWrite          | String              | 否       |        | 允许被授予者在存储桶中创建新对象。                           |
| grantReadACP        | String              | 否       |        | 允许被授予者读取bucket ACL。                                 |
| grantWriteACP       | String              | 否       |        | 允许被授予者写入适用存储桶的ACL。                            |
| requestPayer        | String              | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| versionId           | String              | 否       |        | 用于引用对象的特定版本的版本ID。                             |
| expectedBucketOwner | String              | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### 响应参数

| 参数名称              | **参数类型** | 是否必填 | 默认值 | 描述                                       |
| --------------------- | ------------ | -------- | ------ | ------------------------------------------ |
| x-amz-request-charged | String       | 是       |        | 如果存在，则表示请求者已成功收取请求费用。 |





# 64、将合法的保留配置应用于指定的对象

## PutObjectLegalHold



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let putReq = PutObjectLegalHoldRequest(
            bucket: bucket_lock,
            key: objectId,
            legalHold: ObjectLockLegalHold(status: "ON")
        )
        println(putReq)
        let putRsp = s3.putObjectLegalHold(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```





请求参数列表

| 参数名称 | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutObjectLegalHoldRequest](#PutObjectLegalHoldRequest) | 是       |        | 参数对象 |





### PutObjectLegalHoldRequest

| 参数名称            | **参数类型**                                | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                      | 是       |        | 存储桶名称                                                   |
| key                 | String                                      | 是       |        | 要对其进行合法挂起的对象的密钥名称。                         |
| legalHold           | [ObjectLockLegalHold](#ObjectLockLegalHold) | 是       |        | 根级别标记                                                   |
| contentMD5          | String                                      | 否       |        | 请求正文的MD5哈希。                                          |
| checksumAlgorithm   | String                                      | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值:             |
| requestPayer        | String                                      | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| versionId           | String                                      | 否       |        | 要对其进行合法挂起的对象的版本ID。                           |
| expectedBucketOwner | String                                      | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### ObjectLockLegalHold

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                              |
| -------- | ------------ | -------- | ------ | ------------------------------------------------- |
| status   | String       | 否       |        | 指示指定的对象是否具有合法的保留。有效值：ON\|OFF |







### 响应参数



| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                        |
| -------------- | ------------ | -------- | ------ | ----------------------------------------------------------- |
| requestCharged | String       | 是       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值:requester |









# 65、在指定的存储桶上放置对象锁定配置

## PutObjectLockConfiguration





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let putReq = PutObjectLockConfigurationRequest(
            bucket: bucket_lock,
            configuration: ObjectLockConfiguration(
                objectLockEnabled: "Enabled",
                rule: ObjectLockRule(defaultRetention: DefaultRetention(mode: "GOVERNANCE", days: 1))
            )
        )
        println(putReq)
        let putRsp = s3.putObjectLockConfiguration(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```



请求参数列表

| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| putReq   | [PutObjectLockConfigurationRequest](#PutObjectLockConfigurationRequest) | 是       |        | 参数对象 |





#### PutObjectLockConfigurationRequest

| 参数名称            | **参数类型**                                        | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | --------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                                              | 是       |        | 桶的名称                                                     |
| configuration       | [ObjectLockConfiguration](#ObjectLockConfiguration) | 否       |        | 根级别标记                                                   |
| contentMD5          | String                                              | 否       |        | 请求正文的MD5哈希。                                          |
| checksumAlgorithm   | String                                              | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。                    |
| requestPayer        | String                                              | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| token               | String                                              | 否       |        | 允许为现有存储桶启用对象锁定的令牌。                         |
| expectedBucketOwner | String                                              | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



##### ObjectLockConfiguration

| 参数名称          | **参数类型**   | 是否必填 | 默认值 | 描述                               |
| ----------------- | -------------- | -------- | ------ | ---------------------------------- |
| objectLockEnabled | String         | 否       |        | 指示此存储桶是否启用了对象锁定配置 |
| rule              | ObjectLockRule | 否       |        | 为指定的对象指定对象锁定规则。     |





### 响应参数

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                      |
| -------------- | ------------ | -------- | ------ | --------------------------------------------------------- |
| requestCharged | String       | 是       |        | 如果操作成功，该服务将发回HTTP 200响应。有效值：requester |







# 66、在对象上放置对象保留配置。

## PutObjectRetention





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let putReq = PutObjectRetentionRequest(
            bucket: bucket_lock,
            key: objectId,
            retention: retention
        )
        println(putReq)
        let putRsp = s3.putObjectRetention(putReq)
        println(putRsp)
        println(putRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutObjectRetentionRequest](#PutObjectRetentionRequest) | 是       |        | 参数对象 |





#### PutObjectRetentionRequest

| 参数名称                  | **参数类型**                                | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket                    | String                                      | 是       |        | 存储桶名称，其中包含要应用此对象保留配置的对象。             |
| key                       | String                                      | 是       |        | 要应用此对象保留配置的对象的密钥名称。                       |
| retention                 | [ObjectLockRetention](#ObjectLockRetention) | 否       |        | Retention参数的根级别标记。                                  |
| bypassGovernanceRetention | Bool                                        | 否       |        | 指示此操作是否应绕过管理模式限制。                           |
| contentMD5                | String                                      | 否       |        | 请求正文的MD5哈希。                                          |
| checksumAlgorithm         | String                                      | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。                    |
| requestPayer              | String                                      | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| versionId                 | String                                      | 否       |        | 要应用此对象保留配置的对象的版本ID。                         |
| expectedBucketOwner       | String                                      | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### ObjectLockRetention

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                                                   |
| --------------- | ------------ | -------- | ------ | ------------------------------------------------------ |
| mode            | String       | 否       |        | 指示指定对象的保留模式。有效值：GOVERNANCE\|COMPLIANCE |
| retainUntilDate | DateTime     | 否       |        | 此对象锁定保留期将到期的日期。                         |





### 响应参数

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                        |
| -------------- | ------------ | -------- | ------ | ----------------------------------------------------------- |
| requestCharged | String       | 是       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester |









# 67、将提供的标记集设置为存储桶中已存在的对象。

## PutObjectTagging





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let putReq = PutObjectTaggingRequest(
            bucket: bucket2,
            key: objectId,
            tagging: Tagging(
                tagSet: ArrayList<Tag>(
                    [
                        Tag(key: "key-1", value: "value-1"),
                        Tag(key: "key-2", value: "value-2")
                    ]
                )
            )
        )
        println(putReq)
        let putRsp = s3.putObjectTagging(putReq)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| putReq   | [PutObjectTaggingRequest](#PutObjectTaggingRequest) | 是       |        | 参数对象 |



#### PutObjectTaggingRequest

| 参数名称            | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String              | 是       |        | 存储桶名称。                                                 |
| key                 | String              | 是       |        | 对象键的名称。                                               |
| tagging             | [Tagging](#Tagging) | 是       |        | 标记参数的根级别标记。                                       |
| contentMD5          | String              | 否       |        | 请求正文的MD5哈希。                                          |
| checksumAlgorithm   | String              | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值：CRC32\|CRC32C\|SHA1\|SHA256 |
| requestPayer        | String              | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| versionId           | String              | 否       |        | 标记集将添加到的对象的版本ID。                               |
| expectedBucketOwner | String              | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |

##### Tagging

| 参数名称 | **参数类型**           | 是否必填 | 默认值 | 描述                |
| -------- | ---------------------- | -------- | ------ | ------------------- |
| tagSet   | ArrayList<[Tag](#Tag)> | 是       |        | 键值-名称对的容器。 |



### 响应参数

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                             |
| --------- | ------------ | -------- | ------ | -------------------------------- |
| versionId | String       | 是       |        | 已将标记集添加到的对象的版本ID。 |







# 68、从AmazonS3中检索一个对象。

## GetObject



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectRequest(
            bucket: bucket2,
            key: objectId
        )
        println(getReq)
        s3.getObject(
            getReq,
            {
                getRsp, rspBody =>
                rspBody.toFile("./tmp/${objectId}.txt", true)
                println(getRsp.responseMetadata)
                println(getRsp)
            }
        )
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                          | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectRequest](#GetObjectRequest) | 是       |        | 参数对象 |





#### GetObjectRequest

| 参数名称                   | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket                     | String       | 是       |        | 包含对象的存储桶名称。                                       |
| key                        | String       | 否       |        | 要获取的对象的键。                                           |
| ifMatch                    | String       | 否       |        | 仅当对象的实体标记（ETag）与此标头中指定的实体标记相同时，才返回对象；否则，返回412前提条件失败错误。 |
| ifModifiedSince            | DateTime     | 否       |        | 仅当对象自指定时间以来已被修改时，才返回该对象；否则，返回304 Not Modified错误。 |
| ifNoneMatch                | String       | 否       |        | 只有当对象的实体标记（ETag）与此标头中指定的不同时，才返回对象；否则，返回304 Not Modified错误。 |
| ifUnmodifiedSince          | DateTime     | 否       |        | 仅当对象自指定时间以来未被修改时才返回该对象；否则，返回412前提条件失败错误。 |
| responseCacheControl       | String       | 否       |        | 设置响应的“缓存控制”标头。                                   |
| responseContentDisposition | String       | 否       |        | 设置响应的内容处置标头。                                     |
| responseContentEncoding    | String       | 否       |        | 设置响应的内容编码标头。                                     |
| responseContentLanguage    | String       | 否       |        | 设置响应的“内容语言”标头。                                   |
| responseContentType        | String       | 否       |        | 设置响应的“内容类型”标头。                                   |
| responseExpires            | DateTime     | 否       |        | 设置响应的Expires标头。                                      |
| partNumber                 | Int32        | 否       |        | 正在读取的对象的部件号。这是一个介于1和10000之间的正整数。有效地执行指定零件的“范围”GET请求。仅用于下载对象的一部分。 |
| range                      | String       | 否       |        | 下载对象的指定字节范围                                       |
| versionId                  | String       | 否       |        | 用于引用对象的特定版本的版本ID。                             |
| checksumMode               | String       | 否       |        | 若要检索校验和，必须启用此模式。有效值:ENABLED               |
| expectedBucketOwner        | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| requestPayer               | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| sseCustomerAlgorithm       | String       | 否       |        | 指定解密对象时要使用的算法（例如，AES256）。                 |
| sseCustomerKey             | String       | 否       |        | 指定客户提供的加密密钥，该密钥最初是您为Amazon S3提供的，用于在存储数据之前对数据进行加密。 |
| sseCustomerKeyMD5          | String       | 否       |        | 根据RFC 1321，指定客户提供的加密密钥的128位MD5摘要。         |





### 响应参数

| 参数名称                  | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| acceptRanges              | String              | 否       |        | 指示在请求中指定了一个字节范围。                             |
| cacheControl              | String              | 否       |        | 指定请求/回复链上的缓存行为。                                |
| contentDisposition        | String              | 否       |        | 指定对象的表示信息。                                         |
| contentEncoding           | String              | 否       |        | 指示已将哪些内容编码应用于对象，因此必须应用哪些解码机制才能获得“内容类型”标头字段引用的媒体类型。 |
| contentLanguage           | String              | 否       |        | 内容使用的语言。                                             |
| contentLength             | Int64               | 否       |        | 正文的大小（以字节为单位）。                                 |
| Content-Range             | String              | 否       |        | 响应中返回的对象部分。                                       |
| contentType               | String              | 否       |        | 描述对象数据格式的标准MIME类型。                             |
| etag                      | String              | 否       |        | 实体标签（ETag）是一种不透明的标识符，由网络服务器分配给在URL中找到的资源的特定版本。 |
| expires                   | DateTime            | 否       |        | 对象不再可缓存的日期和时间。                                 |
| lastModified              | DateTime            | 否       |        | 上次修改对象的日期和时间。                                   |
| checksumCRC32             | String              | 否       |        | 对象的base64编码的32位CRC32校验和。                          |
| checksumCRC32C            | String              | 否       |        | 对象的base64编码的32位CRC32C校验和。                         |
| checksumSHA1              | String              | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| checksumSHA256            | String              | 否       |        | 对象的base64编码的256位SHA-256摘要。                         |
| deleteMarker              | Bool                | 否       |        | 指示检索到的对象是（true）删除标记还是（false）删除标记。    |
| expiration                | String              | 否       |        | 如果配置了对象过期，则响应将包括此标头。                     |
| missingMeta               | String              | 否       |        | 这被设置为在以x-amz-meta-为前缀的标头中未返回的元数据条目的数量。 |
| partsCount                | Int32               | 否       |        | 此对象包含的部分数。只有当您在请求中指定了partNumber并且对象是以多部分上载的方式上载时，才会返回此值。 |
| objectLockLegalHoldStatus | String              | 否       |        | 指示此对象是否具有活动的合法持有。只有当您有权查看对象的合法持有状态时，才会返回此字段。有效值：ON\|OFF、 |
| objectLockMode            | String              | 否       |        | 当前用于此对象的“对象锁定”模式。有效值：GOVERNANCE\|COMPLIANCE |
| objectLockRetainUntilDate | DateTime            | 否       |        | 此对象的对象锁定将过期的日期和时间。                         |
| replicationStatus         | String              | 否       |        | 如果您的请求涉及复制规则中的源或目标bucket，AmazonS3可以返回此消息。有效值：COMPLETE\|PENDING \|FAILED\|REPLICA\|COMPLETED |
| requestCharged            | String              | 否       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester  |
| restore                   | String              | 否       |        | 提供有关对象还原操作和已还原对象副本的过期时间的信息。       |
| serverSideEncryption      | String              | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法（例如，AES256、aws:kms、aws:kms:dsse）。有效值：AES256\|aws:kms \|aws:kms:dsse |
| ssekmsKeyId               | String              | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled          | String              | 否       |        | 指示对象是否使用S3 Bucket Key与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| sseCustomerAlgorithm      | String              | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKeyMD5         | String              | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| storageClass              | String              | 否       |        | 提供对象的存储类信息。有效值:STANDARD \|REDUCED_REDUNDANCY \|STANDARD_IA \|ONEZONE_IA \| INTELLIGENT_TIERING\|  GLACIER\| DEEP_ARCHIVE \| OUTPOSTS \|GLACIER_IR \| SNOW \|EXPRESS_ONEZONE |
| tagCount                  | Int32               | 否       |        | 当您具有读取对象标记的相关权限时，对象上的标记数（如果有）。 |
| versionId                 | String              | 否       |        | 对象的版本ID。                                               |
| websiteRedirectLocation   | String              | 否       |        | 如果bucket被配置为网站，则将对该对象的请求重定向到同一bucket中的另一个对象或外部URL。 |
| metadata                  | Map<String, String> | 否       |        | API创建元数据                                                |















# 69、返回对象的访问控制列表（ACL）。

## GetObjectAcl





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectAclRequest(
            bucket: bucket2,
            key: objectId
        )
        println(getReq)
        let getRsp = s3.getObjectAcl(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```



### 请求参数列表



| 参数名称 | **参数类型**                                | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectAclRequest](#GetObjectAclRequest) | 是       |        | 参数对象 |





#### GetObjectAclRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 包含要获取其ACL信息的对象的bucket名称。                      |
| key                 | String       | 是       |        | 要获取其ACL信息的对象的密钥。                                |
| versionId           | String       | 否       |        | 用于引用对象的特定版本的版本ID。                             |
| requestPayer        | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。有效值：requester    |
| expectedBucketOwner | String       | 否       |        | The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code `403 Forbidden` (access denied). |









### 响应参数

| 参数名称       | **参数类型**               | 是否必填 | 默认值 | 描述                                                         |
| -------------- | -------------------------- | -------- | ------ | ------------------------------------------------------------ |
| requestCharged | String                     | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值：requester |
| Grants         | ArrayList<[Grant](#Grant)> | 否       |        | 赠款清单。                                                   |
| Owner          | [Owner](#Owner)            | 否       |        | 存储桶所有者的显示名称和ID的容器。                           |







# 70、从对象检索所有元数据，而不返回对象本身

## GetObjectAttributes



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectAttributesRequest(
            bucket: bucket2,
            key: objectId,
            objectAttributes: ArrayList<String>(
                [
                    "ETag",
                    "Checksum",
                    "ObjectParts",
                    "StorageClass",
                    "ObjectSize"
                ]
            )
        )
        println(getReq)
        let getRsp = s3.getObjectAttributes(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectAttributesRequest](#GetObjectAttributesRequest) | 是       |        | 参数对象 |





#### GetObjectAttributesRequest

|       参数名称       | **参数类型**      | 是否必填 | 默认值 | 描述                                                         |
| :------------------: | ----------------- | -------- | ------ | ------------------------------------------------------------ |
|        bucket        | String            | 是       |        | 包含对象的存储桶的名称。                                     |
|         key          | String            | 是       |        | 对象键。                                                     |
|      versionId       | String            | 否       |        | 用于引用对象的特定版本的版本ID。                             |
|     requestPayer     | String            | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner  | String            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
|       maxParts       | Int32             | 否       |        | 设置要返回的最大零件数。                                     |
|   partNumberMarker   | Int32             | 否       |        | 指定应在其之后开始列出的零件。                               |
| sseCustomerAlgorithm | String            | 否       |        | 指定加密对象时要使用的算法。                                 |
|    sseCustomerKey    | String            | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
|  sseCustomerKeyMD5   | String            | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |
|   objectAttributes   | ArrayList<String> | 否       |        | 指定要在响应中返回的根级别的字段。未指定的字段不会返回。有效值:ETag\|\|Checksum\|ObjectParts\|StorageClass\|ObjectSize |



### 响应参数

| 参数名称                  | **参数类型**                                          | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ----------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| lastModified              | String                                                | 否       |        | 对象的创建日期。                                             |
| deleteMarker              | String                                                | 否       |        | 指定检索到的对象是（true）删除标记还是（false）删除标记。如果为false，则此响应标头不会出现在响应中。 |
| requestCharged            | String                                                | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |
| versionId                 | String                                                | 否       |        | 对象的版本ID。                                               |
| GetObjectAttributesOutput | String                                                | 是       |        | 参数的根级别标记。                                           |
| checksum                  | [Checksum](#Checksum)                                 | 否       |        | 对象的校验和或摘要。                                         |
| etag                      | String                                                | 否       |        | ETag是一种不透明的标识符，由网络服务器分配给在URL中找到的资源的特定版本。 |
| objectParts               | [GetObjectAttributesParts](#GetObjectAttributesParts) | 否       |        | 与多部分上传相关联的部分的集合。                             |
| objectSize                | Long                                                  | 否       |        | 对象的大小（以字节为单位）。                                 |
| storageClass              | String                                                | 否       |        | 提供对象的存储类信息。有效值:STANDARD\|REDUCED_REDUNDANCY\|\|STANDARD_IA\|ONEZONE_IA<br />\|INTELLIGENT_TIERING\|GLACIER\|DEEP_ARCHIVE\|OUTPOSTS<br /><br />GLACIER_IR\|SNOW\|EXPRESS_ONEZONE |





#### Checksum

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| -------------- | ------------ | -------- | ------ | ------------------------------------ |
| checksumCRC32  | String       | 否       |        | 对象的base64编码的32位CRC32校验和。  |
| checksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。 |
| checksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要     |
| checksumSHA256 | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。 |









##### GetObjectAttributesParts

| 参数名称             | **参数类型**                         | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| totalPartsCount      | Int32                                | 否       |        | 部件的总数。                                                 |
| partNumberMarker     | Int32                                | 否       |        | 当前零件的标记。                                             |
| nextPartNumberMarker | Int32                                | 否       |        | 当列表被截断时，此元素指定列表中的最后一个部分，以及在后续请求中用于PartNumberMarker请求参数的值。 |
| maxParts             | Int32                                | 否       |        | 响应中允许的最大部件数。                                     |
| isTruncated          | Bool                                 | 否       |        | 指示返回的零件列表是否被截断。                               |
| parts                | ArrayList<[ObjectPart](#ObjectPart)> | 否       |        | 与特定零件相关的元素的容器。                                 |







###### ObjectPart

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| ChecksumCRC32  | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。 |
| ChecksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。                         |
| ChecksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| ChecksumSHA256 | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。                         |
| PartNumber     | Int64        | 否       |        | 识别零件的零件号。此值是一个介于1和10000之间的正整数。       |
| Size           | Long         | 否       |        | 已上载部分的大小（以字节为单位）。                           |

















# 71、获取对象的当前合法保留状态。

## GetObjectLegalHold





### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectLegalHoldRequest(
            bucket: bucket_lock,
            key: objectId,
        )
        println(getReq)
        let getRsp = s3.getObjectLegalHold(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        @Expect("ON" == (getRsp.legalHold.status??""))
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectLegalHoldRequest](#GetObjectLegalHoldRequest) | 是       |        | 参数对象 |



#### GetObjectLegalHoldRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 存储桶名称，包含要检索其合法持有状态的对象。                 |
| key                 | String       | 是       |        | 要检索其合法持有状态的对象的密钥名称。                       |
| versionId           | String       | 否       |        | 要检索其合法保留状态的对象的版本ID。                         |
| requestPayer        | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数



| 参数名称  | **参数类型**                                | 是否必填 | 默认值 | 描述                        |
| --------- | ------------------------------------------- | -------- | ------ | --------------------------- |
| LegalHold | [ObjectLockLegalHold](#ObjectLockLegalHold) | 是       |        | LegalHold参数的根级别标记。 |



##### ObjectLockLegalHold

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                             |
| -------- | ------------ | -------- | ------ | ------------------------------------------------ |
| Status   | String       | 否       |        | 指示指定的对象是否具有合法的保留。有效值:ON\|OFF |













# 72、获取bucket的Object Lock配置。

## GetObjectLockConfiguration



### 示例代码

```java
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectLockConfigurationRequest(bucket: bucket_lock)
        println(getReq)
        let getRsp = s3.getObjectLockConfiguration(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        @Expect("Enabled" == (getRsp.configuration.objectLockEnabled??""))
    }
}
```



### 请求参数列表



| 参数名称 | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| getReq   | [GetObjectLockConfigurationRequest](#GetObjectLockConfigurationRequest) | 是       |        | 参数对象 |





#### GetObjectLockConfigurationRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 要检索其Object Lock配置的bucket。                            |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数

| 参数名称                | **参数类型**                                        | 是否必填 | 默认值 | 描述                                      |
| ----------------------- | --------------------------------------------------- | -------- | ------ | ----------------------------------------- |
| ObjectLockConfiguration | [ObjectLockConfiguration](#ObjectLockConfiguration) | 是       |        | ObjectLockConfiguration参数的根级别标记。 |





#### ObjectLockConfiguration

| 参数名称          | **参数类型**                      | 是否必填 | 默认值 | 描述                                               |
| ----------------- | --------------------------------- | -------- | ------ | -------------------------------------------------- |
| ObjectLockEnabled | String                            | 否       |        | 指示此存储桶是否启用了对象锁定配置。有效值:Enabled |
| Rule              | [ObjectLockRule](#ObjectLockRule) | 否       |        | 为指定的对象指定对象锁定规则。                     |



##### ObjectLockRule

| 参数名称         | **参数类型**                          | 是否必填 | 默认值 | 描述                                                         |
| ---------------- | ------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| defaultRetention | [defaultRetention](#defaultRetention) | 是       |        | 要应用于放置在指定存储桶中的新对象的默认对象锁定保留模式和期限。 |



###### defaultRetention

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| Days     | Int64        | 否       |        | 要为默认保留期指定的天数。必须与Mode一起使用。               |
| Mode     | String       | 否       |        | 要应用于放置在指定存储桶中的新对象的默认对象锁定保留模式。必须与Days或Years一起使用。有效值:GOVERNANCE\|COMPLIANCE |
| Years    | Int64        | 否       |        | 要为默认保留期指定的年数。必须与Mode一起使用。               |









# 73、检索对象的保留设置。

## GetObjectRetention



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectRetentionRequest(bucket: bucket_lock, key: objectId)
        println(getReq)
        let getRsp = s3.getObjectRetention(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
        @Expect("GOVERNANCE" == (getRsp.retention.mode??""))
    }
}
```



### 请求参数列表



| 参数名称 | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectRetentionRequest](#GetObjectRetentionRequest) | 是       |        | 参考对象 |





#### GetObjectRetentionRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 存储桶名称                                                   |
| key                 | String       | 是       |        | 要检索其保留设置的对象的密钥名称。                           |
| versionId           | String       | 否       |        | 要检索其保留设置的对象的版本ID。                             |
| requestPayer        | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数



| 参数名称  | **参数类型**                                | 是否必填 | 默认值 | 描述                        |
| --------- | ------------------------------------------- | -------- | ------ | --------------------------- |
| Retention | [ObjectLockRetention](#ObjectLockRetention) | 是       |        | Retention参数的根级别标记。 |





#### ObjectLockRetention

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                                                      |
| --------------- | ------------ | -------- | ------ | --------------------------------------------------------- |
| Mode            | String       | 否       |        | 指示指定对象的保留模式。有效值： GOVERNANCE \| COMPLIANCE |
| RetainUntilDate | DateTime     | 否       |        | 此对象锁定保留期将到期的日期。                            |









# 74、返回对象的标记集。

## GetObjectTagging



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let getReq = GetObjectTaggingRequest(bucket: bucket2, key: objectId)
        println(getReq)
        let getRsp = s3.getObjectTagging(getReq)
        println(getRsp)
        println(getRsp.responseMetadata)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                                        | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------- | -------- | ------ | -------- |
| getReq   | [GetObjectTaggingRequest](#GetObjectTaggingRequest) | 是       |        | 参数对象 |





#### GetObjectTaggingRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 包含要获取其标记信息的对象的bucket名称。                     |
| key                 | String       | 是       |        | 要获取其标记信息的对象键。                                   |
| versionId           | String       | 否       |        | 要获取其标记信息的对象的版本ID。                             |
| requestPayer        | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数



| 参数名称  | **参数类型**           | 是否必填 | 默认值 | 描述                         |
| --------- | ---------------------- | -------- | ------ | ---------------------------- |
| versionId | String                 | 否       |        | 获得标记信息的对象的版本ID。 |
| tagSet    | ArrayList<[Tag](#Tag)> | 否       |        | 标记参数的根级别标记。       |







# 75、返回bucket中的部分或全部（最多1000个）对象。

## ListObjects



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListObjectsRequest(bucket: bucket1, maxKeys: 1)
        println(listReq)
        let listRsp = s3.listObjects(listReq)
        println(listRsp)
    }
}
```



### 请求参数列表

| 参数名称 | **参数类型**       | 是否必填 | 默认值 | 描述     |
| -------- | ------------------ | -------- | ------ | -------- |
| listReq  | ListObjectsRequest | 是       |        | 参考对象 |





| 参数名称                 | **参数类型**      | 是否必填 | 默认值 | 描述                                                         |
| ------------------------ | ----------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket                   | String            | 是       |        | 包含对象的存储桶的名称。                                     |
| delimiter                | String            | 否       |        | 分隔符是用于对键进行分组的字符。                             |
| encodingType             | String            | 否       |        | 请求AmazonS3对响应中的对象密钥进行编码，并指定要使用的编码方法。有效值:url |
| marker                   | String            | 否       |        | Marker是您希望AmazonS3开始上市的地方。                       |
| maxKeys                  | Int64             | 否       |        | 设置响应中返回的最大键数。                                   |
| prefix                   | String            | 否       |        | 将响应限制为以指定前缀开头的键。                             |
| requestPayer             | String            | 否       |        | 确认请求者知道她或他将被收取列表对象请求的费用。有效值:requester |
| expectedBucketOwner      | String            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| optionalObjectAttributes | ArrayList<String> | 否       |        | 指定要在响应中返回的可选字段。未指定的字段不会返回。         |





### 响应参数



| 参数名称         | **参数类型**                             | 是否必填 | 默认值 | 描述                                                         |
| ---------------- | ---------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| requestCharged   | String                                   | 否       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester  |
| ListBucketResult | String                                   | 是       |        | ListBucketResult参数的根级别标记。                           |
| commonPrefixes   | ArrayList<[CommonPrefix](#CommonPrefix)> | 否       |        | 在计算返回次数时，公共前缀中汇总的所有键（最多1000个）都将作为单个返回计数。 |
| contents         | ArrayList<[S3Object](#S3Object)>         | 否       |        | 返回的每个对象的元数据。                                     |
| delimiter        | String                                   | 否       |        | 使在前缀和第一次出现分隔符之间包含相同字符串的键汇总到CommonPrefixes集合中的单个结果元素中。 |
| encodingType     | String                                   | 否       |        | AmazonS3用于对响应中的对象密钥进行编码的编码类型。           |
| isTruncated      | Bool                                     | 否       |        | 一个标志，指示AmazonS3是否返回了满足搜索标准的所有结果。     |
| marker           | String                                   | 否       |        | 指示存储段列表的起始位置。                                   |
| maxKeys          | Int64                                    | 否       |        | 在响应正文中返回的最大密钥数。                               |
| name             | String                                   | 否       |        | 存储桶名称。                                                 |
| nextMarker       | String                                   | 否       |        | 当响应被截断时（响应中的IsTruncated元素值为true），您可以使用此字段中的键名称作为后续请求中的标记参数，以获取下一组对象。 |
| prefix           | String                                   | 否       |        | 以指示前缀开头的键。                                         |





#### S3Object

| 参数名称          | **参数类型**                    | 是否必填 | 默认值 | 描述                                                         |
| ----------------- | ------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| key               | String                          | 否       |        | 指定给对象的名称。                                           |
| lastModified      | DateTime                        | 否       |        | 对象的创建日期。                                             |
| etag              | String                          | 否       |        | 实体标记是对象的散列。                                       |
| checksumAlgorithm | ArrayList<String>               | 否       |        | 用于创建对象的校验和的算法。有效值:CRC32 \|CRC32C \|SHA1 \|SHA256 |
| size              | Int64                           | 否       |        | 对象的大小（以字节为单位）                                   |
| storageClass      | String                          | 否       |        | 用于存储对象的存储类。有效值: STANDARD \| REDUCED_REDUNDANCY \|  GLACIER \|STANDARD_IA \|ONEZONE_IA \| INTELLIGENT_TIERING \|DEEP_ARCHIVE \|OUTPOSTS \|GLACIER_IR \|  SNOW \| EXPRESS_ONEZONE |
| owner             | [Owner](#Owner)                 | 否       |        | 对象的所有者                                                 |
| restoreStatus     | [RestoreStatus](#RestoreStatus) | 否       |        | 指定对象的恢复状态。                                         |









# 76、在每个请求中返回bucket中的部分或全部（最多1000个）对象。

## ListObjectsV2





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReqV2 = ListObjectsV2Request(bucket: bucket1, maxKeys: 1)
        println(listReqV2)
        let listRspV2 = s3.listObjectsV2(listReqV2)
        println(listRspV2)
    }
}

```



### 请求参数列表



| 参数名称  | **参数类型**                                  | 是否必填 | 默认值 | 描述     |
| --------- | --------------------------------------------- | -------- | ------ | -------- |
| listReqV2 | [ListObjectsV2Request](#ListObjectsV2Request) | 是       |        | 参数对象 |





#### ListObjectsV2Request

| 参数名称                 | **参数类型**      | 是否必填 | 默认值 | 描述                                                         |
| ------------------------ | ----------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket                   | String            | 是       |        | 目录存储桶命名规则                                           |
| delimiter                | String            | 否       |        | 分隔符是用于对键进行分组的字符。                             |
| encodingType             | String            | 否       |        | AmazonS3用于对响应中的对象密钥进行编码的编码类型。有效值：url |
| maxKeys                  | Int64             | 否       |        | 设置响应中返回的最大键数                                     |
| prefix                   | String            | 否       |        | 将响应限制为以指定前缀开头的键。                             |
| continuationToken        | String            | 否       |        | ContinuationToken向AmazonS3指示该列表正在使用令牌在该bucket上继续。 |
| fetchOwner               | Bool              | 否       |        | 默认情况下，所有者字段不存在于ListObjectsV2中。              |
| startAfter               | String            | 否       |        | StartAfter是您希望AmazonS3开始上市的地方                     |
| requestPayer             | String            | 否       |        | 确认请求者知道她或他将被收取V2样式的列表对象请求的费用。有效值：requester |
| expectedBucketOwner      | String            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| optionalObjectAttributes | ArrayList<String> | 否       |        | 指定要在响应中返回的可选字段。有效值:RestoreStatus           |



### 响应体

```json

HTTP/1.1 200
x-amz-request-charged: RequestCharged
<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult>
   <IsTruncated>Bool</IsTruncated>
   <Contents>
      <ChecksumAlgorithm>string</ChecksumAlgorithm>
      ...
      <ETag>string</ETag>
      <Key>string</Key>
      <LastModified>timestamp</LastModified>
      <Owner>
         <DisplayName>string</DisplayName>
         <ID>string</ID>
      </Owner>
      <RestoreStatus>
         <IsRestoreInProgress>Bool</IsRestoreInProgress>
         <RestoreExpiryDate>timestamp</RestoreExpiryDate>
      </RestoreStatus>
      <Size>long</Size>
      <StorageClass>string</StorageClass>
   </Contents>
   ...
   <Name>string</Name>
   <Prefix>string</Prefix>
   <Delimiter>string</Delimiter>
   <MaxKeys>Int64</MaxKeys>
   <CommonPrefixes>
      <Prefix>string</Prefix>
   </CommonPrefixes>
   ...
   <EncodingType>string</EncodingType>
   <KeyCount>Int64</KeyCount>
   <ContinuationToken>string</ContinuationToken>
   <NextContinuationToken>string</NextContinuationToken>
   <StartAfter>string</StartAfter>
</ListBucketResult>
```





### 响应参数



| 参数名称              | **参数类型**                  | 是否必填 | 默认值 | 描述                                                         |
| --------------------- | ----------------------------- | -------- | ------ | ------------------------------------------------------------ |
| x-amz-request-charged | String                        | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |
| ListBucketResult      | String                        | 是       |        | ListBucketResult参数的根级别标记。                           |
| CommonPrefixes        | [CommonPrefix](#CommonPrefix) | 否       |        | 共享相同前缀的所有密钥（最多1000个）都分组在一起。           |
| Contents              | Object                        | 否       |        | 返回的每个对象的元数据。                                     |
| ContinuationToken     | String                        | 否       |        | 如果ContinuationToken是随请求一起发送的，则它包含在响应中。  |
| Delimiter             | String                        | 否       |        | 使在前缀和第一次出现分隔符之间包含相同字符串的键汇总到CommonPrefixes集合中的单个结果元素中。 |
| EncodingType          | String                        | 否       |        | AmazonS3用于对XML响应中的对象密钥名称进行编码的编码类型。    |
| IsTruncated           | Bool                          | 否       |        | 如果返回了所有结果，则设置为false。                          |
| KeyCount              | Int64                         | 否       |        | KeyCount是此请求返回的密钥数。                               |
| MaxKeys               | Int64                         | 否       |        | 设置响应中返回的最大键数。                                   |
| Name                  | String                        | 否       |        | 存储桶名称。                                                 |
| NextContinuationToken | String                        | 否       |        | 当isTruncated为true时，发送NextContinuationToken，这意味着存储桶中可以列出更多的密钥。 |
| Prefix                | String                        | 否       |        | 以指示前缀开头的键。                                         |
| StartAfter            | String                        | 否       |        | 如果StartAfter是随请求一起发送的，则会包含在响应中。         |







#### CommonPrefix

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                 |
| -------- | ------------ | -------- | ------ | -------------------- |
| prefix   | String       | 否       |        | 指定公用前缀的容器。 |







#### Object

| 参数名称          | **参数类型**                    | 是否必填 | 默认值 | 描述                                                         |
| ----------------- | ------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| key               | String                          | 否       |        | 指定给对象的名称。                                           |
| lastModified      | DateTime                        | 否       |        | 对象的创建日期。                                             |
| etag              | String                          | 否       |        | 实体标记是对象的散列。                                       |
| checksumAlgorithm | ArrayList<String>               | 否       |        | 用于创建对象的校验和的算法。有效值：CRC32\|  CRC32C \|SHA1 \|SHA256 |
| size              | Int64                           | 否       |        | 对象的大小（以字节为单位）                                   |
| storageClass      | String                          | 否       |        | 用于存储对象的存储类。有效值:STANDARD\|REDUCED_REDUNDANCY\|GLACIER\|STANDARD_IA\|<br />ONEZONE_IA\|INTELLIGENT_TIERING\|DEEP_ARCHIVE \|OUTPOSTS<br />GLACIER_IR \| SNOW \|EXPRESS_ONEZONE |
| owner             | [Owner](#Owner)                 | 否       |        | 对象的所有者                                                 |
| restoreStatus     | [RestoreStatus](#RestoreStatus) | 否       |        | 指定对象的恢复状态。                                         |







##### RestoreStatus

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                       |
| ------------------- | ------------ | -------- | ------ | -------------------------- |
| isRestoreInProgress | Bool         | 否       |        | 指定当前是否正在恢复对象。 |
| restoreExpiryDate   | DateTime     | 否       |        | 指示还原的副本何时过期     |













# 77、返回有关存储桶中对象的所有版本的元数据。

## ListObjectVersions





### 示例代码

```json


package s3client_test.action

@Test
public class ObjectVersionsTest {
    @TestCase
    public func testObject_versions(): Unit {
        printTestCase("testObject_versions")
        let listReq = ListObjectVersionsRequest(bucket: bucket2)
        let listRsp = s3.listObjectVersions(listReq)
        println(listRsp.responseMetadata)
        println(listRsp)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                                            | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------------------- | -------- | ------ | -------- |
| listReq  | [ListObjectVersionsRequest](#ListObjectVersionsRequest) | 是       |        | 参考对象 |







#### ListObjectVersionsRequest

| 参数名称                 | **参数类型**      | 是否必填 | 默认值 | 描述                                                         |
| ------------------------ | ----------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket                   | String            | 是       |        | 包含对象的存储桶名称。                                       |
| delimiter                | String            | 否       |        | 分隔符是指定用于对键进行分组的字符。                         |
| encodingType             | String            | 否       |        | 请求AmazonS3对响应中的对象密钥进行编码，并指定要使用的编码方法。有效值:url |
| keyMarker                | String            | 否       |        | 指定在存储桶中列出对象时要使用的键。                         |
| maxKeys                  | Int64             | 否       |        | 设置响应中返回的最大键数。                                   |
| versionIdMarker          | String            | 否       |        | 指定要从中开始列出的对象版本。                               |
| prefix                   | String            | 否       |        | 使用此参数可以仅选择那些以指定前缀开头的键。                 |
| requestPayer             | String            | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner      | String            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| optionalObjectAttributes | ArrayList<String> | 否       |        | 指定要在响应中返回的可选字段。未指定的字段不会返回。 有效值：RestoreStatus |







### 响应参数

| 参数名称            | **参数类型**                                       | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | -------------------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| requestCharged      | String                                             | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |
| ListVersionsResult  | String                                             | 是       |        | ListVersionsResult参数的根级别标记。                         |
| commonPrefixes      | ArrayList<[CommonPrefix](#CommonPrefix)>           | 否       |        | 在计算返回次数时，将所有键汇总到一个公共前缀中作为单个返回计数。 |
| deleteMarkers       | ArrayList<[DeleteMarkerEntry](#DeleteMarkerEntry)> | 否       |        | 作为删除标记的对象的容器。                                   |
| delimiter           | String                                             | 否       |        | 对包含的键进行分组的分隔符。                                 |
| encodingType        | String                                             | 否       |        | AmazonS3用于对XML响应中的对象密钥名称进行编码的编码类型。    |
| isTruncated         | Bool                                               | 否       |        | 一个标志，指示Amazon S3是否返回了满足搜索条件的所有结果。    |
| keyMarker           | String                                             | 否       |        | 标记截断响应中返回的最后一个键。                             |
| maxKeys             | Int64                                              | 否       |        | 指定要返回的最大对象数。                                     |
| name                | String                                             | 否       |        | 存储桶名称。                                                 |
| nextKeyMarker       | String                                             | 否       |        | 当响应数超过MaxKeys的值时，NextKeyMarker指定第一个未返回的满足搜索条件的密钥。 |
| nextVersionIdMarker | String                                             | 否       |        | 当响应数超过MaxKeys的值时，NextVersionIdMarker指定未返回的第一个满足搜索条件的对象版本 |
| prefix              | String                                             | 否       |        | 选择以该参数提供的值开头的对象。                             |
| versions            | ArrayList<[ObjectVersion](#ObjectVersion)>         | 否       |        | 版本信息的容器。                                             |
| versionIdMarker     | String                                             | 否       |        | 标记在截断的响应中返回的密钥的最后一个版本。                 |





#### CommonPrefix

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                 |
| -------- | ------------ | -------- | ------ | -------------------- |
| prefix   | String       | 否       |        | 指定公用前缀的容器。 |



#### DeleteMarkerEntry

| 参数名称     | **参数类型** | 是否必填 | 默认值 | 描述                                                |
| ------------ | ------------ | -------- | ------ | --------------------------------------------------- |
| key          | String       | 否       |        | 对象键。                                            |
| versionId    | String       | 否       |        | 对象的版本ID。                                      |
| isLatest     | Bool         | 否       |        | 指定对象是（true）对象还是（false）对象的最新版本。 |
| lastModified | DateTime     | 否       |        | 上次修改对象的日期和时间。                          |
| owner        | Owner        | 否       |        | 创建删除标记的帐户。>                               |





#### ObjectVersion

| 参数名称          | **参数类型**  | 是否必填                        | 默认值 | 描述                                                         |
| ----------------- | ------------- | ------------------------------- | ------ | ------------------------------------------------------------ |
| etag              | String        | 否                              |        | 实体标记是该版本对象的MD5散列。                              |
| checksumAlgorithm | String        | 否                              |        | 用于创建对象的校验和的算法。有效值:CRC32 \| CRC32C<br /><br />SHA1\|SHA256 |
| size              | Long          | 否                              |        | 对象的大小（以字节为单位）。                                 |
| storageClass      | String        | 否                              |        | 用于存储对象的存储类。                                       |
| key               | String        | 否                              |        | 对象键。                                                     |
| versionId         | String        | 否                              |        | 对象的版本ID。                                               |
| isLatest          | Bool          | 否                              |        | 指定对象是（true）对象还是（false）对象的最新版本。          |
| lastModified      | Timestamp     | 否                              |        | 上次修改对象的日期和时间。                                   |
| owner             | Owner         | [Owner](#Owner)                 |        | 指定对象的所有者。                                           |
| restoreStatus     | RestoreStatus | [RestoreStatus](#RestoreStatus) |        | 指定对象的恢复状态。                                         |











# 78、从存储桶中删除对象

## DeleteObject





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
                    let delReq = DeleteObjectRequest(
                        bucket: bucket2,
                        key: key,
                        versionId: versionId
                    )
                    println("*** DELETE OBJECT: ${bucket2}, ${key}, ${versionId}")
                    s3.deleteObject(delReq)
    }
}

```



### 请求参数列表

| 参数名称 | **参数类型**                                | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------------------------- | -------- | ------ | -------- |
| delReq   | [DeleteObjectRequest](#DeleteObjectRequest) | 是       |        | 参数对象 |





#### DeleteObjectRequest

| 参数名称                  | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket                    | String       | 是       |        | 包含对象的存储桶的存储桶名称。                               |
| key                       | String       | 是       |        | 要删除的对象的密钥名称。                                     |
| mfa                       | String       | 否       |        | 身份验证设备的序列号、空格和身份验证设备上显示的值的串联     |
| versionId                 | String       | 否       |        | 用于引用对象的特定版本的版本ID。                             |
| requestPayer              | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。有效值:requester     |
| bypassGovernanceRetention | Bool         | 否       |        | 指示S3对象锁是否应绕过管理模式限制来处理此操作。             |
| expectedBucketOwner       | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| deleteMarker   | Bool         | 否       |        | 指示被永久删除的指定对象版本在删除前是（true）还是（false）删除标记 |
| requestCharged | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。有效值:requester   |
| versionId      | String       | 否       |        | 返回由于delete操作而创建的删除标记的版本ID。                 |







# 79、此操作使您能够使用单个HTTP请求从存储桶中删除多个对象。

## DeleteObjects





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let delReq = DeleteObjectsRequest(
            bucket: bucket1,
            delete: Delete(
                objects: ArrayList<ObjectIdentifier>(
                    [
                        ObjectIdentifier(key: "eeb4e50e-23da-443c-b55a-fb7c3ea21b6a"),
                        ObjectIdentifier(key: "1")
                    ]
                )
            )
        )
        println(delReq)
        let delRsp = s3.deleteObjects(delReq)
        println(delRsp)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                                  | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------- | -------- | ------ | -------- |
| delReq   | [DeleteObjectsRequest](#DeleteObjectsRequest) | 是       |        | 参数对象 |





#### DeleteObjectsRequest

| 参数名称                  | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket                    | String       | 是       |        | 存储桶名称                                                   |
| delete                    | Delete       | 是       |        | Delete参数的根级别标记。                                     |
| mfa                       | String       | 否       |        | 身份验证设备的序列号、空格和身份验证设备上显示的值的串联。   |
| requestPayer              | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| bypassGovernanceRetention | Bool         | 否       |        | 指定是否要删除此对象，即使该对象具有“治理”类型的“对象锁定”。 |
| expectedBucketOwner       | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| checksumAlgorithm         | String       | 否       |        | 指示使用SDK时用于为对象创建校验和的算法<br /><br />有效值:CRC32\|CRC32C\|SHA256\|SHA1 |





##### Delete

| 参数名称 | **参数类型**                                     | 是否必填 | 默认值 | 描述                     |
| -------- | ------------------------------------------------ | -------- | ------ | ------------------------ |
| objects  | ArrayList<[ObjectIdentifier](#ObjectIdentifier)> | 是       |        | 要删除的对象。           |
| quiet    | Bool                                             | 否       |        | 元素为请求启用静默模式。 |





###### ObjectIdentifier

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                             |
| --------- | ------------ | -------- | ------ | -------------------------------- |
| Key       | String       | 是       |        | 对象的密钥名称。                 |
| VersionId | String       | 否       |        | 要删除的对象的特定版本的版本ID。 |



### 



### 响应参数



| 参数名称       | **参数类型**                               | 是否必填 | 默认值 | 描述                                                         |
| -------------- | ------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| requestCharged | String                                     | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值:requester  |
| deleted        | ArrayList<[DeletedObject](#DeletedObject)> | 否       |        | 成功删除的容器元素。它标识已成功删除的对象。                 |
| errors         | ArrayList<[S3Error](#S3Error)>             | 否       |        | 失败的删除操作的容器，描述AmazonS3试图删除的对象及其遇到的错误。 |







#### S3Error

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| --------- | ------------ | -------- | ------ | ------------------------------------ |
| key       | String       | 否       |        | 错误键。                             |
| versionId | String       | 否       |        | 错误的版本ID。                       |
| code      | String       | 否       |        | 错误代码是唯一标识错误条件的字符串。 |
| message   | String       | 否       |        | 错误消息包含错误条件的英文通用描述。 |









#### DeletedObject

| 参数名称              | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| --------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| key                   | String       | 否       |        | 已删除对象的名称。                                           |
| versionId             | String       | 否       |        | 已删除对象的版本ID。                                         |
| deleteMarker          | Bool         | 否       |        | 指示被永久删除的指定对象版本在删除前是（true）还是（false）删除标记 |
| deleteMarkerVersionId | String       | 否       |        | 由于delete操作而创建的删除标记的版本ID                       |







#### Error

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| --------- | ------------ | -------- | ------ | ------------------------------------ |
| key       | String       | 否       |        | 错误键。                             |
| versionId | String       | 否       |        | 错误的版本ID。                       |
| code      | String       | 否       |        | 错误代码是唯一标识错误条件的字符串。 |
| message   | String       | 否       |        | 错误消息包含错误条件的英文通用描述。 |









# 80、从指定的对象中删除整个标记集。

## DeleteObjectTagging







### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let delReq = DeleteObjectTaggingRequest(
            bucket: bucket2,
            key: objectId
        )
        println(delReq)
        let delRsp = s3.deleteObjectTagging(delReq)
        println(delRsp)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                              | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------------------------- | -------- | ------ | -------- |
| delReq   | [DeleteObjectTaggingRequest](#DeleteObjectTaggingRequest) | 是       |        | 参数对象 |





#### DeleteObjectTaggingRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 包含要从中删除标记的对象的bucket名称。                       |
| key                 | String       | 是       |        | 标识存储桶中要删除所有标记的对象的键。                       |
| versionId           | String       | 否       |        | 将从中删除标记集的对象的版本ID。                             |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



### 响应参数

| 参数名称  | **参数类型** | 是否必填 | 默认值 | 描述                             |
| --------- | ------------ | -------- | ------ | -------------------------------- |
| versionId | String       | 是       |        | 已从中删除标记集的对象的版本ID。 |











# 81、创建一个已经存储在AmazonS3中的对象的副本。

## CopyObject





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let copyReq = CopyObjectRequest(
            destinationBucket: bucket1,
            destinationKey: "cj-copy",
            sourceBucket: bucket2,
            sourceKey: objectId
        )
        println(copyReq)
        let copyRsp = s3.copyObject(copyReq)
        println(copyRsp)
    }
}

```





### 请求参数列表

| 参数名称 | **参数类型**                            | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------------------- | -------- | ------ | -------- |
| copyReq  | [CopyObjectRequest](#CopyObjectRequest) | 是       |        | 参数对象 |





#### CopyObjectRequest

| 参数名称                       | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------------------ | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| acl                            | String              | 否       |        | 要应用于对象的屏蔽访问控制列表（ACL）。有效值:<br />private\|public-read \|public-read-write \|authenticated-read \| aws-exec-read \| bucket-owner-read \| bucket-owner-full-control |
| cacheControl                   | String              | 否       |        | 指定请求/回复链上的缓存行为。                                |
| checksumAlgorithm              | String              | 否       |        | 指示您希望AmazonS3用于创建对象的校验和的算法。               |
| contentDisposition             | String              | 否       |        | 指定对象的表示信息                                           |
| contentEncoding                | String              | 否       |        | 指定对对象应用了哪些内容编码，从而指定必须应用哪些解码机制才能获得“内容类型”标头字段引用的媒体类型。 |
| contentLanguage                | String              | 否       |        | 内容使用的语言。                                             |
| contentType                    | String              | 否       |        | 描述对象数据格式的标准MIME类型。                             |
| copySource                     | String              | 否       |        | 指定复制操作的源对象。                                       |
| copySourceIfMatch              | String              | 否       |        | 如果对象的实体标记（ETag）与指定的标记匹配，则复制该对象。   |
| copySourceIfModifiedSince      | DateTime            | 否       |        | 如果自指定时间以来已对对象进行了修改，则复制该对象。         |
| copySourceIfNoneMatch          | String              | 否       |        | 如果对象的实体标记（ETag）不同于指定的ETag，则复制该对象。   |
| copySourceIfUnmodifiedSince    | DateTime            | 否       |        | 如果自指定时间以来未对对象进行修改，则复制该对象。           |
| expires                        | DateTime            | 否       |        | 对象不再可缓存的日期和时间。                                 |
| grantFullControl               | String              | 否       |        | 赋予被授予者对对象的READ、READ_ACP和WRITE_ACP权限。          |
| grantRead                      | String              | 否       |        | 允许被授予者读取对象数据及其元数据。                         |
| grantReadACP                   | String              | 否       |        | 允许被授予者读取对象ACL。                                    |
| grantWriteACP                  | String              | 否       |        | 允许被授予者写入适用对象的ACL。                              |
| metadata                       | Map<String, String> | 否       |        | 指定是从源对象复制元数据，还是用请求中提供的元数据替换元数据。 |
| metadataDirective              | String              | 否       |        | 指定是从源对象复制元数据，还是用请求中提供的元数据替换元数据。 |
| taggingDirective               | String              | 否       |        | 指定是从源对象复制对象标记集，还是用请求中提供的标记集替换对象标记集。 |
| serverSideEncryption           | String              | 否       |        | 在AmazonS3中存储此对象时使用的服务器端加密算法（例如，AES256、aws:kms、aws:kms:dsse）。 |
| storageClass                   | String              | 否       |        | 如果不使用x-amz-storage-class标头，则默认情况下，复制的对象将存储在STANDARD存储类中。 |
| websiteRedirectLocation        | String              | 否       |        | 如果目标bucket配置为网站，则将此对象副本的请求重定向到同一bucket中的另一个对象或外部URL |
| sseCustomerAlgorithm           | String              | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKey                 | String              | 否       |        | 为AmazonS3指定客户提供的用于解密源对象的加密密钥             |
| sseCustomerKeyMD5              | String              | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |
| ssekmsKeyId                    | String              | 否       |        | 指定用于对象加密的AWS KMS ID（密钥ID、密钥ARN或密钥别名）    |
| ssekmsEncryptionContext        | String              | 否       |        | 如果存在，则指示用于对象加密的AWS KMS加密上下文。            |
| bucketKeyEnabled               | Bool                | 否       |        | 指定Amazon S3是否应使用S3桶密钥进行对象加密，并使用AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密 |
| copySourceSSECustomerAlgorithm | String              | 否       |        | 指定加密对象时要使用的算法（例如，AES256）。                 |
| copySourceSSECustomerKey       | String              | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
| copySourceSSECustomerKeyMD5    | String              | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |
| requestPayer                   | String              | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| tagging                        | String              | 否       |        | 为目标存储桶中的对象副本设置的标记。                         |
| objectLockMode                 | String              | 否       |        | 要应用于对象副本的“对象锁定”模式。                           |
| objectLockRetainUntilDate      | DateTime            | 否       |        | 希望对象副本的“对象锁定”过期的日期和时间。                   |
| objectLockLegalHoldStatus      | String              | 否       |        | 指定是否要对对象副本应用合法保留。                           |
| expectedBucketOwner            | String              | 否       |        | 预期目标存储桶所有者的帐户ID。如果您提供的帐户ID与目标存储桶的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| expectedSourceBucketOwner      | String              | 否       |        | 预期的源存储桶所有者的帐户ID。如果您提供的帐户ID与源bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数

| 参数名称                | **参数类型**                          | 是否必填 | 默认值 | 描述                                                         |
| ----------------------- | ------------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| copySourceVersionId     | String                                | 否       |        | 已复制的源对象的版本ID。                                     |
| expiration              | String                                | 否       |        | 如果配置了对象过期，则响应将包括此标头。                     |
| requestCharged          | String                                | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |
| serverSideEncryption    | String                                | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法（例如，AES256、aws:kms、aws:kms:dsse）。 |
| ssekmsKeyId             | String                                | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled        | Bool                                  | 否       |        | 指示复制的对象是否使用S3 Bucket Key与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| ssekmsEncryptionContext | String                                | 否       |        | 如果存在，则指示用于对象加密的AWS KMS加密上下文。            |
| sseCustomerAlgorithm    | String                                | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKeyMD5       | String                                | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| versionId               | String                                | 否       |        | 新创建副本的版本ID。                                         |
| copyObjectResult        | [copyObjectResult](#copyObjectResult) | 是       |        | CopyObjectResult参数的根级别标记。                           |





#### copyObjectResult

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| -------------- | ------------ | -------- | ------ | ------------------------------------ |
| etag           | String       | 否       |        | 返回新对象的ETag                     |
| lastModified   | DateTime     | 否       |        | 对象的创建日期。                     |
| checksumCRC32  | String       | 否       |        | 对象的base64编码的32位CRC32校验和。  |
| checksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和   |
| checksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要     |
| checksumSHA256 | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。 |











# 82、将对象的存档副本恢复回AmazonS3

## RestoreObject





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let restoreReq = RestoreObjectRequest(
            bucket: bucket2,
            key: objectId,
            restoreRequest: RestoreRequest(
                days: 2,
                glacierJobParameters: GlacierJobParameters(tier: "Expedited")
            )
        )
        println(restoreReq)
        try {
            let restoreRsp = s3.restoreObject(restoreReq)
            println(restoreRsp)
        } catch (ex: Exception) {
            println("${KNOWN_ISSUES_1} [restoreObject]: ${ex}")
        }
    }
}

```



### 请求参数列表



| 参数名称   | **参数类型**                                  | 是否必填 | 默认值 | 描述     |
| ---------- | --------------------------------------------- | -------- | ------ | -------- |
| restoreReq | [RestoreObjectRequest](#RestoreObjectRequest) | 是       |        | 参数对象 |





#### RestoreObjectRequest

| 参数名称            | **参数类型**                      | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | --------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String                            | 是       |        | 存储桶名称。                                                 |
| key                 | String                            | 是       |        | 为其启动操作的对象键。                                       |
| versionId           | String                            | 否       |        | 用于引用对象的特定版本的VersionId。                          |
| restoreRequest      | [RestoreRequest](#RestoreRequest) | 是       |        | RestoreRequest参数的根级别标记。                             |
| requestPayer        | String                            | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| checksumAlgorithm   | String                            | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。有效值:CRC32\| CRC32C \| SHA1 \|SHA256 |
| expectedBucketOwner | String                            | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |



##### RestoreRequest

| 参数名称             | **参数类型**                                  | 是否必填 | 默认值 | 描述                                                  |
| -------------------- | --------------------------------------------- | -------- | ------ | ----------------------------------------------------- |
| days                 | Int32                                         | 否       |        | 活动副本的生存期（天）。                              |
| glacierJobParameters | [GlacierJobParameters](#GlacierJobParameters) | 否       |        | S3与此作业相关的冰川相关参数。                        |
| type_                | String                                        | 否       |        | 还原请求的类型。有效值:SELECT                         |
| tier                 | String                                        | 否       |        | 将处理还原的检索层。有效值:Standard \|Bulk\|Expedited |
| description          | String                                        | 否       |        | 作业的可选描述。                                      |
| selectParameters     | [SelectParameters](#SelectParameters)         | 否       |        | 描述“选择作业类型”的参数。                            |
| outputLocation       | [OutputLocation](#OutputLocation)             | 否       |        | 描述存储还原作业输出的位置。                          |



##### OutputLocation

| 参数名称 | **参数类型**              | 是否必填 | 默认值 | 描述     |
| -------- | ------------------------- | -------- | ------ | -------- |
| s3       | [S3Location](#S3Location) | 是       |        | 参数对象 |



##### S3Location

| 参数名称          | **参数类型**                               | 是否必填 | 默认值 | 描述                                                         |
| ----------------- | ------------------------------------------ | -------- | ------ | ------------------------------------------------------------ |
| bucketName        | String                                     | 是       |        | 将在其中放置恢复结果的存储桶的名称。                         |
| prefix            | String                                     | 是       |        | 准备用于此请求的还原结果的前缀。                             |
| encryption        | [Encryption](#Encryption)                  | 否       |        | 包含所使用的服务器端加密类型。                               |
| cannedACL         | String                                     | 否       |        | 要应用于恢复结果的固定ACL。有操作<br />private \|public-read \|public-read-write \|authenticated-read \| aws-exec-read \|bucket-owner-read \|bucket-owner-full-control |
| accessControlList | ArrayList<[Grant](#Grant)>                 | 否       |        | 控制对暂存结果的访问的授权列表。                             |
| tagging           | [Tagging](#Tagging)                        | 否       |        | 应用于还原结果的标记集。                                     |
| userMetadata      | ArrayList<[MetadataEntry](#MetadataEntry)> | 否       |        | 要与S3中的恢复结果一起存储的元数据列表。                     |
| storageClass      | String                                     | 否       |        | 用于存储还原结果的存储类别。                                 |

##### MetadataEntry

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述         |
| -------- | ------------ | -------- | ------ | ------------ |
| name     | String       | String   |        | 对象的名称。 |
| value    | String       | String   |        | 对象的值。   |



###### Encryption

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| EncryptionType | String       | 是       |        | 在AmazonS3中存储作业结果时使用的服务器端加密算法（例如，AES256，aws:kms）。有效值:AES256 \| aws:kms \| aws:kms:dsse |
| KMSContext     | String       | 否       |        | 如果加密类型为aws:kms，则此可选值可用于指定还原结果的加密上下文。 |
| KMSKeyId       | String       | 否       |        | 如果加密类型为aws:kms，则此可选值指定用于加密作业结果的对称加密客户管理密钥的ID。 |





##### GlacierJobParameters

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                                    |
| -------- | ------------ | -------- | ------ | ------------------------------------------------------- |
| tier     | String       | 是       |        | 将处理还原的检索层。 有效值：Standard\| Bulk\|Expedited |



##### SelectParameters

| 参数名称            | **参数类型**                                | 是否必填 | 默认值 | 描述                              |
| ------------------- | ------------------------------------------- | -------- | ------ | --------------------------------- |
| inputSerialization  | [InputSerialization](#InputSerialization)   | 是       |        | 描述对象的序列化格式。            |
| expressionType      | String                                      | 是       |        | 提供的表达式的类型（例如，SQL）。 |
| expression          | String                                      | 是       |        | 用于查询对象的表达式。            |
| outputSerialization | [OutputSerialization](#OutputSerialization) | 是       |        | 描述如何序列化Select作业的结果。  |



###### InputSerialization

| 参数名称        | **参数类型**            | 是否必填 | 默认值 | 描述                                                         |
| --------------- | ----------------------- | -------- | ------ | ------------------------------------------------------------ |
| csv             | [CSVInput](#CSVInput)   | 否       |        | 描述CSV编码对象的序列化。                                    |
| compressionType | String                  | 否       |        | 指定对象的压缩格式。有效值：NONE、GZIP、BZIP2。默认值：NONE\|GZIP\|BZIP2 |
| json            | [JSONInput](#JSONInput) | 否       |        | 指定JSON作为对象的输入序列化格式。                           |
| parquet         | ParquetInput            | 否       |        | 指定Parquet作为对象的输入序列化格式。                        |



##### CSVInput

| 参数名称                   | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| fileHeaderInfo             | String       | 否       |        | 一个值，描述如何处理输入中的第一行。                         |
| comments                   | String       | 否       |        | 值                                                           |
| quoteEscapeCharacter       | String       | 否       |        | 单个字符，用于对已转义值内的引号字符进行转义。               |
| recordDelimiter            | String       | 否       |        | 单个字符，用于分隔各个记录。                                 |
| fieldDelimiter             | String       | 否       |        | 单个字符，用于分隔记录中的各个字段。该字符必须是 `\n`、`\r` 或范围 32–126 中的 ASCII 字符。默认值为逗号 (`,`)。 |
| quoteCharacter             | String       | 否       |        | 用作转义字符的单个字符，其中字段分隔符是值的一部分。         |
| allowQuotedRecordDelimiter | Bool         | 否       |        | 值                                                           |



###### JSONInput

| 参数名称 | **参数类型** | 是否必填 | 默认值 | 描述                                                     |
| -------- | ------------ | -------- | ------ | -------------------------------------------------------- |
| Contents | String       | 否       |        | 指定JSON作为对象的输入序列化格式。有效值:DOCUMENT\|LINES |





###### OutputSerialization

| 参数名称 | **参数类型**              | 是否必填 | 默认值 | 描述                               |
| -------- | ------------------------- | -------- | ------ | ---------------------------------- |
| CSV      | [CSVOutput](#CSVOutput)   | 否       |        | 描述CSV编码的Select结果的序列化。  |
| JSON     | [JSONOutput](#JSONOutput) | 否       |        | 指定JSON作为请求的输出序列化格式。 |



###### CSVOutput

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                    |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------- |
| quoteFields          | String       | 否       |        | 指示是否在输出字段周围使用引号。有效值:ALWAYS\|ASNEEDED |
| quoteEscapeCharacter | String       | 否       |        | 用于转义已转义的值中的引号字符的单个字符。              |
| recordDelimiter      | String       | 否       |        | 用于分隔记录中各个字段的值。                            |
| fieldDelimiter       | String       | 否       |        | 用于分隔记录中各个字段的值。您可以指定任意的分隔符。    |
| quoteCharacter       | String       | 否       |        | 当字段分隔符是值的一部分时，用于转义的单个字符。        |



###### JSONOutput

| 参数名称        | **参数类型** | 是否必填 | 默认值 | 描述                           |
| --------------- | ------------ | -------- | ------ | ------------------------------ |
| RecordDelimiter | String       |          |        | 用于在输出中分隔各个记录的值。 |





### 响应参数

| 参数名称          | **参数类型** | 是否必填 | 默认值 | 描述                                                     |
| ----------------- | ------------ | -------- | ------ | -------------------------------------------------------- |
| requestCharged    | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。               |
| restoreOutputPath | String       | 否       |        | 指示所提供的S3输出位置中的路径，选择结果将恢复到该位置。 |











# 82、此操作启动多部分上载并返回上载ID。

## CreateMultipartUpload



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let createReq = CreateMultipartUploadRequest(
            bucket: bucket2,
            key: objectId,
            checksumAlgorithm: "SHA256"
        )
        println(createReq)
        let createRsp = s3.createMultipartUpload(createReq)
        println(createRsp)
    }
}
```





### 请求参数列表



| 参数名称  | **参数类型**                                                 | 是否必填 | 默认值 | 描述     |
| --------- | ------------------------------------------------------------ | -------- | ------ | -------- |
| createReq | [CreateMultipartUploadRequest](#CreateMultipartUploadRequest) | 是       |        | 参数对象 |



#### CreateMultipartUploadRequest

| 参数名称                  | **参数类型**        | 是否必填 | 默认值 | 描述                                                         |
| ------------------------- | ------------------- | -------- | ------ | ------------------------------------------------------------ |
| acl                       | String              | 否       |        | 要应用于对象的固定ACL 有效值: private\| public-read \| public-read-write \| authenticated-read \|  aws-exec-read \| |
| bucket                    | String              | 是       |        | 启动多部分上传的bucket的名称以及上传对象的位置。             |
| cacheControl              | String              | 否       |        | 指定请求/回复链上的缓存行为。                                |
| contentDisposition        | String              | 否       |        | 指定对象的表示信息。                                         |
| contentEncoding           | String              | 否       |        | 指定对对象应用了哪些内容编码，从而指定必须应用哪些解码机制才能获得“内容类型”标头字段引用的媒体类型。 |
| contentLanguage           | String              | 否       |        | 内容使用的语言。                                             |
| contentType               | String              | 否       |        | 描述对象数据格式的标准MIME类型。                             |
| expires                   | DateTime            | 否       |        | 对象不再可缓存的日期和时间。                                 |
| grantFullControl          | String              | 否       |        | 明确指定访问权限，以授予被授予者对对象的READ、READ_ACP和WRITE_ACP权限。 |
| grantRead                 | String              | 否       |        | 明确指定访问权限，以允许被授予者读取对象数据及其元数据。     |
| grantReadACP              | String              | 否       |        | 明确指定访问权限以允许被授予者读取对象ACL。                  |
| grantWriteACP             | String              | 否       |        | 明确指定访问权限，以允许被授权者允许被授权人写入适用对象的ACL。 |
| key                       | String              | 是       |        | 要为其启动多部分上载的对象密钥。                             |
| metadata                  | Map<String, String> | 否       |        | 例如，以下x-amz-grant-read标头授予由帐户ID标识的AWS帐户读取对象数据及其元数据的权限： |
| serverSideEncryption      | String              | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法（例如，AES256，aws:kms）。有效值：AES256\| aws:kms \|aws:kms:dsse |
| storageClass              | String              | 否       |        | 默认情况下，AmazonS3使用STANDARD存储类来存储新创建的对象。有效值:STANDARD \| REDUCED_REDUNDANCY \| STANDARD_IA \|<br />ONEZONE_IA \| INTELLIGENT_TIERING \| GLACIER \| DEEP_ARCHIVE\|<br />OUTPOSTS \| GLACIER_IR \|SNOW \|EXPRESS_ONEZONE |
| websiteRedirectLocation   | String              | 否       |        | 如果bucket被配置为网站，则将对该对象的请求重定向到同一bucket中的另一个对象或外部URL。Amazon S3将该头的值存储在对象元数据中。 |
| sseCustomerAlgorithm      | String              | 否       |        | 指定加密对象时要使用的算法（例如，AES256）。                 |
| sseCustomerKey            | String              | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
| sseCustomerKeyMD5         | String              | 否       |        | 根据RFC 1321，指定客户提供的加密密钥的128位MD5摘要。         |
| ssekmsKeyId               | String              | 否       |        | 指定用于对象加密的对称加密客户管理密钥的ID（密钥ID、密钥ARN或密钥别名）。 |
| ssekmsEncryptionContext   | String              | 否       |        |                                                              |
| bucketKeyEnabled          | Bool                | 否       |        |                                                              |
| requestPayer              | String              | 否       |        |                                                              |
| tagging                   | String              | 否       |        | 对象的标记集。标记集必须编码为URL查询参数。                  |
| objectLockMode            | String              | 否       |        | 指定要应用于上载对象的对象锁定模式。 有效值： GOVERNANCE \|COMPLIANCE |
| objectLockRetainUntilDate | DateTime            | 否       |        | 指定希望对象锁定到期的日期和时间。                           |
| objectLockLegalHoldStatus | String              | 否       |        | 指定是否要对上载的对象应用合法保留。                         |
| expectedBucketOwner       | String              | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| checksumAlgorithm         | String              | 否       |        | 指示您希望AmazonS3用于创建对象的校验和的算法。有效值:CRC32\|<br /> CRC32C \| SHA1 \|SHA256 |



### 响应参数



| 参数名称                | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ----------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| abortDate               | DateTime     | 否       |        | 如果bucket的生命周期规则配置了中止不完整的多部分上传的操作，并且生命周期规则中的前缀与请求中的对象名称匹配，则响应包括此标头。 |
| abortRuleId             | String       | 否       |        | 此标头与x-amz-abort-date标头一起返回。它标识了适用的生命周期配置规则，该规则定义了中止不完整的多部分上载的操作。 |
| checksumAlgorithm       | String       | 否       |        | 用于创建对象的校验和的算法。有效值: CRC32 \| CRC32C \| SHA1 \|SHA256 |
| requestCharged          | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值：requester |
| serverSideEncryption    | String       | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法（例如，AES256，aws:kms）。有效值：AES256 \| aws:kms \|aws:kms:dsse |
| ssekmsKeyId             | String       | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled        | Bool         | 否       |        | 指示多部分上传是否使用S3 Bucket密钥与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| ssekmsEncryptionContext | String       | 否       |        | 如果存在，则指示用于对象加密的AWS KMS加密上下文。这个头的值是一个base64编码的UTF-8字符串，包含JSON和加密上下文键值对。 |
| sseCustomerAlgorithm    | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKeyMD5       | String       | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| bucket                  | String       | 否       |        | 启动多部分上载的存储桶的名称。如果使用，则不返回接入点ARN或接入点别名。 |
| Key                     | String       | 否       |        | 为其启动多部分上载的对象密钥。                               |
| uploadId                | String       | 否       |        | 已启动的多部分上载的ID。                                     |









# 83、在多部分上传中上传一个部分。

## UploadPart



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let uploadReq = UploadPartRequest(
                bucket: bucket2,
                key: objectId,
                uploadId: uploadId,
                partNumber: partNumber,
                checksumAlgorithm: "SHA256"
            )
            println(uploadReq)
            let data = StringUtils.repeat("A", 5) // 5MB
            let uploadRsp = s3.uploadPart(uploadReq, S3Content.fromString(data))
            println(uploadRsp)
    }
}
```



### 请求参数列表

| 参数名称  | **参数类型**                            | 是否必填 | 默认值 | 描述     |
| --------- | --------------------------------------- | -------- | ------ | -------- |
| uploadReq | [UploadPartRequest](#UploadPartRequest) | 是       |        | 参数对象 |



#### UploadPartRequest

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket               | String       | 是       |        | 启动多部分上载的存储桶的名称。                               |
| contentLength        | Int64        | 否       |        | 正文的大小（以字节为单位）。当无法自动确定实体的大小时，此参数非常有用。 |
| contentMD5           | String       | 否       |        | 部分数据的base64编码的128位MD5摘要。                         |
| checksumAlgorithm    | String       | 否       |        | 指示使用SDK时用于为对象创建校验和的算法。                    |
| checksumCRC32        | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同 |
| checksumCRC32C       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32C校验和 |
| checksumSHA1         | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同 |
| checksumSHA256       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的256位SHA-256摘要。 |
| key                  | String       | 是       |        | 为其启动多部分上载的对象密钥。                               |
| partNumber           | Int32        | 是       |        | 正在上载的零件的零件号。这是一个介于1和10000之间的正整数。   |
| uploadId             | String       | 是       |        | Upload ID标识正在上载其部分的多部分上载。                    |
| sseCustomerAlgorithm | String       | 否       |        | 指定加密对象时要使用的算法（例如，AES256）。                 |
| sseCustomerKey       | String       | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
| sseCustomerKeyMD5    | String       | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |
| requestPayer         | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。有效值:requester     |
| expectedBucketOwner  | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| sdkPartType          | String       | 否       |        | 类型                                                         |



### 响应参数

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket               | String       | 是       |        | 存储桶的名称                                                 |
| key                  | String       | 是       |        | 为其启动多部分上载的对象密钥。                               |
| location             | String       | 否       |        | 标识新创建的对象的URI。                                      |
| checksumCRC32        | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32校验和。 |
| checksumCRC32C       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32C校验和。 |
| checksumSHA1         | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的160位SHA-1摘要。 |
| checksumSHA256       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的256位SHA-256摘要。 |
| expiration           | String       | 否       |        | 如果配置了对象过期，它将包含过期日期（过期日期）和规则ID（规则ID） |
| serverSideEncryption | String       | 否       |        | 在AmazonS3中存储此对象时使用的服务器端加密算法（例如，AES256，aws:kms）。有效值:AES256\|aws:kms  \|aws:kms:dsse |
| versionId            | String       | 否       |        | 新创建的对象的版本ID，以防bucket已启用版本控制。             |
| ssekmsKeyId          | Bool         | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled     | String       | 否       |        | 指示多部分上传是否使用S3 Bucket密钥与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| requestCharged       | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |





# 84、此操作中止多部分上载。

## AbortMultipartUpload



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
            let abortReq = AbortMultipartUploadRequest(
                bucket: listRsp.bucket,
                key: upload.key,
                uploadId: upload.uploadId
            )
            println(abortReq)
            let abortRsp = s3.abortMultipartUpload(abortReq)
            println(abortRsp)
    }
}
```





### 请求参数列表

| 参数名称 | **参数类型**                | 是否必填 | 默认值 | 描述     |
| -------- | --------------------------- | -------- | ------ | -------- |
| abortReq | AbortMultipartUploadRequest | 是       |        | 参数对象 |



#### AbortMultipartUploadRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 存储桶名称。                                                 |
| key                 | String       | 是       |        | 为其启动多部分上载的对象的密钥。                             |
| uploadId            | String       | 是       |        | 用于标识多部分上载的上载ID。                                 |
| requestPayer        | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| expectedBucketOwner | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用                       |





### 响应参数

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                       |
| -------------- | ------------ | -------- | ------ | ------------------------------------------ |
| requestCharged | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 |













# 85、通过组装先前上载的部件来完成多部件上载。

## CompleteMultipartUpload



### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let completeReq = CompleteMultipartUploadRequest(
            bucket: bucket2,
            key: objectId,
            uploadId: uploadId,
            multipartUpload: CompletedMultipartUpload(parts: completedParts)
        )
        println(completeReq)
        let completeRsp = s3.completeMultipartUpload(completeReq)
        println(completeRsp)
    }
}
```





### 请求参数列表

| 参数名称    | **参数类型**                   | 是否必填 | 默认值 | 描述     |
| ----------- | ------------------------------ | -------- | ------ | -------- |
| completeReq | CompleteMultipartUploadRequest | 是       |        | 参数对象 |





#### CompleteMultipartUploadRequest

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket               | String       | 是       |        | 存储桶的名称                                                 |
| key                  | String       | 是       |        | 为其启动多部分上载的对象密钥。                               |
| location             | String       | 是       |        | 标识新创建的对象的URI。                                      |
| etag                 | String       | 否       |        | 实体标记，用于标识新创建的对象的数据                         |
| checksumCRC32        | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32校验和。 |
| checksumCRC32C       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的32位CRC32C校验和。 |
| checksumSHA1         | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的160位SHA-1摘要。 |
| checksumSHA256       | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同。此标头指定对象的base64编码的256位SHA-256摘要。 |
| expiration           | String       | 否       |        | 如果配置了对象过期，它将包含过期日期（过期日期）和规则ID（规则ID）。 |
| serverSideEncryption | String       | 否       |        | 在AmazonS3中存储此对象时使用的服务器端加密算法（例如，AES256，aws:kms）。 |
| versionId            | String       | 否       |        | 新创建的对象的版本ID，以防bucket已启用版本控制。             |
| ssekmsKeyId          | String       | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled     | Bool         | 否       |        | 指示多部分上传是否使用S3 Bucket密钥与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| requestCharged       | String       |          |        | 如果存在，则表示请求者已成功收取请求费用。                   |



##### CompletedMultipartUpload

| 参数名称 | **参数类型**             | 是否必填 | 默认值 | 描述                          |
| -------- | ------------------------ | -------- | ------ | ----------------------------- |
| parts    | ArrayList<CompletedPart> | 是       |        | CompletedPart数据类型的数组。 |



###### CompletedPart

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                 |
| -------------- | ------------ | -------- | ------ | ---------------------------------------------------- |
| partNumber     | Int32        | 否       |        | 标识零件的零件号。这是一个介于1和10000之间的正整数。 |
| etag           | String       | 否       |        | 上传零件时返回实体标记。                             |
| checksumCRC32  | String       | 否       |        | 对象的base64编码的32位CRC32校验和。                  |
| checksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。                 |
| checksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。                   |
| checksumSHA256 | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。                 |





### 响应参数

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| expiration           | String       | 否       |        | 如果配置了对象过期，它将包含过期日期（过期日期）和规则ID（规则ID）。规则id的值是URL编码的。 |
| requestCharged       | String       | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值：requester |
| serverSideEncryption | String       | 否       |        | 在AmazonS3中存储此对象时使用的服务器端加密算法（例如，AES256，aws:kms）。 有效值：AES256\|aws:kms\|aws:kms:dsse |
| ssekmsKeyId          | String       | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled     | String       | 否       |        | 指示多部分上传是否使用S3 Bucket密钥与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| versionId            | String       | 否       |        | 新创建的对象的版本ID，以防bucket已启用版本控制。             |
| bucket               | String       | 否       |        | 桶的名称                                                     |
| checksumCRC32        | String       | 否       |        | 对象的base64编码的32位CRC32校验和。                          |
| checksumCRC32C       | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。                         |
| checksumSHA1         | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| checksumSHA256       | String       | 否       |        | 对象的base64编码的256位SHA-256摘要                           |
| etag                 | String       | 否       |        | 实体标记，用于标识新创建的对象的数据。                       |
| Key                  | String       | 否       |        | 新创建的对象的对象键。                                       |
| location             | String       | 否       |        | 标识新创建的对象的URI。                                      |









# 86、此操作在bucket中列出正在进行的多部分上载。

## ListMultipartUploads

### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listReq = ListMultipartUploadsRequest(bucket: bucket2, maxUploads: 10)
        println(listReq)
        let listRsp = s3.listMultipartUploads(listReq)
        println(listRsp)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                                | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------------------- | -------- | ------ | -------- |
| listReq  | [ListMultipartUploadsRequest](#ListMultipartUploadsRequest) | 是       |        | 参数对象 |





#### ListMultipartUploadsRequest

| 参数名称            | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket              | String       | 是       |        | 存储桶的名称                                                 |
| delimiter           | String       | 否       |        | 用于对关键点进行分组的角色。                                 |
| encodingType        | String       | 否       |        | 请求AmazonS3对响应中的对象密钥进行编码，并指定要使用的编码方法 有效值:url |
| keyMarker           | String       | 否       |        | 指定应在其之后开始列表的多部分上载。                         |
| maxUploads          | Int32        | 否       |        | 设置要在响应正文中返回的多部分上传的最大数量，从1到1000。1000是响应中可以返回的最大上传次数。 |
| prefix              | String       | 否       |        | 仅列出以指定前缀开头的密钥的正在进行的上载。                 |
| uploadIdMarker      | String       | 否       |        | 与key-marker一起，指定列表开始后的多部分上传。               |
| expectedBucketOwner | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| requestPayer        | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。有效值:requester     |



### 响应参数

| 参数名称           | **参数类型**                        | 是否必填 | 默认值 | 描述                                                         |
| ------------------ | ----------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| requestCharged     | String                              | 否       |        | 如果存在，则表示请求者已成功收取请求费用。 有效值requester   |
| bucket             | String                              | 否       |        | 存储桶的名称                                                 |
| commonPrefixes     | [CommonPrefix](#CommonPrefix)       | 否       |        | 如果在请求中指定了分隔符，那么结果将返回每个不同的键前缀，该前缀包含CommonPrefixes元素中的分隔符。 |
| delimiter          | String                              | 否       |        | 包含您在请求中指定的分隔符。                                 |
| encodingType       | String                              | 否       |        | AmazonS3用于对响应中的对象密钥进行编码的编码类型。有效值：url |
| isTruncated        | Bool                                | 否       |        | 指示返回的多部分上载列表是否被截断                           |
| keyMarker          | String                              | 否       |        | 开始登录时或之后的密钥。                                     |
| maxUploads         | Int64                               | 否       |        | 响应中可能包含的多部分上载的最大数量。                       |
| nextKeyMarker      | String                              | 否       |        | 当列表被截断时，此元素指定应用于后续请求中的键标记请求参数的值。 |
| nextUploadIdMarker | String                              | 否       |        | 当列表被截断时，此元素指定应用于后续请求中的上传id标记请求参数的值。 |
| prefix             | String                              | 否       |        | 当在请求中提供前缀时，此字段包含指定的前缀。                 |
| uploads            | [MultipartUpload](#MultipartUpload) | 否       |        | 与特定多部分上传相关的元素的容器。                           |
| uploadIdMarker     | String                              | 否       |        | 与key-marker一起，指定列表开始后的多部分上传。               |





#### MultipartUpload

| 参数名称     | **参数类型**            | 是否必填 | 默认值 | 描述                                       |
| ------------ | ----------------------- | -------- | ------ | ------------------------------------------ |
| uploadId     | String                  | 否       |        | 用于标识多部分上载的上载ID。               |
| key          | String                  | 否       |        | 为其启动多部分上载的对象的密钥。           |
| initiated    | DateTime                | 否       |        | 标识发起多部分上载的人。                   |
| storageClass | String                  | 否       |        | 用于存储对象的存储类。                     |
| owner        | [Owner](#Owner)         | 否       |        | 指定作为多部分上载的一部分的对象的所有者。 |
| initiator    | [Initiator](#Initiator) | 否       |        | 启动多部分上载的日期和时间。               |













# 87、列出为特定的多部分上载而上载的部件。

## ListParts





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let listPartsReq = ListPartsRequest(
            bucket: bucket2,
            key: objectId,
            uploadId: uploadId
        )
        println(listPartsReq)
        let listPartsRsp = s3.listParts(listPartsReq)
        println(listPartsRsp)
    }
}
```





### 请求参数列表



| 参数名称     | **参数类型**                          | 是否必填 | 默认值 | 描述     |
| ------------ | ------------------------------------- | -------- | ------ | -------- |
| listPartsReq | [ListPartsRequest](#ListPartsRequest) | 是       |        | 参考对象 |





#### ListPartsRequest

| 参数名称             | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| bucket               | String       | 是       |        | 存储桶的名称                                                 |
| key                  | String       | 是       |        | 为其启动多部分上载的对象密钥。                               |
| uploadId             | String       | 是       |        | Upload ID，标识要列出其部件的多部分上载。                    |
| maxParts             | Int32        | 否       |        | 设置要返回的最大零件数。                                     |
| partNumberMarker     | Int32        | 否       |        | 指定应在其之后开始列出的零件。                               |
| requestPayer         | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner  | String       | 否       |        | 预期存储桶所有者的帐户ID。如果您提供的帐户ID与bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| sseCustomerAlgorithm | String       | 否       |        | 用于加密对象的服务器端加密（SSE）算法。                      |
| sseCustomerKey       | String       | 否       |        | 服务器端加密（SSE）客户管理的密钥。                          |
| sseCustomerKeyMD5    | String       | 否       |        | MD5服务器端加密（SSE）客户管理的密钥。                       |



### 响应参数



| 参数名称             | **参数类型**             | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | ------------------------ | -------- | ------ | ------------------------------------------------------------ |
| abortDate            | String                   | 否       |        | 如果bucket的生命周期规则配置有中止不完整的多部分上载的操作   |
| abortRuleId          | String                   | 否       |        | 此标头与x-amz-abort-date标头一起返回。                       |
| requestCharged       | String                   | 否       |        | 如果存在，则表示请求者已成功收取请求费用。                   |
| bucket               | String                   | 否       |        | 存储桶的名称                                                 |
| checksumAlgorithm    | String                   | 否       |        | 用于创建对象的校验和的算法。 有效值:CRC32\|CRC32C\|SHA1\|SHA256 |
| initiator            | [Initiator](#Initiator)  | 否       |        | Container元素，用于标识发起多部分上载的人                    |
| isTruncated          | Bool                     | 否       |        | 指示返回的零件列表是否被截断                                 |
| key                  | String                   | 否       |        | 为其启动多部分上载的对象密钥。                               |
| maxParts             | Int64                    | 否       |        | 响应中允许的最大部件数。                                     |
| nextPartNumberMarker | Int64                    | 否       |        | 当列表被截断时，此元素指定列表中的最后一个零件，以及在后续请求中用于零件号标记请求参数的值。 |
| owner                | [Owner](#Owner)          | 否       |        | Container元素，在创建对象后标识对象所有者。                  |
| parts                | ArrayList<[Part](#Part)> | 否       |        | 与特定零件相关的元素的容器。                                 |
| partNumberMarker     | Int64                    | 否       |        | 指定应在其之后开始列出的零件                                 |
| storageClass         | String                   | 否       |        | 用于存储上载对象的存储类。有效值：STANDARD\| REDUCED_REDUNDANCY \| STANDARD_IA \|ONEZONE_IA \|INTELLIGENT_TIERING \| GLACIER \|DEEP_ARCHIVE \|OUTPOSTS \|GLACIER_IR \|SNOW \|EXPRESS_ONEZONE |
| uploadId             | String                   | 否       |        | Upload ID，标识要列出其部件的多部分上载。                    |







#### Part

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| -------------- | ------------ | -------- | ------ | ------------------------------------------------------------ |
| ChecksumCRC32  | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同 |
| ChecksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和                           |
| ChecksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。                           |
| ChecksumSHA256 | String       | 否       |        | 此标头可用作数据完整性检查，以验证接收到的数据是否与最初发送的数据相同 |
| ETag           | String       | 否       |        | 上传零件时返回实体标记。                                     |
| LastModified   | Timestamp    | 否       |        | 零件上传的日期和时间。                                       |
| PartNumber     | Int64        | 否       |        | 识别零件的零件号。这是一个介于1和10000之间的正整数。         |
| Size           | Long         | 否       |        | 上载的零件数据的大小（以字节为单位）。                       |





#### Initiator

| 参数名称    | **参数类型** | 是否必填 | 默认值 | 描述                                    |
| ----------- | ------------ | -------- | ------ | --------------------------------------- |
| DisplayName | String       | 否       |        | 委托人的姓名。                          |
| ID          | String       | 否       |        | 如果委托人是AWS帐户，它会提供规范用户ID |













# 88、通过将现有对象中的数据作为数据源进行复制来上载零件

## UploadPartCopy





### 示例代码

```json
@Test
public class BucketBasicTest {
    @TestCase
    public func testBucket_basic(): Unit {
        let copyReq = UploadPartCopyRequest(
            sourceBucket: bucket2,
            sourceKey: fromObjectId,
            destinationBucket: bucket2,
            destinationKey: toObjectId,
            uploadId: createRsp.uploadId,
            partNumber: 1
        )
        let copyRsp = s3.uploadPartCopy(copyReq)
        println(copyRsp)
    }
}
```





### 请求参数列表



| 参数名称 | **参数类型**                                    | 是否必填 | 默认值 | 描述     |
| -------- | ----------------------------------------------- | -------- | ------ | -------- |
| copyReq  | [UploadPartCopyRequest](#UploadPartCopyRequest) | 是       |        | 参数对象 |



#### UploadPartCopyRequest

| 参数名称                       | **参数类型** | 是否必填 | 默认值 | 描述                                                         |
| ------------------------------ | ------------ | -------- | ------ | ------------------------------------------------------------ |
| uploadId                       | String       | 是       |        | Upload ID标识要复制其部分的多部分上载。                      |
| partNumber                     | Int32        | 是       |        | 正在复制的零件的零件号。                                     |
| copySource                     | String       | 是       |        | 指定复制操作的源对象。                                       |
| copySourceIfMatch              | String       | 否       |        | 如果对象的实体标记（ETag）与指定的标记匹配，则复制该对象。   |
| copySourceIfModifiedSince      | DateTime     | 否       |        | 如果自指定时间以来已对对象进行了修改，则复制该对象。         |
| copySourceIfNoneMatch          | String       | 否       |        | 如果对象的实体标记（ETag）不同于指定的ETag，则复制该对象。   |
| copySourceIfUnmodifiedSince    | DateTime     | 否       |        | 如果自指定时间以来未对对象进行修改，则复制该对象。           |
| copySourceRange                | String       | 否       |        | 要从源对象复制的字节范围                                     |
| sseCustomerAlgorithm           | String       | 否       |        | 指定解密源对象时要使用的算法（例如，AES256）。               |
| sseCustomerKey                 | String       | 否       |        | 为AmazonS3指定客户提供的用于解密源对象的加密密钥。           |
| sseCustomerKeyMD5              | String       | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要                       |
| copySourceSSECustomerAlgorithm | String       | 否       |        | 指定加密对象时要使用的算法（例如，AES256）。                 |
| copySourceSSECustomerKey       | String       | 否       |        | 指定客户提供的AmazonS3加密数据时使用的加密密钥。             |
| copySourceSSECustomerKeyMD5    | String       | 否       |        | 根据RFC 1321指定加密密钥的128位MD5摘要。                     |
| requestPayer                   | String       | 否       |        | 确认请求者知道他们将因请求而被收取费用。                     |
| expectedBucketOwner            | String       | 否       |        | 预期目标存储桶所有者的帐户ID。如果您提供的帐户ID与目标存储桶的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |
| expectedSourceBucketOwner      | String       | 否       |        | 预期的源存储桶所有者的帐户ID。如果您提供的帐户ID与源bucket的实际所有者不匹配，则请求失败，HTTP状态代码为403 Forbidden（访问被拒绝）。 |





### 响应参数



| 参数名称             | **参数类型**                      | 是否必填 | 默认值 | 描述                                                         |
| -------------------- | --------------------------------- | -------- | ------ | ------------------------------------------------------------ |
| copySourceVersionId  | String                            | 否       |        | 如果已对源存储桶启用版本控制，则复制的源对象的版本。         |
| requestCharged       | String                            | 否       |        | 如果存在，则表示请求者已成功收取请求费用。有效值：requester  |
| serverSideEncryption | String                            | 否       |        | 将此对象存储在AmazonS3中时使用的服务器端加密算法（例如，AES256，aws:kms）。有效值：AES256 \|aws:kms \|aws:kms:dsse |
| ssekmsKeyId          | String                            | 否       |        | 如果存在，表示用于对象的AWS密钥管理服务（AWS KMS）对称加密客户管理密钥的ID。 |
| bucketKeyEnabled     | String                            | 否       |        | 指示多部分上传是否使用S3 Bucket密钥与AWS密钥管理服务（AWS KMS）密钥（SSE-KMS）进行服务器端加密。 |
| sseCustomerAlgorithm | String                            | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以确认所使用的加密算法。 |
| sseCustomerKeyMD5    | String                            | 否       |        | 如果请求使用客户提供的加密密钥进行服务器端加密，则响应将包括此标头，以提供客户提供的密钥的往返消息完整性验证。 |
| copyPartResult       | [copyPartResult](#copyPartResult) | 是       |        | CopyPartResult参数的根级别标记。                             |

​	



#### copyPartResult

| 参数名称       | **参数类型** | 是否必填 | 默认值 | 描述                                 |
| -------------- | ------------ | -------- | ------ | ------------------------------------ |
| ChecksumCRC32  | String       | 否       |        | 对象的base64编码的32位CRC32校验和。  |
| ChecksumCRC32C | String       | 否       |        | 对象的base64编码的32位CRC32C校验和。 |
| ChecksumSHA1   | String       | 否       |        | 对象的base64编码的160位SHA-1摘要。   |
| ChecksumSHA256 | String       | 否       |        | 对象的base64编码的256位SHA-256摘要。 |
| etag           | String       | 否       |        | 对象的实体标记。                     |
| LastModified   | DateTime     | 否       |        | 上载对象的日期和时间。               |







