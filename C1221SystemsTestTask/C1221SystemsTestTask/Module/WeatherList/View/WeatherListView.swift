import SwiftUI

struct WeatherListView: View {

    @ObservedObject private var viewModel: WeatherListViewModel

    init(viewModel: WeatherListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.hideKeyboard()
                }

            VStack {
                SeacrhBar(viewModel: viewModel, text: $viewModel.search, placeholder: "Название города")
                    .onSubmit {
                        viewModel.hideKeyboard()
                    }
                    .padding(.top, 10)

                List {
                    ForEach(viewModel.forecastDays, id: \.id) { fday in
                        ForecastDayCell(fday: fday)
                            .listRowSeparator(.hidden)
                            .padding(.leading, 13)
                    }
                }
                .listStyle(.plain)

                TextButton(text: "Ввести другой API-ключ") {
                    viewModel.goToAuth()
                }
                .padding(.bottom, 10)
            }
        }
        .alert("Введённая локация не найдена", isPresented: $viewModel.locationNotFoundAlert) {
            Button("Ок", role: .cancel) {}
        }
        .alert("Ошибка", isPresented: $viewModel.unknownErrorAlert) {
            Button("Ок", role: .cancel) {}
        }
    }

}
