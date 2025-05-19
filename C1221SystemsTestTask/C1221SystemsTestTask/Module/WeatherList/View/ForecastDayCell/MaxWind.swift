import SwiftUI

struct MaxWind: View {

    let value: Double

    var body: some View {
        HStack {
            Image(systemName: "wind")
                .resizable()
                .frame(width: Const.screenWidth * 0.07, height: Const.screenWidth * 0.07)
            Text(ForecastHandler.getMaxWind(from: value))
                .font(Font.system(size: Const.valueFontSize))
        }
    }

}

#Preview {
    MaxWind(value: 10)
}
