import SwiftUI
import Combine

enum UserRole: String, CaseIterable, Identifiable {
    case einnehmer = "Selbstständiger Einnehmer"
    case betreuer = "Betreuer"
    case betreuterEinnehmer = "Betreuter Einnehmer"

    var id: String { rawValue }

    var canReceiveNotifications: Bool {
        switch self {
        case .einnehmer, .betreuterEinnehmer:
            return true
        case .betreuer:
            return false
        }
    }

    var canAddMedication: Bool {
        switch self {
        case .einnehmer, .betreuer:
            return true
        case .betreuterEinnehmer:
            return false
        }
    }
}

final class UserSession: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var role: UserRole = .einnehmer
}
