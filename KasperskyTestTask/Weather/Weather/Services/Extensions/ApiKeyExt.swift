import Foundation

extension Bundle {

    var weatherAPIKey: String? {
        return object(forInfoDictionaryKey: "WeatherAPIKey") as? String
    }
    
}
