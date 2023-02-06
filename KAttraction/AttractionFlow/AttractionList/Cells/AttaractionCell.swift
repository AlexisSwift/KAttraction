import RxSwift

final class AttaractionCell: BaseTableViewCell {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Handler
    var onDetails: StringHandler?
    
    // MARK: - Config
    private var config: AttractionConfig?
    
    func set(model: AttractionConfig) {
        config = model
        setupUI()
    }
}

// MARK: - UI
private extension AttaractionCell {
    private func setupUI() {
        guard let source = config else { return }
        body(config: source).embedIn(contentView)
        
        descriptionView(config: source)
            .userInteractionEnabled(false)
            .embedInWithInsets(contentView, left: 0, top: 100, right: 0, bottom: 0)
            .setShadow(radius: 10, color: .black, offsetX: 0, offsetY: -6)
        
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
            FlexibleSpacer()
            Label(text: config.attractionName)
                .setFont(.systemFont(ofSize: 18, weight: .bold))
                .setTextColor(.white)
            Spacer(height: 8)
            
            Label(text: config.attractionDescription)
                .multilined
                .setFont(.systemFont(ofSize: 16, weight: .medium))
                .setTextColor(.white)
        }
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
