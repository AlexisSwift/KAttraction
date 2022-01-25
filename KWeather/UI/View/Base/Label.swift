import UIKit.UILabel
import RxSwift

// swiftlint:disable final_class
open class Label: UILabel {

    private let disposeBag = DisposeBag()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public convenience init(text: String?) {
        self.init(frame: .zero)
        self.text = text
    }

    public convenience init(configurator: (Label) -> Void) {
        self.init(frame: .zero)
        configurator(self)
    }

    public convenience init(text: String?, configurator: (Label) -> Void) {
        self.init(frame: .zero)
        self.text = text
        configurator(self)
    }

    public convenience init(text: String, textColor: UIColor) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = textColor
    }

    open func setup() {
    }
}

extension Label {
    @discardableResult
    func setText(_ text: String) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func setTextAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    @discardableResult
    func setFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    func setTextColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }

    @discardableResult
    func setLinesCount(_ count: Int) -> Self {
        self.numberOfLines = count
        return self
    }

    @discardableResult
    func setAttributedText(_ attributedText: NSAttributedString) -> Self {
        self.attributedText = attributedText
        return self
    }
}
