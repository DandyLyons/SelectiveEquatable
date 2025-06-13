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

@Test func isEqual() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let example1 = ExampleStruct(name: "Mickey", age: 100)
    let example2 = ExampleStruct(name: "Mickey", age: 200)
    
    #expect(example1.name == example2.name)
    #expect(example1.age != example2.age)
    #expect(example1.isEqual(to: example2, by: \.name))
    #expect(example1.isEqual(to: example2, by: \.age) != true)
}
