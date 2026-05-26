# 仓颉 1.0.5 → 1.1.0 升级适配说明

## 概述

本次升级将 s3client 和 example 从仓颉 (Cangjie) 1.0.5 版本适配到 1.1.0 版本。

## 环境依赖

| 组件 | 版本 |
|------|------|
| Cangjie SDK | 1.1.0 (cjnative) |
| Cangjie STDX | 1.1.0.1 |

## 代码变更

### 1. `CertificateVerifyMode` 包路径变更

**文件:** `s3client/src/core/_package.cj`

在仓颉 1.1.0 中，`CertificateVerifyMode` 从 `stdx.net.tls` 包移动到了 `stdx.net.tls.common` 子包。

```diff
- internal import stdx.net.tls.CertificateVerifyMode
+ internal import stdx.net.tls.common.CertificateVerifyMode
```

### 2. 静态泛型方法在 `static let` 初始化中触发编译器 ICE

**文件:** `s3client/src/core/s3_metrics.cj`

在仓颉 1.1.0 编译器中，通过 `static func metric<T>()` 泛型方法初始化 `static let` 字段会触发 Internal Compiler Error（LLVM IR 参数数量不匹配）。

解决方案：移除泛型辅助方法 `metric<T>()`，改为直接调用 `S3Metric<T>()` 构造函数进行初始化。

```diff
  public class S3Metrics {
-     private static func metric<T>(name: String, level: S3MetricLevel): S3Metric<T> where T <: ToString {
-         return S3Metric<T>(name, level)
-     }
-     public static let SERVICE_ID = metric<String>("ServiceId", S3MetricLevel.ERROR)
-     public static let OPERATION_NAME = metric<String>("OperationName", S3MetricLevel.ERROR)
+     public static let SERVICE_ID = S3Metric<String>("ServiceId", S3MetricLevel.ERROR)
+     public static let OPERATION_NAME = S3Metric<String>("OperationName", S3MetricLevel.ERROR)
      ...
  }
```

## 验证结果

使用本地 MinIO 服务进行验证，以下所有功能均测试通过：

- ✅ s3client 库编译成功
- ✅ example 编译并运行成功
- ✅ demo 编译成功
- ✅ benchmark (simple & perf) 编译成功
- ✅ Bucket 创建/列表/删除
- ✅ Object 上传（字符串/二进制/文件/带 Metadata）
- ✅ Object 列表
- ✅ Object 下载（字符串/文件）
- ✅ Object 复制
- ✅ 预签名 URL 生成
- ✅ 异步操作
- ✅ 资源清理

## 构建方法

```bash
# 设置 Cangjie 1.1.0 环境
source <cangjie-sdk-path>/envsetup.sh
export CANGJIE_STDX_PATH=<stdx-path>/linux_x86_64_cjnative/dynamic/stdx

# 构建 s3client
cd s3client && cjpm build

# 构建并运行 example
cd example && cjpm run
```
