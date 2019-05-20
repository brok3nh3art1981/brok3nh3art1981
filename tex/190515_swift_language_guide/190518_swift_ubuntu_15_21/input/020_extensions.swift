// extensions
// https://docs.swift.org/swift-book/LanguageGuide/Extensions.html

// extensionによりcomputedプロパティを（Double型に）追加する。
extension Double {
    var km: Double { return self * 1_000.0 }
    var m:  Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm  // リテラルに対して呼び出せる。
print("One inch is \(oneInch) meters")
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")

// ただしextensionはストアドプロパティやプロパティオブザーバは追加できない。

// extensionによってconvenience initializerを追加できる。

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

// default initializerを使う
let defaultRect = Rect()
// memberwise initializerを使う
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                          size: Size(width: 5.0, height: 5.0))
// extensionする
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // memberwise initializerを使う。
        self.init(origin: Point(x: originX, y: originY),
                  size: size)
    }
}

extension Int {
    /// self回task()する。
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    func repetitions1(_ task: @autoclosure () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions {
    print("Hello!")
}
// 3.repetitions1(print("Hello1!"))
// 3.repetitions1({ print("Hello1!"); print(89)}())
// 3.repetitions { print("Hello!"); print(89)}

// 値を変更するextension
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
print(someInt)
someInt.square()
print(someInt)

// 添字をextensionする
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
print(746381295[0], 746381295[1], 746381295[2], 746381295[8],
      746381295[9], 0746381295[9])

// nested typeをextensionする
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
/// numbersの各要素のKindを文字列で出力する。
func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
