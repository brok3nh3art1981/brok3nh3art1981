// advanced operators
// https://docs.swift.org/swift-book/LanguageGuide/AdvancedOperators.html

// 高度な演算子がある。ビット演算子、オーバーフロー演算子、ユーザ定義演算子だ。
// すべてのオーバーフロー演算子は&で始まる。

/// 引数を2進数表現で印字する。
func p2<T: BinaryInteger>(_ xs: T...) {
    /// 引数を2進数で表した文字列を返す。
    func s2<T: BinaryInteger>(_ x: T) -> String {
        /// 引数が8文字以下ならば左を0で満たす。
        func pad8(_ s: String) -> String {
            let padLen: Int = 8 - s.count
            let pad: String = String(repeatElement("0", count: padLen))
            return pad + s
        }
        let s: String = String(x, radix: 2)
        return pad8(s)
    }
    for i in 0..<xs.count {
        let s = s2(xs[i])
        switch i {
        case xs.count - 1:
            print(s)
        default:
            print(s, terminator: " ")
        }
    }
}

// NOT
let initialBits: UInt8 = 0b00001111  // 2進数
let invertedBits = ~initialBits      // NOT演算
p2(invertedBits)                     // 11110000

// AND
let firstSixBits: UInt8 = 0b11111100
let lastSixBits: UInt8  = 0b00111111
let middleFourBits = firstSixBits & lastSixBits
p2(middleFourBits)

// OR
let someBits: UInt8 = 0b10110010
let moreBits: UInt8 = 0b01011110
let combinedbits = someBits | moreBits
p2(combinedbits)

// XOR
let firstBits: UInt8 = 0b00010100
let otherBits: UInt8 = 0b00000101
let outputBits = firstBits ^ otherBits
p2(outputBits)

let shiftBits: UInt8 = 4
p2(shiftBits,
   shiftBits << 1,
   shiftBits << 2,
   shiftBits << 5,
   shiftBits << 6,
   shiftBits >> 2)

let pink: UInt32   = 0xCC6699
let redComponent   = (pink & 0xFF0000) >> 16
let greenComponent = (pink & 0x00FF00) >> 8
let blueComponent  =  pink & 0x0000FF  
p2(redComponent, greenComponent, blueComponent)

// overflow operator オーバーフロー演算子

var potentialOverflow = Int16.max
// potentialOverflow += 1  // 実行時エラー

var unsignedOverflow = UInt8.max
print(unsignedOverflow)  // -> 255
unsignedOverflow = unsignedOverflow &+ 1
print(unsignedOverflow)  // -> 0

unsignedOverflow = UInt8.min
print(unsignedOverflow)  // -> 0
unsignedOverflow = unsignedOverflow &- 1
print(unsignedOverflow)  // -> 255

var signedOverflow = Int8.min
print(signedOverflow)  // -> -128
signedOverflow = signedOverflow &- 1
print(signedOverflow)  // -> 127

// 演算子の優先順位と結合方向は原則としてC / Objective-Cと同じだが、少し改善してある。

// operator methods 演算子メソッド

// 演算子のオーバーロード
/// 2次元のベクトルを表す構造体。
struct Vector2D {
    var x = 0.0, y = 0.0
}
extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x,
                        y: left.y + right.y)
    }
}
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 4.0)
let combinedVector = vector + anotherVector
print(vector, anotherVector, combinedVector)

// 単項演算子
extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x,
                        y: -vector.y)
    }
}
let positive = Vector2D(x: 3.0, y: 4.0)
let negative = -positive
let alsoPositive = -negative
print(positive, negative, alsoPositive)

// compound assignment operators 複合代入演算子
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}
var original = Vector2D(x: 1.0, y: 2.0)
let vectorToAdd = Vector2D(x: 3.0, y: 4.0)
original += vectorToAdd
print(original, vectorToAdd)

// equivalence operators 等価演算子
extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) &&
               (left.y == right.y)
    }
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
if twoThree == anotherTwoThree {
    print("These two vectors are equivalent.")  // 実行される
}

// 自動的な等価演算子を得られる場合もある。
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}
let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are also equivalent.")  // 実行される
}

// custom operators
prefix operator +++ 
extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}
var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
let afterDoubling = +++toBeDoubled
print(toBeDoubled, afterDoubling)

// precedence for custom infix operators カスタムな中置演算子の優先度
// 優先度はprecedence group（優先度グループ）を使って指定する。
infix operator +-: AdditionPrecedence  // +や-と同じ優先度とする。
extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x,
                        y: left.y - right.y)
    }
}
let firstVector = Vector2D(x: 1.0, y: 2.0)
let secondVector = Vector2D(x: 3.0, y: 4.0)
let plusMinusVector = firstVector +- secondVector
print(firstVector, secondVector, plusMinusVector)

// 前置演算子と後置演算子について優先度を指定することはできない。
// しかし同時に使ったときには後置演算子が先に適用される。
