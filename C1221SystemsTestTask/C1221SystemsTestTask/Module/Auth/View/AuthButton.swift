import SwiftUI

struct EnterButton: View {

    let text: String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .padding()
                .background(Const.purpleIndigo)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: Const.cornerRadius)
        )
    }

}

#Preview {
    EnterButton(text: "Перейти в браузер", action: {})
}
