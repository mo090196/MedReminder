//  CalendarView.swift
//  MedReminder
//
//  Created by Assistant on 18.01.26.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: Date = .now

    // Simple demo data: map of day (startOfDay) -> taken(true)/missed(false)
    // In your app, replace this with real persistence from the home confirmation button.
    @State private var intakeStatus: [Date: Bool] = [:]

    // For popup
    @State private var showingDetail: IntakeDetailItem? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                content
            }
            .navigationTitle("Kalender")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .accessibilityLabel("Zurück")
                }
            }
            .onAppear(perform: preloadDemoData)
            .sheet(item: $showingDetail, content: { item in
                IntakeDetailSheet(date: item.date, status: statusFor(item.date))
                    .presentationDetents([.fraction(0.3), .medium])
            })
        }
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

            // Datumstitel analog Mockup (z. B. So, Jan 17)
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

            CalendarMonthGrid(monthFor: selectedDate, intakeStatus: intakeStatus, onTapDay: { date in
                showingDetail = IntakeDetailItem(date: date)
            })
            .padding(.horizontal)

            // Primäre Aktionen analog "Abbrechen" im Mockup
            HStack(spacing: 12) {
                Button(role: .cancel) {
                    dismiss()
                } label: {
                    Text("Abbrechen")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button {
                    // Platzhalter: hier könnte man z. B. ein Detail öffnen
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
        formatter.setLocalizedDateFormatFromTemplate("EEE, MMM d") // z. B. So, Jan 17
        return formatter.string(from: date)
    }

    // MARK: - Helpers

    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "de_DE")
        return cal
    }()

    private func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    private func statusFor(_ date: Date) -> Bool? {
        intakeStatus[startOfDay(date)]
    }

    private func preloadDemoData() {
        // Generate some demo statuses for current month
        let comps = calendar.dateComponents([.year, .month], from: selectedDate)
        guard let monthStart = calendar.date(from: comps),
              let range = calendar.range(of: .day, in: .month, for: monthStart) else { return }
        var dict: [Date: Bool] = [:]
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                // Demo rule: even days taken (green), odd days missed (red)
                dict[startOfDay(date)] = (day % 2 == 0)
            }
        }
        intakeStatus = dict
    }
}

// MARK: - Subviews

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
    let intakeStatus: [Date: Bool]
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
        let firstWeekday = calendar.component(.weekday, from: monthStart) // 1..7
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
                            DayCell(date: date, isInMonth: true, status: statusFor(date)) {
                                onTapDay(date)
                            }
                        }
                    }
                }
            }
        }
    }

    private func startOfDay(_ date: Date) -> Date { calendar.startOfDay(for: date) }

    private func statusFor(_ date: Date) -> Bool? {
        intakeStatus[startOfDay(date)]
    }
}

private struct DayCell: View {
    let date: Date
    let isInMonth: Bool
    let status: Bool? // true = taken(green), false = missed(red), nil = no data
    let tap: () -> Void

    var body: some View {
        Button(action: tap) {
            VStack(spacing: 4) {
                Text("\(dayNumber(date))")
                    .font(.body)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)

                // Small circle marker below the number
                Circle()
                    .fill(colorForStatus(status))
                    .frame(width: 8, height: 8)
                    .opacity(status == nil ? 0 : 1)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func dayNumber(_ date: Date) -> String {
        let d = Calendar.current.component(.day, from: date)
        return String(d)
    }

    private func colorForStatus(_ status: Bool?) -> Color {
        guard let status = status else { return .clear }
        return status ? .green : .red
    }
}

private struct IntakeDetailItem: Identifiable, Equatable {
    let id: Date
    let date: Date
    init(date: Date) {
        // Use startOfDay to ensure stable identity for the same calendar day
        let day = Calendar.current.startOfDay(for: date)
        self.id = day
        self.date = day
    }
}

private struct IntakeDetailSheet: View, Identifiable {
    let id = UUID()
    let date: Date
    let status: Bool?

    var body: some View {
        VStack(spacing: 12) {
            Capsule().fill(Color.secondary.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 8)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
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

    private var message: String {
        switch status {
        case .some(true):
            return "Die Einnahme wurde an diesem Tag bestätigt (grün)."
        case .some(false):
            return "Die Einnahme wurde an diesem Tag nicht durchgeführt (rot)."
        case .none:
            return "Keine Daten zur Einnahme für diesen Tag vorhanden."
        }
    }
}

#Preview {
    CalendarView()
}
