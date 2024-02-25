import Foundation

protocol Copyable {
    init(data: Self)
    mutating func copy() -> Self
}

struct IOSCollection: Copyable {
    var data: NSMutableArray
    
    init(data: NSMutableArray) {
        self.data = data
    }
    
    init(data: IOSCollection) {
        self = data
    }
    
    mutating func copy() -> IOSCollection {
        self.data = self.data.mutableCopy() as! NSMutableArray
        return self
    }
    
    mutating func append(elem: Any) {
        if !isKnownUniquelyReferenced(&self.data) {
            self = self.copy()
        }
        self.data.add(elem)
    }
    
    func appendWOCopy(elem: Any) {
        self.data.add(elem)
    }
    
}

var arr: NSMutableArray = NSMutableArray(capacity: 16) // резервируем память, чтобы избежать реаллокации при добавлении
arr.add("IOSv1")
arr.add("IOSv2")

var coll1: IOSCollection = IOSCollection(data: arr)
var coll2: IOSCollection = IOSCollection(data: arr)

print("coll1 before             ", Unmanaged.passUnretained(coll1.data).toOpaque())
print("coll2 before             ", Unmanaged.passUnretained(coll2.data).toOpaque())

coll2.appendWOCopy(elem: "IOSv3")

print("coll1 append without copy", Unmanaged.passUnretained(coll1.data).toOpaque())
print("coll2 append without copy", Unmanaged.passUnretained(coll2.data).toOpaque())

coll2.append(elem: "IOSv4")

print("coll1 after              ", Unmanaged.passUnretained(coll1.data).toOpaque())
print("coll2 after              ", Unmanaged.passUnretained(coll2.data).toOpaque())

print()

protocol Hotel {
    init(roomCount: Int)
}

class HotelAlfa: Hotel {
    var roomCount: Int
    required init(roomCount: Int) {
        self.roomCount = roomCount
    }
}

// создаем протокол
protocol GameDice {
    var numberDice: Int { get }
}

// Расширяем инт
extension Int: GameDice {
    var numberDice: Int {
        get {
            print("Выпало \(self) на кубе")
            return self
        }
    }
}

// Используем get
let diceCoub = 4; diceCoub.numberDice

print()

// создаем протокол
protocol UselessProtocol {
    var property1: String { get }
    var property2: Int? { get set }
    
    func simpleMethod()
}

// подписываем класс на протокол
class UselessClass: UselessProtocol {
    var property1: String
    var property2: Int?
    
    init(property1: String, property2: Int? = nil) {
        self.property1 = property1
        self.property2 = property2
    }
    
    func simpleMethod() {
        print("simpleMethod")
    }
}

// Создание экземпляра класса и использование его
let someObject = UselessClass(property1: "My required property")
someObject.simpleMethod()
print(someObject.property1)

print()

// из видео
import Foundation

protocol Priority {
    var order : Int { get }
}

protocol EntryName : Priority {
    var label : String { get }
}

class Student : EntryName {
    var firstName : String
    var lastName : String

    var fullName: String {
        return firstName + " " + lastName
    }
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    var label : String {
        return fullName
    }
    
    let order = 1

}

class Animal {

}

class Cow : Animal, EntryName {
    var name : String?
    
    var label  : String {
        return name ?? "a cow"
    }

    let order = 2
}

struct Grass : EntryName {
    var name : String

     var label : String {
        return "Grass: " + name
     }

     let order = 3
}

let student1 = Student(firstName: "Bob", lastName: "Shmob")
let student2 = Student(firstName: "Bill", lastName: "Shill")
let student3 = Student(firstName: "Brian", lastName: "Shmian")

let cow1 = Cow()
cow1.name = "Burenka"
let cow2 = Cow()

let grass1 = Grass(name: "Bermuda")
let grass2 = Grass(name: "St. Augustine")

/*
for value in array {

    if let grass = value as? Grass {
        println(grass.type)
    } else if let student = value as? Student {
        println(student.fullName)
    } else if let cow = value as? Cow {
        println(cow.name ?? "a cow")
    }


    switch value {
    case let grass as Grass : println(grass.type)
    case let student as Student : println(student.fullName)
    case let cow as Cow: println(cow.name ?? "a cow")
    default : break
    }
}*/

func printFarm(array: inout [EntryName]) {
    array.sort(by: {a, b in
        if a.order == b.order {
            return a.label.lowercased() < b.label.lowercased()
        } else {
            return a.order < b.order
        }
    })

    for value in array {
        print(value.label)
    }
}

var array : [EntryName] =
[cow1, student1, grass2, cow2, student3, grass1, student2]

printFarm(array: &array)

print()

// Протоколы
protocol CodingProtocol {
    var time: Int { get set }
    var linesOfCode: Int { get set }
    
    func writeCode(platform: Platform, numberOfSpecialists: Int)
}

protocol CodingStopProtocol {
    func stopCoding()
}

// Енам для платформ
enum Platform {
    case iOS
    case Android
    case Web
}

// Компания
class Company: CodingProtocol, CodingStopProtocol {
    var numberOfProgrammers: Int
    var specialization: [String]
    
    init(numberOfProgrammers: Int, specialization: [String]) {
        self.numberOfProgrammers = numberOfProgrammers
        self.specialization = specialization
    }
    
    var time: Int = 0
    var linesOfCode: Int = 0
    var usedProgrammers: [Int] = []
    
    func writeCode(platform: Platform, numberOfSpecialists: Int) {
        if numberOfProgrammers - usedProgrammers.reduce(0, +) - numberOfSpecialists >= 0 {
            print("Пишем код для \(platform), нужно \(numberOfSpecialists) сотрудников")
            usedProgrammers.append(numberOfSpecialists)
        }
        else {
            print("Недостаточно программистов для задачи, осталось \(numberOfProgrammers - usedProgrammers.reduce(0, +)) сотрудников")
        }
    }
    
    func stopCoding() {
        print("Работа закончена. Сдаю в тестирование")
        _ = usedProgrammers.popLast()
    }
}

// Создаем экземпляра класса Company
let myCompany = Company(numberOfProgrammers: 50, specialization: ["iOS", "Android", "Web"])

myCompany.writeCode(platform: .iOS, numberOfSpecialists: 45)
// прилетела новая таска, но на нее нужно больше ресурсов, чем есть
myCompany.writeCode(platform: .Android, numberOfSpecialists: 10)
myCompany.stopCoding()
myCompany.writeCode(platform: .Android, numberOfSpecialists: 10)
myCompany.stopCoding()
