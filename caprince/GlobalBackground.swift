import SwiftUI

struct GlobalBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
        }
    }
}

extension View {
    func globalBackground() -> some View {
        self.modifier(GlobalBackground())
    }
}
