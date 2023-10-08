import RxSwift
import SnapKit
import UIKit

final class CoordinatesView: UIView {
    
    private let disposeBag = DisposeBag()
    
    init(config: CoordinatesConfig) {
        super.init(frame: .zero)
        setup(config: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension CoordinatesView {
    private func setup(config: CoordinatesConfig) {
        backgroundColor = .secondarySystemFill
        border(color: .gray)
        cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = config.cityName
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        let latitudeLabel = UILabel()
        latitudeLabel.text = "\(L10n.latitude()) \(config.latitude)"
        latitudeLabel.font = .systemFont(ofSize: 18, weight: .regular)
        latitudeLabel.textColor = .white
        addSubview(latitudeLabel)
        latitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(50)
            make.left.right.equalToSuperview().inset(24)
        }
        
        let longitudeLabel = UILabel()
        longitudeLabel.text = "\(L10n.longitude()) \(config.longitude)"
        longitudeLabel.font = .systemFont(ofSize: 18, weight: .regular)
        longitudeLabel.textColor = .white
        addSubview(longitudeLabel)
        longitudeLabel.snp.makeConstraints { make in
            make.top.equalTo(latitudeLabel).inset(24)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
                
        let closeButton = UIButton()
        closeButton.setImage(UIImage(
            systemName: "xmark.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large))
        )
        closeButton.tintColor = .white
        addSubview(closeButton)
        closeButton.touchUpInside(store: disposeBag) {
            self.removeSubviews()
        }
        closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Config
extension CoordinatesView {
    struct CoordinatesConfig {
        let cityName: String
        let longitude: Double
        let latitude: Double
    }
}
