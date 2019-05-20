// memory safety
// https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html

var one = 1                    // メモリに書き込む
print("We're number \(one)!")  // メモリを読み取る

/// than+1を返す。
func oneMore(than number: Int) -> Int {
    return number + 1
}
var myNumber = 1
myNumber = oneMore(than: myNumber)
print(myNumber)  // 2

// A function has long-term write access to all of its in-out parameters.

// conflicting access to in-out parameters:
var stepSize = 1
func increment(_ number: inout Int) {
    number += stepSize
}
// increment(&stepSize)  // 実行時エラー

var copyOfStepSize = stepSize  // 別のメモリ領域に一時的にコピーする
increment(&copyOfStepSize)     // コピーされた側をコピー元(stepSize)で更新する
stepSize = copyOfStepSize      // オリジナルなメモリ領域に更新を反映する
print(stepSize)                // 2

// passing a single variable as the argument for multiple in-out parameters
// of the same function produces a conflict:
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)     // OK
// balance(&playerOneScore, &playerOneScore)  // コンパイルエラー
print(playerOneScore, playerTwoScore)  // 36 36

// conflicting access to self in methods
struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}
extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}
var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)     // OK
// oscar.shareHealth(with: &oscar)  // コンパイルエラー
print(oscar, maria)

// conflicting access to properties

var playerInformation = (health: 10, energy: 20)
// balance(&playerInformation.health, &playerInformation.energy)  // 実行時エラー

var holly = Player(name: "Holly", health: 10, energy: 10)
// balance(&holly.health, &holly.energy)  // 実行時エラー

// ローカル変数ならアクセスが競合してないことをコンパイラが証明できる。
func someFunction() {
    var oscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&oscar.health, &oscar.energy)  // OK
}
someFunction()

// ある構造体の異なる部分へのアクセスがコンパイラに許される条件は次の3つだ。
// computedプロパティやclassプロパティではなくstoredプロパティにのみアクセスしている。
// 構造体がグローバル変数の値ではなくローカル変数の値である。
// 構造体がクロージャに補足されてないか、nonescapingなクロージャにのみ補足されている。
