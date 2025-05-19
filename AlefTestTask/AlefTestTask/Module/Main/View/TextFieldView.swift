import UIKit

final class TextFieldView: UIView, UITextFieldDelegate {
    enum KeyboardType {
        case chars
        case numbers
    }
    
    let labelText: String
    let keyboardType: KeyboardType
    private let label = UILabel()
    let textField = UITextField()
    
    init(labelText: String,
         keyboardType: KeyboardType,
         frame: CGRect = .zero) {
        self.labelText = labelText
        self.keyboardType = keyboardType
        super.init(frame: frame)
        textField.delegate = self
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Utility
extension TextFieldView {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if keyboardType == .numbers && (newText.hasPrefix("0") || newText.contains(",")) {
            return false
        }
        
        return true
    }
    
    func clear() {
        textField.text = ""
    }
}

// MARK: - Setup
extension TextFieldView {
    private func setUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1
        layer.borderColor = ColorPack.gray5.cgColor
        layer.cornerRadius = 5
        
        setLabel()
        setTextField()
    }
    
    private func setLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.textColor = ColorPack.gray
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor,
                                       constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: 15)
        ])
    }
    
    private func setTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        if keyboardType == .numbers {
            textField.keyboardType = .decimalPad
        }
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
}
