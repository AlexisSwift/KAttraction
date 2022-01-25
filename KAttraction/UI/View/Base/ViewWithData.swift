import UIKit.UIView
import RxSwift
import RxCocoa

@resultBuilder
public enum ViewWithDataBuilder {
    public static func buildBlock(_ arg: UIView) -> UIView {
        return arg
    }
}

// swiftlint:disable:next final_class
open class ViewWithData<S>: BaseView {
    public var source: S? {
        didSet {
            updateUi()
        }
    }
    private var disposeBag = DisposeBag()
    private lazy var emptyView = UIView()
    private let content: (S) -> UIView

    public init(
        _ sourceObserver: Driver<S?>,
        @ViewWithDataBuilder content: @escaping (S) -> UIView = { _ in UIView() }
    ) {
        self.content = content
        super.init(frame: .zero)
        sourceObserver
            .drive { [weak self] newSource in
                self?.source = newSource }
            .disposed(by: disposeBag)
    }

    public init(
        _ sourceObserver: Driver<S>,
        @ViewWithDataBuilder content: @escaping (S) -> UIView = { _ in UIView() }
    ) {
        self.content = content
        super.init(frame: .zero)

        sourceObserver
            .drive { [weak self] newSource in
                self?.source = newSource }
            .disposed(by: disposeBag)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func setup() {
        super.setup()
    }

    // Must be overrided
    open func body(source: S) -> UIView {
       content(source)
    }

    open func updateUi() {
        guard let source = source else {
            emptyView.embedIn(self)
            return
        }
        body(source: source).embedIn(self)
    }
}
