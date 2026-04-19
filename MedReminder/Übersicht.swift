import Combine
import SwiftUI

final class MedicationStore: ObservableObject {
    struct Medication: Identifiable, Equatable {
        let id: UUID
        var time: Date
        var name: String
        var details: String?

        var startDate: Date
        var endDate: Date?
        var frequency: String
        var weekdays: Set<Int>

        var takenDates: Set<Date>

        init(
            id: UUID = UUID(),
            time: Date,
            name: String,
            details: String? = nil,
            startDate: Date,
            endDate: Date? = nil,
            frequency: String,
            weekdays: Set<Int> = [],
            takenDates: Set<Date> = []
        ) {
            self.id = id
            self.time = time
            self.name = name
            self.details = details
            self.startDate = Calendar.current.startOfDay(for: startDate)
            self.endDate = endDate.map { Calendar.current.startOfDay(for: $0) }
            self.frequency = frequency
            self.weekdays = weekdays
            self.takenDates = takenDates
        }

        func isScheduled(on date: Date) -> Bool {
            let calendar = Calendar.current
            let day = calendar.startOfDay(for: date)
            let start = calendar.startOfDay(for: startDate)

            if day < start { return false }

            if let endDate {
                let end = calendar.startOfDay(for: endDate)
                if day > end { return false }
            }

            let daysBetween = calendar.dateComponents([.day], from: start, to: day).day ?? 0

            switch frequency {
            case "daily":
                return true

            case "every2Days":
                return daysBetween % 2 == 0

            case "once":
                return calendar.isDate(day, inSameDayAs: start)

            case "weekdays":
                let weekday = weekdayIndex(for: day)
                return weekdays.contains(weekday)

            default:
                return false
            }
        }

        func isTaken(on date: Date) -> Bool {
            let day = Calendar.current.startOfDay(for: date)
            return takenDates.contains(day)
        }

        mutating func markTaken(on date: Date) {
            let day = Calendar.current.startOfDay(for: date)
            takenDates.insert(day)
        }

        private func weekdayIndex(for date: Date) -> Int {
            let weekday = Calendar.current.component(.weekday, from: date)
            return (weekday + 5) % 7
        }
    }

    @Published var medications: [Medication] = []
}

struct UebersichtView: View {
    @EnvironmentObject private var store: MedicationStore
    
    @State private var navigateToStartseite: Bool = false
    @State private var navigateToCalendar: Bool = false
    @State private var navigateToSettings: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                VStack(spacing: 0) {
                    Header()

                    ScrollView {
                        VStack(spacing: 16) {
                            if store.medications.isEmpty {
                                Text("Noch keine Medikamente eingetragen")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(store.medications) { med in
                                    MedicationCard(
                                        time: med.time,
                                        name: med.name,
                                        details: med.details,
                                        isActive: med.isScheduled(on: Date())                                )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                    }
                }
                .background(Color(hex: 0xE3FAFF))
                .ignoresSafeArea(edges: .top)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { navigateToSettings = true } label: { Image(systemName: "gearshape") }
                }
            }
            .overlay(
                HStack {
                    // Left: Übersicht highlighted
                    VStack {
                        Image(systemName:"list.bullet.rectangle")
                            .font(.system(size: 60, weight: .bold))
                        Text("Übersicht")
                            .font(.system(size: 22, weight: .bold))
                    }
                    .foregroundColor(.white)

                    Spacer()

                    // Center: Startseite (dimmed)
                    Button(action: { navigateToStartseite = true }) {
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 55))
                            Text("Startseite")
                                .font(.system(size: 22, weight: .bold))
                        }
                    }
                    .foregroundColor(.white.opacity(0.7))

                    Spacer()

                    // Right: Kalender (dimmed)
                    Button(action: { navigateToCalendar = true }) {
                        VStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 55))
                            Text("Kalender")
                                .font(.system(size: 22, weight: .bold))
                        }
                    }
                    .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(Color(red: 35/255, green: 150/255, blue: 185/255))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30))
                .offset(y: 35)
                .ignoresSafeArea(edges: .bottom)
            , alignment: .bottom)
            .navigationDestination(isPresented: $navigateToStartseite) {
                Startseite()
                    .environmentObject(store)
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
                    .environmentObject(store)
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView100()
            }
        }
    }
}

private struct Header: View {
    var body: some View {
        ZStack {
            HeaderBackground()
            
            HStack(spacing: 8) {
                Image(systemName: "pills.circle")
                    .font(.system(size: 46, weight: .regular))
                    .foregroundStyle(Color(hex: 0x229EBC))
                Text("Eingetragene\nMedikamente")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x219EBC))
            }
            .padding(.top, 24)
        }
        .frame(height: 180)
    }
}

private struct HeaderBackground: View {
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: 0, y: height * 0.65))
                path.addQuadCurve(
                    to: CGPoint(x: width, y: height * 0.65),
                    control: CGPoint(x: width / 2, y: height * 1.05)
                )
                path.addLine(to: CGPoint(x: width, y: 0))
                path.closeSubpath()
            }
            .fill(Color(hex: 0xA9E5F3))
        }
    }
}

private struct MedicationCard: View {
    var time: Date
    var name: String
    var details: String?
    var isActive: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(time, style: .time)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x000000))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x023047))
                if let details, !details.isEmpty {
                    Text(details)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color(hex: 0x000000))
                }
            }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .trailing) {
                Image(systemName: isActive ? "timer" : "exclamationmark.circle")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isActive ? Color(hex: 0x0B6B7A) : Color.red)
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .overlay(
            HStack(spacing: 12) {
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x7A8A90))
            }
            .padding(.trailing, 12)
            .padding(.top, 8), alignment: .top
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Medikament: \(name), Zeit: \(time.formatted(date: .omitted, time: .shortened))")
    }
}

private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

#Preview {
    UebersichtView()
        .environmentObject(MedicationStore())
}

