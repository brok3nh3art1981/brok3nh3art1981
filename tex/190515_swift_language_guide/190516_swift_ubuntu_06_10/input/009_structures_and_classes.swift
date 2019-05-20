// structures and classes 構造体とクラス
// https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html

// In practice, this means most of the custom data types you define will be
// structures and enumerations.



struct Resolution {
    var width = 0  // stored porperty
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
let someResolution = Resolution()  // initializer syntax
let someVideoMode = VideoMode()
print(someResolution, someVideoMode)

// dot syntax ドット文法
print("The width of someResolution is \(someResolution.width)")  // 0
print("The width of someVideoMode is \(someVideoMode.resolution.width)")  // 0

someVideoMode.resolution.width = 1280
print("The width of someVideoMode is now \(someVideoMode.resolution.width)")  // 1280

// memberwise initializers for structure types
let vga = Resolution(width: 640, height: 480)
print(vga)

// structures and enumerations are value types 構造体と列挙は値型である。
// 配列と辞書は構造体である。
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide")
print("hd is still \(hd.width) pixels wide")

// 列挙も値型だから、pass-by-valueされる。
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()
print("The current direction is \(currentDirection)")
print("The remembered direction is \(rememberedDirection)")

// クラスは参照型なのでpass-by-referenceされる。
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0
print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")  // 30.0

// identity operators
// identicalかどうかをBoolで返す。
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}
