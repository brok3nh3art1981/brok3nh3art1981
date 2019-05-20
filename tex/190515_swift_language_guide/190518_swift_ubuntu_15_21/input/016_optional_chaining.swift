// optional chaining
// https://docs.swift.org/swift-book/LanguageGuide/OptionalChaining.html

class Person {
    var residence: Residence?
}
class Residence {
    var numberOfRooms = 1
}
let john = Person()
// let roomCount = john.residence!.numberOfRooms  // 実行時エラー
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")  // 実行される
}
john.residence = Residence()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")  // 実行される
} else {
    print("Unable to retrieve the number of rooms.")
}

// より階層化された場合を考える:
class Person1 {
    var residence: Residence1?  /// 住んでいる家
}
/// 住居
class Residence1 {
    var rooms = [Room1]()  /// この家にある部屋ら
    /// この家にある部屋の個数
    var numberOfRooms: Int {
        return rooms.count
    }
    /// 整数の添字によってこの家のそれぞれの部屋を表す
    subscript(i: Int) -> Room1 {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    /// 部屋の個数を出力する
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address1?  /// この家の所在地
}
/// 家のそれぞれの部屋
class Room1 {
    let name: String  /// 部屋の名前
    init(name: String) { self.name = name }
}
/// 所在地
class Address1 {
    var buildingName: String?    /// 建物の名前
    var buildingNumber: String?  /// 建物の番号
    var street: String?          /// 通りの名前
    /// この所在地にある建物の識別子
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

let john1 = Person1()
if let roomCount = john1.residence?.numberOfRooms {  // residenceはnilである
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")  // 実行される
}

let someAddress = Address1()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john1.residence?.address = someAddress  // residenceはnilだから右辺は評価されない。

// 右辺が評価されていないことを確認する
/// 所在地を作って返す
func createAddress() -> Address1 {  // 実行されない
    print("Function was called.")   // 実行されない

    let someAddress = Address1()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"

    return someAddress
}
john1.residence?.address = createAddress()

// 返り値のないメソッドについてのoptional chaining:
if john1.residence?.printNumberOfRooms() != nil {  // 成功なら()、失敗ならnilだ。
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")  // 実行される
}

// optional chainingへの代入はVoid?型の値を返すので、代入が成功したか判定できる。
if (john1.residence?.address = someAddress) != nil {  // residenceはnilなので失敗する。
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")  // 実行される
}

// optional chainingを通じた添字へのアクセス:
if let firstRoomName = john1.residence?[0].name {  // residenceはnilなので失敗する。
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")  // 実行される
}
john1.residence?[0] = Room1(name: "Bathroom")  // residenceはnilなので代入できない。

let johnsHouse = Residence1()
johnsHouse.rooms.append(Room1(name: "Living Room"))
johnsHouse.rooms.append(Room1(name: "Kitchen"))
john1.residence = johnsHouse

if let firstRoomName = john1.residence?[0].name {  // 今やresidenceはnilではない。
    print("The first room name is \(firstRoomName).")  // 実行される
} else {
    print("Unable to retrieve the first room name.")
}

// 添字の返り値がOptional型の場合:
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
print(testScores)
testScores["Dave"]?[0] = 91   // 成功する
testScores["Bev"]?[0] += 1    // 成功する
testScores["Brian"]?[0] = 72  // キーBrianはないので代入は失敗する。
print(testScores)

// optional chainingを重ねてもOptionalは1層でありつづける。

if let johnsStreet = john1.residence?.address?.street {  // address == nil
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")  // 実行される
}

let johnsAddress = Address1()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john1.residence?.address = johnsAddress

if let johnsStreet = john1.residence?.address?.street {
    print("John's street name is \(johnsStreet).")  // 実行される
} else {
    print("Unable to retrieve the address.")
}

if let buildingIdentifier = john1.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}

// メソッドの返り値もoptional chainingできる。
if let beginsWithThe =
        john1.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")  // 実行される
    } else {
        print("John's building identifier does not begin with \"The\".")
    }
}
