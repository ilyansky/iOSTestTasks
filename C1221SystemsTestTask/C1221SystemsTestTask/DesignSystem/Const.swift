import SwiftUI

enum Const {

    // screen
    static let screenWidth = UIScreen.main.bounds.width

    // size
    static let cornerRadius: CGFloat = 25
    static let smallCornerRadius: CGFloat = 10

    static let dateFontSize: CGFloat = 35
    static let textDescriptionsFontSize: CGFloat = 20
    static let valueFontSize: CGFloat = 25


    // color
    static let purpleIndigo: LinearGradient = LinearGradient(colors: [.purple, .indigo],
                                                             startPoint: .top,
                                                             endPoint: .bottom)

    // url
    static let weatherAPI = "https://www.weatherapi.com/"

    static func getValidationUrlString(apiKey: String) -> String {
        "https://api.weatherapi.com/v1/forecast.json?q=moscow&key=\(apiKey)"
    }

    static func getWeatherUrlString(for city: String, apiKey: String) -> String {
        "https://api.weatherapi.com/v1/forecast.json?q=\(city)&days=5&key=\(apiKey)"
    }

}
