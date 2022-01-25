import UIKit

// swiftlint:disable final_class
open class ContainerCell<View: UIView>: UITableViewCell {
    public let view = View()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
        setup()
    }

    open func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    open func layout() {
        contentView.addSubview(view)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = contentView.bounds
    }
}
