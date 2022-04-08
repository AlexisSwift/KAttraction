import UIKit
import RxSwift

class AlertViewController: UIViewController {
    
    // MARK: - Constants
    
    var message = ""
    var buttonTitle: String?
    var completion: (()->())?
    private let disposeBag = DisposeBag()
    
    private let mainView = UIView()
    private let messageLabel = UILabel()
    private let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 1
        }
    }
    
    private func setupView() {
        body()
    }
    
    private func body() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 15
        mainView.height(120)
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(24)
        }
        
        messageLabel.text = message
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.top).inset(28)
            make.centerX.equalToSuperview()
        }
        
        let closeButton = UIButton()
        closeButton.setTitle("Закрыть")
        closeButton.setTitleColor(.red)
        closeButton.onTap(store: disposeBag) {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.view.alpha = 0
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: nil)
            }
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).inset(-16)
            make.centerX.equalToSuperview()
        }
    }
}
