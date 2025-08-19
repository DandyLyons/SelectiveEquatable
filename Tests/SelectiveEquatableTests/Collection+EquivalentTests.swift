//
//  Collection+EquivelentTests.swift
//  SelectiveEquatable
//
//  Created by Daniel Lyons on 8/19/25.
//

import Foundation
import Testing

struct Person: Identifiable, Hashable {
    let id: UUID
    let name: String
    let age: Int
}

struct Product: Identifiable, Hashable {
    let id: Int
    let name: String
    let price: Double
}

@Suite
struct CollectionEquivalentTests {
  @Test("Collections with same elements in different order are equivalent")
  func testSameElementsDifferentOrder() {
    let person1 = Person(id: UUID(), name: "Alice", age: 30)
    let person2 = Person(id: UUID(), name: "Bob", age: 25)
    let person3 = Person(id: UUID(), name: "Charlie", age: 35)
    
    let collection1 = [person1, person2, person3]
    let collection2 = [person3, person1, person2] // Different order
    
    #expect(collection1.isEquivalent(to: collection2))
    #expect(collection2.isEquivalent(to: collection1))
  }
  
  
  @Test("Empty collections are equivalent")
  func testEmptyCollections() {
    let empty1: [Person] = []
    let empty2: [Person] = []
    
    #expect(empty1.isEquivalent(to: empty2))
    #expect(empty2.isEquivalent(to: empty1))
  }
  
  @Test("Single element collections with same element are equivalent")
  func testSingleElementSame() {
    let person = Person(id: UUID(), name: "Alice", age: 30)
    let collection1 = [person]
    let collection2 = [person]
    
    #expect(collection1.isEquivalent(to: collection2))
    #expect(collection2.isEquivalent(to: collection1))
  }
  
  @Test("Collections with different counts are not equivalent")
  func testDifferentCounts() {
    let person1 = Person(id: UUID(), name: "Alice", age: 30)
    let person2 = Person(id: UUID(), name: "Bob", age: 25)
    
    let collection1 = [person1, person2]
    let collection2 = [person1]
    
    #expect(!collection1.isEquivalent(to: collection2))
    #expect(!collection2.isEquivalent(to: collection1))
  }
  
  
  @Test("Collections with missing counterpart are not equivalent")
  func testMissingCounterpart() {
      let person1 = Person(id: UUID(), name: "Alice", age: 30)
      let person2 = Person(id: UUID(), name: "Bob", age: 25)
      let person3 = Person(id: UUID(), name: "Charlie", age: 35)
      
      let collection1 = [person1, person2]
      let collection2 = [person1, person3] // person3 doesn't exist in collection1
      
      #expect(!collection1.isEquivalent(to: collection2))
      #expect(!collection2.isEquivalent(to: collection1))
  }

  @Test("Collections with same IDs but different values are not equivalent")
  func testSameIDDifferentValues() {
      let id = UUID()
      let person1 = Person(id: id, name: "Alice", age: 30)
      let person2 = Person(id: id, name: "Alice", age: 31) // Different age
      
      let collection1 = [person1]
      let collection2 = [person2]
      
      #expect(!collection1.isEquivalent(to: collection2))
      #expect(!collection2.isEquivalent(to: collection1))
  }

  @Test("Collections with duplicate IDs in first collection are not equivalent")
  func testDuplicateIDsInFirst() {
      let id = UUID()
      let person1 = Person(id: id, name: "Alice", age: 30)
      let person2 = Person(id: id, name: "Bob", age: 25) // Same ID
      let person3 = Person(id: UUID(), name: "Charlie", age: 35)
      
      let collection1 = [person1, person2] // Duplicate IDs
      let collection2 = [person3]
      
      #expect(!collection1.isEquivalent(to: collection2))
      #expect(!collection2.isEquivalent(to: collection1))
  }

  @Test("Collections with duplicate IDs in second collection are not equivalent")
  func testDuplicateIDsInSecond() {
      let id = UUID()
      let person1 = Person(id: UUID(), name: "Alice", age: 30)
      let person2 = Person(id: id, name: "Bob", age: 25)
      let person3 = Person(id: id, name: "Charlie", age: 35) // Same ID as person2
      
      let collection1 = [person1]
      let collection2 = [person2, person3] // Duplicate IDs
      
      #expect(!collection1.isEquivalent(to: collection2))
      #expect(!collection2.isEquivalent(to: collection1))
  }

  @Test("Different collection types with same elements are equivalent")
  func testDifferentCollectionTypes() {
      let person = Person(id: UUID(), name: "Alice", age: 30)
      
      let array = [person]
      let set = Set([person])
      
      #expect(array.elementsAreEquivalent(to: set))
      #expect(set.elementsAreEquivalent(to: array))
  }

  @Test("Products comparison works correctly")
  func testProductsComparison() {
      let product1 = Product(id: 1, name: "iPhone", price: 999.99)
      let product2 = Product(id: 2, name: "iPad", price: 599.99)
      
      let catalog1 = [product1, product2]
      let catalog2 = [product2, product1] // Different order
      
      #expect(catalog1.isEquivalent(to: catalog2))
      #expect(catalog2.isEquivalent(to: catalog1))
  }
}
