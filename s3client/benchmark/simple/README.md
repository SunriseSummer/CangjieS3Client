
单线程的循环测试, 不实际发送 HTTP 请求, 主要测试除 HTTP 请求之外的代码耗时

#### 前置条件
- 已经编译完 `s3client4cj`

#### 编译/运行
```
cjpm clean &&  cjpm run -V
```

#### 结果
``` 
Cangjie
===== GetObjectAcl: 5ms989us500ns
===== PutObjectAcl: 5ms943us500ns
===== ListObjectsV2Paginator: 33ms705us600ns
```

``` 
Java
===== GetObjectAcl: 13ms
===== PutObjectAcl: 8ms
===== ListObjectsV2Paginator: 52ms
``` 