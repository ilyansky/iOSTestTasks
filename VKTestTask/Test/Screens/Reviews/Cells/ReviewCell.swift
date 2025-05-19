import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Имя пользователя.
    let userName: NSAttributedString
    /// Картинка рейтинга.
    let ratingImage: UIImage
    /// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void

    /// Объект, хранящий посчитанные фреймы для ячейки отзыва.
    fileprivate let layout = Layout.shared

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
        cell.userNameTextLabel.attributedText = userName
        cell.ratingImage.image = ratingImage
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

    fileprivate var config: Config?

    fileprivate let avatarImage = UIImageView(image: UIImage(named: "defaultAvatar"))
    fileprivate let userNameTextLabel = UILabel()
    fileprivate let ratingImage = UIImageView()
    fileprivate let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.backgroundColor = .clear
        colView.showsHorizontalScrollIndicator = false
        return colView
    }()
    fileprivate let reviewTextLabel = UILabel()
    fileprivate let createdLabel = UILabel()
    fileprivate let showMoreButton = UIButton()

    var photos: [UIImage] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photos = photosEmulating()
        setupCell()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        avatarImage.frame = layout.avatarImageFrame
        userNameTextLabel.frame = layout.userNameTextLabelFrame
        ratingImage.frame = layout.ratingImageFrame
        photosCollectionView.frame = layout.photosFrame
        reviewTextLabel.frame = layout.reviewTextLabelFrame
        createdLabel.frame = layout.createdLabelFrame
        showMoreButton.frame = layout.showMoreButtonFrame
    }

    /// Метод, эмулирующий различное кол-во фото для отзыва
    func photosEmulating() -> [UIImage] {
        let photosCount = Int.random(in: 0...5)
        let imageName = ["1", "2", "3", "4", "5", "6"]
        var images: [UIImage] = []

        for _ in 0..<photosCount {
            let imageName = imageName.randomElement() ?? "6"
            let image = UIImage(named: imageName) ?? UIImage()
            images.append(image)
        }

        return images
    }

}

// MARK: - Delegates
extension ReviewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPhotosCell.reuseId, for: indexPath) as! ReviewPhotosCell
        cell.imgView.image = photos[indexPath.item]
        return cell
    }
}


// MARK: - Private

private extension ReviewCell {

    func setupCell() {
        setupAvatarImage()
        setupUserNameTextLabel()
        setupRatingImage()
        setupReviewTextLabel()
        setupCreatedLabel()
        setupShowMoreButton()
    }

    func setupAvatarImage() {
        contentView.addSubview(avatarImage)
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = Layout.avatarCornerRadius
    }

    func setupUserNameTextLabel() {
        contentView.addSubview(userNameTextLabel)
    }

    func setupRatingImage() {
        contentView.addSubview(ratingImage)
    }

    func setupReviewTextLabel() {
        contentView.addSubview(reviewTextLabel)
        reviewTextLabel.lineBreakMode = .byWordWrapping
    }

    func setupCreatedLabel() {
        contentView.addSubview(createdLabel)
    }

    func setupShowMoreButton() {
        contentView.addSubview(showMoreButton)
        showMoreButton.contentVerticalAlignment = .fill
        showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
    }

}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

    private init() { }

    static let shared = ReviewCellLayout()

    // MARK: - Размеры

    fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
    fileprivate static let avatarCornerRadius = 18.0
    fileprivate static let photoCornerRadius = 8.0

    private static let photoSize = CGSize(width: 55.0, height: 66.0)
    private static let showMoreButtonSize = Config.showMoreText.size()

    // MARK: - Фреймы

    private(set) var avatarImageFrame = CGRect.zero
    private(set) var userNameTextLabelFrame = CGRect.zero
    private(set) var ratingImageFrame = CGRect.zero
    private(set) var photosFrame = CGRect.zero
    private(set) var reviewTextLabelFrame = CGRect.zero
    private(set) var showMoreButtonFrame = CGRect.zero
    private(set) var createdLabelFrame = CGRect.zero

    // MARK: - Отступы

    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

    /// Горизонтальный отступ от аватара до имени пользователя.
    private let avatarToUsernameSpacing = 10.0
    /// Вертикальный отступ от имени пользователя до вью рейтинга.
    private let usernameToRatingSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до текста (если нет фото).
    private let ratingToTextSpacing = 6.0
    /// Вертикальный отступ от вью рейтинга до фото.
    private let ratingToPhotosSpacing = 10.0
    /// Горизонтальные отступы между фото.
    private let photosSpacing = 8.0
    /// Вертикальный отступ от фото (если они есть) до текста отзыва.
    private let photosToTextSpacing = 10.0
    /// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
    private let reviewTextToCreatedSpacing = 6.0
    /// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
    private let showMoreToCreatedSpacing = 6.0

    // MARK: - Расчёт фреймов и высоты ячейки

    /// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        let width = maxWidth - insets.left - insets.right
        let avatarToRightObjectSpacing = avatarToUsernameSpacing + Layout.avatarSize.width

        var maxY = insets.top
        var showShowMoreButton = false

        avatarImageFrame = CGRect(
            origin: CGPoint(x: insets.left, y: maxY),
            size: Layout.avatarSize
        )

        userNameTextLabelFrame = CGRect(
            origin: CGPoint(x: insets.left + avatarToRightObjectSpacing, y: maxY),
            size: config.userName.boundingRect(width: width - avatarToRightObjectSpacing).size
        )
        maxY = userNameTextLabelFrame.maxY + usernameToRatingSpacing

        ratingImageFrame = CGRect(
            origin: CGPoint(x: insets.left + avatarToRightObjectSpacing, y: maxY),
            size: config.ratingImage.size
        )
        maxY = ratingImageFrame.maxY + ratingToTextSpacing

        if !config.reviewText.isEmpty() {
            // Высота текста с текущим ограничением по количеству строк.
            let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
            // Максимально возможная высота текста, если бы ограничения не было.
            let actualTextHeight = config.reviewText.boundingRect(width: width).size.height
            // Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
            showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

            reviewTextLabelFrame = CGRect(
                origin: CGPoint(x: insets.left + avatarToRightObjectSpacing, y: maxY),
                size: config.reviewText.boundingRect(width: width - avatarToRightObjectSpacing,
                                                     height: currentTextHeight).size
            )
            maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
        }

        if showShowMoreButton {
            showMoreButtonFrame = CGRect(
                origin: CGPoint(x: insets.left + avatarToRightObjectSpacing, y: maxY),
                size: Self.showMoreButtonSize
            )
            maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
        } else {
            showMoreButtonFrame = .zero
        }

        createdLabelFrame = CGRect(
            origin: CGPoint(x: insets.left + avatarToRightObjectSpacing, y: maxY),
            size: config.created.boundingRect(width: width).size
        )

        return createdLabelFrame.maxY + insets.bottom
    }

}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
