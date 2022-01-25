import UIKit.UICollectionView

// swiftlint:disable final_class
open class BaseCollectionViewCell: UICollectionViewCell {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    open func setup() { }
}
