import SwiftUI

@main
struct C1221SystemsTestTaskApp: App {

    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            if router.hasAPIKey {
                buildWeatherListModule()
            } else {
                buildAuthModule()
            }
        }
    }

    func buildWeatherListModule() -> WeatherListView {
        let vm = WeatherListViewModel(router: router)
        let view = WeatherListView(viewModel: vm)
        return view
    }

    func buildAuthModule() -> AuthView {
        let vm = AuthViewModel(router: router)
        let view = AuthView(viewModel: vm)
        return view
    }

}
