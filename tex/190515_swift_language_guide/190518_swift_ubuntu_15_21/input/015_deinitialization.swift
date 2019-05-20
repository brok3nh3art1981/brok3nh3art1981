// deinitialization
// https://docs.swift.org/swift-book/LanguageGuide/Deinitialization.html

// deinitializerはdeinit {}と書く。クラスにのみ使える。
// Automatic Reference Counting (ARC)という仕組みがある。
// deinit {}を自ら呼ぶことはできない。サブクラスのdeinit {}が先に呼ばれる。

class Bank {
    static var coinsInBank = 10_000
    /// coins単位だけお金を引き出す。ただし銀行にある以上には引き出せない。
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend  // 残高を減少する
        return numberOfCoinsToVend
    }
    /// coins単位だけお金を預ける。
    static func receive(coins: Int) {
        print("Bank.receive()")
        coinsInBank += coins                // 残高を増加する
    }
}
class Player {
    var coinsInPurse: Int  /// 所持金
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        print("Player#deinit()")
        Bank.receive(coins: coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
print("There are now \(Bank.coinsInBank) coins left in the bank")

playerOne!.win(coins: 2_000)
print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
print("The bank now only has \(Bank.coinsInBank) coins left")

playerOne = nil  // プレイヤーがゲームを離れる。参照カウントが0になる。
print("PlayerOne has left the game")
print("The bank now has \(Bank.coinsInBank) coins")

