// initialization 初期化
// https://docs.swift.org/swift-book/LanguageGuide/Initialization.html

// Swiftのイニシャライザinit()は値を返さない。

struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Fahrenheit")

// initialization parameters

struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
print(boilingPointOfWater.temperatureInCelsius)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
print(freezingPointOfWater.temperatureInCelsius)
let bodyTemperature = Celsius(37.0)
print(bodyTemperature.temperatureInCelsius)

struct Color {
// struct Color: CustomStringConvertible {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
    /* var description: String {
        let s: String = [red, green, blue].map{ String($0) }.joined(separator: " ")
        return "(\(s))"
    } */
}
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
print(magenta)
let halfGray = Color(white: 0.5)
print(halfGray)

// optional property types
class SurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."

let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beets. (But not with cheese.)"

// default initializer
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()
print(item)

class Class0 {
    init(x: Int) { print(x) }
}
// Class0()  // compile-time error; default initializerが作られない。
let _ = Class0(x: 1)

// memberwise initializers for structure types
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)  // implicit memberwise initializer
print(twoByTwo, Size())                       // implicit default initializerもある

// initializer delegation イニシャライザ移譲とはinit()の別の実装を応用すること。
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // イニシャライザ移譲
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let basicRect = Rect()
print(basicRect)
let originRect = Rect(origin: Point(x: 2.0, y: 2.0),
                      size: Size(width: 5.0, height: 5.0))
print(originRect)
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
print(centerRect)

// class inheritance and initialization
// クラスのイニシャライザには、designated initializerとconvenience initializerがある。
// designated initializerは、すべてのプロパティを初期化する。
// convenience initializerはconvenience修飾を持ち、designated initializerに移譲する。
// designated initializerは、多くの場合1つだが、複数あってもいい。

// two-phase initialization
// クラスのinit()はまず自らのプロパティを初期化し、スーパークラスのinit()で初期化する。
// 次に、任意のプロパティを任意に変更する。

// safety check 1
// super.init()の前にサブクラスのプロパティがすべて初期化されてなければコンパイルエラー。
// safety check 2
// super.init()の前にスーパークラスのプロパティをどれか初期化したらコンパイルエラー。
// ∵super.init()で上書きされてしまうかもしれないので。
// safety check 3
// convenicence init()がinit()する前にプロパティを初期化したらコンパイルエラー。
// ∵init()が上書きしてしまうかもしれないので。
// safety check 4
// selfとsuperのプロパティが初期化される第1段階以降にのみプロパティやメソッドを使える。
// ∵ まだ初期化されていないものにアクセスしかねないので。

// super.init()より前にサブクラスのプロパティが初期化されてなければならない理由:
// クラスSubのプロパティxにアクセスするoverride func f()がスーパークラスから呼ばれうるから。

// initializer inheritance and overriding
// （暗黙でdesignatedな）default initializerを持つクラス。
class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")

class Bicycle: Vehicle {
    override init() {  // custom designated initializer
        super.init()
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")

class Hoverboard: Vehicle {
    var color: String
    init(color: String) {
        self.color = color
        // super.init() implicitly called here
    }
    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}
let hoverboard = Hoverboard(color: "silver")
print("Hoverboard: \(hoverboard.description)")

// Note
// You always write the override modifier when overriding a superclass
// designated initializer, even if your subclass’s implementation of the
// initializer is a convenience initializer.
class Bicycle1: Vehicle {
    var color: String
    init(color: String) {
        self.color = color
        super.init()
        numberOfWheels = 2
    }
    // スーパークラスのinit()を間接的に呼ぶのでoverrideである。
    // （間接的に呼ばずともスーパークラスのdesignatedイニシャライザなのでoverride。）
    override convenience init() { self.init(color: "silver") }
}
let bicycle1 = Bicycle1()
print("Bicycle1: \(bicycle1.description)")

// As a result, you do not write the override modifier when providing a
// matching implementation of a superclass convenience initializer.
class Bicycle2: Bicycle1 {
    var bgColor: String
    init(color: String, bgColor: String) {
        self.bgColor = bgColor
        super.init(color: color)
    }
    // スーパークラスのinit()を間接的にすら呼ばないのでoverrideではない。
    // (というかスーパークラスのconvenienceイニシャライザなのでoverrideではない。）
    convenience init() { self.init(color: "silver", bgColor: "silver") }
}
let bicycle2 = Bicycle2()
print("Bicycle2: \(bicycle2.description)")

// 間接的に呼ばずともスーパークラスのdesignatedイニシャライザならoverrideせねばならない:
class Super {
    init(x: Int) { print("Super#init(x: Int)") }
    init(x: String) {}  // 間接的にも呼ばれないスーパークラスのdesignatedイニシャライザ。
}
class Sub: Super {
    init(x: Double) { super.init(x: 0) }
    override convenience init(x: String) { self.init(x: 1.2) }
}
let _ = Sub(x: "")
// overrideかどうかを考える際には、祖先クラスのconvenienceイニシャライザは忘れてよさそうだ。
// こういう仕組みである必要性は不明。

// https://stackoverflow.com/questions/24192253/overriding-convenience-init
// スーパークラスのすべてのdesignatedイニシャライザをoverrideするとすべてのconvenience
// イニシャライザは自動的に継承される、らしい。2014年。
// https://stackoverflow.com/questions/25322421/convenience-init-override
// 2014年。
// https://forums.swift.org/t/overriding-convenience-initializers-possible-bug/11274/2
// Remember that convenience initializers are inherited if you implement all
// of the designated initializers from your superclass, or if you don’t
// provide any designated initializers (in which case you inherit all 
// initializers from your superclass).
// https://teamtreehouse.com/community/help-with-override-in-swift

// すべてのdesignatedイニシャライザをoverrideするとconvenienceイニシャライザは継承される。
class Super1 {
    init()       { print("Super1#init()") }          // designated
    init(x: Int) { print("Super1#init(x: Int)") }    // designated
    convenience init(x: String) { self.init(x: 0) }  // convenience
}
class Sub1: Super1 {
    override init() { super.init() }                 // designated
    override init(x: Int) { super.init(x: x) }       // designated
    // convenience init(x: String) { self.init() }
}
let _ = Sub1(x: "")

// スーパークラスのconvenienceイニシャライザがサブクラスから呼ばれる可能性はない。
// ∴ そのときはoverrideとはしない。
// スーパークラスのdesignatedイニシャライザはサブクラスから呼ばれるかもしれない。
// ∴ そのときはoverrideとする。

// 普通のメソッドとは異なり、初期化子は継承されない。
// よって、親クラスにある初期化子が子クラスにないことは普通である。
// よって、依存する特命初期化子がないかもしれないから親クラスの利便初期化子は呼べない。
// また同じ理由で、親クラスの特命初期化子をすべて継承すれば利便初期化子もすべて使える。

// オブジェクトには多態性があるから上書きしているメンバが暗黙に適用される。
// 特命初期化子であれ利便初期化子であれ特命初期化子を上書きするならば明示する必要がある。
// 一方で、利便初期化子については、子クラスでは存在してないようなものだから上書きにはならない。
// つまり特命初期化子には常に上書きが発生し、利便初期化子には決して上書きが発生しない。
// 利便初期化子は上書きの対象に値しない、特命初期化子の付属的な構文糖衣にすぎない。

// automatic initializer inheritance
/// ベースクラス
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
class ShoppingListItem1: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
var breakfastList = [
    ShoppingListItem1(),
    ShoppingListItem1(name: "Bacon"),
    ShoppingListItem1(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

// failable initializer
// 失敗可能な初期化子はinit?()と書かれる。
let wholeNumber = 12345.0, pi = 3.14159  // これらを使うとなぜか実行時エラーになった。
if let valueMaintained = Int(exactly: 12345.0) {
    print("\(wholeNumber) conversion to Int maintains value of \(valueMaintained)")
}
let valueChanged = Int(exactly: 3.14159)
if valueChanged == nil {
    print("\(pi) conversion to Int does not maintain value")
}

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}
let someCreature = Animal(species: "Giraffe")
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}
let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}

enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .kelvin
        case "C":
            self = .celsius
        case "F":
            self = .fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

// rawValueを持つ列挙型は暗黙にinit?(rawValue:)を持つ。
enum TemperatureUnit1: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}
let fahrenheitUnit1 = TemperatureUnit1(rawValue: "F")
if fahrenheitUnit1 != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
let unknownUnit1 = TemperatureUnit1(rawValue: "X")
if unknownUnit1 == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

// propagation of initialization failure
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}

// overriding a failable initializer
// 失敗可能な初期化子を継承して失敗不可能な初期化子にできる。
// 失敗不可能な初期化子を継承して失敗可能な初期化子にはできない。
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {  // init(name: String)でinit?(name: String)を上書き。
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!  // force-unwrap
    }
}

// setting a default property value with a closure or function
struct Chessboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    /// row行column列のセルが黒ければ真を返す。
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}
let board = Chessboard()
print(board.squareIsBlackAt(row: 0, column: 1))  // true
print(board.squareIsBlackAt(row: 7, column: 7))  // false
