// collection types
// https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html

// 基本的なコレクション型として、配列、セット、辞書がある。
// あるコレクションオブジェクトのすべての要素の型は同じである。
// 変数で参照したコレクションは可変であり、定数で参照したコレクションは不変である。

var someInts = [Int]()
var someInts1 = Array<Int>()
var someInts2: [Int] = []
print(someInts, someInts1, someInts2)

var threeDoubles = Array(repeating: 0.0, count: 3)
print(threeDoubles)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles
print(sixDoubles)

var shoppingList = ["Eggs", "Milk"]
print(shoppingList, type(of: shoppingList))  // Array<String>
var test1 = [1, 2.0]
print(test1, type(of: test1))  // Array<Double>

shoppingList.append("Flour")
shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
print(shoppingList)
shoppingList[0] = "Six eggs"
print(shoppingList)
shoppingList[4...6] = ["Bananas", "Apples"]  // change a range
print(shoppingList)
shoppingList.insert("Maple Syrup", at: 0)
print(shoppingList)
let mapleSyrup = shoppingList.remove(at: 0)
print(mapleSyrup, shoppingList)
let apples = shoppingList.removeLast()  // 特に最後の要素を削除する
print(apples, shoppingList)

for (index, var value) in shoppingList.enumerated() {
    value += "!"
    print("Item \(index + 1): \(value)")
}

// Set 集合; Setを表すリテラルはない。
var letters = Set<Character>()
letters.insert("a")
print(letters)
letters = []
print(letters)

// var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
print(favoriteGenres)
print("I have \(favoriteGenres.count) favorite music genres.")
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}
favoriteGenres.insert("Jazz")
if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}
if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}
for genre in favoriteGenres {
    print("\(genre)")
}

let oddDigits              : Set = [1, 3, 5, 7, 9],
    evenDigits             : Set = [0, 2, 4, 6, 8],
    singleDigitPrimeNumbers: Set = [2, 3, 5, 7]
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] [] [1, 9] [1, 2, 9]
print(oddDigits.union(evenDigits).sorted(),
      oddDigits.intersection(evenDigits).sorted(),
      oddDigits.subtracting(singleDigitPrimeNumbers).sorted(),
      oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())

let houseAnimals: Set = ["🐶", "🐱"],
    farmAnimals : Set = ["🐮", "🐔", "🐑", "🐶", "🐱"],
    cityAnimals : Set = ["🐦", "🐭"]
// true true true
print(houseAnimals.isSubset(of: farmAnimals),
      farmAnimals.isSuperset(of: houseAnimals),
      farmAnimals.isDisjoint(with: cityAnimals))

// Dictionary 辞書
var namesOfIntegers = [Int: String]()
// var namesOfIntegers: [Int: String] = [:]
// var namesOfIntegers: Dictionary<Int, String> = [:]
print(namesOfIntegers)
namesOfIntegers[16] = "sixteen"
print(namesOfIntegers)
namesOfIntegers = [:]
print(namesOfIntegers)

// International Air Transport Association codes
var airports = ["YYZ": "Toronto Pearson",
                "DUB": "Dublin"]
print(airports)
airports["LHR"] = "London"
print(airports)
airports["LHR"] = "London Heathrow"
print(airports)

// .updateValue()は添字による更新と同じだが古い値があれば返す。
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("The old value for DUB was \(oldValue).")
}

// 辞書要素へのアクセスはOptionalオブジェクトを返す。
if let airportName = airports["DUB"] {
    print("The name of the airport is \(airportName).")
} else {
    print("That airport is not in the airports dictionary.")
}

// 辞書の要素を削除するにはnilを代入すればいい。
airports["APL"] = "Apple International"
print(airports)
airports["APL"] = nil
print(airports)

// .removeValue()で削除するとキーに対応する値が返される。
if let removedValue = airports.removeValue(forKey: "DUB") {
    print("The removed airport's name is \(removedValue).")
} else {
    print("The airports dictionary does not contain a value for DUB.")
}

// iterationg over a dictionary
for (airportCode, airportName) in airports {  // key, valueを走査する
    print("\(airportCode): \(airportName)")
}
for airportCode in airports.keys {            // keyを走査する
    print("Airport code: \(airportCode)")
}
for airportName in airports.values {          // valueを走査する
    print("Airport name: \(airportName)")
}

print(type(of: airports.keys), type(of: airports.values))  // Keys Values

let airportCodes = [String](airports.keys),  // 配列にする
    airportNames = [String](airports.values)
print(airportCodes, airportNames)
