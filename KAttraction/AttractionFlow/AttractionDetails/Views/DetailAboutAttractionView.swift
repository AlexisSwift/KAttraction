import RxSwift

final class AttractionDetailsView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var textLabel = Label()
    private lazy var reedMoreButton = Button()
    
    init(config: Config) {
        super.init(frame: .zero)
        body(config: config).embedIn(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension AttractionDetailsView {
    private func body(config: Config) -> UIView {
        VStack (alignment: .leading) {
            textLabel
                .setText(config.description)
                .setFont(.systemFont(ofSize: 16, weight: .regular))
                .setTextColor(.white)
                .multilined
            reedMoreButton
                .setTitleColor(.link)
                .setFont(.systemFont(ofSize: 16))
                .setTitle(Localization.AttractionFlow.AboutAttraction.reedMore)
                .touchUpInside(store: disposeBag) { [weak self] in
                    self?.reedMoreButton.isHidden = true
                    self?.textLabel
                        .setText(config.descriptionFull)
                }
        }
    }
}

// MARK: - Config
extension AttractionDetailsView {
    struct Config {
        let description: String
        let descriptionFull: String
    }
}
