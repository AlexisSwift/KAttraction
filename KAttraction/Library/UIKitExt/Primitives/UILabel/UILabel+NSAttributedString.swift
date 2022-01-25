import UIKit

public extension UILabel {
    private func addSymbol(_ symbol: String,
                           withText text: String,
                           symbolColor: UIColor,
                           textAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let symbolAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: symbolColor]

        let muttableAttributed = NSMutableAttributedString()
        let formattedString = "\(symbol) \(text)"
        let attributedString = NSMutableAttributedString(string: formattedString)
        attributedString.addAttributes(
            textAttributes,
            range: NSRange(location: 0, length: attributedString.length)
        )

        let string: NSString = NSString(string: formattedString)
        let symbolRange: NSRange = string.range(of: symbol)
        attributedString.addAttributes(symbolAttributes, range: symbolRange)
        muttableAttributed.append(attributedString)

        return muttableAttributed
    }
}
