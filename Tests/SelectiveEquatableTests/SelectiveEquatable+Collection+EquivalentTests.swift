//
//  SelectiveEquatable+Collection+EquivalentTests.swift
//  SelectiveEquatable
//
//  Created by Daniel Lyons on 8/19/25.
//

import Foundation
import Testing
@testable import SelectiveEquatable

@Suite
struct SelectiveEquatableCollectionEquivalentTests {
  struct Person: SelectiveEquatable, Identifiable {
    let id: Int
    var name: String
    var age: Int
    var height: Int
  }
  
  let a = Person(id: 1, name: "Alice", age: 30, height: 60)
  let a_31 = Person(id: 1, name: "Alice", age: 31, height: 60)
  let b = Person(id: 2, name: "Bob", age: 30, height: 60)
  let c = Person(id: 3, name: "Carol", age: 30, height: 60)
  
  @Test
  func equivalent() {
    let collection1: [Person] = [a, b, c]
    let collection2: [Person] = [c, b, a_31]
    
    #expect(collection1.isEquivalent(to: collection2, by: \.name, \.height))
    #expect(collection2.isEquivalent(to: collection1, by: \.name, \.height))
    #expect(collection1.isNotEquivalent(to: collection2, by: \.age, \.height))
    #expect(collection2.isNotEquivalent(to: collection1, by: \.age, \.height))
  }
  
  @Test func emptyCollection() {
    let empty1: [Person] = []
    let empty2: [Person] = []
    
    #expect(empty1.isEquivalent(to: empty2, by: \.name, \.height))
    #expect(empty2.isEquivalent(to: empty1, by: \.name, \.height))
  }
  
  @Test func differentCounts() {
    let collection1: [Person] = [a, b]
    let collection2: [Person] = [a, b, c]
    
    #expect(collection1.isNotEquivalent(to: collection2, by: \.name, \.height))
    #expect(collection2.isNotEquivalent(to: collection1, by: \.name, \.height))
  }
  
  @Test func sameIDDifferentProperties() {
    let collection1: [Person] = [a, b]
    let collection2: [Person] = [a_31, b]
    
    #expect(collection1.isNotEquivalent(to: collection2, by: \.age, \.height))
    #expect(collection2.isNotEquivalent(to: collection1, by: \.age, \.height))
  }
  
  @Test func duplicateIDsInFirst() {
    let collection1: [Person] = [a, a, b]
    let collection2: [Person] = [a, b]
    
    #expect(collection1.isNotEquivalent(to: collection2, by: \.name, \.height))
    #expect(collection2.isNotEquivalent(to: collection1, by: \.name, \.height))
  }

}

