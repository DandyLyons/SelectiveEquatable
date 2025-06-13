import Testing
@testable import SelectiveEquatable

final class ExampleStruct: SelectiveEquatable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

@Suite
struct SelectiveEquatableTests {
    let example1 = ExampleStruct(name: "Mickey", age: 100)
    let example2 = ExampleStruct(name: "Mickey", age: 200)

    @Test func isEqual() async throws {
        #expect(example1.isEqual(to: example2, by: \.name))
        #expect(example1.isEqual(to: example2, by: \.age) != true)
    }
        
    @Test func isNotEqual() async throws {
        #expect(example1.isNotEqual(to: example2, by: \.name) == false)
        #expect(example1.isNotEqual(to: example2, by: \.age))
    }
}

