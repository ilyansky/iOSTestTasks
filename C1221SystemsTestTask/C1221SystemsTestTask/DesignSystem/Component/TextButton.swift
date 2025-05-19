import SwiftUI

struct TextButton: View {

    let text: String
    let isLoading: Bool
    let action: () -> Void

    init(text: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            if isLoading {
                ProgressView()
                    .fixedSizeView(background: Const.purpleIndigo)
                    .tint(.white)
            } else {
                Text(text)
                    .fixedSizeView(background: Const.purpleIndigo)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: Const.cornerRadius)
        )
    }

}

#Preview {
    TextButton(text: "Перейти в браузер", action: {})
}
