public struct EquatableValueSequence<T: Equatable> {
    public static func == (lhs: EquatableValueSequence<T>, rhs: T) -> Bool {
        return lhs.values.contains(rhs)
    }

    public static func == (lhs: T, rhs: EquatableValueSequence<T>) -> Bool {
        return rhs == lhs
    }

    fileprivate let values: [T]
}

public func any<T: Equatable>(of values: T...) -> EquatableValueSequence<T> {
    return EquatableValueSequence(values: values)
}

public func any<T: Equatable>(of values: [T]) -> EquatableValueSequence<T> {
    return EquatableValueSequence(values: values)
}
