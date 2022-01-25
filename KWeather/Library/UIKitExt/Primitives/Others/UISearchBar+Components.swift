import UIKit

public extension UISearchBar {
    private enum SubviewKey: String {
        case searchField,
             clearButton,
             cancelButton,
             placeholderLabel
    }

    var searchField: UITextField? {
        return self.value(forKey: SubviewKey.searchField.rawValue) as? UITextField
    }

    var clearButton: UIButton? {
        return searchField?.value(forKey: SubviewKey.clearButton.rawValue) as? UIButton
    }

    var placeholderLabel: UILabel? {
        return searchField?.value(forKey: SubviewKey.placeholderLabel.rawValue) as? UILabel
    }

    // Cancel button to change the appearance.
    var cancelButton: UIButton? {
        guard showsCancelButton else { return nil }
        return self.value(forKey: SubviewKey.cancelButton.rawValue) as? UIButton
    }
}
