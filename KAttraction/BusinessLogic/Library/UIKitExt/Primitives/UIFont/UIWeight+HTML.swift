import UIKit

extension UIFont.Weight {
    static func weight(fromHTML weight: CGFloat) -> UIFont.Weight {
        switch weight {
        case 100:
            return .ultraLight
        case 200:
            return .thin
        case 300:
            return .light
        case 500:
            return .medium
        case 600:
            return .semibold
        case 700:
            return .bold
        case 800:
            return .heavy
        case 900:
            return .black
        default:
            return .regular
        }
    }

    static func weight(fromHTMLName name: String) -> UIFont.Weight {
        switch name {
        case "ultraLight":
            return .ultraLight
        case "thin":
            return .thin
        case "light":
            return .light
        case "medium":
            return .medium
        case "semibold":
            return .semibold
        case "bold":
            return .bold
        case "heavy":
            return .heavy
        case "black":
            return .black
        default:
            return .regular
        }
    }
}
