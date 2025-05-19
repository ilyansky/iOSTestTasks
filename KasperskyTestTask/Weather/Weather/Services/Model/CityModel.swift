import Foundation

struct CityModel: Codable {

    let location: LocationInfo
    let current: CurrentWeatherInfo

}

struct LocationInfo: Codable {

    let name: String
    let localtime: String

}

struct CurrentWeatherInfo: Codable {

    let temp_c: Double
    let condition: Condition

}

struct Condition: Codable {

    let text: String
    let icon: String

}
