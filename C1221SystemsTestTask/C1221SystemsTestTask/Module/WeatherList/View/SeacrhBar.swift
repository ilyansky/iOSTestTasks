import SwiftUI

struct SeacrhBar: View {

    @ObservedObject private var viewModel: WeatherListViewModel

    var text: Binding<String>
    let placeholder: String

    init(viewModel: WeatherListViewModel, text: Binding<String>, placeholder: String) {
        self.viewModel = viewModel
        self.text = text
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            TextField(placeholder, text: text)
            .fixedSizeView(background: .ultraThinMaterial, scale: Const.screenWidth * 0.7)
            .cornerRadius(Const.cornerRadius, corners: [.bottomLeft, .topLeft])
            .cornerRadius(Const.smallCornerRadius, corners: [.bottomRight, .topRight])

            Button {
                Task {
                    await viewModel.handleCityRequest()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "magnifyingglass")
                        .tint(.white)
                }
            }
            .fixedSizeView(background: Const.purpleIndigo, scale: Const.screenWidth * 0.15)
            .cornerRadius(Const.cornerRadius, corners: [.bottomRight, .topRight])
            .cornerRadius(Const.smallCornerRadius, corners: [.bottomLeft, .topLeft])
        }
    }

}

#Preview {
    @State var text = "text"
    SeacrhBar(viewModel: WeatherListViewModel(router: Router()), text: $text, placeholder: "plh")
}
