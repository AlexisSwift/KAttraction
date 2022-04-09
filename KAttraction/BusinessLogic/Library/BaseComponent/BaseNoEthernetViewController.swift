import UIKit
import RxSwift

final class BaseNoEthernetViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startMonitor()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray4
        body().embedIn(self.view)
    }
    
    private func body() -> UIView {
        VStack {
            FlexibleGroupedSpacer(groupId: 1)
            UIImageView(image: Asset.GlobalIcon.SystemStatus.noEthernet)
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
                .onTap(store: disposeBag) {
                    guard self.monitor.currentPath.status == .satisfied else {
                        self.showAlert(message: "Соединение не установлено!")
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            FlexibleGroupedSpacer(groupId: 1)
        }
        .linkSpacers()
        .layoutMargins(hInset: 16)
    }
    
    private func startMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if path.status == .satisfied {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
