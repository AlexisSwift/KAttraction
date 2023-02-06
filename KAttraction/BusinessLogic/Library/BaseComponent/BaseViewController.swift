import Network
import RxSwift

class BaseViewController: UIViewController {
    
    private let queueForMonitor = DispatchQueue(label: "queueForMonitor")
    
    let monitor = NWPathMonitor()
    let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorConfig()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        monitor.cancel()
    }
}

// MARK: - Network Monitor
private extension BaseViewController {
    private func monitorConfig() {
        monitor.start(queue: queueForMonitor)
        if self is DisableNetworkViewController { } else {
            monitor.pathUpdateHandler = { [weak self] path in
                if path.status == .unsatisfied {
                    DispatchQueue.main.async {
                        let vc = DisableNetworkViewController()
                        vc.modalPresentationStyle = .overFullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

// MARK: - Alert
extension BaseViewController {
    func showAlert(
        message: String,
        buttonTitle: String? = nil,
        completion: VoidHandler? = nil
    ) {
        let alert = AlertViewController(message: message, cancelButtonTitle: buttonTitle, completion: completion)
        alert.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.present(alert, animated: false, completion: nil)
        })
    }
}

// MARK: - Loading
extension BaseViewController {
    func startLoading() {
        loadingView.embedInWithInsets(view)
    }
    
    func endLoading() {
        loadingView.hideLoading()
    }

}
