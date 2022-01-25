import Foundation
import RxSwift
import RxCocoa

// MARK: - filterNil
public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

public extension Observable where Element: OptionalType {

    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }
}

// MARK: - filterCases
public extension ObservableType where Element: Equatable {
    func filterCases(cases: Element...) -> Observable<Element> {
        return filter { cases.contains($0) }
    }
}

public extension Driver where SharingStrategy == DriverSharingStrategy {
    func drive(_ onNextCompletion: @escaping ((Element) -> Void)) -> Disposable {
        return drive(onNext: onNextCompletion,
                     onCompleted: nil,
                     onDisposed: nil)
    }
}

// MARK: - asVoid
public extension Observable {
    func asVoid() -> Observable<Void> {
        return map({ _ -> Void in })
    }
}
