import UIKit
import Network

final class DisableNetworkViewController: BaseViewController {
    
    private let monitor: NWPathMonitor
    
    init(monitor: NWPathMonitor) {
        self.monitor = monitor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - UI
private extension DisableNetworkViewController {
    private func setupView() {
        view.backgroundColor = .systemGray4
        body().embedInWithSafeArea(view)
    }
    
    private func body() -> UIView {
        VStack {
            FlexibleGroupedSpacer(groupId: 1)
            UIImageView(image: Image.noEthernet())
                .contentMode(.scaleAspectFit)
            Spacer(height: 16)
            Label(text: "Нет подключения\nк интернету")
                .multilined
                .setFont(.systemFont(ofSize: 28, weight: .bold))
                .setTextAlignment(.center)
                .setTextColor(.black)
            Spacer(height: 16)
            Label(text: "Ваше интернет-соединение в настоящее время недоступно, пожалуйста, проверьте или повторите попытку.")
                .multilined
                .setTextAlignment(.center)
                .setFont(.systemFont(ofSize: 16, weight: .regular))
                .setTextColor(.black)
            Spacer(height: 16)
            Button(title: "Попробовать ещё раз")
                .onTap(store: disposeBag) { [weak self] in
                    guard let self = self, self.monitor.currentPath.status == .satisfied else {
                        self?.showAlert(message: "Соединение не установлено!")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            FlexibleGroupedSpacer(groupId: 1)
        }
        .linkSpacers()
        .layoutMargins(hInset: 16)
    }
}
