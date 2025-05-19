import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewsCountCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewsCountCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Количество отзывов.
    let reviewsCount: NSAttributedString

    fileprivate let layout = Layout.shared

}

extension ReviewsCountCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewsCountCell else { return }
        cell.reviewsCountLabel.attributedText = reviewsCount
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Cell

final class ReviewsCountCell: UITableViewCell {

    fileprivate var config: Config?

    let reviewsCountLabel = UILabel()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        reviewsCountLabel.frame = layout.reviewsCountLabelFrame
    }

}

// MARK: - Private

private extension ReviewsCountCell {

    func setupCell() {
        contentView.addSubview(reviewsCountLabel)
    }
    
}

// MARK: - Layout

/// Класс, в котором происходит расчёт фрейма для сабвью ячейки количества отзывов.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewsCountCellLayout {
    private init() {}

    static let shared = ReviewsCountCellLayout()

    // MARK: - Фрейм

    private(set) var reviewsCountLabelFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    // MARK: - Расчёт фреймов и высоты ячейки

    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right
        let labelSize = config.reviewsCount.boundingRect(width: width).size
        let height = labelSize.height

        let centerX = (maxWidth - labelSize.width) / 2
        let centerY = (height - labelSize.height) / 2

        reviewsCountLabelFrame = CGRect(
            origin: CGPoint(x: centerX, y: centerY),
            size: labelSize
        )

        return height
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewsCountCellConfig
fileprivate typealias Layout = ReviewsCountCellLayout
