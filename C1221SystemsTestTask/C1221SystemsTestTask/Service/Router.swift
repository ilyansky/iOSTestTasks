import SwiftUI

final class Router: ObservableObject {

    let weatherAPIService: WeatherAPIService
    @Published var hasAPIKey = false

    init() {
        weatherAPIService = WeatherAPIService()
        weatherAPIService.delegate = self
        hasAPIKey = weatherAPIService.apiKey != nil
    }

    func goToWeatherList() {
        hasAPIKey = true

    }

    func goToAuth() {
        hasAPIKey = false
    }

}
