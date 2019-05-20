// language guide - the basics
// https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html

let maximumNumberOfLoginAttempts = 10  // 定数
var currentLoginAttempt = 0            // 変数
print(maximumNumberOfLoginAttempts, currentLoginAttempt)

var x = 0.0, y = 0.0, z = 0.0  // 複数の変数を1行で宣言する
print(x, y, z)

var welcomeMessage: String  // 型注釈を使う。代入前に使うとコンパイルエラー。
welcomeMessage = "Hello"
print(welcomeMessage)

var red, green, blue: Double  // 型注釈が行全体に効く

let π = 3.14159, 你好 = "你好世界", 🐶🐮 = "dogcow"  // unicode
print("π, 你好, 🐶🐮", π, 你好, 🐶🐮)

let `if` = 1  // キーワードをどうしても変数名にしたければ`で囲む
print(`if`)

var friendlyWelcome = "Hello!"
friendlyWelcome = "Bonjour!"
print(friendlyWelcome)

let languageName = "Swift"
print(languageName + "++")

print("your age: ", terminator: "")  // 改行以外で終わりたければ指定する
print(99)

// string interpolation 文字列補間
print("The current value of friendlyWelcome is \(friendlyWelcome)")

/* /* ネストした複数行コメント */ */

let cat = "🐱"; print(cat)  // セミコロンを使えば1行に複数の文を書ける
let uInt8Value: UInt8 = 255; print(uInt8Value)
print(UInt8.min, UInt8.max, type(of: UInt8.max))
print(Int.min, Int.max, type(of: Int.max))

// Unless you need to work with a specific size of integer, always use
// Int for integer values in your code.
// 特に必要がない限りはサイズを指定せずInt型を用いるべきだ。

// Use UInt only when you specifically need an unsigned integer type with
// the same size as the platform’s native word size. If this isn’t the
// case, Int is preferred, even when the values to be stored are known to
// be nonnegative. 
// 特に必要がない限りは正の数に限られる状況でも単にInt型を用いるべきだ。

// Double has a precision of at least 15 decimal digits, whereas the
// precision of Float can be as little as 6 decimal digits. 
// ...
// In situations where either type would be appropriate, Double is preferred.
// 特に必要がないならFloatよりDoubleを使っておけばいい。

let meaningOfLife = 42, pi = 3.14159          // 型推論
print(type(of: meaningOfLife), type(of: pi))  // -> Int Double

print(17, 0b10001, 0o21, 0x11)  // 10進数、2進数、8進数、16進数で17

print(1.25e2, 1.25e-2)
print(0xfp2, 0xfp-2)
print(12.1875, 1.21875e1, 0xc.3p0)
print(000123.456, 1_000_000, 1_000_000.000_000_1, 1_0000)

// 数の型変換
// var tooBig: UInt8 = 255; tooBig += 1  // 実行時エラー

let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)  // 新インスタンス作成
print(twoThousandAndOne)

let three = 3
let pointOneFourOneFiveNine = 0.14159
let pi2 = Double(three) + pointOneFourOneFiveNine
print(pi2)
print(Int(pi2))

// 型の別名 (type aliase)
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min
print(maxAmplitudeFound, type(of: maxAmplitudeFound))  // -> 0 UInt16

// Bool
let orangesAreOrange = true, turnipsAreDelicious = false  // カブ
print(orangesAreOrange, turnipsAreDelicious)
if turnipsAreDelicious {  // 条件部がBool型でなければコンパイルエラー
    print("Mmm, tasty turnips!")
} else {
    print("Eww, turnips are horrible.")
}

// タプル
let http404Error = (404, "Not Found")
print(http404Error, type(of: http404Error))
let (statusCode, statusMessage) = http404Error  // decompose
print(statusCode, statusMessage, http404Error.0)
let http200Status = (statusCode: 200, description: "OK")  // named tuple
print(http200Status.statusCode, http200Status.description)

// If your data structure is likely to persist beyond a temporary scope,
// model it as a class or structure, rather than as a tuple.
// 多少なり長く使う構造にタプルを汎用すべきではない。クラスなどが適している。

// optional
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)  // Int(String)は:Int?である。
print(convertedNumber as Any, type(of: convertedNumber))

var serverResponseCode: Int? = 404
print(serverResponseCode as Any)
serverResponseCode = nil
print(serverResponseCode as Any)

var surveyAnswer: String?; print(surveyAnswer as Any)  // 初期値nil

if convertedNumber != nil {
    print("convertedNumber contains some integer value.")
    // 文脈上optionalがnilでないと確信できるのでforced unwrappingする。
    print("convertedNumber has an integer value of \(convertedNumber!).")
}

if let actualNumber = Int(possibleNumber) {
    print("The string \"\(possibleNumber)\" has an integer value " +
          "of \(actualNumber)")
} else {
    print("The string \"\(possibleNumber)\" could not be converted " +
          "to an integer")
}

// 条件部を,で並べれば&&のような意味になる。
if let firstNumber = Int("4"), let secondNumber = Int("42"),
        firstNumber < secondNumber, secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}

// implicitly unwrapped optionalというものがある。
let possibleString: String? = "An optional string."
let forcedString: String = possibleString!  // forced unwrapping
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString
print(forcedString, implicitString)
print(type(of: possibleString), type(of: assumedString))  // String? String?
if assumedString != nil {
    print(assumedString!)
    print(assumedString as Any)
}
if let definiteString = assumedString {
    print(definiteString)
}

// Stopping execution as soon as an invalid state is detected also helps
// limit the damage caused by that invalid state.

let age = -3
// assert(age >= 0)
// assert(age >= 0, "A person's age can't be less than zero.")

if age > 10 {
    print("You can ride the roller-coaster or the ferris wheel.")
} else if age >= 0 {
    print("You can ride the ferris wheel.")
} else {
    // assertionFailure("A person's age can't be less than zero.")
}

// The difference between assertions and preconditions is in when they’re
// checked: Assertions are checked only in debug builds, but preconditions
// are checked in both debug and production builds. 
// assert()はデバッグビルドでのみ有効だがprecondition()はそうではない。
// ただし、precondition()も-Ouncheckedとしてオフにされうる。
// precondition(age >= 0)

// 決してオフにされないのはfatalError()だけだ。しかしassert()の機能はない。
// fatalError("Unimplemented")
