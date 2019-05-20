// control flow 制御構造
// https://docs.swift.org/swift-book/LanguageGuide/ControlFlow.html

// for-in loop
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

// 辞書のkey-valueペアらをfor-inループでdecomposeする。
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

// Range (ClosedRange) オブジェクトを用いたfor-inループ。
for index in 1...5 {  // closed range operator
    print("\(index) times 5 is \(index * 5)")
}

let base=3, power=10
var answer=1
for _ in 1...power {
    // print(_)  // compile-time error; 単なる慣習ではない
    answer *= base
}
print("\(base)^\(power) == \(answer)")


print(type(of: stride(from: 0, to:      10, by: 2)))  // StrideTo<Int>
print(type(of: stride(from: 0, through: 10, by: 2)))  // StrideThrough<Int>
let minutes = 60
let minuteInterval = 5
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    print("\(tickMark), ", terminator:"")
}; print()
let hours = 12
let hourInterval = 3
for tickMark in stride(from: 3, through: hours, by: hourInterval) {
    print("\(tickMark), ", terminator:"")
}; print()

// 蛇と梯子ゲーム
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02  // 梯子
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08  // 蛇
var square = 0
var diceRoll = 0
while square < finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    square += diceRoll
    print("\(square) ", terminator: "")
    if square < board.count {
        square += board[square]
    }
}
print("Game over!")

// No ladder on the board takes the player straight to square 25, and so
// it isn’t possible to win the game by moving up a ladder.
// ?
square=0; diceRoll=0
repeat {
    print("\(square) ", terminator: "")
    square += board[square]
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    square += diceRoll
} while square < finalSquare
print("Game over!")

// conditional statements 条件文
var temperatureInFahrenheit = 30                        // -1.1℃
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")  // 実行される
}
temperatureInFahrenheit = 40                            // 4.4℃
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else {
    print("It's not that cold. Wear a t-shirt.")        // 実行される
}
temperatureInFahrenheit = 90                            // 32.2℃
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")  // 実行される
} else {
    print("It's not that cold. Wear a t-shirt.")
}
temperatureInFahrenheit = 72                            // 22.2℃
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")
}                                                       // いずれも実行されない。

// switch
// Every switch statement must be exhaustive. switch文は必ず網羅的にする。
var someCharacter: Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")  // 実行される
default:
    print("Some other character")
}
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")  // 実行される
default:
    print("Not the letter A")
}

// interval matching 区間マッチ
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"  // 実行される
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):                                 // _はワイルドカード
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):                       // 区間マッチと併用できる
    print("\(somePoint) is inside the box")  // 実行される
default:
    print("\(somePoint) is outside of the box")
}

// value binding 値束縛
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):                                    // 第0要素を記号xに束縛する
    print("on the x-axis with an x value of \(x)")  // 実行される
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}

// where clause
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:                     // where節で制約を加える
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")  // 実行される
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

// compound cases
// 実行される本体の処理を共有するケースらは「,」で並べる。
someCharacter = "e"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")  // 実行される
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}

// 複合ケースと値束縛を同時に使うには、すべてのケースで同じ型を束縛すればいい。
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")  // 実行される
default:
    print("Not on an axis")
}

// control transfer statements 制御移転文
// とは、continue、break、fallthrough、return、throwの5個である。
// continueの例
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in puzzleInput {
    if charactersToRemove.contains(character) {
        continue  // 特定の文字は無視する
    }
    puzzleOutput.append(character)
}
print(puzzleOutput)  // -> "grtmndsthnklk"

let numberSymbol: Character = "三"  // Chinese symbol for the number 3
var possibleIntegerValue: Int?      // デフォルト値nil
switch numberSymbol {
case "1", "١", "一", "๑":     // アラビア数字、アラビア語数字、中国語、タイ語
    possibleIntegerValue = 1
case "2", "٢", "二", "๒":
    possibleIntegerValue = 2
case "3", "٣", "三", "๓":
    possibleIntegerValue = 3  // 実行される
case "4", "٤", "四", "๔":
    possibleIntegerValue = 4
default:
    break  // 網羅的にするためにdefaultケースを設け空にしないためにbreakを書く。
}
if let integerValue = possibleIntegerValue {  // optional binding
    print("The integer value of \(numberSymbol) is \(integerValue).")  // 実行される
} else {
    print("An integer value could not be found for \(numberSymbol).")
}

// fallthrough
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"  // 実行される
    fallthrough
default:
    description += " an integer."               // 実行される
}
print(description)



square=0; diceRoll=0
// gameLoop: while square != finalSquare {
gameLoop: while true {  // ループ条件を与えなくても動作は同じ。
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    print("\(square + diceRoll) ", terminator: "")
    switch square + diceRoll {
    case finalSquare:
        break gameLoop     // switchではなくgameloopをbreakする。
    case let newSquare where newSquare > finalSquare:  // where節用の値束縛
        // continue gameLoop  // ラベルを与えなくても動作は同じ。
        continue
    default:
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")

// guard文
func greet(person: [String: String]) {
    guard let name = person["name"] else {  // 束縛は以降で有効
        return  // guardのボディはfallthroughを許されない。
    }
    print("Hello \(name)!")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")  // optional束縛を利用する
}
greet(person: ["name": "John"])
greet(person: ["name": "Jane", "location": "Cupertino"])

// checking API availability
if #available(iOS 10, macOS 10.12, *) {
    print("Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS")
} else {
    print("Fall back to earlier iOS and macOS APIs")
}
