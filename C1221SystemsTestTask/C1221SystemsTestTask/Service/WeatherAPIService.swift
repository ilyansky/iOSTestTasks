import KeychainAccess
import Foundation

enum WeatherAPIError: Error {
    case locationNotFound
    case unknownError
}

final class WeatherAPIService {

    private let keychain = Keychain(service: "com.ilyansky.C1221SystemsTestTask")
    private let keyName = "weatherAPIKey"
    weak var delegate: Router?

    var apiKey: String? {
        get {
            try? keychain.get(keyName)
        }

        set {
            if let value = newValue {
                try? keychain.set(value, key: keyName)
                delegate?.goToWeatherList()
            } else {
                try? keychain.remove(keyName)
                delegate?.goToAuth()
            }
        }
    }

    init(delegate: Router? = nil) {
        self.delegate = delegate
    }

}

// MARK: - Auth validation

extension WeatherAPIService {

    func validateAPIKey(_ key: String) async -> Bool {
        guard let url = URL(string: Const.getValidationUrlString(apiKey: key)) else {
            return false
        }

        do {
            let (_, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            } else {
                return false
            }
        } catch {
            return false
        }
    }

}

// MARK: - WeatherList logic

extension WeatherAPIService {

    func handleCityRequest(_ city: String) async -> ([ForecastDay]?, WeatherAPIError?) {
        guard let apiKey,
              let url = URL(string: Const.getWeatherUrlString(for: city, apiKey: apiKey)) else {
            return (nil, WeatherAPIError.unknownError)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                return (nil, WeatherAPIError.unknownError)
            }

            if httpResponse.statusCode == 400 {
                return (nil, WeatherAPIError.locationNotFound)
            }

            let result = parseData(data)

            return (result, nil)
        } catch {
            return (nil, WeatherAPIError.unknownError)
        }
    }

    private func parseData(_ data: Data) -> [ForecastDay]? {
        do {
            let weather = try JSONDecoder().decode(Weather.self, from: data)
            var result = [ForecastDay]()
            var lastDate = ""

            for now in weather.forecast.forecastday {
                if lastDate == "" || lastDate != now.date {
                    lastDate = now.date
                    result.append(now)
                }
            }

            return result
        } catch {
            return nil
        }
    }

}
