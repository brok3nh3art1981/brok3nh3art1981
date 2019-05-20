// generics
// https://docs.swift.org/swift-book/LanguageGuide/Generics.html

// 総称関数を用いない場合、実装が同じ関数を型ごとに定義せざるをえない:
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

// generics function 総称的な関数
// type parameter 型パラメータTを用いる
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
someInt = 3
anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print(someInt, anotherInt)

var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
print(someString, anotherString)

func swapTwoValues1<T>(_ a: inout T, _ b: inout T) { (a, b) = (b, a) }
someInt = 3
anotherInt = 107
swapTwoValues1(&someInt, &anotherInt)
print(someInt, anotherInt)
someInt = 3
anotherInt = 107
swap(&someInt, &anotherInt)
print(someInt, anotherInt)

// naming type parameters
// Dictionary<Key, Value>やArray<Element>のように、型パラメータには有意義な名前が望ましい。
// しかし特に適当なものがない場合には慣習的に、T、U、Vなどとする。

// generic type 総称関数とは別に総称型がある。
// stackはpushとpopができるデータ構造である。

// 総称的でない型によるスタックの実装:
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 総称的なStack型:
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
print(stackOfStrings.items)
let fromTheTop = stackOfStrings.pop()
print(fromTheTop, stackOfStrings.items)

// 総称型をextensionするときは、宣言しなくても同じ型変数（ここではElement）が使える:
extension Stack {
    /// トップにある要素を返す。ただし、もし空ならnilを返す。
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {  // optional束縛
    print("The top item on the stack is \(topItem).")
}

// type constraints 型制約
// 例えばDictionaryオブジェクトの要素のキーはHashableでなければならない。
// type constraints in action

/// 配列inにおけるofStringの位置を返す。存在しなければnilを返す。
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {  // 各要素について
        if value == valueToFind {               // 見つけた
            return index
        }
    }
    return nil  // 見つからなかった
}
let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    print("The index of llama is \(foundIndex)")
}

// 総称関数で演算子==を用いるには型がEquatableでなければならない:
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
print(doubleIndex as Any)
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
print(stringIndex as Any)

// associatedtype
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
struct IntStack1: Container {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // typealias Item = Int  // turns abstract type into a concrete type.
    mutating func append(_ item: Int) {  // IntがContainerのItemだろうと推論される。
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}
struct Stack1<Element>: Container {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(_ item: Element) {  // ElementがItemだと自動的に推論される。
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

// extending an existing type to specify an associatedtype
// 既存のArrayはそもそもContainerたる要件を満たしているので宣言さえすればいい:
extension Array: Container {}

// adding constraints to an associatedtype
protocol Container1 {
    associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// using a protocol in its associated type's constraints
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    /// 末尾のsize個の要素を返す。
    func suffix(_ size: Int) -> Suffix
}
extension Stack1: SuffixableContainer {
    func suffix(_ size: Int) -> Stack1 {  // Suffixは具体的にはStack1だと推論される。
        var result = Stack1()
        for index in (count-size)..<count {  // 末尾のsize個それぞれについて
            result.append(self[index])
        }
        return result
    }
}
var stackOfInts = Stack1<Int>()
stackOfInts.append(10)  // [10]
stackOfInts.append(20)  // [10, 20]
stackOfInts.append(30)  // [10, 20, 30]
let suffix = stackOfInts.suffix(2)
print(suffix)  // [20, 30]

// 上の例ではStack1のassociatedtypeはまたStack1であったが、そうでなくてもいい。
// 例えば次の例では、IntStack1のassociatedtype Stack1<Int>は制約を満たしている。
// 制約とはつまり、ともにSuffixableContainerであって、要素の型がInt同士等しいということだ。
extension IntStack1: SuffixableContainer {
    func suffix(_ size: Int) -> Stack1<Int> {
        var result = Stack1<Int>()
        for index in (count-size)..<count {
            result.append(self[index])
        }
        return result
    }
}

// generic where clause
/// C1とC2の各要素が同じ順でそれぞれ等しければ真を返す。
/// Containerでありさえすれば、C1とC2の型は異なっていていい。
func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        if someContainer.count != anotherContainer.count {
            return false  // そもそもコンテナの大きさが異なる。
        }
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false  // ある要素が存在して等しくなかった。
            }
        }
        return true  // コンテナの大きさが等しく各添字の要素が互いに等しい。
}
var stackOfStrings1 = Stack1<String>()
stackOfStrings1.push("uno")
stackOfStrings1.push("dos")
stackOfStrings1.push("tres")
var arrayOfStrings = ["uno", "dos", "tres"]
if allItemsMatch(stackOfStrings1, arrayOfStrings) {
    print("All items match.")  // 実行される
} else {
    print("Not all items match.")
}

// extensions with a generic where clause
// Stack1型を（ElementがEquatableなものについてのみ）extensionする。
extension Stack1 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false  // [Element]#lastは要素がないときnil。
        }
        return topItem == item  // トップにある要素がitemかどうか。
    }
}
if stackOfStrings1.isTop("tres") {
    print("Top element is tres.")  // 実行される
} else {
    print("Top element is something else.")
}

struct NotEquatable { }
var notEquatableStack = Stack1<NotEquatable>()
let notEquatableValue = NotEquatable()
notEquatableStack.push(notEquatableValue)
// notEquatableStack.isTop(notEquatableValue)  // Error
// error: argument type 'NotEquatable' does not conform to expected type 'Equatable'

// protocolをwhereで拡張する:
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
if [9, 9, 9].startsWith(42) {
    print("Starts with 42.")
} else {
    print("Starts with something else.")  // 実行される
}

extension Container where Item == Double {  // 具体的な型で制約する。
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
print([1260.0, 1200.0, 98.6, 37.0].average())  // 648.9

// associated types with a generic where clause
protocol Container2 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
    func makeIterator() -> Iterator
}

// protocolを継承した子protocolでassociatedtypeを制約するwhere節はこう書ける:
protocol ComparableContainer: Container where Item: Comparable { }

// generic subscript 総称的添字
extension Container {
    // 添字としてSequence型を取る。ただしそのIteratorのElementはIntでなければならない。
    // なおselfの添字がIntであることは、Containerプロトコルの定義がすでに言っている。
    subscript<Indices: Sequence>(indices: Indices) -> [Item]
        where Indices.Iterator.Element == Int {
            var result = [Item]()
            for index in indices {
                result.append(self[index])
            }
            return result
    }
}
print(stackOfStrings1)          // ["uno", "dos", "tres"]
print(stackOfStrings1[[0, 1]])  // ["uno", "dos"]
