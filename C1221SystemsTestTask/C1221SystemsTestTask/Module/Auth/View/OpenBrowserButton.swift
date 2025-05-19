import SwiftUI

struct OpenBrowserButton: View {

    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "network")
                .padding()
                .foregroundColor(.white)
                .background(Const.purpleIndigo)

        }
        .clipShape(Circle())
    }

}

#Preview {
    OpenBrowserButton(action: {})
}
