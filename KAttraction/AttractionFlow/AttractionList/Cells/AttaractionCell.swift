import Kingfisher
import SnapKit
import UIKit

final class AttaractionCell: BaseTableViewCell {
    var onDetails: StringHandler?

    private let attractionImageView = UIImageView()
    private let descriptionContainer = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var attractionName = ""

    override func setup() {
        super.setup()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 16

        attractionImageView.contentMode = .scaleAspectFill
        descriptionContainer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(attractionImageView)
        contentView.addSubview(descriptionContainer)
        descriptionContainer.addSubview(titleLabel)
        descriptionContainer.addSubview(descriptionLabel)

        attractionImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(219)
        }
        descriptionContainer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(100)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        contentView.addGestureRecognizer(tap)
    }

    func set(model: AttractionConfig) {
        attractionName = model.attractionName
        titleLabel.text = model.attractionName
        descriptionLabel.text = model.attractionDescription
        attractionImageView.kf.cancelDownloadTask()
        attractionImageView.image = nil
        attractionImageView.setImage(withUrl: model.attractionImage.first ?? "")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        attractionName = ""
        onDetails = nil
        attractionImageView.kf.cancelDownloadTask()
        attractionImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    @objc private func didTapCell() {
        guard !attractionName.isEmpty else { return }
        onDetails?(attractionName)
    }
}

extension AttaractionCell {
    struct AttractionConfig {
        let attractionImage: [String]
        let attractionName: String
        let attractionDescription: String
    }
}
