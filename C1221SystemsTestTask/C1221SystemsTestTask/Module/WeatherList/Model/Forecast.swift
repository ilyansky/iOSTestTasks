import Foundation

struct Forecast: Identifiable, Decodable {
    let id = UUID().uuidString
    let forecastday: [ForecastDay]
}

struct ForecastDay: Identifiable, Decodable {
    let id = UUID().uuidString
    let date: String
    let day: Day
}
