# SelectiveEquatable

SelectiveEquatable is a Swift library that allows you to perform equality checks on object and value instances by specifying which properties to include in the comparison. Any combination of properties can be included in the comparison so long as they conform to the `Equatable` protocol.

## Usage
Suppose we have the following `Person` struct:

```swift
struct Person: Identifiable {
   let firstName: String
   let lastName: String
   let age: Int
   let id: UUID
   let profileImage: UIImage
}
```

Suppose we had a collection of `Person`s and we'd like to determine if any persons have the same `firstName`, `lastName`, and `age` but different `id`s and `profileImage`s. We can use `SelectiveEquatable` to perform this comparison:

```swift
extension Person: SelectiveEquatable {}
person1.isEqual(to: person2, by: \.firstName, \.lastName, \.age) // returns true or false
```

By simply conforming our type to `SelectiveEquatable`, we can now selectively compare instances of `Person` based on the properties we specify. In this case, we're comparing `person1` and `person2` based on their `firstName`, `lastName`, and `age`.

## Installation
`SelectiveEquatable` is an extremely simple protocol. In order to use it, you can simply copy the `SelectiveEquatable.swift` file into your project.

### Swift Package Manager
You can also use the Swift Package Manager to install `SelectiveEquatable`. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "", from: "1.0.0")
]
```

## License
`SelectiveEquatable` is available under the MIT license. See the LICENSE file for more info.
