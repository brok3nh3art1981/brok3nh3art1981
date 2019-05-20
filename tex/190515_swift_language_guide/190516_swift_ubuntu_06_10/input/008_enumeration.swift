// enumeration 列挙
// https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html

enum CompassPoint {
    case north  // 各enumeration caseらを定義する
    case south
    case east
    case west
}
print(CompassPoint.north)

enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

var directionToHead = CompassPoint.west
print(directionToHead)
directionToHead = .east
print(directionToHead)
let directionToHead1: CompassPoint = .north
print(directionToHead1)

directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")  // 実行される
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}

let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")  // 実行される
default:
    print("Not a safe place for humans")
}

// CaseIterableプロトコルをenumerationに設定する。
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")
for beverage in Beverage.allCases {
    print(beverage)
}

// associated value
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
// インスタンス化
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
print(productBarcode)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
print(productBarcode)

// switch文では、associated valueらを束縛できる。
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// letやvarは手前にまとめて書ける。
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}

// raw value
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// implicitly assigned raw value
enum Planet1: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
enum CompassPoint1: String {
    case north, south, east, west
}

let earthsOrder = Planet1.earth.rawValue
print(earthsOrder)      // 3
let sunsetDirection = CompassPoint1.west.rawValue
print(sunsetDirection)  // west

// initializing from a row value
let possiblePlanet = Planet1(rawValue: 7)  // failable initializer
print(possiblePlanet!, possiblePlanet == Planet1.uranus)

let positionToFind = 11
if let somePlanet = Planet1(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")  // 実行される
}

// recursive enumeration 再帰的列挙
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
// すべてのケースについてindirectにするにはenum全体をindirect修飾すればいい。
indirect enum ArithmeticExpression1 {
    case number(Int)
    case addition(ArithmeticExpression1, ArithmeticExpression1)
    case multiplication(ArithmeticExpression1, ArithmeticExpression1)
}

// (5 + 4) * 2
let five = ArithmeticExpression1.number(5)
let four = ArithmeticExpression1.number(4)
let sum = ArithmeticExpression1.addition(five, four)
let product = ArithmeticExpression1.multiplication(sum, ArithmeticExpression1.number(2))
print(product)
func evaluate(_ expression: ArithmeticExpression1) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}
print(evaluate(product))  // 18
