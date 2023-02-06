import RxSwift

final class CityCell: BaseTableViewCell {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Handler
    var attractionHandler: CityHandler?
    
    // MARK: - Config
    private var config: City?
    
    func set(model: City, handler: CityHandler?) {
        config = model
        attractionHandler = handler
        setupUI()
    }
}

// MARK: - UI
private extension CityCell {
    private func setupUI() {
        guard let source = config else { return }
        body(config: source).embedIn(contentView)
    }
    
    private func body(config: City) -> UIView {
        VStack(spacing: 12) {
            FlexibleGroupedSpacer(groupId: 1)
            Label(text: config.name)
                .setTextColor(.white)
                .setFont(.systemFont(ofSize: 32, weight: .heavy))
            FlexibleGroupedSpacer(groupId: 1)
        }
        .linkSpacers()
        .background(Palette.backgroundPrimary)
        .layoutMargins(hInset: 24)
        .onTap(store: disposeBag) { [weak self] in
            self?.attractionHandler?(config)
        }
    }
}
