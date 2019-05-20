// automatic reference counting
// https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html

// Automatic Reference Counting (ARC)
// ARCはクラスのインスタンスにのみ適用される。構造体と列挙型はpass by valueなので無関係だ。

protocol CountRef: AnyObject {}
extension CountRef {
    func countRef() {
        print("(strong, owned, weak) =",
              _getRetainCount(self),
              _getUnownedRetainCount(self),
              _getWeakRetainCount(self))
    }
}

class Person: CountRef {
    let name: String  // stored constant property
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
var reference1: Person?
var reference2: Person?
var reference3: Person?
reference1 = Person(name: "John Appleseed")
reference1?.countRef()
// 現在、John Appleseedへの強参照は1個である。
reference2 = reference1
reference3 = reference1
reference1?.countRef()
// 現在、John Appleseedへの強参照は3個である。
reference1 = nil
reference2 = nil
reference1?.countRef()
reference3 = nil

// strong reference cycle
// 強参照循環は、例えば2つのオブジェクトが互いを参照するときに起こる。

// 互いを参照することで強参照循環を起こしてしまう誤った実装の例:
class Person1: CountRef {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment1?
    deinit { print("\(name) is being deinitialized") }
}
class Apartment1: CountRef {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person1?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
var john: Person1?
var unit4A: Apartment1?
john = Person1(name: "John Appleseed")
unit4A = Apartment1(unit: "4A")
john?.countRef(); unit4A?.countRef();
// john = nil; unit4A = nil;  // ここでnilにすればdeinitする。

john!.apartment = unit4A
unit4A!.tenant = john
john?.countRef(); unit4A?.countRef();
john = nil; unit4A = nil;  // nilにしても（強参照循環のため）deinitしない。
// memory leakが起きたことになる。

// resolving strong reference cycles between class instances
// クラスインスタンス間の強参照循環を解決する
// weak referenceとunowned referenceというものが提供される。

// 参照先の生存時間が自分よりも短いときにはweak referenceを使うといい。
// 参照先の生存時間が短いか同じときにはunowned referenceを使うといい。
// weak referenceはdeinitされたときnilになるのでOptionalな変数にする。定数にはできない。

// Apartment2からPerson2への参照を弱参照に修正した:
class Person2: CountRef {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment2?
    deinit { print("\(name) is being deinitialized") }
}
class Apartment2: CountRef {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person2?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
var john2: Person2?
var unit4A2: Apartment2?
john2 = Person2(name: "John Appleseed")
unit4A2 = Apartment2(unit: "4A")
john2!.apartment = unit4A2
unit4A2!.tenant = john2
john2?.countRef(); unit4A2?.countRef();
john2 = nil    // deinit()
unit4A2 = nil  // deinit()

// 参照カウント方式でないガーベジコレクションを用いるシステムでは、弱参照がキャッシュに使われる。
// その弱参照は、メモリ容量が不足したときに破棄される。参照カウントの弱参照はただちに破棄される。
// よってARCの弱参照は、いわゆるGCにおけるcachingの用途には適してない。

// unowned reference
// unowned referenceはnilにならない。しかしdeinit済みの参照にアクセスしたら実行時エラーだ。

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}
class CreditCard {
    let number: UInt64
    // unowned let customer: Customer
    unowned(unsafe) let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
var john3: Customer?
john3 = Customer(name: "John Appleseed")
john3!.card = CreditCard(number: 1234_5678_9012_3456, customer: john3!)
john3 = nil  // deinit

// unowned(unsafe)と書けばunsafe unowned referenceが使える。実行時のチェックがなくなる。
// チェックがなくなるとはつまり、すでに存在しない参照先を読み書きしても実行時エラーにならない。

// unowned references and implicitly unwrapped optional properties

class Country {
    let name: String
    // selfがinit()されるまではCity()にselfを渡せないのでletにはできない。
    var capitalCity: City!  // implicitly unwrapped optional property
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}
class City {
    let name: String
    unowned let country: Country  // unowned reference property
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")

// strong reference cycles for closures
// クラスのプロパティにあるクロージャがselfを補足すると、強参照循環が起こっている。
// closure capture listという機能がある。

// クラスとクロージャによって強参照循環が起こりメモリリークしている例:
/// HTML要素を表すクラス。
class HTMLElement: CountRef {
    let name: String   // 要素の名前。h1、p、brなど。
    let text: String?  // この要素のなかのテキスト。<p>text</p>などの内側部分。
    // init()完了後にselfが使えるのでlazyとする。
    lazy var asHTML: () -> String = {  // クロージャ
        // このクロージャはselfを補足する。
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())  // <h1>some default text</h1>

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
paragraph!.countRef()
print(paragraph!.asHTML())  // <p>hello, world</p>
paragraph!.countRef()
paragraph = nil

// resolving strong reference cycle for closures
// 強参照循環をなくしメモリリークを解決したバージョン:
class HTMLElement1: CountRef {
    let name: String
    let text: String?
    lazy var asHTML: () -> String = {
        [unowned self] in  // closure capture list
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
var paragraph1: HTMLElement1? = HTMLElement1(name: "p", text: "hello, world")
paragraph1!.countRef()
print(paragraph1!.asHTML())
paragraph1!.countRef()
paragraph1 = nil  // 無事にdeinit()される。
