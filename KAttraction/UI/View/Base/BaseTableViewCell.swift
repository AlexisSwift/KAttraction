import UIKit.UITableView

// swiftlint:disable final_class
open class BaseTableViewCell: UITableViewCell {

    class var isLoadedFromNib: Bool { true }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() {
        selectionStyle = .none
    }
}
