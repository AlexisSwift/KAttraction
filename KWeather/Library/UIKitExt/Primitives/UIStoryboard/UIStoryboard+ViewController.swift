import UIKit

/**
 Протокол для объектов, имеющих идентификатор в сториборде.
 */
public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

/**
 Расширение UIViewController,
 которое дает совместимость с протоколом StoryboardIdentifiable.
 */
extension UIViewController: StoryboardIdentifiable {}

/**
 Расширение протокола StoryboardIdentifiable для UIViewController,
 создающее идентифиактор в сториборде равный названию класса контроллера.
 */
public extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

public extension UIStoryboard {
    static func makeController<T: UIViewController>(_: T.Type) -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: T.storyboardIdentifier, bundle: nil)
        return storyboard.instantiateViewController(T.self)
    }

    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }

        return viewController
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }

        return viewController
    }
}
