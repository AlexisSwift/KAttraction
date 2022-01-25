import UIKit.UIView
import RxSwift

// swiftlint:disable final_class
open class BaseView: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public convenience init(configurator: (BaseView) -> Void) {
        self.init()
        configurator(self)
    }

    open func setup() { }

    private let disposeBag = DisposeBag()
}
