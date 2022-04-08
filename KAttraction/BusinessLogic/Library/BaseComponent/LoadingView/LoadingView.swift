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
    
    private func setupView() {
        body()
    }
    
    private func body() {
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
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.removeFromSuperview()
        }
    }
}
