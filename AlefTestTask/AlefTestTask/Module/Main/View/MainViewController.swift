import UIKit

protocol CellViewDelegate: AnyObject {
    func deleteButtonTapped(in cell: CellView)
}

final class MainViewController: UIViewController {
    private let viewModel = ViewModel()

    private let personalDataLabel = LabelView(labelText: "Персональные данные",
                                              fontSize: 17)
    private let nameTextField = TextFieldView(labelText: "Имя",
                                              keyboardType: .chars)
    private let ageTextField = TextFieldView(labelText: "Возраст",
                                             keyboardType: .numbers)
    private let childrenLabel = LabelView(labelText: "Дети (макс. 5)",
                                          fontSize: 17)
    private let addChildButton = UIButton(type: .system)
    private let childrenTableView = UITableView()
    private let clearButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
}

// MARK: - Utility
extension MainViewController {
    private func clearTableView() {
        let count = viewModel.getChildrenCount()

        for row in 0..<count {
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = childrenTableView.cellForRow(at: indexPath) as? CellView {
                cell.clear()
            }
        }

        viewModel.clear()

        var indexPaths: [IndexPath] = []
        for row in 0..<count {
            indexPaths.append(IndexPath(row: row, section: 0))
        }

        childrenTableView.beginUpdates()
        childrenTableView.deleteRows(at: indexPaths, with: .fade)
        childrenTableView.endUpdates()
    }

    private func clearPersonalData() {
        nameTextField.clear()
        ageTextField.clear()
    }

    private func showButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 1
        })
    }

    private func hideButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 0
        })
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MainViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getChildrenCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellView.reuseId, for: indexPath) as? CellView else {
            return UITableViewCell()
        }
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
}

extension MainViewController: CellViewDelegate {
    func deleteButtonTapped(in cell: CellView) {
        if let indexPath = childrenTableView.indexPath(for: cell) {
            let count = viewModel.getChildrenCount()

            if count == 5 {
                showButton(addChildButton)
            }

            viewModel.decrementChildrenCount()

            childrenTableView.beginUpdates()
            childrenTableView.deleteRows(at: [indexPath], with: .fade)
            childrenTableView.endUpdates()
        }
    }
}

// MARK: - Action
extension MainViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        hideButton(clearButton)

        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            childrenTableView.setBottomInset(to: keyboardHeight)
        }
    }

    @objc private func keyboardWillHide() {
        showButton(clearButton)
        childrenTableView.setBottomInset(to: 0.0)
    }

    @objc private func incrementChild() {
        let childrenCount = viewModel.getChildrenCount()

        if childrenCount == 4 {
            hideButton(addChildButton)
        }

        let newIndexPath = IndexPath(row: childrenCount, section: 0)
        viewModel.incrementChildrenCount()

        childrenTableView.beginUpdates()
        childrenTableView.insertRows(at: [newIndexPath], with: .fade)
        childrenTableView.endUpdates()

        childrenTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }

    @objc private func tapClearButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let resetAction = UIAlertAction(title: "Сбросить данные", style: .default) { _ in
            self.clearTableView()
            self.clearPersonalData()
            self.showButton(self.addChildButton)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)

        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}

// MARK: - Setup
extension MainViewController {
    private func setup() {
        view.backgroundColor = .white

        addKeyboardObservers()
        hideKeyboardWhenTappedAround()
        setTableView()

        setPersonalDataLabel()
        setNameTextField()
        setAgeTextField()
        setAddChildButton()
        setChildrenLabel()
        setClearButton()
        setChildrenTableView()
    }

    private func setTableView() {
        childrenTableView.delegate = self
        childrenTableView.dataSource = self
        childrenTableView.register(CellView.self, forCellReuseIdentifier: CellView.reuseId)
    }

    private func setPersonalDataLabel() {
        view.addSubview(personalDataLabel)

        NSLayoutConstraint.activate([
            personalDataLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            personalDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setNameTextField() {
        view.addSubview(nameTextField)

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: personalDataLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setAgeTextField() {
        view.addSubview(ageTextField)

        NSLayoutConstraint.activate([
            ageTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            ageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ageTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setAddChildButton() {
        addChildButton.setTitle("Добавить ребенка", for: .normal)
        addChildButton.setTitleColor(ColorPack.blue, for: .normal)

        let image = UIImage(systemName: "plus")
        addChildButton.setImage(image, for: .normal)
        addChildButton.tintColor = ColorPack.blue

        addChildButton.layer.cornerRadius = 25
        addChildButton.layer.borderWidth = 2
        addChildButton.layer.borderColor = ColorPack.blue.cgColor
        addChildButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        addChildButton.translatesAutoresizingMaskIntoConstraints = false
        addChildButton.addTarget(self, action: #selector(incrementChild), for: .touchUpInside)
        view.addSubview(addChildButton)

        NSLayoutConstraint.activate([
            addChildButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addChildButton.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 10),
            addChildButton.heightAnchor.constraint(equalToConstant: 50),
            addChildButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
    }

    private func setChildrenLabel() {
        view.addSubview(childrenLabel)

        NSLayoutConstraint.activate([
            childrenLabel.centerYAnchor.constraint(equalTo: addChildButton.centerYAnchor),
            childrenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }

    private func setClearButton() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.tintColor = ColorPack.red
        clearButton.layer.borderWidth = 2
        clearButton.layer.borderColor = ColorPack.red.cgColor
        clearButton.layer.cornerRadius = 25
        clearButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        clearButton.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)

        view.addSubview(clearButton)

        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            clearButton.heightAnchor.constraint(equalToConstant: 50),
            clearButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 180)
        ])
    }

    private func setChildrenTableView() {
        childrenTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childrenTableView)

        NSLayoutConstraint.activate([
            childrenTableView.topAnchor.constraint(equalTo: addChildButton.bottomAnchor, constant: 10),
            childrenTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            childrenTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            childrenTableView.bottomAnchor.constraint(equalTo: clearButton.topAnchor, constant: -15)
        ])
    }
}
