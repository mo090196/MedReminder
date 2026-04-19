import SwiftUI

struct Übersicht: View {
    @EnvironmentObject private var medicationStore: MedicationStore
    @State private var navigateToCalendar = false
    @State private var navigateToStartseite = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 240/255, green: 248/255, blue: 255/255).ignoresSafeArea() // optional light blue background
                Text("Übersicht")
                    .font(.title)
                    .bold()
            }
            .overlay(alignment: .bottom) {
                HStack {
                    // Left: Übersicht (highlighted, no action)
                    VStack(spacing: 4) {
                        Image(systemName: "list.bullet.rectangle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Übersicht")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Center: Startseite button (dimmed)
                    Button {
                        navigateToStartseite = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "house")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.6))
                            Text("Startseite")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Right: Kalender button (dimmed)
                    Button {
                        navigateToCalendar = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.6))
                            Text("Kalender")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 14)
                .background(Color(red: 35/255, green: 150/255, blue: 185/255))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30))
                .offset(y: 35)
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationDestination(isPresented: $navigateToStartseite) {
                Startseite()
                    .environmentObject(medicationStore)
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
                    .environmentObject(medicationStore)
            }
        }
    }
}

#Preview {
    Übersicht()
        .environmentObject(MedicationStore())
}
