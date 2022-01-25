import UIKit

public extension UITextField {
    private var isEmpty: Bool {
        guard let attributedText = attributedText else {
            return true
        }
        return attributedText.string.isEmpty
    }

    func currentAttributtedFont() -> UIFont? {
        guard !isEmpty else { return nil }
        return attributedText?.attributes(at: 0, effectiveRange: nil).first {
            $0.key == NSAttributedString.Key.font
            }?.value as? UIFont
    }

    func currentAttributtedTextColor() -> UIColor? {
        guard !isEmpty else { return nil }
        return attributedText?.attributes(at: 0, effectiveRange: nil).first {
            $0.key == NSAttributedString.Key.foregroundColor
            }?.value as? UIColor
    }

    func obtainLetterSpacing(_ letterSpacing: CGFloat?) -> CGFloat? {
        guard letterSpacing == nil else { return letterSpacing }
        guard !isEmpty else { return nil }
        return attributedText?.attributes(at: 0, effectiveRange: nil).first {
            $0.key == NSAttributedString.Key.kern
            }?.value as? CGFloat
    }

    func obtainLineHeight(_ lineHeight: CGFloat?, font: UIFont) -> CGFloat? {
        guard !isEmpty else { return nil }
        guard let lineHeight = lineHeight else {
            return attributedText?.attributes(at: 0, effectiveRange: nil).first {
                $0.key == NSAttributedString.Key.paragraphStyle
                }?.value as? CGFloat
        }
        return CGFloat(lineHeight) - font.lineHeight
    }
}
