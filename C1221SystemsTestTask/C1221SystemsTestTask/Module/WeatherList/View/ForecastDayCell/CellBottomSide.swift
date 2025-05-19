import SwiftUI

struct CellBottomSide: View {

    let icon: String
    let temp: Double
    let maxWind: Double
    let humidity: Double

    var body: some View {
        HStack {
            Text(ForecastHandler.getTemperature(from: temp))
                .font(Font.system(size: Const.valueFontSize))
            ImageIcon(path: ForecastHandler.getIconPath(from: icon))

            VStack(alignment: .leading) {
                MaxWind(value: maxWind)
                Humidity(value: humidity)
            }
        }
    }

}

#Preview {
    CellBottomSide(
        icon: "https://res.cloudinary.com/dc72tjhk3/image/upload/v1747521692/nh0npmvjx39llms25syr.jpg",
        temp: 10.234,
        maxWind: 10.123,
        humidity: 90)
}
