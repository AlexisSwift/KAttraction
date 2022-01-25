import Foundation
import RxSwift
import RxCocoa

@propertyWrapper
public final class DriverValue<Value> {

    private let behaviorRelay: BehaviorRelay<Value>!

    public var wrappedValue: Value {
        didSet {
            behaviorRelay.accept(wrappedValue)
        }
    }

     public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        self.behaviorRelay = BehaviorRelay<Value>(value: wrappedValue)
    }

    public var projectedValue: Driver<Value> {
        behaviorRelay.asDriver()
    }
}
