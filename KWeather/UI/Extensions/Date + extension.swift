import Foundation

extension Date {
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
}
