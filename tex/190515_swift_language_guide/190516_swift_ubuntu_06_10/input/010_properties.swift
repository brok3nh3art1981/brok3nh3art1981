// properties プロパティ
// https://docs.swift.org/swift-book/LanguageGuide/Properties.html

// Stored PropertyとComputed Propertyがある。
// type propertyはインスタンスではなく型に属する。

// stored property

struct FixedLengthRange {
    var firstValue: Int  // 変数属性
    let length: Int      // 定数属性
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
print(rangeOfThreeItems)
rangeOfThreeItems.firstValue = 6
print(rangeOfThreeItems)


// stored properties of constant structure instances
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// rangeOfFourItems.firstValue = 6  // 定数は変更できない。

// lazy stored properties
class DataImporter {  // 初期化の重いクラス
    var filename = "data.txt"
    init() { print("Initializing a DataImporter instance.... Done.") }
}
class DataManager {
    // DataMangerがinit完了した時点では未定なのでlazy対象はvarとせねばならない。
    lazy var importer = DataImporter()  // 必要になるまでインスタンス化しない
    var data = [String]()
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
print(manager.importer.filename)

// Note
// If a property marked with the lazy modifier is accessed by multiple
// threads simultaneously and the property has not yet been initialized,
// there is no guarantee that the property will be initialized only once.

// computed properties
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point(), size = Size()  // 保持されるのは原点と大きさ
    var center: Point {                  // 中心点はcomputedプロパティ
        get {
            // 原点のx座標に矩形の幅の半分を加えたものが中心点のx座標である。
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            // 中心点のx座標から矩形の幅の半分を引いたものが原点のx座標である。
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0,
                                y: 0.0),
                  size:   Size(width:  10.0,
                               height: 10.0))
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")

// なおsetでデフォルト引数newValueを用いるなら次のようになる。
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

// read-only computed properties
struct Cuboid {  // 直方体
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {  // 読み取り専用computedプロパティ
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")  // 40.0

// property observers プロパティオブザーバ
// スーパークラスのイニシャライザが呼ばれたあとのサブクラスのイニシャライザからの更新では、
// スーパークラスのプロパティのwillSetやdidSetが呼ばれる。

class StepCounter {
    var totalSteps: Int = 0 {
        // willSet(newTotalSteps) {
        //     print("About to set totalSteps to \(newTotalSteps)")
        // }
        willSet {
            print("About to set totalSteps to \(newValue)")
        }
        didSet {
            if totalSteps > oldValue  {  // 増分を出力する
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360
stepCounter.totalSteps = 896

// 関数のinoutパラメータにオブザーバを持つ他のプロパティを渡すと常にwillSet/didSetが呼ばれる。

// global and local variables
// storedプロパティに対してcomputedプロパティやプロパティオブザーバが行えたことは、
// stored変数について、computedな変数や変数へのオブザーバとして同様に実装できる。
// globalな定数と変数は常にlazyにcomputeされる。localな定数と変数は決してlazyにはならない。

// type properties; （インスタンスプロパティではないものとしての）型プロパティ

// stored型プロパティについては初期化するイニシャライザがないので必ず初期値が必要だ。
// stored型プロパティは常にlazyだが、インスタンスプロパティと異なり、必ず1度しか呼ばれない。

// 型プロパティはstaticないしclassキーワードで修飾する。
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}
// インスタンス化せずに使える。
print(SomeStructure.storedTypeProperty)
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)
print(SomeEnumeration.computedTypeProperty)
print(SomeClass.computedTypeProperty)

struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {  // セッタでいいのではないか
                currentLevel = AudioChannel.thresholdLevel   // didSetを再発火しない
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()
leftChannel.currentLevel = 7
print(leftChannel.currentLevel)                  // 7
print(AudioChannel.maxInputLevelForAllChannels)  // 7
rightChannel.currentLevel = 11
print(rightChannel.currentLevel)                 // 10; capされた
print(AudioChannel.maxInputLevelForAllChannels)  // 10; 共有されている
// print(leftChannel.maxInputLevelForAllChannels)  // 型メンバはインスタンスから呼べない
