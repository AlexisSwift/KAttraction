import UIKit.UIStackView
import RxSwift
import RxCocoa

@resultBuilder
public enum ForEachBuilder {
    public static func buildBlock(_ args: UIView...) -> [UIView] {
        return args
    }
}

public final class ForEach<T>: UIStackView where T: Collection {
    private var collection: T? {
        didSet {
            setupCollection(collection)
        }
    }
    private let spacerSize: CGFloat
    private let content: (T.Element) -> [UIView]
    private var disposeBag = DisposeBag()
    private var defaultDistribution: UIStackView.Distribution

    public init(_ collectionDriver: Driver<T>,
                spacerSize: CGFloat = 0,
                distribution: UIStackView.Distribution = .fill,
                @ForEachBuilder content: @escaping (T.Element) -> [UIView]) {
        self.content = content
        self.spacerSize = spacerSize
        self.defaultDistribution = distribution
        super.init(frame: .zero)
        self.distribution = distribution
        collectionDriver
            .drive { [weak self] newCollection in
                self?.collection = newCollection
            }
            .disposed(by: disposeBag)
    }

    public init(_ collectionDriver: Driver<T?>, spacerSize: CGFloat = 0,
                distribution: UIStackView.Distribution = .fill,
                @ForEachBuilder content: @escaping (T.Element) -> [UIView]) {
        self.content = content
        self.spacerSize = spacerSize
        self.defaultDistribution = distribution
        super.init(frame: .zero)
        self.distribution = distribution
        collectionDriver
            .drive { [weak self] newCollection in
                self?.collection = newCollection
            }
            .disposed(by: disposeBag)
    }

    public init(collection: T?, spacerSize: CGFloat = 0, distribution: UIStackView.Distribution = .fill,
                @ForEachBuilder content: @escaping (T.Element) -> [UIView]) {
        self.content = content
        self.spacerSize = spacerSize
        self.defaultDistribution = distribution
        super.init(frame: .zero)
        self.distribution = distribution
        self.collection = collection
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        var axis: NSLayoutConstraint.Axis?
        if let stackAxis = (newSuperview as? UIStackView)?.axis {
            axis = stackAxis
        } else if let listAxis = (newSuperview as? ListView)?.axis {
            axis = listAxis
        }
        guard let unwrappedAxis = axis else { return }
        alignment = .fill
        distribution = defaultDistribution
        self.axis = unwrappedAxis
        setupCollection(collection)
    }

    private func setupCollection(_ collection: T?) {
        guard let collection = collection else { return }
        removeSubviews()
        var arrangedContent: [UIStackView]?
        if axis == .vertical {
            arrangedContent = collection.enumerated().map { index, element in
                let stack = VStack(arrangedSubviews: content(element))
                if (index + 1) != collection.count {
                    stack.addArrangedSubview(Spacer(height: spacerSize))
                }
                return stack
            }
        } else if axis == .horizontal {
            arrangedContent = collection.enumerated().map { index, element in
                let stack = HStack(arrangedSubviews: content(element))
                if (index + 1) != collection.count {
                    stack.addArrangedSubview(Spacer(width: spacerSize))
                }
                return stack
            }
        }
        arrangedContent?.forEach { addArrangedSubview($0) }
    }
}
