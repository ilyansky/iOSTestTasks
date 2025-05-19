import SwiftUI

struct Humidity: View {

    let value: Double

    var body: some View {
        HStack {
            Image(systemName: "humidity")
                .resizable()
                .frame(width: Const.screenWidth * 0.07, height: Const.screenWidth * 0.07)
            Text(ForecastHandler.getHumidity(from: value))
                .font(Font.system(size: Const.valueFontSize))
        }
    }

}

#Preview {
    Humidity(value: 10)
}
