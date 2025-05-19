import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()
    let reviewsSpinner = UIActivityIndicatorView(style: .large)

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }

}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
        setupSpinner()
    }

    func setupTableView() {
        addSubview(tableView)

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
        tableView.register(ReviewsCountCell.self, forCellReuseIdentifier: ReviewsCountCellConfig.reuseId)
    }

    func setupSpinner() {
        reviewsSpinner.startAnimating()

        addSubview(reviewsSpinner)
        reviewsSpinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            reviewsSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            reviewsSpinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
