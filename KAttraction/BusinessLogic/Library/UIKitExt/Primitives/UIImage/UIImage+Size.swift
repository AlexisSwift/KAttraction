import UIKit

public extension UIImage {
    func compressAndConvertToData(expectedSizeInMb: Int) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        while needCompress && compressingValue > 0.0 {
            if let data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        return imgData
    }

    func resize(_ size: CGSize, opaque: Bool = false, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var newImage: UIImage

        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = opaque
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(
                width: size.width,
                height: size.height
            ),
            format: renderFormat
        )
        newImage = renderer.image { _ in
            self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        return newImage
    }
}
