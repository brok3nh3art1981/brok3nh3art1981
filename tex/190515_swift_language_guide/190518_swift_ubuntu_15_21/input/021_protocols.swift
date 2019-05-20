// protocols
// https://docs.swift.org/swift-book/LanguageGuide/Protocols.html

import Foundation

// protocolにconformしている（則っている）、という言い方をする。
// 継承する親クラスは則るプロトコルより先に記載する。

protocol FullyNamed {
    var fullName: String { get }
}
struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")
print(john.fullName)

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
print(ncc1701.fullName)

// メソッドのプロトコル
protocol RandomNumberGenerator {
    func random() -> Double
}
// 線形合同法による擬似乱数生成器
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0  // random seed
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")

// プロトコルのメソッドをmutatingとすればstructないしenumerationも準拠できる。
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
print(lightSwitch)
lightSwitch.toggle()
print(lightSwitch)

// クラスのinitializerがあるプロトコルに準拠するときにはrequiredキーワードを書く。
// required修飾されたinitializerは任意のサブクラスについて存在を保証することになる。
// finalなクラスについてはサブクラスが存在しえないのでrequiredを書く必要はない。

// 親クラスのrequiredな初期化子をoverrideする意味ではrequiredのみ書けばよい。
// ただし親クラスの（designated）初期化子をoverrideしプロトコルの初期化子をrequired
// するときには併記する。

// failable initializer requirements
// プロトコル規約init?はinit?でもinitでも準拠できる。
// プロトコル規約initは、init! (implicitly unwrapped failable initializer)または
// initで準拠できる。

// protocols as types プロトコルは型である
/// size個の面を持つサイコロを表す。
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator  // この型はプロトコルだ
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        // generator.random()は[0, 1)。
        // generator.random() * Double(sides)は[0, sides)。
        // Int(generator.random() * Double(sides))は[0, sides-1]。+1して[1, sides]。
        return Int(generator.random() * Double(sides)) + 1
    }
}
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {  // 5回試行する
    print("Random dice roll is \(d6.roll())")
}

// delegation 移譲
protocol DiceGame {
    var dice: Dice { get }
    func play()
}
// protocolがclass-only（クラス専用）であることを: AnyObjectと書いて表す。
protocol DiceGameDelegate: AnyObject {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)  // fail gracefully for nil
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}
class DiceGameTracker: DiceGameDelegate {  // 移譲クラス
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {  // type check
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}
let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()

// adding protocol conformance with an extension
// extensionによって既存の型をあるプロトコルに準拠させる
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
print(game.textualDescription)

// conditionally conforming to a protocol
// generic where clauseを使う。
// 要素がTextRepresentableなArrayがTextRepresentableであることを定める。
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]  // 要素がTextRepresentableなArray
print(myDice.textualDescription)

// declaring protocol adoption with an extension
// そもそもprotocolに準拠している実装を備えたクラス
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
// すでに実装があるのでHamsterもまたTextRepresentableであることのみ定めればいい。
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")
// protocol型で保持する:
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)

// collectrions of protocol types
let things: [TextRepresentable] = [game, d12, simonTheHamster]
// let things = [game, d12, simonTheHamster]  // 型宣言しないとコンパイルエラー
for thing in things {
    print(thing.textualDescription)
}

// protocol inheritance プロトコルはプロトコルを継承できる
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:  // 梯子の根元
                output += "▲ "
            case let snake where snake < 0:    // 蛇の頭
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}
print(game.prettyTextualDescription)

// class-only protocol クラス専用プロトコルは: AnyObjectで表せる。
// Use a class-only protocol when the behavior defined by that protocol’s
// requirements assumes or requires that a conforming type has reference
// semantics rather than value semantics.

// protocol composition プロトコル合成
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person1: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {  // プロトコル合成
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person1(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)

class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {  // クラスとプロトコルの合成
    print("Hello, \(location.name)!")
}

let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)

// checking for protocol conformance
// プロトコルについてもis (type check operator)とas (type cast operator)が使える。
protocol HasArea {
    var area: Double { get }
}
// HasAreaなクラスを2つ定義する。
class Circle: HasArea {
    let pi = 3.1415927  // 円周率
    var radius: Double  // 半径
    var area: Double { return pi * radius * radius }  // computed property
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double  // stored property
    init(area: Double) { self.area = area }
}
class Animal {  // HasAreaではない
    var legs: Int
    init(legs: Int) { self.legs = legs }
}
let objects: [AnyObject] = [  // 任意のクラスのインスタンスを要素とする配列
    Circle(radius: 2.0),      // 面積は12.5663708単位
    Country(area: 243_610),   // United Kingdom is 243,610 km^2
    Animal(legs: 4)
]
for object in objects {
    if let objectWithArea = object as? HasArea {  // optional binding
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}

// optional protocol requirements
// Objective-Cとの協調のためにoptional requirementという仕組みが存在する。
// Objective-C系のクラスは、optional requirementなプロパティやメソッドを持てる。

// optional requirementはプロトコルそのものとともに@objc属性で修飾する。
// @objcなプログラムに準拠できるのは、Objective-Cのクラスを継承するクラスだけである。
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}
/*
class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {  // コンパイルエラー
            count += amount
        } else if let amount = dataSource?.fixedIncrement {        // コンパイルエラー
            count += amount
        }
    }
}
class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}
var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}
*/

// Protocol Extensions プロトコルはextensionできる。実装を追加する。
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
let generator1 = LinearCongruentialGenerator()
print("Here's a random number: \(generator1.random())")
print("And here's a random Boolean: \(generator1.randomBool())")

// providing default implementations
// protocolをextensionすることでデフォルトの実装を提供できる。

// adding constraints to protocol extensions
// 要素がEquatableなCollectionのみここでextensionする。
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false  // 最初の要素に等しくない要素があればallEqual()ではない。
            }
        }
        return true  // すべての要素が最初の要素に等しい、つまりすべての要素が等しい。
    }
}
let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
print(equalNumbers.allEqual())      // true
print(differentNumbers.allEqual())  // false
