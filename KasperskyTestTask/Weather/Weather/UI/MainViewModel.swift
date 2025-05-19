import Foundation

final class MainViewModel {

    typealias Item = CityTableCellViewModel

    private weak var delegate: MainViewController?
    private var items: [Item] = []

    private lazy var weatherService: WeatherService = {
        WeatherServiceImpl()
    }()

    private lazy var lastSearchCitiesProvider: LastSearchCitiesProvider = {
        let context = CoreDataStack.shared.context
        return LastSearchCitiesProviderImpl(context: context)
    }()

    init(delegate: MainViewController) {
        self.delegate = delegate
        loadLastSearchedCities()
    }

}

// MARK: - TableView

extension MainViewModel {

    func getItems() -> [Item] {
        items
    }

    func refreshTable() {
        items.removeAll()
        loadLastSearchedCities()
        delegate?.reloadTableView()
    }

    func cellModel(at indexPath: IndexPath) -> Item? {
        let numberOfItems = items.count
        guard indexPath.row >= 0 && indexPath.row < numberOfItems else {
            print("View model section <\(indexPath.section)> contains <\(numberOfItems)> cells. Got request for a cell at index <\(indexPath.row)>")
            return nil
        }
        return items[indexPath.row]
    }

    func insertCity(_ cityCell: CityTableCellViewModel) {
        items.insert(cityCell, at: 0)
    }

}


// MARK: - Items Handler

extension MainViewModel {

    func searchCity(_ cityName: String) {
        weatherService.getCurrentWeather(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let cityModel):
                self?.handleReceivedCity(cityModel: cityModel)
            case .failure(_):
                self?.delegate?.showCityNotFoundAlert()
            }
        }
    }

    func removeCity(at indexPath: IndexPath) -> Bool {
        var cityRemoved = false
        guard indexPath.row < items.count else { return cityRemoved }

        let lastSearchedCitiesIndex = lastSearchCitiesProvider.lastSearchedCities.count - 1 - indexPath.row

        if lastSearchCitiesProvider.removeCity(at: lastSearchedCitiesIndex) {
            items.remove(at: indexPath.row)
            cityRemoved = true
        }

        return cityRemoved
    }

    // MARK: - Private Methods

    private func loadLastSearchedCities() {
        let cities = lastSearchCitiesProvider.lastSearchedCities
        loadLastSearchedCitiesSequentially(from: cities)
    }

    private func loadLastSearchedCitiesSequentially(from cities: [String], index: Int = 0) {
        guard index < cities.count else { return }

        let cityName = cities[index]
        weatherService.getCurrentWeather(cityName: cityName) { [weak self] result in
            switch result {
            case .success(let cityModel):
                self?.delegate?.insertCityToTableView(cityModel: cityModel)
            case .failure(_):
                self?.delegate?.showCityNotFoundAlert()
            }

            self?.loadLastSearchedCitiesSequentially(from: cities, index: index + 1)
        }
    }

    private func handleReceivedCity(cityModel: CityModel) {
        if !lastSearchCitiesProvider.lastSearchedCities.contains(cityModel.location.name) {
            if lastSearchCitiesProvider.addCity(cityModel.location.name) {
                delegate?.insertCityToTableView(cityModel: cityModel)
            } else {
                delegate?.showCityNotAddedAlert()
            }
        } else {
            let cityIndex = findCityIndex(cityName: cityModel.location.name)
            let cityCell = CityTableCellViewModel(cityModel: cityModel)

            items.remove(at: cityIndex)
            items.insert(cityCell, at: cityIndex)

            delegate?.updateCell(at: cityIndex)
        }
    }

    private func findCityIndex(cityName: String) -> Int {
        for (i, item) in items.enumerated() {
            if item.name == cityName {
                return i
            }
        }
        return 0
    }

}
