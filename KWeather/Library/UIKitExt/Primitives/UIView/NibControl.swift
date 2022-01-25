import UIKit

// swiftlint:disable final_class
open class NibControl: UIControl {
    open var mainView: UIView? {
        return subviews.first
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setup()
    }

    open func setup() {}
}
