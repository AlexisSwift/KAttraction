import UIKit.UIScrollView
import RxSwift
import RxCocoa

@resultBuilder
public enum ScrollViewBuilder {
    public static func buildBlock(_ arg: UIStackView) -> UIStackView {
        return arg
    }
}

// swiftlint:disable:next final_class
public class ScrollView: UIScrollView {

    public init(padding: CGFloat = 0, @ScrollViewBuilder content: () -> UIStackView) {
        super.init(frame: .zero)
        let stack = content()
        addSubview(stack)
        delaysContentTouches = false
        stack.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview().inset(padding)
            maker.right.equalToSuperview().offset(padding)
            switch stack.axis {
            case .horizontal:
                maker.height.equalToSuperview()
            case .vertical:
                maker.width.equalToSuperview().inset(padding)
            @unknown default:
                break
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func hideScrollIndicators() -> Self {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        return self
    }

    @discardableResult
    public func delaysContentTouches() -> Self {
        delaysContentTouches = true
        return self
    }

    @discardableResult
    public func isScrollEnabled(_ isEnabled: Bool) -> Self {
        isScrollEnabled = isEnabled
        return self
    }

    @discardableResult
    public func isBouncingEnabled(_ isEnabled: Bool) -> Self {
        bounces = isEnabled
        return self
    }

    public func onRefresh(
        store: DisposeBag,
        refreshStore: Driver<Bool>,
        _ updateHandler: @escaping (() -> Void)
    ) -> Self {

        refreshControl = UIRefreshControl()
        let loadTrigger = PublishSubject<Void>()

        refreshStore.drive { [weak self] refreshing in
            if !refreshing {
                self?.refreshControl?.endRefreshing()
            }
        }.disposed(by: store)

        refreshControl?.rx.controlEvent(.valueChanged)
            .bind(to: loadTrigger)
            .disposed(by: store)

        loadTrigger
            .asObserver()
            .bind(onNext: { [weak self] in
                if self?.refreshControl?.isRefreshing == true {
                    updateHandler()
                }
            })
            .disposed(by: store)

        return self
    }

    @discardableResult
    public func isPagingEnabled(_ isEnabled: Bool) -> Self {
        isPagingEnabled = isEnabled
        return self
    }

    @discardableResult
    public func setDelegate(_ delegate: UIScrollViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
}

public final class ListView: ScrollView {

    let axis: NSLayoutConstraint.Axis

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, padding: CGFloat = 16, @ScrollViewBuilder content: () -> UIStackView) {
        self.axis = axis
        super.init(padding: padding, content: content)
    }
}
