import Foundation

final class ForecastHandler {

    static func getDayAndMonth(from date: String) -> String {
        let mas = date.split(separator: "-")[1...2]
        return "\(mas[1]).\(mas[2])"
    }

    static func getTemperature(from double: Double) -> String {
        let intTemp = Int(double)
        return "\(intTemp)\u{00B0}"
    }

    static func getIconPath(from path: String) -> String {
        "https:\(path)"
    }

    static func getMaxWind(from value: Double) -> String {
        "\(Int(value)) км/ч"
    }

    static func getHumidity(from value: Double) -> String {
        "\(Int(value)) %"
    }

}
