import SwiftUI

struct GlobalBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color(.black)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func globalBackground() -> some View {
        self.modifier(GlobalBackground())
    }
}
