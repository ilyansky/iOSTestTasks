import SwiftUI

struct AuthView: View {

    @ObservedObject private var viewModel: AuthViewModel

    init(viewModel: AuthViewModel) {
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
                InstructionLabel(viewModel: viewModel)

                AuthTextField(text: $viewModel.apiKeyText, placeholder: "API-ключ")
                    .onSubmit {
                        viewModel.hideKeyboard()
                    }

                TextButton(text: "Перейти к прогнозу погоды", isLoading: viewModel.apiKeyChecking) {
                    Task {
                        await viewModel.goToWeatherList()
                    }
                }
            }
        }
        .alert("Некорректный API-ключ", isPresented: $viewModel.invalidAPIKey) {
            Button("Ок", role: .cancel) {}
        }
    }
    
}

#Preview {
    AuthView(viewModel: AuthViewModel(router: Router()))
}
