import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var medicationStore: MedicationStore
    @State private var selectedDate: Date = .now
    @State private var showingDetail: IntakeDetailItem? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                content
            }
            .navigationTitle("Kalender")
            .navigationBarTitleDisplayMode(.inline)
                    .sheet(item: $showingDetail) { item in
                        IntakeDetailSheet(
                            date: item.date,
                            medications: medicationStore.medications
                        )
                        .presentationDetents([.fraction(0.3), .medium])
                    }        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .imageScale(.large)
                Text("Kalender")
                    .font(.title2).bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 12)

            Text(formattedSelectedDateTitle(selectedDate))
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .background(
            LinearGradient(colors: [Color(.systemTeal).opacity(0.15), .clear], startPoint: .top, endPoint: .bottom)
        )
    }

    private var content: some View {
        VStack(spacing: 16) {
            MonthHeader(date: selectedDate) { direction in
                withAnimation(.easeInOut) {
                    selectedDate = calendar.date(byAdding: .month, value: direction, to: selectedDate) ?? selectedDate
                }
            }
            .padding(.horizontal)

            WeekdayHeader()
                .padding(.horizontal)

            CalendarMonthGrid(monthFor: selectedDate) { date in
                showingDetail = IntakeDetailItem(date: date)
            }
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Abbrechen")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                } label: {
                    Text("Fertig")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.systemTeal))
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemGroupedBackground))
    }

    private func formattedSelectedDateTitle(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.setLocalizedDateFormatFromTemplate("EEE, MMM d")
        return formatter.string(from: date)
    }

    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "de_DE")
        return cal
    }()

    private func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
}


private struct MonthHeader: View {
    let date: Date
    let onChange: (Int) -> Void
    private let calendar = Calendar.current

    init(date: Date, onChange: @escaping (Int) -> Void) {
        self.date = date
        self.onChange = onChange
    }

    var body: some View {
        HStack {
            Button { onChange(-1) } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            Text(monthYearString(date))
                .font(.headline)
            Spacer()
            Button { onChange(1) } label: {
                Image(systemName: "chevron.right")
            }
        }
    }

    private func monthYearString(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.setLocalizedDateFormatFromTemplate("LLLL yyyy")
        return f.string(from: date)
    }
}

private struct WeekdayHeader: View {
    private let symbols: [String] = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "de_DE")
        return cal.shortStandaloneWeekdaySymbols
    }()

    var body: some View {
        HStack {
            ForEach(symbols, id: \.self) { s in
                Text(s)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

private struct CalendarMonthGrid: View {
    let monthFor: Date
    let onTapDay: (Date) -> Void

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "de_DE")
        return cal
    }

    var body: some View {
        let comps = calendar.dateComponents([.year, .month], from: monthFor)
        let monthStart = calendar.date(from: comps) ?? monthFor
        let daysRange = calendar.range(of: .day, in: .month, for: monthStart) ?? 1..<31
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leadingEmpty = (firstWeekday - calendar.firstWeekday + 7) % 7

        let totalCells = leadingEmpty + daysRange.count
        let rows = Int(ceil(Double(totalCells) / 7.0))

        VStack(spacing: 8) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { col in
                        let index = row * 7 + col
                        if index < leadingEmpty || index >= totalCells {
                            Spacer().frame(maxWidth: .infinity)
                        } else {
                            let day = index - leadingEmpty + 1
                            let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) ?? monthStart
                            DayCell(date: date) {
                                onTapDay(date)
                            }
                        }
                    }
                }
            }
        }
    }
}

    private struct DayCell: View {
        let date: Date
        let tap: () -> Void

        var body: some View {
            Button(action: tap) {
                Text("\(dayNumber(date))")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }

        private func dayNumber(_ date: Date) -> String {
            let d = Calendar.current.component(.day, from: date)
            return String(d)
        }
    }

private struct IntakeDetailItem: Identifiable, Equatable {
    let id: Date
    let date: Date
    init(date: Date) {
        let day = Calendar.current.startOfDay(for: date)
        self.id = day
        self.date = day
    }
}
    
    private struct IntakeDetailSheet: View, Identifiable {
        let id = UUID()
        let date: Date
        let medications: [MedicationStore.Medication]

        private var scheduledMedications: [MedicationStore.Medication] {
            medications.filter { $0.isScheduled(on: date) }
        }

        var body: some View {
            VStack(spacing: 12) {
                Capsule()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)

                Text(title)
                    .font(.headline)

                if scheduledMedications.isEmpty {
                    Text("Für diesen Tag sind keine Medikamente eingeplant.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(scheduledMedications) { med in
                        Text(message(for: med))
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()
            }
            .padding()
        }

        private var title: String {
            let f = DateFormatter()
            f.locale = Locale(identifier: "de_DE")
            f.setLocalizedDateFormatFromTemplate("EEEE, d. MMMM yyyy")
            return f.string(from: date)
        }

        private func message(for med: MedicationStore.Medication) -> String {
            if med.isTaken(on: date) {
                return "\(med.name) wurde an diesem Tag eingenommen."
            } else {
                return "\(med.name) wurde an diesem Tag nicht eingenommen."
            }
        }
    }

    #Preview {
        CalendarView()
            .environmentObject(MedicationStore())
    }
