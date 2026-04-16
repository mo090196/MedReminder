import SwiftUI
import UserNotifications

final class LocalNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}

struct AppContainerView: View {
    @State private var notificationAuthRequested = false
    @State private var isLoggedIn = false
    private let notificationDelegate = LocalNotificationDelegate()

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
            UNUserNotificationCenter.current().delegate = notificationDelegate
            do {
                try await NotificationManager.shared.requestAuthorization()
            } catch {
                print("Notification authorization error: \(error)")
            }
        }
    }
}
