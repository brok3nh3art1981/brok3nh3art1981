// closures クロージャ
// https://docs.swift.org/swift-book/LanguageGuide/Closures.html

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(names)

// 普通の関数定義による整列関数。
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)
print(reversedNames)

// 無名関数による実装:
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})
print(reversedNames)

// 型推論
// 引数に渡される無名関数については常に型推論できる。
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
print(reversedNames)

// 暗黙のreturn
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
print(reversedNames)

// shorthand argument name
reversedNames = names.sorted(by: { $0 > $1 } )
print(reversedNames)

// この場合は既存の関数を渡しても同じである。
reversedNames = names.sorted(by: >)
print(reversedNames)

// trailing closures
reversedNames = names.sorted() { $0 > $1 }
print(reversedNames)

reversedNames = names.sorted { $0 > $1 }
print(reversedNames)

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        // numberの第1桁を取得し辞書を通してすぐにforce-unwrapする。
        output = digitNames[number % 10]! + output  // 文字列の先頭に追加していく
        number /= 10    // 第1桁を捨てる
    } while number > 0  // 右から左にすべての桁を処理する
    return output
}
print(strings)



func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    // クロージャ。amoutとrunningTotalを補足する。
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}
let incrementByTen = makeIncrementer(forIncrement: 10)
print(incrementByTen())
print(incrementByTen())
print(incrementByTen())
let incrementBySeven = makeIncrementer(forIncrement: 7)
print(incrementBySeven())
print(incrementBySeven())
print(incrementBySeven())
print(incrementByTen())

// A closure is said to escape a function when the closure is passed as an argument
// to the function, but is called after the function returns.
// ある関数呼び出しが終了したのちに渡した関数が使われうるなら渡した関数はescapingしている。

var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}
class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }  // self.が必要
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()   // インスタンスを生成する
instance.doSomething()
print(instance.x)            // 200; プロパティの状態を見る
completionHandlers.first?()  // escapingなクロージャによる更新
print(instance.x)            // 100

// autoclosure
// An autoclosure lets you delay evaluation, because the code inside isn’t run
// until you call the closure.

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customersInLine.count)  // 5
let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)  // 5
print("Now serving \(customerProvider())!")  // Chris
print(customersInLine.count)  // 4

// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
// 明示的なclosure
serve(customer: { customersInLine.remove(at: 0) } )  // Alex
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
// 暗黙なclosureつまりautoclosure
serve(customer: customersInLine.remove(at: 0))  // Ewa

// 属性@autoclosureと@escapingを同時に用いる。
var customerProviders: [() -> String] = []      // 関数の配列
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)  // 配列に関数を追加する
}
collectCustomerProviders(customersInLine.remove(at: 0))  // autoclosureがescapingする
collectCustomerProviders(customersInLine.remove(at: 0))  // autoclosureがescapingする
print("Collected \(customerProviders.count) closures.")  // 2
for customerProvider in customerProviders {
    // escapingされていたそれぞれのautoclosureが実行される。
    print("Now serving \(customerProvider())!")
}
