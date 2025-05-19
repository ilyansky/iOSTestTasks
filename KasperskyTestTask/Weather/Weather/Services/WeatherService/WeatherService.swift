import Foundation

enum WeatherError: Error {

    case networkError
    case decodingError
    case cityNotFound

}

typealias CityModelResult = Result<CityModel, WeatherError>
typealias CityModelCompletion = (CityModelResult) -> Void

protocol WeatherService: AnyObject {

    func getCurrentWeather(cityName: String, completion: @escaping CityModelCompletion)

}

final class WeatherServiceImpl: WeatherService {

    func getCurrentWeather(cityName: String, completion: @escaping CityModelCompletion) {
        guard let apiKey = Bundle.main.weatherAPIKey else {
            Logger.WeatherService.apiKeyMissing()
            completion(.failure(.networkError))
            return
        }

        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(cityName)"

        guard let url = URL(string: urlString) else {
            Logger.WeatherService.incorrectUrl(urlString)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = self.handleError(error) {
                self.completeOnMain(completion, result: .failure(error))
                return
            }

            if let httpResponseError = self.handleHttpResponse(response) {
                self.completeOnMain(completion, result: .failure(httpResponseError))
                return
            }

            guard let data = data else {
                Logger.WeatherService.dataNotReceived()
                self.completeOnMain(completion, result: .failure(.networkError))
                return
            }

            do {
                let city = try JSONDecoder().decode(CityModel.self, from: data)
                Logger.WeatherService.decodeDataSuccess(data)
                self.completeOnMain(completion, result: .success(city))
            } catch {
                Logger.WeatherService.decodeDataFail(data, error: error)
                self.completeOnMain(completion, result: .failure(.decodingError))
            }
        }
        task.resume()
    }

    private func handleError(_ error: Error?) -> WeatherError? {
        guard let error = error else { return nil }
        Logger.WeatherService.taskError(error)
        return .networkError
    }

    private func handleHttpResponse(_ response: URLResponse?) -> WeatherError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            Logger.WeatherService.castResponseFail(response)
            return .networkError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if httpResponse.statusCode == 400 {
                Logger.WeatherService.cityNotFound(response: httpResponse)
                return .cityNotFound
            }
            Logger.WeatherService.badStatusCode(in: httpResponse)
            return .networkError

        }

        if httpResponse.statusCode != 200 {
            Logger.WeatherService.badStatusCode(in: httpResponse)
            return .networkError
        }

        return nil
    }

    private func completeOnMain(_ completion: @escaping CityModelCompletion, result: CityModelResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
}
