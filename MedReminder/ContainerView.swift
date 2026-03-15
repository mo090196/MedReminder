import SwiftUI

struct AppContainerView: View {
    @State private var isLoggedIn = false

    var body: some View {
        ZStack {
            if isLoggedIn {
                Startseite()
                    .transition(.move(edge: .trailing))
            } else {
                RootView(isLoggedIn: $isLoggedIn)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isLoggedIn)
    }
}
