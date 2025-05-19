import Foundation

final class Logger {

    enum WeatherService {

        static func apiKeyMissing() {
            print("ApiKey missing")
        }

        static func incorrectUrl(_ urlString: String) {
            print("Incorrect url string = \(urlString)")
        }

        static func taskError(_ error: Error) {
            print("Task error description = \(error.localizedDescription)")
        }

        static func castResponseFail(_ response: URLResponse?) {
            print("Unable to cast response, response description = \(response.debugDescription)")
        }

        static func cityNotFound(response: HTTPURLResponse) {
            print("City not found, response description = \(response.debugDescription)")
        }

        static func badStatusCode(in response: HTTPURLResponse) {
            print("Bad status code = \(response.statusCode)")
        }

        static func dataNotReceived() {
            print("Data not received")
        }

        static func decodeDataSuccess(_ data: Data) {
            print("Data decoded successfully, \(data.debugDescription)")
        }

        static func decodeDataFail(_ data: Data, error: Error?) {
            print("Unable to decode data, data = \(data.debugDescription)")
            if let error {
                print("Error description = \(error.localizedDescription)")
            }
        }

    }

    enum LastSearchCitiesProvider {

        static func printFetchedCities(_ cities: [String]) {
            print("Cities fetched successfully, fetched cities = \(cities)")
        }

        static func fetchError(_ error: Error) {
            print("Fetch error description = \(error.localizedDescription)")
        }

        static func cityAdded(name: String, cities: [String]) {
            print("City with name \(name) added")
            print("Cities list now = \(cities)")
        }

        static func cityNotAdded(name: String, error: Error?) {
            print("City with name \(name) not added")
            if let error {
                print("Error description = \(error.localizedDescription)")
            }
        }

        static func cityDeleted(name: String) {
            print("City with name \(name) deleted")
        }

        static func cityNotDeleted(name: String, error: Error?) {
            print("City with name \(name) not deleted")
            if let error {
                print("Error description = \(error.localizedDescription)")
            }
        }

    }

    enum MainViewController {

        static func unableToCastCell() {
            print("Unable to cast tableCell to CityTableCell")
        }

        static func unableToGetCellModel(at indexPath: IndexPath) {
            print("Unable to get cell model at indexPath <\(indexPath)>")
        }

    }

}
