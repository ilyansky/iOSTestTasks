import SwiftUI
import SDWebImageSwiftUI

struct ImageIcon: View {

    let path: String

    var body: some View {
        WebImage(url: URL(string: path))
            .resizable()
            .frame(width: Const.screenWidth * 0.12, height: Const.screenWidth * 0.12)
            .cornerRadius(Const.smallCornerRadius, corners: [.allCorners])
    }

}
