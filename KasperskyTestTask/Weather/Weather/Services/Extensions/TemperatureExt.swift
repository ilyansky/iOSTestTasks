import Foundation

extension Double {

    func getTemperatureInCelsius() -> String {
        String(Int(self)) + "\u{00B0}"
    }

}
