import Foundation

struct Condition: Identifiable, Decodable {
    let id = UUID().uuidString
    let text: String
    let icon: String
}
