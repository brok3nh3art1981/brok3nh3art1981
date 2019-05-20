// methods メソッド
// https://docs.swift.org/swift-book/LanguageGuide/Methods.html

// メソッドは型に属する関数だ。クラス、構造体、列挙型について存在する。
// メソッドには、インスタンスメソッドと型メソッドがある。

// instance method インスタンスメソッド
// 3個のインスタンスメソッドを持つクラスを定義する。
class Counter {
    var count = 0  // ストアド変数プロパティ
    /// 1増加する
    func increment() {
        count += 1
    }
    /// by増加する
    func increment(by amount: Int) {
        count += amount
    }
    /// 0にする
    func reset() {
        count = 0
    }
}
let counter = Counter()
print(counter.count)  // 0
counter.increment()
print(counter.count)  // 1
counter.increment(by: 5)
print(counter.count)  // 6
counter.reset()
print(counter.count)  // 0

// In practice, you don’t need to write self in your code very often.
// ...
// The main exception to this rule occurs when a parameter name for an
// instance method has the same name as a property of that instance.

// self.が有用な例:
struct Point {
    var x = 0.0, y = 0.0
    /// 点selfがx=xよりも右にあれば真を返す。
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}

// mutating
struct Point1 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var somePoint1 = Point1(x: 1.0, y: 1.0)  // varにしとかないとmutating memberが使えない。
somePoint1.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint1.x), \(somePoint1.y))")  // 3.0 4.0

// mutating methods for enumerations
enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
print(ovenLight)  // .low
ovenLight.next()
print(ovenLight)  // .high
ovenLight.next()
print(ovenLight)  // .off

// type method 型メソッド
struct LevelTracker {
    static var highestUnlockedLevel = 1  // このデバイスでアンロックされたレベル
    var currentLevel = 1                 // 各プレイヤーのレベル
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    @discardableResult  // 返り値は無視していい
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
class Player {
    var tracker = LevelTracker()
    let playerName: String
    /// プレイヤーがあるレベルを完了したときに呼ばれる
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)  // 返り値は無視する
    }
    init(name: String) {
        playerName = name
    }
}
var player = Player(name: "Argyrios")
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")  // 1
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")  // 2
player = Player(name: "Beto")       // 同じデバイスを使う別のプレイヤー
if player.tracker.advance(to: 6) {  // レベル6に進もうとする
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")  // 実行される
}
