//
//  File.swift
//  SelectiveEquatable
//
//  Created by Daniel Lyons on 8/19/25.
//

import Foundation

// MARK: - Collection Extension for Comparing Identifiable & Equatable Elements

extension Collection where Element: Identifiable & Equatable {
  
  /// Compares this collection with another collection.
  ///
  /// Verifies that:
  /// 1. Each element has exactly one corresponding counterpart by ID
  /// 2. The value of each counterpart must be equal
  /// 3. No element is missing a corresponding counterpart
  /// 4. Order does not matter
  ///
  /// >Note: Commutative property: If collection A is equivalent to collection B, then B is equivalent to A.
  ///
  /// - Parameter other: The collection to compare against. May be any `Collection` that holds the same `Element` type.
  /// - Returns: `true` if collections have matching elements by ID and value, `false` otherwise
  public func elementsAreEquivalent<C: Collection>(to other: C) -> Bool
  where C.Element == Element {
    
    // Must have same count for one-to-one correspondence
    guard self.count == other.count else {
      return false
    }
    
    // Build lookup dictionary from this collection
    let selfLookup = Dictionary(
      self.map { ($0.id, $0) },
      uniquingKeysWith: { first, _ in
        
        return first // Keep the first value if duplicates found
      }
    )
    
    // Ensure no duplicate IDs in this collection
    guard selfLookup.count == self.count else {
      return false
    }
    
    // Verify each element in other collection
    var processedIds = Set<Element.ID>()
    
    for otherElement in other {
      // Check for duplicate IDs in other collection
      guard !processedIds.contains(otherElement.id) else {
        return false
      }
      processedIds.insert(otherElement.id)
      
      // Find corresponding element in this collection
      guard let selfElement = selfLookup[otherElement.id] else {
        return false // Missing counterpart
      }
      
      // Values must be equal
      guard selfElement == otherElement else {
        return false
      }
    }
    
    return true
  }
  
  /// Returns the inverse of `isEquivalent(to:)` for semantic clarity
  ///
  /// >Note: Commutative property: If collection A is not equivalent to collection B, then B is not equivalent to A.
  ///
  /// - Parameter other: The collection to compare against
  /// - Returns: `true` if collections are NOT equivalent, `false` if they are equivalent
  public func elementsAreNotEquivalent<C: Collection>(to other: C) -> Bool
  where C.Element == Element {
    return !elementsAreEquivalent(to: other)
  }
  
  /// Compares this collection with another collection of the same type.
  ///
  /// Verifies that:
  /// 1. Each element has exactly one corresponding counterpart by ID
  /// 2. The value of each counterpart must be equal
  /// 3. No element is missing a corresponding counterpart
  /// 4. Order does not matter
  ///
  /// >Note: Commutative property: If collection A is equivalent to collection B, then B is equivalent to A.
  ///
  /// - Parameter other: The collection to compare against. Must be the same type as this collection.
  /// - Returns: `true` if collections have matching elements by ID and value, `false` otherwise
  public func isEquivalent(to other: Self) -> Bool {
    
    // Must have same count for one-to-one correspondence
    guard self.count == other.count else {
      return false
    }
    
    // Build lookup dictionary from this collection
    let selfLookup = Dictionary(uniqueKeysWithValues: self.map { ($0.id, $0) })
    
    // Ensure no duplicate IDs in this collection
    guard selfLookup.count == self.count else {
      return false
    }
    
    // Verify each element in other collection
    var processedIds = Set<Element.ID>()
    
    for otherElement in other {
      // Check for duplicate IDs in other collection
      guard !processedIds.contains(otherElement.id) else {
        return false
      }
      processedIds.insert(otherElement.id)
      
      // Find corresponding element in this collection
      guard let selfElement = selfLookup[otherElement.id] else {
        return false // Missing counterpart
      }
      
      // Values must be equal
      guard selfElement == otherElement else {
        return false
      }
    }
    
    return true
  }
  
  /// Returns the inverse of `isEquivalent(to:)` for semantic clarity
  ///
  /// >Note: Commutative property: If collection A is not equivalent to collection B, then B is not equivalent to A.
  public func isNotEquivalent(to other: Self) -> Bool {
    return !isEquivalent(to: other)
  }
}

// MARK: - Detailed Comparison with Error Reporting
//
//enum ElementComparisonError: Error, LocalizedError {
//    case differentCounts(self: Int, other: Int)
//    case duplicateIdInSelf(id: Any)
//    case duplicateIdInOther(id: Any)
//    case missingCounterpart(id: Any)
//    case valuesMismatch(id: Any, selfValue: Any, otherValue: Any)
//    
//    var errorDescription: String? {
//        switch self {
//        case .differentCounts(let selfCount, let otherCount):
//            return "Collections have different counts: \(selfCount) vs \(otherCount)"
//        case .duplicateIdInSelf(let id):
//            return "Duplicate ID in source collection: \(id)"
//        case .duplicateIdInOther(let id):
//            return "Duplicate ID in comparison collection: \(id)"
//        case .missingCounterpart(let id):
//            return "No counterpart found for ID: \(id)"
//        case .valuesMismatch(let id, let selfValue, let otherValue):
//            return "Elements with ID \(id) have different values - self: \(selfValue), other: \(otherValue)"
//        }
//    }
//}

//extension Collection where Element: Identifiable & Equatable {
//    
//    /// Performs detailed comparison and returns specific error information
//    /// - Parameter other: The collection to compare against
//    /// - Returns: `.success(())` if equivalent, `.failure(error)` with specific issue
//    func compareElements<C: Collection>(with other: C) -> Result<Void, ElementComparisonError>
//    where C.Element == Element {
//        
//        guard self.count == other.count else {
//            return .failure(.differentCounts(self: self.count, other: other.count))
//        }
//        
//        // Build lookup dictionary and check for duplicates in self
//        var selfLookup: [Element.ID: Element] = [:]
//        for element in self {
//            guard selfLookup[element.id] == nil else {
//                return .failure(.duplicateIdInSelf(id: element.id))
//            }
//            selfLookup[element.id] = element
//        }
//        
//        // Check other collection
//        var processedIds = Set<Element.ID>()
//        for otherElement in other {
//            // Check for duplicates in other
//            guard !processedIds.contains(otherElement.id) else {
//                return .failure(.duplicateIdInOther(id: otherElement.id))
//            }
//            processedIds.insert(otherElement.id)
//            
//            // Find counterpart
//            guard let selfElement = selfLookup[otherElement.id] else {
//                return .failure(.missingCounterpart(id: otherElement.id))
//            }
//            
//            // Check equality
//            guard selfElement == otherElement else {
//                return .failure(.valuesMismatch(id: otherElement.id, selfValue: selfElement, otherValue: otherElement))
//            }
//        }
//        
//        return .success(())
//    }
//}

// MARK: - Example Usage



//// Example usage:
//func demonstrateUsage() {
//    // Test with Person objects
//    let alice = Person(id: UUID(), name: "Alice", age: 30)
//    let bob = Person(id: UUID(), name: "Bob", age: 25)
//    let charlie = Person(id: UUID(), name: "Charlie", age: 35)
//    
//    let group1 = [alice, bob, charlie]
//    let group2 = [charlie, alice, bob] // Same elements, different order
//    let group3 = [alice, bob] // Missing charlie
//    let group4 = [alice, bob, Person(id: charlie.id, name: "Charlie", age: 36)] // Different age
//    
//    print("Same people, different order:", group1.isEquivalent(to: group2)) // true
//    print("Missing person:", group1.isEquivalent(to: group3)) // false
//    print("Different age:", group1.isEquivalent(to: group4)) // false
//    
//    // Using detailed comparison
//    switch group1.compareElements(with: group4) {
//    case .success:
//        print("Collections are equivalent")
//    case .failure(let error):
//        print("Comparison failed: \(error.localizedDescription)")
//    }
//    
//    // Test with Product objects
//    let products1 = [
//        Product(id: 1, name: "iPhone", price: 999.99),
//        Product(id: 2, name: "iPad", price: 599.99)
//    ]
//    
//    let products2 = [
//        Product(id: 2, name: "iPad", price: 599.99),
//        Product(id: 1, name: "iPhone", price: 999.99)
//    ] // Same products, different order
//    
//    print("Same products, different order:", products1.isEquivalent(to: products2)) // true
//    
//    // Test with arrays vs sets
//    let arrayOfProducts = [Product(id: 1, name: "iPhone", price: 999.99)]
//    let setOfProducts = Set([Product(id: 1, name: "iPhone", price: 999.99)])
//    
//    print("Array vs Set comparison:", arrayOfProducts.isEquivalent(to: setOfProducts)) // true
//}

//extension Collection where Element: Identifiable & Equatable {
//    
//    /// Performs detailed comparison and returns specific error information
//    /// - Parameter other: The collection to compare against
//    /// - Returns: `.success(())` if equivalent, `.failure(error)` with specific issue
//    func compareElements<C: Collection>(with other: C) -> Result<Void, ElementComparisonError>
//    where C.Element == Element {
//        
//        guard self.count == other.count else {
//            return .failure(.differentCounts(self: self.count, other: other.count))
//        }
//        
//        // Build lookup dictionary and check for duplicates in self
//        var selfLookup: [Element.ID: Element] = [:]
//        for element in self {
//            guard selfLookup[element.id] == nil else {
//                return .failure(.duplicateIdInSelf(id: element.id))
//            }
//            selfLookup[element.id] = element
//        }
//        
//        // Check other collection
//        var processedIds = Set<Element.ID>()
//        for otherElement in other {
//            // Check for duplicates in other
//            guard !processedIds.contains(otherElement.id) else {
//                return .failure(.duplicateIdInOther(id: otherElement.id))
//            }
//            processedIds.insert(otherElement.id)
//            
//            // Find counterpart
//            guard let selfElement = selfLookup[otherElement.id] else {
//                return .failure(.missingCounterpart(id: otherElement.id))
//            }
//            
//            // Check equality
//            guard selfElement == otherElement else {
//                return .failure(.valuesMismatch(id: otherElement.id, selfValue: selfElement, otherValue: otherElement))
//            }
//        }
//        
//        return .success(())
//    }
//}

// MARK: - Swift Testing Test Suite
//



//
// MARK: - Detailed Comparison Tests
//
//@Test("Detailed comparison succeeds for equivalent collections")
//func testDetailedComparisonSuccess() {
//    let person1 = Person(id: UUID(), name: "Alice", age: 30)
//    let person2 = Person(id: UUID(), name: "Bob", age: 25)
//    
//    let collection1 = [person1, person2]
//    let collection2 = [person2, person1]
//    
//    let result = collection1.compareElements(with: collection2)
//    
//    switch result {
//    case .success:
//        break // Expected
//    case .failure(let error):
//        Issue.record("Expected success but got error: \(error)")
//    }
//}
//
//@Test("Detailed comparison reports different counts")
//func testDetailedComparisonDifferentCounts() {
//    let person = Person(id: UUID(), name: "Alice", age: 30)
//    
//    let collection1 = [person]
//    let collection2: [Person] = []
//    
//    let result = collection1.compareElements(with: collection2)
//    
//    switch result {
//    case .success:
//        Issue.record("Expected failure but got success")
//    case .failure(.differentCounts(let selfCount, let otherCount)):
//        #expect(selfCount == 1)
//        #expect(otherCount == 0)
//    case .failure(let otherError):
//        Issue.record("Expected differentCounts but got: \(otherError)")
//    }
//}
//
//@Test("Detailed comparison reports duplicate ID in self")
//func testDetailedComparisonDuplicateInSelf() {
//    let sharedId = UUID()
//    let person1 = Person(id: sharedId, name: "Alice", age: 30)
//    let person2 = Person(id: sharedId, name: "Bob", age: 25) // Same ID
//    let person3 = Person(id: UUID(), name: "Charlie", age: 35)
//    
//    let collection1 = [person1, person2] // Duplicate IDs
//    let collection2 = [person3, person3] // We need same count
//    
//    let result = collection1.compareElements(with: collection2)
//    
//    switch result {
//    case .success:
//        Issue.record("Expected failure but got success")
//    case .failure(.duplicateIdInSelf(let id)):
//        #expect("\(id)" == "\(sharedId)")
//    case .failure(let otherError):
//        Issue.record("Expected duplicateIdInSelf but got: \(otherError)")
//    }
//}
//
//@Test("Detailed comparison reports values mismatch with both values")
//func testDetailedComparisonValuesMismatch() {
//    let sharedId = UUID()
//    let person1 = Person(id: sharedId, name: "Alice", age: 30)
//    let person2 = Person(id: sharedId, name: "Alice", age: 31) // Same ID, different age
//    
//    let collection1 = [person1]
//    let collection2 = [person2]
//    
//    let result = collection1.compareElements(with: collection2)
//    
//    switch result {
//    case .success:
//        Issue.record("Expected failure but got success")
//    case .failure(.valuesMismatch(let id, let selfValue, let otherValue)):
//        #expect("\(id)" == "\(sharedId)")
//        
//        // Verify the values are included in the error
//        let selfPerson = selfValue as? Person
//        let otherPerson = otherValue as? Person
//        
//        #expect(selfPerson?.age == 30)
//        #expect(otherPerson?.age == 31)
//        
//        // Test error message includes both values
//        let errorMessage = ElementComparisonError.valuesMismatch(
//            id: id,
//            selfValue: selfValue,
//            otherValue: otherValue
//        ).localizedDescription
//        
//        #expect(errorMessage.contains("self:"))
//        #expect(errorMessage.contains("other:"))
//        #expect(errorMessage.contains("30"))
//        #expect(errorMessage.contains("31"))
//        
//    case .failure(let otherError):
//        Issue.record("Expected valuesMismatch but got: \(otherError)")
//    }
//}
//
//@Test("Detailed comparison reports missing counterpart")
//func testDetailedComparisonMissingCounterpart() {
//    let person1 = Person(id: UUID(), name: "Alice", age: 30)
//    let person2 = Person(id: UUID(), name: "Bob", age: 25)
//    
//    let collection1 = [person1]
//    let collection2 = [person2] // Different person with different ID
//    
//    let result = collection1.compareElements(with: collection2)
//    
//    switch result {
//    case .success:
//        Issue.record("Expected failure but got success")
//    case .failure(.missingCounterpart(let id)):
//        #expect("\(id)" == "\(person2.id)")
//    case .failure(let otherError):
//        Issue.record("Expected missingCounterpart but got: \(otherError)")
//    }
//}
//
//@Test("isNotEquivalent works correctly")
//func testIsNotEquivalent() {
//    let person1 = Person(id: UUID(), name: "Alice", age: 30)
//    let person2 = Person(id: UUID(), name: "Bob", age: 25)
//    
//    let collection1 = [person1, person2]
//    let collection2 = [person2, person1] // Same elements, different order
//    let collection3 = [person1] // Missing person2
//    
//    #expect(!collection1.isNotEquivalent(to: collection2)) // Should be equivalent
//    #expect(collection1.isNotEquivalent(to: collection3)) // Should not be equivalent
//}
//
//@Test("Custom operator works correctly")
//func testCustomOperator() {
//    let person1 = Person(id: UUID(), name: "Alice", age: 30)
//    let person2 = Person(id: UUID(), name: "Bob", age: 25)
//    
//    let collection1 = [person1, person2]
//    let collection2 = [person2, person1]
//    let collection3 = [person1]
//    
//    #expect(collection1 ~= collection2) // Should be equivalent
//    #expect(!(collection1 ~= collection3)) // Should not be equivalent
//}
//
//@Test("Alternative method names work correctly")
//func testAlternativeMethodNames() {
//    let person = Person(id: UUID(), name: "Alice", age: 30)
//    
//    let collection1 = [person]
//    let collection2 = [person]
//    
//    // Test all method names
//    #expect(collection1.hasMatchingElements(with: collection2))
//    #expect(collection1.isEquivalent(to: collection2))
//    #expect(collection1.containsSameElements(as: collection2))
//}
