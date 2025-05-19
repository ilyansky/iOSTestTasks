import UIKit

class MainViewController: UIViewController {

    // MARK: - Private Properties

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupRefreshControl()

        viewModel = MainViewModel(delegate: self)
    }

}

// MARK: - Table View

extension MainViewController {

    func updateCell(at row: Int) {
        scrollTableView(to: row)

        performTableViewUpdate {
            tableView.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }

    func insertCityToTableView(cityModel: CityModel) {
        let cityCell = CityTableCellViewModel(cityModel: cityModel)
        viewModel?.insertCity(cityCell)

        performTableViewUpdate {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }

        scrollTableView(to: 0)
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func setupTableView() {
        tableView.register(CityTableCell.nib, forCellReuseIdentifier: CityTableCell.reuseIdentifier)
        tableView.delegate = self
    }

    private func performTableViewUpdate(block: () -> Void) {
        tableView.beginUpdates()
        block()
        tableView.endUpdates()
    }

    private func scrollTableView(to row: Int) {
        DispatchQueue.main.async {
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .top, animated: true)
            }
        }
    }

}

// MARK: - Refresh Control

extension MainViewController {

    @objc func refresh(sender: UIRefreshControl) {
        viewModel?.refreshTable()
        sender.endRefreshing()
    }

    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - Alerts

extension MainViewController {

    func showCityNotFoundAlert() {
        let alertController = UIAlertController(title: "Город не найден", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "ОК", style: .cancel)

        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }

    func showCityNotAddedAlert() {
        let alertController = UIAlertController(title: "Город не добавлен. Возникла ошибка.", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "ОК", style: .cancel)

        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }

    private func showCityNotRemovedAlert() {
        let alertController = UIAlertController(title: "Город не удален. Возникла ошибка.", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "ОК", style: .cancel)

        alertController.addAction(doneAction)
        present(alertController, animated: true)
    }

}

// MARK: - Protocols

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getItems().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = CityTableCell.reuseIdentifier
        let tableCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        guard let cityTableCell = tableCell as? CityTableCell else {
            Logger.MainViewController.unableToCastCell()
            return tableCell
        }

        guard let cellModel = viewModel?.cellModel(at: indexPath) else {
            Logger.MainViewController.unableToGetCellModel(at: indexPath)
            return tableCell
        }

        cityTableCell.configure(with: cellModel)

        return cityTableCell
    }

}

extension MainViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel?.searchCity(searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in

            if self?.viewModel?.removeCity(at: indexPath) ?? false {
                self?.performTableViewUpdate {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }

                completionHandler(true)
            } else {
                self?.showCityNotRemovedAlert()
                completionHandler(false)
            }
        }

        deleteAction.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
