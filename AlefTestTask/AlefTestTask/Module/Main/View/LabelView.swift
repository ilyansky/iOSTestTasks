import UIKit

final class LabelView: UILabel {
    let labelText: String
    let fontSize: CGFloat
    
    init(labelText: String,
         fontSize: CGFloat,
         frame: CGRect = .zero) {
        self.labelText = labelText
        self.fontSize = fontSize
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension LabelView {
    private func setUI() {
        text = labelText
        font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

