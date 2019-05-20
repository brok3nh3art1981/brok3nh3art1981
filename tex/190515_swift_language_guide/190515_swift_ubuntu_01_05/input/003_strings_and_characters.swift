// strings and characters
// https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html

print(type(of: ""))  // -> String
print("\"\u{24} \u{2665} \u{1f496}\"")
print(#"Line 1\nLine 2"#)  // extended string delimiters
print(###"Line 1\###nLine 2"###)
// print(##"""
//    abc
//    def
//    """##)
for s in ["", String()] {
    print(s.isEmpty, s=="")
}

// Behind the scenes, Swift’s compiler optimizes string usage so that
// actual copying takes place only when absolutely necessary.
// 文字列は値渡しだが、自動的な最適化により、不要なコピーは実際には行われない。

for character in "Dog!🐶" {
    print(character)
}

let exclamationMark: Character = "!"
print(exclamationMark, type(of: exclamationMark))

let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)
print(catString)

let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
welcome.append(exclamationMark)
print(welcome)

// string interpolation
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
print(message)

print("\u{1f425}")

// extended grapheme cluster 拡張書記素クラスタ

let eAcute: Character = "\u{e9}"
let combinedEAcute: Character = "\u{65}\u{301}"
print(eAcute, combinedEAcute)

let precomposed: Character = "\u{D55C}"                 // 한
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"  // ᄒ、ᅡ、ᆫ
print(precomposed, decomposed)

let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
print(regionalIndicatorForUS)

let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")  // 40

var greeting = "Guten Tag!"
print(greeting[greeting.startIndex])                         // G
print(greeting[greeting.index(before: greeting.endIndex)])   // !
print(greeting[greeting.index(after: greeting.startIndex)])  // u
var index = greeting.index(greeting.startIndex, offsetBy: 7)
print(greeting[index])                                       // a

for index in greeting.indices {
    print("\(greeting[index]) ", terminator: "")
}
print()

welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
print(welcome)
welcome.insert(contentsOf: " there",
               at: welcome.index(before: welcome.endIndex))
print(welcome)

welcome.remove(at: welcome.index(before: welcome.endIndex))
print(welcome)
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
print(welcome)

// Substring type
greeting = "Hello, world!"
index = greeting.firstIndex(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]
print(beginning, type(of: beginning))
let newString = String(beginning)
print(newString, type(of: newString))

print("\u{E9}", "\u{65}\u{301}", "\u{E9}"=="\u{65}\u{301}")  // true

// String and character comparisons in Swift are not locale-sensitive.

print("abcd".hasPrefix("ab"), "abcd".hasSuffix("cd"))  // true true

let dogString = "Dog‼🐶"
print(dogString)
print(type(of: dogString.utf8),            // UTF8View
      type(of: dogString.utf16),           // UTF16View
      type(of: dogString.unicodeScalars))  // UnicodeScalarView
print(type(of: dogString.utf8[dogString.utf8.startIndex]))    // UInt8
print(type(of: dogString.utf16[dogString.utf16.startIndex]))  // UInt16
print(type(of: dogString.unicodeScalars[
        dogString.unicodeScalars.startIndex]))  // Scalar
