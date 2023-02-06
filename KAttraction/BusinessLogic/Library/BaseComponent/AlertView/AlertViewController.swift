import UIKit
import RxSwift

final class AlertViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Handlers
    private var completion: VoidHandler?
    
    // MARK: - Initializers
    init(message: String = String(), cancelButtonTitle: String? = nil, completion: VoidHandler? = nil) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        setupView(message: message, cancelButtonTitle: cancelButtonTitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.alpha = 1
        }
    }
}

// MARK: - UI
private extension AlertViewController {
    private func setupView(message: String, cancelButtonTitle: String?) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        
        let mainView = UIView()
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 15
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        messageLabel.textColor = .gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.top).inset(28)
            make.centerX.equalToSuperview()
            make.trailing.leading.equalTo(mainView).inset(16)
        }
        
        let closeButton = UIButton()
        closeButton.setTitle(cancelButtonTitle ?? "Ок")
        closeButton.setFont(UIFont.systemFont(ofSize: 16, weight: .bold))
        closeButton.setTitleColor(.black)
        closeButton.touchUpInside(store: disposeBag) { [weak self] in
            self?.action()
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).inset(-24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mainView).inset(24)
        }
    }
}

// MARK: - Actions
private extension AlertViewController {
    private func action() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.alpha = 0
        } completion: { [weak self] _ in
            self?.dismiss(animated: false, completion: nil)
            self?.completion?()
        }
    }
}
