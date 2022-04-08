import UIKit

@objc
public protocol CellViewModelActionable {
    func onClickOnAnyModel()
    @objc optional func onUnclickOnAnyModel()
}

public protocol CellViewModelActionableFaceless: CellViewModelActionable {
    var onClick: ((Self) -> Void)? { get set }
    var onUnclick: ((Self) -> Void)? { get set }
}

public extension CellViewModelActionableFaceless {
    func onClickOnAnyModel() {
        onClick?(self)
    }

    func onUnclickOnAnyModel() {
        onUnclick?(self)
    }
}
