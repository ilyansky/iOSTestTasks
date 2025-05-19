import UIKit

/// Класс, описывающий бизнес-логику экрана отзывов.
final class ReviewsViewModel: NSObject {

    /// Замыкание, вызываемое при изменении `state`.
    var onStateChange: ((State) -> Void)?

    private var state: State
    private let reviewsProvider: ReviewsProvider
    private let ratingRenderer: RatingRenderer
    private let decoder: JSONDecoder

    init(
        state: State = State(),
        reviewsProvider: ReviewsProvider = ReviewsProvider(),
        ratingRenderer: RatingRenderer = RatingRenderer(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.state = state
        self.reviewsProvider = reviewsProvider
        self.ratingRenderer = ratingRenderer
        self.decoder = decoder
    }

}

// MARK: - Internal

extension ReviewsViewModel {

    typealias State = ReviewsViewModelState

    /// Метод получения отзывов.
    func getReviews() {
        guard state.shouldLoad else { return }
        state.shouldLoad = false

        DispatchQueue.global().async {
            self.reviewsProvider.getReviews { result in
                DispatchQueue.main.async {
                    self.gotReviews(result)
                }
            }
        }
    }

}

// MARK: - Private

private extension ReviewsViewModel {

    /// Метод обработки получения отзывов.
    func gotReviews(_ result: ReviewsProvider.GetReviewsResult) {
        do {
            let data = try result.get()

            let allReviews = try decoder.decode(Reviews.self, from: data)
            state.reviewsCount = allReviews.count

            // Имитация запросов пачками
            let pagedReviews = Array(allReviews.items[state.offset..<min(state.offset + state.limit, state.reviewsCount)])

            state.items += pagedReviews.map(makeReviewItem)
            state.offset += pagedReviews.count
            state.shouldLoad = state.offset < state.reviewsCount

            updateReviewsCountItem()
        } catch {
            state.shouldLoad = true
        }
        onStateChange?(state)
    }

    /// Метод, обновляющий последнюю ячейку с количеством отзывов
    func updateReviewsCountItem() {
        if state.items.count == state.reviewsCount {
            let reviewsCountItem = makeReviewsCountItem()
            state.items.append(reviewsCountItem)
        }
    }

    /// Метод, вызываемый при нажатии на кнопку "Показать полностью...".
    /// Снимает ограничение на количество строк текста отзыва (раскрывает текст).
    func showMoreReview(with id: UUID) {
        guard
            let index = state.items.firstIndex(where: { ($0 as? ReviewItem)?.id == id }),
            var item = state.items[index] as? ReviewItem
        else { return }
        item.maxLines = .zero
        state.items[index] = item
        onStateChange?(state)
    }

}

// MARK: - Items

private extension ReviewsViewModel {

    typealias ReviewItem = ReviewCellConfig
    typealias ReviewsCountItem = ReviewsCountCellConfig

    func makeReviewItem(_ review: Review) -> ReviewItem {
        let userName = "\(review.first_name) \(review.last_name)".attributed(font: .username)
        let rating = review.rating
        let image = ratingRenderer.ratingImage(rating)
        let reviewText = review.text.attributed(font: .text)
        let created = review.created.attributed(font: .created, color: .created)
        let item = ReviewItem(
            userName: userName,
            ratingImage: image,
            reviewText: reviewText,
            created: created,
            onTapShowMore: showMoreReview
        )
        return item
    }

    func makeReviewsCountItem() -> ReviewsCountItem {
        let reviewsCount = state.reviewsCount
        let reviewsCountString = handleReviewsCountNumber(reviewsCount)
        let reviewsCountText = reviewsCountString.attributed(font: .reviewCount, color: .reviewCount)
        let item = ReviewsCountItem(reviewsCount: reviewsCountText)
        return item
    }

    func handleReviewsCountNumber(_ number: Int) -> String {
        func countDigits() -> Int {
            var count = 0
            var num = number

            if number == 0 { return 1 }

            while num > 0 {
                num /= 10
                count += 1
            }

            return count
        }

        func handleLastDigit(_ digit: Int) -> String {
            if [0, 5, 6, 7, 8, 9].contains(digit) {
                return rpm
            } else if [2, 3, 4].contains(digit)  {
                return rpe
            } else {
                return ip
            }
        }

        var result = ""
        let digits = countDigits()

        /// Именительный падеж
        var ip: String {
            "\(number) отзыв"
        }

        /// Родительный падеж - единственное число
        var rpe: String {
            "\(number) отзыва"
        }

        /// Родительный падеж - множественное число
        var rpm: String {
            "\(number) отзывов"
        }

        switch digits {
        case 1:
            result = handleLastDigit(number)
        default:
            let lastDigit = number % 10
            let secondLastDigit = (number / 10) % 10

            if secondLastDigit == 1 {
                result = rpm
            } else {
                result = handleLastDigit(lastDigit)
            }
        }

        return result
    }

}

// MARK: - UITableViewDataSource

extension ReviewsViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let config = state.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: config.reuseId, for: indexPath)
        config.update(cell: cell)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension ReviewsViewModel: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        state.items[indexPath.row].height(with: tableView.bounds.size)
    }

    /// Метод дозапрашивает отзывы, если до конца списка отзывов осталось два с половиной экрана по высоте.
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if shouldLoadNextPage(scrollView: scrollView, targetOffsetY: targetContentOffset.pointee.y) {
            getReviews()
        }
    }

    private func shouldLoadNextPage(
        scrollView: UIScrollView,
        targetOffsetY: CGFloat,
        screensToLoadNextPage: Double = 2.5
    ) -> Bool {
        let viewHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let triggerDistance = viewHeight * screensToLoadNextPage
        let remainingDistance = contentHeight - viewHeight - targetOffsetY
        return remainingDistance <= triggerDistance
    }

}
