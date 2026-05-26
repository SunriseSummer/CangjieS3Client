
性能测试
- 服务端: MinIO RELEASE.2024-06-29T01-20-47Z (go1.22.4 linux/amd64), MinIO未经调优, 使用默认配置
- 客户端: 100并发, 每个并发执行1000次迭代, 每个迭代会执行3个操作 putObject, getObject, deleteObject

#### 前置条件
- 已经编译完 `s3client4cj`

#### 编译/运行
```
cjpm build -V
export LD_LIBRARY_PATH=../../target/release/s3client:$CANGJIE_STDX_PATH:$LD_LIBRARY_PATH
export cjHeapSize=1GB
target/release/bin/main --endpoint=http://localhost:9000 --accessKeyId=DxXnzPqzfWlU0XKWBCK3 --secretAccessKey=7rGzgiKaya5oBuRgKk4dlvnMGt36hZUpk9FOMlVB --connections=100 --threads=100 --loopCount=1000
```

#### 结果
``` 
Cangjie
    ......
    ......
    ......
    End thread: 45 => FinishedLoops: 1000, Duration: 21s732ms16us991ns
    End thread: 95 => FinishedLoops: 1000, Duration: 21s736ms916us923ns
    End thread: 40 => FinishedLoops: 1000, Duration: 21s729ms430us375ns
    End thread: 42 => FinishedLoops: 1000, Duration: 21s733ms924us440ns
    End thread: 54 => FinishedLoops: 1000, Duration: 21s734ms672us532ns
    End thread: 23 => FinishedLoops: 1000, Duration: 21s745ms977us721ns
    End thread: 77 => FinishedLoops: 1000, Duration: 21s749ms618us612ns
    End thread: 66 => FinishedLoops: 1000, Duration: 21s754ms74us472ns
    End thread: 86 => FinishedLoops: 1000, Duration: 21s750ms212us271ns
    End thread: 26 => FinishedLoops: 1000, Duration: 21s757ms663us477ns
    End thread: 69 => FinishedLoops: 1000, Duration: 21s755ms404us68ns
    End thread: 83 => FinishedLoops: 1000, Duration: 21s753ms550us933ns
    End thread: 22 => FinishedLoops: 1000, Duration: 21s756ms696us744ns
    End thread: 30 => FinishedLoops: 1000, Duration: 21s759ms525us535ns
    End thread: 18 => FinishedLoops: 1000, Duration: 21s761ms503us607ns
    End thread: 10 => FinishedLoops: 1000, Duration: 21s757ms193us951ns
    End thread: 52 => FinishedLoops: 1000, Duration: 21s757ms275us875ns
    End thread: 64 => FinishedLoops: 1000, Duration: 21s768ms44us552ns
    End thread: 93 => FinishedLoops: 1000, Duration: 21s778ms192us583ns
    End thread: 82 => FinishedLoops: 1000, Duration: 21s795ms970us485ns
    End thread: 14 => FinishedLoops: 1000, Duration: 21s801ms184us396ns
End test
FinishedLoops: 100000, Duration: 21s806ms940us534ns
```

``` 
Java
    ......
    ......
    ......
    End thread: 73 => FinishedLoops: 1000, Duration: 23250
    End thread: 26 => FinishedLoops: 1000, Duration: 23260
    End thread: 70 => FinishedLoops: 1000, Duration: 23256
    End thread: 65 => FinishedLoops: 1000, Duration: 23257
    End thread: 56 => FinishedLoops: 1000, Duration: 23266
    End thread: 62 => FinishedLoops: 1000, Duration: 23263
    End thread: 95 => FinishedLoops: 1000, Duration: 23269
    End thread: 82 => FinishedLoops: 1000, Duration: 23266
    End thread: 55 => FinishedLoops: 1000, Duration: 23271
    End thread: 74 => FinishedLoops: 1000, Duration: 23268
    End thread: 59 => FinishedLoops: 1000, Duration: 23276
    End thread: 67 => FinishedLoops: 1000, Duration: 23277
    End thread: 69 => FinishedLoops: 1000, Duration: 23287
    End thread: 5 => FinishedLoops: 1000, Duration: 23289
    End thread: 63 => FinishedLoops: 1000, Duration: 23287
    End thread: 29 => FinishedLoops: 1000, Duration: 23287
    End thread: 6 => FinishedLoops: 1000, Duration: 23286
    End thread: 88 => FinishedLoops: 1000, Duration: 23289
    End thread: 23 => FinishedLoops: 1000, Duration: 23290
    End thread: 33 => FinishedLoops: 1000, Duration: 23297
    End thread: 21 => FinishedLoops: 1000, Duration: 23296
    End thread: 34 => FinishedLoops: 1000, Duration: 23301
    End thread: 93 => FinishedLoops: 1000, Duration: 23318
    End thread: 78 => FinishedLoops: 1000, Duration: 23326
    End thread: 97 => FinishedLoops: 1000, Duration: 23331
    End thread: 32 => FinishedLoops: 1000, Duration: 23358
End test
FinishedLoops: 100000, Duration: 23363
``` 