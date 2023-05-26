import Foundation
import os.log

struct LoggerService {

    private static let serviceLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Info")
    private static let networkLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Network")
    private static let errorLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Error")
    private static let debugLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Debug")
    private static let consoleLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Console")

    static func debug<T: CustomStringConvertible>(_ message: T) {
        log(message.description, type: .debug, log: debugLog)
    }

    static func network<T: CustomStringConvertible>(_ message: T) {
        log(message.description, type: .debug, log: networkLog)
    }

    static func info<T: CustomStringConvertible>(_ message: T) {
        log(message.description, type: .info, log: serviceLog)
    }

    static func error<T: CustomStringConvertible>(_ message: T) {
        log(message.description, type: .error, log: errorLog)
    }

    static func console<T: CustomStringConvertible>(_ message: T) {
        log(message.description, type: .default, log: consoleLog)
    }

    private static func log(_ message: String, type: OSLogType, log: OSLog) {
        os_log("%{public}@", log: log, type: type, message)
    }

}
