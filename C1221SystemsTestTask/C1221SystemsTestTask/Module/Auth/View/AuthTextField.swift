import SwiftUI

struct AuthTextField: View {

    var text: Binding<String>
    let placeholder: String

    var body: some View {
        VStack {
            TextField(placeholder, text: text)
        }
        .fixedSizeView(background: .ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius: Const.cornerRadius)
        )
    }

}

#Preview {
    @State var text = "123"
    AuthTextField(text: $text, placeholder: "plh")
}
