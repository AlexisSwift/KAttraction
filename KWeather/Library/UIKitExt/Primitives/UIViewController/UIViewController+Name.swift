import UIKit

// swiftlint:disable final_class
public extension UIViewController {

    var className: String {
        return NSStringFromClass(classForCoder).components(separatedBy: ".").last ?? ""
    }
}
