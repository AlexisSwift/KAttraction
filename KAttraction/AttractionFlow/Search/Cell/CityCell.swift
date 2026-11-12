import SnapKit

final class CityCell: BaseTableViewCell {
    var attractionHandler: CityHandler?

    private let titleLabel = UILabel()
    private var city: City?

    override func setup() {
        super.setup()
        contentView.backgroundColor = R.color.backgroundPrimary()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 32, weight: .heavy)
        titleLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(12)
        }

        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCell)))
    }

    func set(model: City, handler: CityHandler?) {
        city = model
        attractionHandler = handler
        titleLabel.text = model.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        city = nil
        attractionHandler = nil
        titleLabel.text = nil
    }

    @objc private func didTapCell() {
        guard let city = city else { return }
        attractionHandler?(city)
    }
}
