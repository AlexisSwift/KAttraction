class ViewModel {
    deinit {
        LoggerService.debug("deinit \(String(describing: self))")
    }
}
