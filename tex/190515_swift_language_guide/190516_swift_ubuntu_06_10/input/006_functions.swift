// functions 関数
// https://docs.swift.org/swift-book/LanguageGuide/Functions.html

// すべての関数には型がある。関数はネストできる。
// すべての関数には名前がある。

func func0(x0: Int, x1: Int) {
    print(x0 * x1)
}
func0(x0: 2, x1: 3)
// func0(x1: 2, x0: 3)  // 引数の順番を守らないとcompile-time error。

// 文字列を取り文字列を返す関数を定義する。
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
// argument labelを用いて引数を与える。
print(greet(person: "Anna"))
print(greet(person: "Brian"))

func greetAgain(person: String) -> String {
    return "Hello again, " + person + "!"  // 一旦定数に束縛することをせずにreturnする。
}
print(greetAgain(person: "Anna"))

// パラメータのない関数。
func sayHelloWorld() -> String {
    return "hello, world"
}
print(sayHelloWorld())

// 複数のパラメータを持つ関数。
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return greetAgain(person: person)
    } else {
        return greet(person: person)
    }
}
print(greet(person: "Tim", alreadyGreeted: true))

// 返り値はなくてもいい。
func greet1(person: String) {
// func greet1(person: String) -> () {
    print("Hello, \(person)!")
}
print(greet1(person: "Dave"), ())  // -> ()

func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}
func printWithoutCounting(string: String) {  // 返り値はない
    let _ = printAndCount(string: string)    // 返り値を無視している
}
// printAndCount(string: "hello, world")  // 返り値12を無視している。warning
let _ = printAndCount(string: "hello, world")  // warningを抑制する
let _ = printAndCount(string: "hello, world")  // _は複数回定義できる
printWithoutCounting(string: "hello, world")

// タプルによって複数の値を返す。
func minMax(array: [Int]) -> (min: Int, max: Int) {  // 名前付きタプルを返す
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
let bounds = minMax(array: [8, -6, 2, 109, 3, 71])
print("min is \(bounds.min) and max is \(bounds.max)")

// optional tuple return types
func minMax1(array: [Int]) -> (min: Int, max: Int)? {
    print("optional tuple return types")
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax1(array: [8, -6, 2, 109, 3, 71]) {
    print("min is \(bounds.min) and max is \(bounds.max)!")
}
print(minMax1(array: [8, -6, 2, 109, 3, 71]) as Any)
print(minMax1(array: [8, -6, 2, 109, 3, 71])!)

// 面倒な気がする。
// minMaxを使う側はこの場合、[Int]#isEmptyではないと知っている。
// しかし、minMaxのなかで未知の問題が起きないとも限らないからminMax()!とまでしたくない。
// 本当にしたいことは、minMax()に[]を渡したときにはコンパイルエラーとして、
// []以外を渡したときにはそうでなくしてほしいということだ。
// つまり、minMax()の引数はarray: [Int]というより、where !array.isEmptyなわけである。
// しかし言語仕様などのためにそうはいかないから、minMax()は定義域に[]を含むことになる。
// 結果として、入力[]について出力nilが返される。結果として正常な使用者にも影響が生じる。
// 1つの方法は、minMax1に[]が与えられたときにはnilを返さず実行時エラーにすることだろう。
// すると、コードは簡潔になる。
// optionalにある思想の1つは、実行時エラーにしないということだろうか。
// というのも、使用者はもしかしたら回復のすべを持っているのかもしれない。
// ならば、すべての関数（の返り値）をOptionalにするか？
// しかしすべての関数の引数をOptionalにまでしないのだから、nilのまますべて進行するのではない。
// minMax(array: [Int])とすることで、APIはユーザに対して[]を受け取ると宣言してしまう。
// 宣言しておいて、[]を渡されたときには注意書き違反だと実行時エラーを出してそれでいいのか。
// エラーが結果としてのnilで表されるとどこに問題があったのかわかりにくい。
// というのも、開発中の大半のエラーは、なんでもないtypoなどで生じるだろう。
// 他の言語で、precondition()を用いる方法も一般的である。
// また別の方法は、デフォルト値として(0, 0)などを返すことである。
// それは問題を最も隠蔽する面はあるが、過大な定義域について出力の型を堅持することができる。
// 実装時にコントロールできない条件についてはOptionalは適しているだろう。
// 正常系を外れたときには、例外を投げるか、Optionalでnilを返すか、実行時エラーとする。
// コードの上では、ある制約を満たしていると明らかであっても、言語はそのすべてを理解できない。
// ゆえに、理想的に堅牢にはできない。
// 実行時エラーを見たくないというのは、考え方としてはありうる。
// もし関数がOptionalなら、実行時エラーにするかどうかはユーザが選べる。
// 実行時エラーにしたければ、ただf()!を多用すればよいと考えられる。
// いかなるときにある関数がnilを返すかは、ドキュメントで謳う形になるだろう。
// しかし実行時エラーにするかどうかをユーザに選ばせるという意味では、f()!は好ましくない。
// やはり、nilのまま進行させることになる。どこからを実行時エラーとすべきか、ということになる。
// モジュールでの異常値がプログラム全体を停止させるに値しないならassert()を使う。
// その異常値ではどうせ処理ができないならprecondition()を使う。

// https://stackoverflow.com/questions/30094582/swift-ounchecked-and-assertions
// You should definitely not compile -Ounchecked for release in order to use
// precondition only while testing. Compiling -Ounchecked also disables
// checks for things like array out of bounds and unwrapping nil, that could
// lead to some pretty nasty production bugs involving memory corruption.

// 引数の定義域を理想的に制約できないことによる入力値にはprecondition()でいいのではないか。
// 辞書の要素アクセスすらOptionalなので、Optionalを汎用すればいいのかもしれない。!を多用する。

// Place parameters that don’t have default values at the beginning of a
// function’s parameter list, before the parameters that have default values.

// default値のある引数について、ラベルで区別できるので前方にも置ける。
// 引数ラベルを無名にするなども、呼び出しが曖昧にならない限り許される。
func f1(x: Int = 1, y: Int) {
    print(x * y)
}
f1(x:2, y:3)
f1(y:3)

// variadic parameters 可変長パラメータ
// パラメータnumberの型は[Double]となる。
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
print(arithmeticMean(1, 2, 3, 4, 5),
      arithmeticMean(3, 8.25, 18.75))

// 引数ラベルを_としなかった場合:
func f2(x: Int...) {
    for element in x {
        print("\(element) ", terminator:"")
    }
    print()
}
f2(x: 1, 2, 3)  // 先頭にだけ引数ラベルを与えれば動くようだ。

// inout parameters
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
func printHelloWorld() {
    print("hello, world")
}
print(type(of: addTwoInts),
      type(of: multiplyTwoInts),
      type(of: printHelloWorld))
var mathFunction: (Int, Int) -> Int = addTwoInts
print("Result: \(mathFunction(2, 3))")
mathFunction = multiplyTwoInts
print("Result: \(mathFunction(2, 3))")

// 高階関数
func printMathResult(_ mathFunction: (Int, Int) -> Int,
                     _ a: Int,
                     _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)

func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
// 関数を返す関数。
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
// nested function
func chooseStepFunction1(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = 3
// let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
let moveNearerToZero = chooseStepFunction1(backward: currentValue > 0)
print("Counting to zero:")
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")

do {
    let x = 89
    print(x)
}
// print(x)
