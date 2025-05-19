import Foundation

struct Weather: Identifiable, Decodable {
    let id = UUID().uuidString
    let forecast: Forecast
}
