import UIKit
import SnapKit

final class LoadingView: UIView {
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemGray3
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
private extension LoadingView {
    private func setupView() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let label = UILabel()
        addSubview(label)
        label.text = "Загрузка..."
        label.textColor = .black
        
        label.snp.makeConstraints { make in
            make.bottom.equalTo(activityIndicator.snp.top).inset(-8)
            make.centerX.equalToSuperview()
        }
    }
    
    func hideLoading() {
        UIView.animate(withDuration: 0.5) {
            self.removeFromSuperview()
        }
    }
}
