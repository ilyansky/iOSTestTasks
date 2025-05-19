import SwiftUI

struct CellTopSide: View {

    let date: String
    let text: String

    var body: some View {
        HStack {
            Text(ForecastHandler.getDayAndMonth(from: date))
                .font(Font.system(size: Const.dateFontSize))

            Text(text)
                .font(Font.system(size: Const.textDescriptionsFontSize))
        }
    }
}
