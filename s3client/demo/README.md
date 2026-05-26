
#### 前置条件
- 已经编译完 `s3client4cj`
- 修改 `src/main.cj` 里 `${accessKeyId}`, `${secretAccessKey}`

#### 编译/运行
- 方式一
```
cjpm clean &&  cjpm run -V
```

- 方式二 (Win)
```
cjpm clean &&  cjpm build -V
set Path=../target/release/s3client4cj;%Path%
target\release\bin\main.exe
```