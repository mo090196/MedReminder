import SwiftUI

@main
struct MedReminderApp: App {
    @StateObject private var medicationStore = MedicationStore()
    @StateObject private var userSession = UserSession()

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .environmentObject(medicationStore)
                .environmentObject(userSession)
        }
    }
}

#Preview {
    AppContainerView()
        .environmentObject(MedicationStore())
        .environmentObject(UserSession())
}
