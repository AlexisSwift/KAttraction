import UIKit

public protocol HeightableButton: AnyObject {
    static var height: CGFloat { get }
    var height: CGFloat { get }
}

public extension HeightableButton {
    var height: CGFloat { return type(of: self).height }
}
