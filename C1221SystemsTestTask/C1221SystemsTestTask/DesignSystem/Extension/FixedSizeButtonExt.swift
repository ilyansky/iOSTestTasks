import SwiftUI

extension View {

    func fixedSizeView<Background: ShapeStyle>(background: Background,
                                               scale: CGFloat = Const.screenWidth * 0.85) -> some View {
        self
            .padding()
            .frame(width: scale)
            .background(background)
    }

}
