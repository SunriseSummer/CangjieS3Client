# CangjieS3Client 示例项目

本示例演示如何使用 `s3client` 仓颉库访问 S3 兼容的对象存储服务（以 MinIO 为例）。

## 功能演示

示例程序涵盖以下典型 S3 操作场景：

1. **Bucket 操作** — 创建 Bucket、检查 Bucket 是否存在、列出所有 Bucket
2. **上传对象** — 上传字符串、二进制数据、带自定义 Metadata 的对象、从文件上传
3. **列出对象** — 按前缀列出对象，展示对象名和大小
4. **下载对象** — 下载为字符串、下载为文件、查看对象头部信息（HeadObject）
5. **复制对象** — 在同一 Bucket 内复制对象
6. **预签名 URL** — 生成 GET/PUT 预签名 URL
7. **异步操作** — 异步上传对象并使用回调处理结果
8. **资源清理** — 列出并删除所有对象，删除 Bucket

## 前置条件

### 1. 安装仓颉 SDK

下载并解压仓颉编译器：

```bash
# 下载 SDK
wget https://github.com/SunriseSummer/CangjieSDK/releases/download/1.0.5/cangjie-sdk-linux-x64-1.0.5.tar.gz

# 解压
tar xzf cangjie-sdk-linux-x64-1.0.5.tar.gz

# 设置环境变量（将 <解压路径> 替换为实际路径）
source <解压路径>/cangjie/envsetup.sh
```

### 2. 安装仓颉 STDX

下载并解压仓颉扩展标准库：

```bash
# 下载 STDX
wget https://github.com/SunriseSummer/CangjieSDK/releases/download/1.0.5/cangjie-stdx-linux-x64-1.0.5.1.zip

# 解压
unzip cangjie-stdx-linux-x64-1.0.5.1.zip -d cangjie-stdx

# 设置环境变量
export CANGJIE_STDX_PATH=<解压路径>/cangjie-stdx/linux_x86_64_cjnative/dynamic/stdx
```

### 3. 安装 MinIO（本地 S3 服务）

MinIO 是一个高性能的 S3 兼容对象存储服务，可方便地在本地进行开发测试。

```bash
# 下载 MinIO
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio

# 创建数据目录
mkdir -p ~/minio-data

# 启动 MinIO（默认用户名/密码: minioadmin/minioadmin）
MINIO_ROOT_USER=minioadmin MINIO_ROOT_PASSWORD=minioadmin \
  ./minio server ~/minio-data --address :9000 --console-address :9001
```

启动后：
- **S3 API 地址**：`http://127.0.0.1:9000`
- **Web 管理控制台**：`http://127.0.0.1:9001`（可在浏览器中访问）

## 编译 s3client 库

在运行示例前，需要先编译 `s3client` 库：

```bash
cd s3client
cjpm build
```

## 编译与运行示例

```bash
cd example

# 编译
cjpm build

# 运行
cjpm run
```

如果需要自定义 MinIO 连接信息，请修改 `src/main.cj` 中的以下常量：

```
let ENDPOINT    = "http://127.0.0.1:9000"  // S3 服务地址
let ACCESS_KEY  = "minioadmin"              // Access Key
let SECRET_KEY  = "minioadmin"              // Secret Key
let BUCKET_NAME = "example-bucket"          // Bucket 名称
```

## 预期输出

```
=== CangjieS3Client 示例程序 ===

--- 1. Bucket 操作 ---
  创建 Bucket: example-bucket, location=/example-bucket
  当前 Bucket 列表:
    - example-bucket (创建时间: ...)

--- 2. 上传 Object ---
  上传文本: test/hello.txt, ETag="..."
  上传二进制: test/binary.dat, ETag="..."
  上传带 Metadata: test/with-metadata.txt, ETag="..."
  上传文件: test/from-file.txt, ETag="..."

--- 3. 列出 Object ---
  Bucket 'example-bucket' 中 'test/' 前缀下的对象 (共 4 个):
    - test/binary.dat (大小: 256 字节)
    - test/from-file.txt (大小: 68 字节)
    - test/hello.txt (大小: 51 字节)
    - test/with-metadata.txt (大小: 33 字节)

--- 4. 下载 Object ---
  下载 test/hello.txt: contentLength=Some(51)
  内容: Hello, 仓颉 S3Client! 这是一段测试文本。
  ...

--- 5. 复制 Object ---
  复制 test/hello.txt -> test/hello-copy.txt, ETag=...

--- 6. 预签名 URL ---
  GET 预签名 URL (1小时有效):
    http://127.0.0.1:9000/example-bucket/test/hello.txt?X-Amz-...
  PUT 预签名 URL (30分钟有效):
    http://127.0.0.1:9000/example-bucket/test/presigned-upload.txt?X-Amz-...

--- 7. 异步操作 ---
  异步上传完成: test/async-upload.txt, ETag="..."

--- 8. 清理资源 ---
  删除对象: test/async-upload.txt
  删除对象: test/binary.dat
  ...
  删除 Bucket: example-bucket
  确认 Bucket 'example-bucket' 已成功删除

=== 所有示例执行完毕 ===
```

## 连接其他 S3 服务

本示例同样适用于 AWS S3、阿里云 OSS、华为云 OBS 等 S3 兼容服务，只需修改 `ENDPOINT`、`ACCESS_KEY` 和 `SECRET_KEY` 即可。

> **注意**：连接 MinIO 或其他使用路径风格（path-style）的 S3 服务时，需要设置 `.forcePathStyle(true)`。连接 AWS S3 等使用虚拟主机风格（virtual-hosted-style）的服务时，可省略此设置。

## 项目结构

```
example/
├── cjpm.toml          # 仓颉包管理配置
├── readme.md          # 本文档
└── src/
    └── main.cj        # 示例代码
```
