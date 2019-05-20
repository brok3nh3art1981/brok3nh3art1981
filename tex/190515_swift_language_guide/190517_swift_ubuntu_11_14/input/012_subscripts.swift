// subscripts 添字
// https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")  // 18

for multiplier in 1...9 {
    let table = TimesTable(multiplier: multiplier)
    for index in 1...9 {
        print("\(table[index]) ", terminator: "")
    }
    print()
}

var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
print(numberOfLegs)
numberOfLegs["bird"] = 2
print(numberOfLegs)

var array0 = [1, 2, 3]
print(array0[1])
// print(array0[10])  // runtime error

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    /// rowまたはcolumnが不正なら偽を返す。
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    func printSelf() {
        for row in 0..<rows {
            for column in 0..<columns {
                print("\(self[row, column]) ", terminator: "")
            }
            print()
        }
    }
}
var matrix = Matrix(rows: 2, columns: 2)
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
matrix.printSelf()
