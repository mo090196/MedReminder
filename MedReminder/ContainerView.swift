import SwiftUI
import UserNotifications

struct AppContainerView: View {
    @State private var notificationAuthRequested = false
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
        .task {
            guard !notificationAuthRequested else { return }
            notificationAuthRequested = true
            do {
                try await NotificationManager.shared.requestAuthorization()
            } catch {
                // Optional: handle or log the error
                print("Notification authorization error: \(error)")
            }
        }
    }
}
