import UIKit

class ReviewPhotosCell: UICollectionViewCell {

    static let reuseId = String(describing: ReviewPhotosCell.self)

    let imgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 8.0
        imgView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imgView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
