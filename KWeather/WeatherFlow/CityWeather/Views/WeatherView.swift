import UIKit

final class WeatherView: UIView {
    init(config: WeatherConfig) {
        super.init(frame: .zero)
        body(config: config).embedIn(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func body(config: WeatherConfig) -> UIView {
        VStack {
            UIImageView(image: config.weatherStatus.weatherIcon)
            Label(text: config.time)
                .setFont(.systemFont(ofSize: 16, weight: .regular))
                .setTextAlignment(.center)
                .setTextColor(.white)
            Label(text: config.weatherStatus.description)
                .setFont(.systemFont(ofSize: 13, weight: .medium))
                .setTextAlignment(.center)
                .setTextColor(.white)
            Spacer(height: 4)
        }
        .cornerRadius(8)
        .size(.init(width: 80, height: 120))
        .background(Palette.backgroundViewColorPrimary)
    }
    
}
// MARK: - Config
extension WeatherView {
    struct WeatherConfig {
        let weatherStatus: WeatherType
        let time: String
    }
}
