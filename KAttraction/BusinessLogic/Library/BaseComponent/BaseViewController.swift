import RxSwift

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    // MARK: - Views
    private lazy var loadingView = LoadingView()
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
