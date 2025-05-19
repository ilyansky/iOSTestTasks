import SwiftUI

struct ForecastDayCell: View {

    let fday: ForecastDay

    var body: some View {
        VStack(alignment: .center) {
            CellTopSide(date: fday.date,
                        text: fday.day.condition.text)

            CellBottomSide(icon: fday.day.condition.icon,
                           temp: fday.day.avgtemp_c,
                           maxWind: fday.day.maxwind_kph,
                           humidity: fday.day.avghumidity)
        }
        .fixedSizeView(background: .ultraThinMaterial)
        .cornerRadius(Const.cornerRadius, corners: [.allCorners])
    }

}

#Preview {
    ForecastDayCell(fday: ForecastDay(date: "2025-05-18",
                                             day: Day(condition: Condition(text: "text", icon: "https://res.cloudinary.com/dc72tjhk3/image/upload/v1747521692/nh0npmvjx39llms25syr.jpg"),
                                                      avgtemp_c: 10.0,
                                                      maxwind_kph: 20.0,
                                                      avghumidity: 30)))
}
