import RxSwift

final class CityCell: BaseTableViewCell {
    private let disposeBag = DisposeBag()
    var attractionHandler: CityHandler?

    func set(model: City, handler: CityHandler?) {
        attractionHandler = handler
        setupUI(model: model)
    }
}

private extension CityCell {
    func setupUI(model: City) {
        body(config: model).embedIn(contentView)
    }

    func body(config: City) -> UIView {
        VStack(spacing: 12) {
            FlexibleGroupedSpacer(groupId: 1)
            Label(text: config.name)
                .setTextColor(.white)
                .setFont(.systemFont(ofSize: 32, weight: .heavy))
            FlexibleGroupedSpacer(groupId: 1)
        }
        .linkSpacers()
        .background(R.color.backgroundPrimary())
        .layoutMargins(hInset: 24)
        .onTap(store: disposeBag) { [weak self] in
            self?.attractionHandler?(config)
        }
    }
}
