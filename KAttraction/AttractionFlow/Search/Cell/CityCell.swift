import RxSwift

final class CityCell: BaseTableViewCell {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Handler
    var attractionHandler: CityHandler?
    
    func set(model: City, handler: CityHandler?) {
        attractionHandler = handler
        setupUI(model: model)
    }
}

// MARK: - UI
private extension CityCell {
    private func setupUI(model: City) {
        body(config: model).embedIn(contentView)
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
        .background(Color.backgroundPrimary())
        .layoutMargins(hInset: 24)
        .onTap(store: disposeBag) { [weak self] in
            self?.attractionHandler?(config)
        }
    }
}
