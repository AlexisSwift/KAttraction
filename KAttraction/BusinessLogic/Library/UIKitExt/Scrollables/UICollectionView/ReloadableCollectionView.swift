import UIKit

// swiftlint:disable final_class
open class ReloadableCollectionView: UICollectionView {
    public typealias ReloadCompletionHandler = () -> Void

    private var completion: ReloadCompletionHandler?

    open func reload(then completion: @escaping ReloadCompletionHandler) {
        self.completion = completion
        reloadData()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        completion?()
        completion = nil
    }
}
