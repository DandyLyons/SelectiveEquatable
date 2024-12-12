public protocol SelectiveEquatable {
    func isEqual<each V: Equatable>(to other: Self, by keyPath: repeat KeyPath<Self, each V>) -> Bool
}

extension  SelectiveEquatable {
    public func isEqual<each V: Equatable>(to other: Self, by keyPath: repeat KeyPath<Self, each V>) -> Bool {
        for kp in repeat each keyPath {
            if self[keyPath: kp] != other[keyPath: kp] {
                return false
            }
        }
        return true
    }
}