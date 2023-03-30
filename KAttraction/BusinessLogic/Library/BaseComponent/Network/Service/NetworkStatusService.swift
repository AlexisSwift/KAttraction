import Network

final class NetworkStatusService {
    
    static let shared = NetworkStatusService()
    
    var unsatisfied: VoidHandler?
    var satisfied: VoidHandler?
    
    lazy var monitor: NWPathMonitor = {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .unsatisfied {
                DispatchQueue.main.async {
                    self?.unsatisfied?()
                }
            } else {
                DispatchQueue.main.async {
                    self?.satisfied?()
                }
            }
        }
        return monitor
    }()
}

extension NetworkStatusService {
    func startMonitor() {
        monitor.start(queue: DispatchQueue(label: "queueForMonitor"))
    }
}
