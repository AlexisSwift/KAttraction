import UIKit

/// Extending the UIView class to allow loading UIView from *. xib
public extension UIView {
    /// Method for loading a view from a nib file.
    ///
    /// - returns: loaded view with hung properties
    class func loadFromNib() -> Self {
        return instantiateFromNibHelper()
    }

    private class func instantiateFromNibHelper<T>() -> T {
        let selfType = self
        let bundle: Bundle = Bundle(for: self)
        let nibName: String = String(describing: selfType)

        return view(bundle, nibName: nibName)
    }

    private class func view<T>(_ bundle: Bundle, nibName: String) -> T {
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)
        let nibContents = nib.instantiate(withOwner: self, options: nil)

        for obj in nibContents {
            if let view = obj as? T {
                return view
            }
        }

        fatalError("Error loading nib with name \(nibName)")
    }

    /// Helper method to init and setup the view from the Nib.
    func xibSetup() {
        let view = loadFromNib()
        addSubview(view)
        stretch(view: view)
    }

    /// Method to init the view from a Nib.
    ///
    /// - Returns: Optional UIView initialized from the Nib of the same class name.
    func loadFromNib<T: UIView>() -> T {
        let selfType = type(of: self)
        let bundle: Bundle = Bundle(for: selfType)
        let nibName: String = String(describing: selfType)
        let nib: UINib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            fatalError("Error loading nib with name \(nibName)")
        }

        return view
    }

    /// Stretches the input view to the UIView frame using Auto-layout
    ///
    /// - Parameter view: The view to stretch.
    func stretch(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
