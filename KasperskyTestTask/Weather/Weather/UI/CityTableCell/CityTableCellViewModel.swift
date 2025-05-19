public struct CityTableCellViewModel {

    let name: String?
    let localTime: String?
    let temperature: String?
    let conditionText: String?
    let conditionIconURL: String?

    init(cityModel: CityModel) {
        name = cityModel.location.name
        localTime = cityModel.location.localtime.getCurrentTime()
        temperature = cityModel.current.temp_c.getTemperatureInCelsius()
        conditionText = cityModel.current.condition.text
        conditionIconURL = "https:" + cityModel.current.condition.icon
    }
    
}
