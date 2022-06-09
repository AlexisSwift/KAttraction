import UIKit
import Network

class BaseViewController: UIViewController {
    
    let monitor = NWPathMonitor()
    
    private let queueForMonitor = DispatchQueue(label: "queueForMonitor")
    private var loadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorConfig()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        monitor.cancel()
    }
    
    private func monitorConfig() {
        monitor.start(queue: queueForMonitor)
        if self is BaseNoEthernetViewController { } else {
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                if path.status == .satisfied {
                    print("We're connected!")
                } else {
                    print("We're not connected!")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let vc = BaseNoEthernetViewController()
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func showAlert(message: String, buttonTitle: String? = nil, completion: (()->())? = nil) {
        let vc = AlertViewController()
        vc.message = message
        vc.buttonTitle = buttonTitle
        vc.completion = completion
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            guard let self = self else { return }
            self.present(vc, animated: false, completion: nil)
        })
    }
    
    func startLoading() {
        loadingView.embedInWithInsets(view)
    }
    
    func endLoading() {
        loadingView.hideLoading()
    }

}
