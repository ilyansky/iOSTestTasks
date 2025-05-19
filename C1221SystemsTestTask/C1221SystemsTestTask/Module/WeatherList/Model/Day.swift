import Foundation

struct Day: Identifiable, Decodable {
    let id = UUID().uuidString
    let condition: Condition
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
}
