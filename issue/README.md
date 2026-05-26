# 仓颉 1.1.0 编译器 ICE：静态泛型方法在 `static let` 初始化中触发 Internal Compiler Error

## 环境

| 组件 | 版本 |
|------|------|
| Cangjie Compiler | 1.1.0 (cjnative) |
| Target | x86_64-unknown-linux-gnu |

## Bug 描述

当一个类中定义了**泛型静态方法**（如 `static func create<T>(...): Wrapper<T>`），并在同一个类中通过该方法初始化 **`static let`** 字段时，编译器产生 Internal Compiler Error。

错误信息：
```
Internal Compiler Error: Broken llvm ir!
Please report this to Cangjie team and include the project. Error Code: 13
Incorrect number of arguments passed to called function!
```

## 触发条件

1. 存在一个泛型类 `Wrapper<T>`
2. 另一个类中定义 `private static func create<T>()` 泛型工厂方法，返回 `Wrapper<T>`
3. 使用该泛型工厂方法初始化 `static let` 字段

## 最小复现代码

```cangjie
package ice_repro

enum Level <: ToString {
    A | B
    public func toString(): String {
        match (this) {
            case A => "A"
            case B => "B"
        }
    }
}

class Wrapper<T> <: ToString where T <: ToString {
    let name: String
    let level: Level
    init(name: String, level: Level) {
        this.name = name
        this.level = level
    }
    public func toString(): String {
        return "Wrapper(${name}, ${level})"
    }
}

class Registry {
    // 泛型工厂方法 —— 触发 ICE 的关键
    private static func create<T>(name: String, level: Level): Wrapper<T> where T <: ToString {
        return Wrapper<T>(name, level)
    }

    // 通过泛型工厂方法初始化 static let —— 触发 ICE
    public static let FIELD_A = create<String>("fieldA", Level.A)
    public static let FIELD_B = create<Int64>("fieldB", Level.B)
}

main(): Int64 {
    println(Registry.FIELD_A)
    println(Registry.FIELD_B)
    return 0
}
```

## 复现步骤

```bash
source /path/to/cangjie/envsetup.sh
cd issue
cjpm build
```

## 完整编译器输出

```
Incorrect number of arguments passed to called function!
Cangjie Compiler: 1.1.0 (cjnative)
Target: x86_64-unknown-linux-gnu
Internal Compiler Error: Broken llvm ir!
Please report this to Cangjie team and include the project. Error Code: 13
Error: failed to compile package `ice_repro`, return code is 2
Error: cjpm build failed
  %0 = call i8 addrspace(1)* @_CN9ice_repro8Registry6createIG_HRNat6StringENNY_5LevelE(
    %"record.std.core:String"* @"$const_cjstring.2FEkxMpvVQh",
    i32 1,
    %TypeInfo* @"ice_repro:Registry.ti",
    %TypeInfo* @"ice_repro:Registry.ti"), !dbg !23
```

## 绕过方案

不使用泛型工厂方法，改为直接调用泛型类的构造函数：

```diff
  class Registry {
-     private static func create<T>(name: String, level: Level): Wrapper<T> where T <: ToString {
-         return Wrapper<T>(name, level)
-     }
-     public static let FIELD_A = create<String>("fieldA", Level.A)
-     public static let FIELD_B = create<Int64>("fieldB", Level.B)
+     public static let FIELD_A = Wrapper<String>("fieldA", Level.A)
+     public static let FIELD_B = Wrapper<Int64>("fieldB", Level.B)
  }
```

## 备注

该 bug 在从仓颉 1.0.5 升级到 1.1.0 时发现（原项目 `s3client/src/core/s3_metrics.cj`），在 1.0.5 中同样的代码可以正常编译。
