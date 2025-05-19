import SwiftUI

final class WeatherListViewModel: ObservableObject {

    @ObservedObject private var router: Router
    private let app = UIApplication.shared

    @Published var forecastDays = [ForecastDay]()
    @Published var search = ""
    @Published var isLoading = false
    @Published var locationNotFoundAlert = false
    @Published var unknownErrorAlert = false

    init(router: Router) {
        self.router = router
    }

    func goToAuth() {
        router.weatherAPIService.apiKey = nil
    }

}

// MARK: - Search request

extension WeatherListViewModel {

    @MainActor
    func handleCityRequest() async {
        isLoading = true

        let (result, error) = await router.weatherAPIService.handleCityRequest(search)

        if !isError(error), let result {
            forecastDays = result
        }

        isLoading = false
    }

    private func isError(_ error: WeatherAPIError?) -> Bool {
        if error != nil {

            switch error {
            case .locationNotFound:
                locationNotFoundAlert = true
            case .unknownError:
                unknownErrorAlert = true
            case .none:
                break
            }

            return true
        }

        return false
    }

}

// MARK: - Support

extension WeatherListViewModel {

    func hideKeyboard() {
        app.endEditing()
    }

}
