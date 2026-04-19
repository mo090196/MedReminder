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
    @EnvironmentObject private var userSession: UserSession

    @State private var notificationAuthRequested = false
    private let notificationDelegate = LocalNotificationDelegate()

    var body: some View {
        ZStack {
            if userSession.isLoggedIn {
                Startseite()
                    .transition(.move(edge: .trailing))
            } else {
                RootView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: userSession.isLoggedIn)
        .task {
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }
        .onChange(of: userSession.isLoggedIn) { loggedIn in
            guard loggedIn else { return }
            requestNotificationsIfNeeded()
        }
    }

    private func requestNotificationsIfNeeded() {
        guard userSession.role.canReceiveNotifications else { return }
        guard !notificationAuthRequested else { return }

        notificationAuthRequested = true

        Task {
            do {
                try await NotificationManager.shared.requestAuthorization()
            } catch {
                print("Notification authorization error: \(error)")
            }
        }
    }
}
