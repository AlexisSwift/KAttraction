import UIKit

public extension Collection {
    /// Returns true if the collection is not empty
    var isNotEmpty: Bool {
        return !isEmpty
    }

    var nilIfEmpty: Self? {
        return isNotEmpty ? self : nil
    }
}

public extension Array {
    mutating func append(_ item: Element?) {
        if let item = item {
            append(item)
        }
    }

    /// Returns the original array with the added element
    func appended(_ value: Element) -> Array {
        var result = self
        result.append(value)
        return result
    }

    /// Returns the original array with the inserted element
    func prepended(_ value: Element) -> Array {
        var result = self
        result.insert(value, at: 0)
        return result
    }
}

public extension Array where Element: Equatable {
    /// Returns the original array with the added element, if it was not already in the array
    func insertedIfNotContains(_ value: Element?) -> Array {
        guard let value = value else { return self }
        if contains(where: { $0 == value }) {
            return self
        } else {
            return prepended(value)
        }
    }
}

public extension Array {
    func contains<T>(_: T.Type) -> Bool {
        return contains(where: { $0 is T })
    }

    func first<T>(_: T.Type) -> T? {
        return first(where: { $0 is T }) as? T
    }

    func last<T>(_: T.Type) -> T? {
        return last(where: { $0 is T }) as? T
    }

    func castMap<T>(_: T.Type) -> [T] {
        return self.compactMap({ $0 as? T })
    }
}

public extension Collection {
    subscript(safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
