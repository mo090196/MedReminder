//
//  MedReminderApp.swift
//  MedReminder
//
//  Created by Simav  on 09.04.26.
//

import SwiftUI

@main
struct MedReminderApp: App {
    @StateObject private var medicationStore = MedicationStore()

    var body: some Scene {
        WindowGroup {
            AppContainerView()
                .environmentObject(medicationStore)
        }
    }
}

#Preview {
    AppContainerView()
        .environmentObject(MedicationStore())
}
