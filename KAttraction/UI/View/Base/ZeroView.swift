import Foundation
import UIKit

public final class ZeroView: BaseView {
    override public func setup() {
        super.setup()
        huggingPriority(.defaultHigh, axis: .vertical)
        huggingPriority(.defaultHigh, axis: .horizontal)
        if let stackAxis = (superview as? UIStackView)?.axis {
            switch stackAxis {
            case .horizontal:
                self.snp.makeConstraints {
                    $0.width.equalTo(0).priority(.high)
                }
            case .vertical:
                self.snp.makeConstraints {
                    $0.height.equalTo(0).priority(.high)
                }
            @unknown default:
                break
            }
        }
    }
}
