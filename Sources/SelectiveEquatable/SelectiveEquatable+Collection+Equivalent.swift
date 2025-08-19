//
//  SelectiveEquatable+Collection+Equivalent.swift
//  SelectiveEquatable
//
//  Created by Daniel Lyons on 8/19/25.
//

import Foundation

extension Collection
where Element: Identifiable & SelectiveEquatable {
  
// TODO: Implement this method
//  /// Compares this collection with another collection.
//  ///
//  /// Verifies that:
//  /// 1. Each element has exactly one corresponding counterpart by ID
//  /// 2. The value of each counterpart must be selectively equal to a corresponding counterpart (according to the key paths provided)
//  /// 3. No element is missing a corresponding counterpart
//  /// 4. Order does not matter
//  ///
//  /// >Note: Commutative property: If collection A is equivalent to collection B, then B is equivalent to A.
//  ///
//  /// - Parameter other: The collection to compare against. May be any `Collection` that holds the same `Element` type.
//  /// - Parameter keyPath: A key path to the property (or properties) that should be compared for equality.
//  /// - Returns: `true` if collections have matching elements by ID and value, `false` otherwise
//  public func elementsAreEquivalent<C: Collection, each E: SelectiveEquatable>(
//    to other: C,
//    by keyPath: repeat KeyPath<Self, each E>
//  ) -> Bool
//  where C.Element == Self.Element,
//        each E == Self.Element
//  {
//    // Must have same count for one-to-one correspondence
//    guard self.count == other.count else {
//      return false
//    }
//    
//    // Build lookup dictionary from this collection
//    let selfLookup = Dictionary(uniqueKeysWithValues: self.map { ($0.id, $0) })
//    
//    // Ensure no duplicate IDs in this collection
//    guard selfLookup.count == self.count else {
//      return false
//    }
//    
//    // Verify each element in other collection
//    var processedIds = Set<Element.ID>()
//    
//    for otherElement in other {
//      // Check for duplicate IDs in other collection
//      guard !processedIds.contains(otherElement.id) else {
//        return false
//      }
//      processedIds.insert(otherElement.id)
//      
//      // Find corresponding element in this collection
//      guard let selfElement = selfLookup[otherElement.id] else {
//        return false // Missing counterpart
//      }
//      
//      // Values must be equal
//      guard selfElement.isEqual(to: other, by: keyPath) else {
//        return false
//      }
//    }
//  }
  
  /// Compares this collection with another collection of the same type.
  ///
  /// Verifies that:
  /// 1. Each element has exactly one corresponding counterpart by ID
  /// 2. The value of each counterpart must be equal (according to the key paths provided)
  ///    - If multiple key paths are provided, all must match for equality
  ///    - To check if all key paths match use `Collection/isEquivalent(to:)` method instead
  /// 3. No element is missing a corresponding counterpart
  /// 4. Order does not matter
  ///
  /// >Note: Commutative property: If collection A is equivalent to collection B, then B is equivalent to A.
  ///
  /// - Parameter other: The collection to compare against. Must be the same type as this collection.
  /// - Parameter keyPath: The key path(s) to the property (or properties) that should be compared for equality.
  /// - Returns: `true` if collections have matching elements by ID and value, `false` otherwise
  public func isEquivalent<each V: Equatable>(
    to other: Self,
    by keyPath: repeat KeyPath<Self.Element, each V>
  ) -> Bool {
    
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
      
      // Check if values are equal for each of the provided key paths
      for kp in repeat each keyPath {
        if selfElement[keyPath: kp] != otherElement[keyPath: kp] {
          return false
        }
      }
    }
    
    return true
  }
  
  /// Compares this collection with another collection of the same type. Functionally equivalent to `!collection.isEquivalent(to:)`, but returns `true`.
  ///
  /// For full documentation see `Collection/isEquivalent(to:by:)`.
  public func isNotEquivalent<each V: Equatable>(
    to other: Self,
    by keyPath: repeat KeyPath<Self.Element, each V>
  ) -> Bool {
    
    // Must have same count for one-to-one correspondence
    guard self.count == other.count else {
      return true
    }
    
    // Build lookup dictionary from this collection
    let selfLookup = Dictionary(uniqueKeysWithValues: self.map { ($0.id, $0) })
    
    // Ensure no duplicate IDs in this collection
    guard selfLookup.count == self.count else {
      return true
    }
    
    // Verify each element in other collection
    var processedIds = Set<Element.ID>()
    
    for otherElement in other {
      // Check for duplicate IDs in other collection
      guard !processedIds.contains(otherElement.id) else {
        return true
      }
      processedIds.insert(otherElement.id)
      
      // Find corresponding element in this collection
      guard let selfElement = selfLookup[otherElement.id] else {
        return true // Missing counterpart
      }
      
      // Check if values are equal for each of the provided key paths
      for kp in repeat each keyPath {
        if selfElement[keyPath: kp] != otherElement[keyPath: kp] {
          return true
        }
      }
    }
    
    return false
  }
}
