import RxSwift

final class AttaractionCell: BaseTableViewCell {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Handler
    var onDetails: StringHandler?
    
    func set(model: AttractionConfig) {
        setupUI(model: model)
    }
}

// MARK: - UI
private extension AttaractionCell {
    private func setupUI(model: AttractionConfig) {
        body(config: model).embedIn(contentView)
        
        descriptionView(config: model)
            .userInteractionEnabled(false)
            .embedInWithInsets(contentView, left: .zero, top: 100, right: .zero, bottom: .zero)
            .setShadow(radius: 10, color: .black, offsetX: .zero, offsetY: -6)
        
        cornerRadius(16)
    }
    
    private func body(config: AttractionConfig) -> UIView {
        VStack {
            UIImageView()
                .contentMode(.scaleAspectFill)
                .setImage(withUrl: config.attractionImage.randomElement() ?? "")
        }
        .height(219)
        .onTap(store: disposeBag) { [weak self] in
            self?.onDetails?(config.attractionName)
        }
    }
    
    private func descriptionView(config: AttractionConfig) -> UIView {
        VStack {
            FlexibleGroupedSpacer(groupId: 1)
            Label(text: config.attractionName)
                .setFont(.systemFont(ofSize: 18, weight: .bold))
                .setTextColor(.white)
            Spacer(height: 8)
            Label(text: config.attractionDescription)
                .multilined
                .setFont(.systemFont(ofSize: 16, weight: .medium))
                .setTextColor(.white)
            FlexibleGroupedSpacer(groupId: 2)
        }
        .linkSpacers()
        .background(UIColor(red: 0, green: 0, blue: 0, alpha: 0.8))
        .layoutMargins(vInset: 16, hInset: 8)
    }
}

// MARK: - Config
extension AttaractionCell {
    struct AttractionConfig {
        let attractionImage: [String]
        let attractionName: String
        let attractionDescription: String
    }
}
