// inheritance 継承
// https://docs.swift.org/swift-book/LanguageGuide/Inheritance.html

// クラスBがAを継承したらBはAのサブクラスでAはBのスーパークラスだ。
// サブクラスではスーパークラスのメソッドやプロパティがoverrideされうる。
// 他のどのクラスからも継承していないクラスをbase classと呼ぶ。

class Vehicle {
    var currentSpeed = 0.0
    /// Vehicleオブジェクトを描写する。
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    /// override用
    func makeNoise() {}
}
let someVehicle = Vehicle()  // initializer syntax
print("Vehicle: \(someVehicle.description)")

class Bicycle: Vehicle {
    var hasBasket = false  // このサブクラスで追加するストアドプロパティ
}
let bicycle = Bicycle()
bicycle.hasBasket = true
bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")

class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")

// overriding
// overrideキーワードがなくoverrideしたときと、あってoverrideしてないときはコンパイルエラー。
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
let train = Train()
train.makeNoise()

// overriding property getters and setters
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")

// overriding property observers
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1  // 速度に応じたギアを選ぶ。
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")

// finalキーワードで修飾することでメンバないしクラスを継承不可能にできる。
// クラスをfinalにするとdynamic dispatchからstatic dispatchになる。
// static dispatchにするためには、サブクラスでfinalにしたのでは駄目だろうと思う。

class Class0 {
    func f() { print("Class0#f()") }
}
Class0().f()  // -> "Class0#f()"
final class Class1: Class0 {
    final override func f() { print("Class1#f()") }
}
Class1().f()  // -> "Class1#f()"
let class1: Class1 = Class1()
class1.f()    // -> "Class1#f()"
let class0: Class0 = class1
class0.f()    // -> "Class1#f()"
