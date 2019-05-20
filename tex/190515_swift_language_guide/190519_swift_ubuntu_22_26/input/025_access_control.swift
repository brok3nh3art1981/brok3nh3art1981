// access control
// https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html

// Indeed, if you are writing a single-target app, you may not need to
// specify explicit access control levels at all.

// moduleとは、importキーワードの対象になるものである。
// 5個のaccess levelがある。open、public、internal、fileprivate、privateである。
// privateは型の中から参照できる。fileprivateはファイルの中から参照できる。
// internalはモジュールの中から参照できる。publicはモジュールの中から継承できる。
// openはモジュールの外から継承できる。

// Swift 2まではpublic、internal、privateの3つしかなかった。
// そこでのpublicとprivateは今でいうopenとfileprivateであった。
// つまりSwift 3でpublicとprivateが追加された。
// Swift 4でprivateの仕様が変わりextensionを許すようになった。

// Open access is the highest (least restrictive) access level and private
// access is the lowest (most restrictive) access level.
// アクセスレベルが「高い」とは広範囲から見えることであり、「低い」とはローカルなことだ。

public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}

// func someFunction() -> (SomeInternalClass, SomePrivateClass) {  // コンパイルエラー
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
    return (SomeInternalClass(), SomePrivateClass())
}

// ゲッタよりもセッタのアクセスレベルを高くする:
struct TrackedString {
    private(set) var numberOfEdits = 0
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}
var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")  // 3

// さらにゲッタにもアクセスレベルを設定する:
public struct TrackedString1 {
    public private(set) var numberOfEdits = 0
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}

// private members in extensions
protocol SomeProtocol {
    func doSomething()
}
struct SomeStruct {
    private var privateVariable = 12
}
extension SomeStruct: SomeProtocol {
    func doSomething() {
        print(privateVariable)  // 同じファイルなのでprivateメンバにアクセスできる。
    }
}
SomeStruct().doSomething()  // -> 12
