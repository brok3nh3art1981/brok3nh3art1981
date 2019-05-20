// type casting
// https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html

/// デジタルメディアのライブラリの要素を表すクラス。
class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

/// 映画を表すクラス
class Movie: MediaItem {
    var director: String  /// 映画監督
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

/// 歌を表すクラス
class Song: MediaItem {
    var artist: String  /// アーティスト
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [  // [MediaItem]型へと型推論される。
    Movie(name: "Casablanca",              director: "Michael Curtiz"),
    Song (name: "Blue Suede Shoes",        artist: "Elvis Presley"),
    Movie(name: "Citizen Kane",            director: "Orson Welles"),
    Song (name: "The One And Only",        artist: "Chesney Hawkes"),
    Song (name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// MediaItem型の要素の元の型を扱うにはdowncastする必要がある。

// is (type check operator)によってあるインスタンスの型があるサブクラスかわかる。
var movieCount = 0  // 映画の個数
var songCount = 0   // 歌の個数
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("Media library contains \(movieCount) movies and \(songCount) songs")

// as (type cast operator)によってdowncastができる。
for item in library {
    // optional bindingを使う。
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// type casting for Any and AnyObject
// Anyは何でも。AnyObjectは任意のクラスを表す。
var things = [Any]()
things.append(0)                                                      // Int
things.append(0.0)                                                    // Double
things.append(42)                                                     // Int
things.append(3.14159)                                                // Double
things.append("hello")                                                // String
things.append((3.0, 5.0))                                             // (Double, Double)
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))  // Movie
things.append({ (name: String) -> String in "Hello, \(name)" })       // (String) -> String
print(things)
// for x in things { print(type(of: x)) }

// switch文で型でマッチして処理を振り分ける。
for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}
