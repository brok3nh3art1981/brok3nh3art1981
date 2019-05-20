// error handling
// https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html

// ゲームのなかの自動販売機のエラーを表す列挙型:
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// コインが5枚足りないことを表すエラー:
// throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

// throwsと書かれた関数はthrowing functionでありエラーを（外に）投げることができる。
// throwsのない関数がエラーを投げたなら（中で）自ら処理せねばならない。

struct Item {
    var price: Int  /// 価格
    var count: Int  /// 個数
}
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0  /// 投入されたコインの個数
    func vend(itemNamed name: String) throws {
        // guard文を使う
        guard let item = inventory[name] else {  // nameという名のアイテムはない
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {  // itemはもう1つもない
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {  // itemを売るにはコインが足りない
            throw VendingMachineError.insufficientFunds(
                    coinsNeeded: item.price - coinsDeposited)  // 不足分を算出する
        }
        coinsDeposited -= item.price  // 売った分のコインを減らす
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")   // nameを販売する
    }
}

/// keyの好きなスナックはvalueである。
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
// エラーをさらに上に投げる関数:
/// personの好きなスナックをvendingMachineで購入する。
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

// throwing initializer
struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

// catchする例:
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
// AliceはChipsが好きだが、Chipsを買うにはコインが2個足りない。
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {  // 実行される
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")  // 暗黙なローカル変数error
}

/// 栄養補給する
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Invalid selection, out of stock, or not enough money.")
    }
}
do {
    try nourish(with: "Beet-Flavored Chips")  // 存在しないitem
} catch {
    print("Unexpected non-vending-machine-related error: \(error)")
}

// try?によってエラーをOptionalに変換できる。
// try!によってエラーを実行時エラーにして無視できる。

// エラーと無関係にdefer文を使ってもいい。
