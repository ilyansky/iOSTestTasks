import SwiftUI

struct InstructionLabel: View {

    @ObservedObject private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text("Введи свой API-ключ, полученный на сайте:")

            OpenBrowserButton {
                viewModel.openWeatherAPIInBrowser()
            }
        }
        .fixedSizeView(background: .ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: Const.cornerRadius)
        )
    }

}

#Preview {
    InstructionLabel(viewModel: AuthViewModel(router: Router()))
}
