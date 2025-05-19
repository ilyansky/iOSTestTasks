import SwiftUI

final class AuthViewModel: ObservableObject {

    @ObservedObject private var router: Router
    private let app = UIApplication.shared

    @Published var apiKeyText: String = ""
    @Published var invalidAPIKey = false
    @Published var apiKeyChecking = false

    init(router: Router) {
        self.router = router
    }

    @MainActor
    func goToWeatherList() async {
        apiKeyChecking = true
        if await router.weatherAPIService.validateAPIKey(apiKeyText) {
            router.weatherAPIService.apiKey = apiKeyText
        } else {
            invalidAPIKey = true
        }
        apiKeyChecking = false
    }

}

// MARK: - Support

extension AuthViewModel {

    func openWeatherAPIInBrowser() {
        guard let url = URL(string: Const.weatherAPI),
              UIApplication.shared.canOpenURL(url) else { return }

        UIApplication.shared.open(url)
    }

    func hideKeyboard() {
        app.endEditing()
    }

}


