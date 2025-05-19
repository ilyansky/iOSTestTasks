import UIKit

final class CellView: UITableViewCell {
    static let reuseId = String(describing: CellView.self)
    weak var delegate: CellViewDelegate?

    private let nameTextField = TextFieldView(labelText: "Имя",
                                              keyboardType: .chars)
    private let ageTextField = TextFieldView(labelText: "Возраст",
                                             keyboardType: .numbers)
    private let deleteButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Utility
extension CellView {
    func clear() {
        nameTextField.clear()
        ageTextField.clear()
    }
}

// MARK: - Action
extension CellView {
    @objc private func deleteButtonTapped() {
        clear()
        delegate?.deleteButtonTapped(in: self)
    }
}

// MARK: - Setup
extension CellView {
    private func setUI() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        setNameTextField()
        setDeleteButton()
        setAgeTextField()
    }

    private func setNameTextField() {
        addSubview(nameTextField)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            nameTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setDeleteButton() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.addTarget(self, action: #selector (deleteButtonTapped), for: .touchUpInside)

        addSubview(deleteButton)

        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: nameTextField.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 20)
        ])
    }

    private func setAgeTextField() {
        addSubview(ageTextField)

        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,
                                              constant: 15),
            ageTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            ageTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            ageTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}


