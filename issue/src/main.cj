package ice_repro

// ---- 最小复现：静态泛型方法在 static let 初始化中触发编译器 ICE ----
//
// 仓颉 1.1.0 (cjnative) 编译以下代码时，会产生 Internal Compiler Error:
//   "Broken llvm ir! ... Incorrect number of arguments passed to called function!"
//
// 触发条件：
//   1. 一个泛型类 Wrapper<T>
//   2. 另一个类中定义 private static func 泛型工厂方法，返回 Wrapper<T>
//   3. 用该泛型工厂方法初始化 static let 字段
//
// 绕过方法：不使用泛型工厂方法，直接调用 Wrapper<T>(...) 构造函数。

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
    // 泛型工厂方法 —— 这是触发 ICE 的关键
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
