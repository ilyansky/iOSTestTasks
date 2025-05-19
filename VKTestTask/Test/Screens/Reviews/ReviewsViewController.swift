import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getReviews()
        setupRefreshControl()
    }

}

// MARK: - Action

private extension ReviewsViewController {

    @objc func refresh(sender: UIRefreshControl) {
        viewModel.getReviews()
        sender.endRefreshing()
    }
    
}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        return reviewsView
    }

    func setupViewModel() {
        viewModel.onStateChange = { [weak reviewsView] _ in
            reviewsView?.tableView.reloadData()
            if let spinnedIsActive = reviewsView?.reviewsSpinner.isAnimating {
                if spinnedIsActive {
                    reviewsView?.reviewsSpinner.stopAnimating()
                }
            }
        }
    }

    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        reviewsView.tableView.refreshControl = refreshControl
    }

}
