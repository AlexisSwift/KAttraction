import RxSwift
import SnapKit

final class CheckWeatherView: UIView {
    
    private let disposeBag = DisposeBag()
    
    init(config: WeatherConfig) {
        super.init(frame: .zero)
        setup(config: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension CheckWeatherView {
    private func setup(config: WeatherConfig) {
        backgroundColor = .secondarySystemFill
        border(color: .gray)
        cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = config.city.name
        titleLabel.font = .systemFont(ofSize: 20, weight: .heavy)
        titleLabel.textColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        let checkWeatherLabel = UILabel()
        checkWeatherLabel.text = Localization.AttractionFlow.Attraction.checkWeatherTap
        checkWeatherLabel.textAlignment = .center
        checkWeatherLabel.textColor = .white
        checkWeatherLabel.numberOfLines = 0
        addSubview(checkWeatherLabel)
        checkWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).inset(50)
            make.left.right.equalToSuperview().inset(6)
            make.bottom.equalToSuperview().inset(24)
        }
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill",
                                     withConfiguration: UIImage.SymbolConfiguration(pointSize: 18,
                                                                                    weight: .bold,
                                                                                    scale: .large)))
        closeButton.tintColor = .white
        addSubview(closeButton)
        closeButton.touchUpInside(store: disposeBag) { [weak self] in
            self?.removeSubviews()
        }
        closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Config
extension CheckWeatherView {
    struct WeatherConfig {
        let city: City
    }
}
