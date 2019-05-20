// basic operators
// https://docs.swift.org/swift-book/LanguageGuide/BasicOperators.html

print(1..<10, 1...10, type(of: 1..<10), type(of: 1...10))
// print(! true)  // compile-time error
for x in [true, false] {
    print(x ? "T" : "F")  // C同様に唯一の三項演算子
}

// assignment operator 代入演算子
let b = 10
var a = 5
a = b
print(a, b)  // -> 10 10

let (x, y) = (1, 2)  // decompose
print(x, y)  // -> 1 2

// arithmetic operators 算術演算子
print(1 + 2, 5 - 3, 2 * 3, 10.0 / 2.5)  // 3 2 6 4.0
print("hello, " + "world")

// remainder operator 剰余演算子
print(9 % 4)   // 1
print(-9 % 4)  // -1; Cと同じでPythonと異なる。数学的なmoduloではない。

// 単項プラス／マイナス演算子。空白をあけてはならない。
let three = 3, minusThree = -three, plusThree = -minusThree
print(plusThree)
let minusSix = -6, alsoMinusSix = +minusSix
print(alsoMinusSix)

// compound assignment operators 複合代入演算子
a = 1; a += 2; print(a)  // 3

// comparison operators 比較演算子
// 2!=1とは書けない。2!が不正なforced unwrappingと見なされるため。
// true true true true true false
print(1==1, 2 != 1, 2>1, 1<2, 1>=1, 2<=1)

let name = "world"
if name == "world" {
    print("hello, world")  // 実行される
} else {
    print("I'm sorry \(name), but I don't recognize you")
}

print( (1, "zebra") < (2, "apple"),  // true
       (3, "apple") < (3, "bird"),   // true
       (4, "dog") == (4, "dog"))     // true

print( ("blue", -1) < ("purple", 1) )  // true
// print( ("blue", false) < ("purple", true) )  // compile-time error
print((1,1,1,1,1,1)==(1,1,1,1,1,1))  // true
// print((1,1,1,1,1,1,1)==(1,1,1,1,1,1,1))  // compile-time error
// ∵Swift標準ライブラリは要素数が6個以下のタプルにしか比較演算子を用意していない。
// 必要なら自ら実装すればよい。

// 三項条件演算子
let contentHeight = 40
let hasHeader = true
print(contentHeight + (hasHeader ? 50 : 20))  // 90

// nil-coalescing operator ??
let defaultColorName = "red"
var userDefinedColorName: String?
var colorNameToUse = userDefinedColorName ?? defaultColorName
print(colorNameToUse)  // red. nilだったので右側オペランドが評価された。

// range operators 範囲演算子
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
// var lowerBound = 200, upperBound = 100
// for index in lowerBound...upperBound {}  // runtime error

// half-open range operator
let names = ["Anna", "Alex", "Brian", "Jack"]
let count = names.count
for i in 0..<count {  // [0, count)
    print("Person \(i + 1) is called \(names[i])")
}

for name in names[2...] { print(name) }
for name in names[...2] { print(name) }
for name in names[..<2] { print(name) }

for i in 1000... { print(i); if i==1003 {break} }
// false true true
print((...5).contains(7), (...5).contains(4), (...5).contains(-1))

let allowedEntry = false
if !allowedEntry {
    print("ACCESS DENIED")
}
