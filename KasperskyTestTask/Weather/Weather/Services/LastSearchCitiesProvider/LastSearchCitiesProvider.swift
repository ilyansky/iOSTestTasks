import Foundation
import CoreData
import UIKit

// MARK: - Protocol

protocol LastSearchCitiesProvider {

    var lastSearchedCities: [String] { get }
    func addCity(_ cityName: String) -> Bool
    func removeCity(at index: Int) -> Bool

}

// MARK: - Implementation

final class LastSearchCitiesProviderImpl: LastSearchCitiesProvider {

    var lastSearchedCities: [String] = []
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchCities()
    }

    func addCity(_ cityName: String) -> Bool {
        var cityAdded = true
        let city = City(context: context)
        city.name = cityName

        do {
            try context.save()
            lastSearchedCities.append(cityName)
            Logger.LastSearchCitiesProvider.cityAdded(name: cityName, cities: lastSearchedCities)
        } catch {
            Logger.LastSearchCitiesProvider.cityNotAdded(name: cityName, error: error)
            cityAdded = false
        }

        return cityAdded
    }

    func removeCity(at index: Int) -> Bool {
        var cityRemoved = true
        let cityName = lastSearchedCities[index]
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", cityName)

        do {
            let result = try context.fetch(fetchRequest)
            for city in result {
                context.delete(city)
            }

            try context.save()
            lastSearchedCities.remove(at: index)
            Logger.LastSearchCitiesProvider.cityDeleted(name: cityName)
        } catch {
            Logger.LastSearchCitiesProvider.cityNotDeleted(name: cityName, error: error)
            cityRemoved = false
        }

        return cityRemoved
    }

    // MARK: - Private Methods

    private func fetchCities() {
        var result = [String]()
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()

        do {
            let cities = try context.fetch(fetchRequest)

            for city in cities {
                if let name = city.name {
                    result.append(name)
                }
            }
            Logger.LastSearchCitiesProvider.printFetchedCities(result)
        } catch {
            Logger.LastSearchCitiesProvider.fetchError(error)
        }

        lastSearchedCities = result
    }

}
