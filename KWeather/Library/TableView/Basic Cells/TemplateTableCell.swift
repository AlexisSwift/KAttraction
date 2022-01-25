import UIKit.UIView

// swiftlint:disable:next final_class
class TemplateTableViewCell<View: UIView>: BaseTableViewCell {

    override class var isLoadedFromNib: Bool { false }

    var makeView: (() -> View) = View.init

    lazy var rootView: View = { makeView() }()

    override func setup() {
        super.setup()
        layoutRootView()
    }

    func layoutRootView() {
        if !rootView.isDescendant(of: self) {
            rootView.translatesAutoresizingMaskIntoConstraints = false
            contentView.embed(subview: rootView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let preparableView = rootView as? PreparableForReuse {
            preparableView.prepareForReuse()
        }
    }
}
