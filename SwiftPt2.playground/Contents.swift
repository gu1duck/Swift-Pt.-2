import UIKit

// Swift doesn't like nil - class values must be initialized

let string: String // We can create variables in a storyboard without initilaizing them immediately or prividing them with a value...

string = "hello" // ... and supply them with a value later ...

class MyClass {
    let string:String // ... but the compiler will not let us do this in a class...

    init(string: String) {
        self.string = string // ...without supplying them with a value in an initializer.
    }
}

// Optional is a wrapper class, just like an array—we cannot call String methods on an optional String
// here, just like we can't call String methods on an array of strings.

[String]()

// is the same as:

Array<String>()

String?()

// is the same as:

Optional<String>()

// Unwrapping optionals

let optionalString1:String? = nil
let optionalString2:String? = " there"

if let optionalString1 = optionalString1,   // we need to unwrap optionals before we can use them
    optionalString2 = optionalString2 where // with `if let` (optional binding) to add other
    optionalString1 == "hello" {            // conditions, use `where`
    print(optionalString1 + optionalString2)
} else {
    print("something bad happened") // Use `else` after `if let` statements so they don't fail
}                                   // silently!!

func doSomething() {
    guard let optionalString1 = optionalString1, // Use `guard let ... else` to exit functions
        optionalString2 = optionalString2 else { // early if conditions are not fulfilled
            print("something bad happened")
            return                               // guard statements must exit (return) or throw
    }
    print(optionalString1 + optionalString2)     // these are now unwrapped in the function's scope
}

// Downcasting: we can try to convert a class into one of its subclasses by downcasting

class Car {
    let gears = [1,2,3,4]
}

class FancyCar: Car {
    let paintJob = "hot"
}

let car1 = Car()
let car2 = FancyCar()

let carArray: [Car] = [car1, car2]

let queryCar = carArray[1] // Because carArray is type [Car] it will always reuturn Cars, not FancyCars...
queryCar.gears
//queryCar.paintJob        // ...so queryCar is returned as a Car, even if we know it's actually a FancyCar

let queryCar2 = carArray[1] as? FancyCar // This optional downcast returns an optional that contains `nil`
let queryCar3 = carArray[0] as? FancyCar // or a FancyCar, depending on whether the downcast is successful

let paintJob1 = queryCar2?.paintJob // We can use `?` after an optional in the same way to return an
let paintJob2 = queryCar3?.paintJob // optional that contains nil or he the deired value

// ☝️ This is called optional chaining. It's efficient to write, but if it returns nil, it could cause a bug
// without throwing an error, which is hard to diagnose. Use optional binding instead, where possible

if let queryCar4 = carArray[1] as? FancyCar { // We can use optional binding whe nwe first declare a value
    queryCar4.gears
    queryCar4.paintJob
} else {
    // ... always consider what goes here!!
}

// Errors

enum Error: ErrorType { // Errortype is a protocol that we use to define errors (usually as an enumerator)
    case BadError
    case WorseError
}

func unreliableFunction(parameter:Bool) throws -> String { // Throwing functions are marked before their return

    if (parameter == true){
    return "unreliable string"
    }
    throw Error.BadError // a throw statement can take the place of a return (otherwise this would not compile)
}

func doAThing() throws -> String {       // we can call functions that throw inside other functions that throw ...
    return try unreliableFunction(false) // ... but we have to mark them with `try`. This will throw errors to the
}                                        // function that calls this function.

func doAnotherThing() {                  // If we call them inside a function that does not throw,
    do {                                 // we must do so inside a `do{}catch{}` construction.
        let myString = try doAThing()
        print(myString)
    } catch Error.BadError {             // We CAN catch specific kinds of errors, like we defined above ...
        print("we hit a bad error!!")
    } catch Error.WorseError {
        print("this is even worse!!")
    } catch {                            // but we MUST end with an open-ended catch statement: if we catch one
        print("we can't. I don't even")  // thing, we must catch anything that is thrown.
    }
}

doAnotherThing()

let badString = try? unreliableFunction(false) // We can use optional chaining to `try` without catching, which
                                               // will always return an optional


// Access control

class MyPrivateClass: NSObject, UITableViewDataSource{
    let property = "property"
    private let anotherProperty = 5 // declaring members as Private means they are only accessible within the file
}

private extension MyPrivateClass { // you can create a private extension within a file to make multiple members
    func aFunction() -> String {   // private
        return "hello"
    }
}

extension MyPrivateClass { // side note: extensions are often used to separate out functionality (within a file)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// Memory management

// To avoid retain cycles, use weak or unowned references in parent-child relationships

class Doctor {
    weak var patient:Patient? // use `weak` when the refence is variable (weak references must be optional)
}

class Chart {
    unowned let patient: Patient // use `unowned` when the reference is a constant
    init(patient: Patient) {
        self.patient = patient
    }
}

class Patient {
    let doctor: Doctor
    var chart: Chart

    init(doctor:Doctor, chart:Chart) {
        self.doctor = doctor
        self.chart = chart
    }
}

class MemoryLeak {  // watch out for memory leaks when capturing `self` in blocks!!
    let name = "my name"
    func printMyName() {
        unowned let weakSelf = self // create a weak or unowned reference to `self` and reference that instead
        let printingBlock = {
            print(weakSelf.name)
        }
        printingBlock()
    }
}

// Tuples

let dictionary = ["index":5]

for (index, value) in dictionary { // Tuples let us do some cool things we couldn't do in Objective C
    print(index)
    print(value)
}

// Generics

//func peek (value:Int) -> Int {
//    return value
//}
//
//func peek (value:Double) -> Double {
//    return value
//}
//
//func peek (value:String) -> String {
//    return value
//}
//
//func peek (value:AnyObject) -> AnyObject {
//    return value
//}

func peek<T> (value:T) -> T { // Instead of making a bunch of functions, like above, we can make a generic one
    return value              // that works with any type (T), this is how arrays, optionals and dictionaries work
}

let p = peek("hello").capitalizedString

let integer = peek(5) + 5


// Operators

let coalesce = optionalString1 ?? "other thing" // Use the `nil coalescing` operator (??) after an optional to
                                                // assign a default value if that operator contains nil.
                                                // note that, witha default, `coalesce` is NOT an optional.

infix operator ** { associativity left precedence 160 } // We can define our own operators if we want to be fancy
                                                        // For the most part, you shouldn't do this, but you can.
func ** (left: String, right: Int) -> String {
    if right <= 0 {
        return ""
    }

    var result = left

    for _ in 1..<right {
        result += left
    }

    return result

}

"a" ** 6

