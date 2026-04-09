import SwiftUI
import SwiftData
import Foundation

struct HinzufügenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var savedMedication: Medication? = nil
    
    //Eingaben
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var startDate: Date = .now
    @State private var endDate: Date? = nil
    @State private var time: Date = .now
    @State private var frequency: String = ""
    
    @State private var selectedWeekdays: Set<Int> = [] // 0 = Montag, 6 = Sonntag (angepasst)
    
    @State private var nameEdited: Bool = false
    @State private var startDateEdited: Bool = false
    @State private var timeEdited: Bool = false
    @State private var frequencyEdited: Bool = false
    
    @State private var showSummary = false
    @State private var lastSummary: MedicationSummary? = nil
    
    @State private var showingFrequencySheet = false
    @State private var showingStartDateSheet = false
    @State private var showingEndDateSheet = false
    @State private var goHome = false
    
    struct MedicationSummary: Identifiable {
        let id = UUID()
        let name: String
        let note: String?
        let startDate: Date
        let time: Date
        let frequency: String
        let weekdays: Set<Int>
    }
    
    // Formatter und Hilfsfunktionen für diese View
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateStyle = .long
        return f
    }

    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.timeStyle = .short
        return f
    }

    private func frequencyDisplay(for freq: String) -> String {
        switch freq {
        case "daily": return "Täglich"
        case "every2Days": return "Alle 2 Tage"
        case "once": return "Nur einmal"
        case "weekdays": return "An bestimmten Wochentagen"
        default: return freq
        }
    }
    
    private func displayFrequencyForCapsule(_ freq: String) -> String {
        switch freq {
        case "daily": return "Jeden Tag"
        case "every2Days": return "Alle 2 Tage"
        case "once": return "Nur einmal"
        case "weekdays": return "An bestimmten Wochentagen"
        default: return freq
        }
    }
    
    private func startDateCapsuleText() -> String {
        return dateFormatter.string(from: startDate)
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.82, green: 0.95, blue: 0.97) // helles cyan
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    NavigationLink(destination: Startseite(), isActive: $goHome) { EmptyView() }

                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color(red: 0.80, green: 0.94, blue: 0.96)) // leicht aufgehellt, ohne Schatten
                            .frame(height: 65)

                        Circle()
                            .fill(Color(red: 0.92, green: 0.96, blue: 0.97))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "pills.fill")
                                    .font(.system(size: 35, weight: .semibold))
                                    .foregroundStyle(Color.orange)
                            )
                    }
                    .padding(.horizontal)

                    // TextField mit neuem Hintergrund
                    HStack(spacing: 8) {
                        TextField("Medikamenten eingeben…", text: $name, onEditingChanged: { editing in
                            if !editing { nameEdited = true }
                        })
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .padding(.vertical, 12)
                        .padding(.leading, 16)

                        Button {
                            // Optional: show a small explanation or validation info
                        } label: {
                            Image(systemName: name.isEmpty && nameEdited ? "exclamationmark.circle" : "info.circle")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(name.isEmpty && nameEdited ? .red : .secondary)
                                .padding(.trailing, 12)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(red: 0.88, green: 0.96, blue: 0.97))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(name.isEmpty && nameEdited ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    
                    // Häufigkeit Header
                    HStack {
                        Text("Häufigkeit")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0.03, green: 0.26, blue: 0.33))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Frequency capsule button
                    Button {
                        // Toggle a simple picker sheet
                        showingFrequencySheet = true
                    } label: {
                        HStack {
                            Text(frequency.isEmpty ? "Bitte wählen" : displayFrequencyForCapsule(frequency))
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.0, green: 0.6, blue: 0.75)) // türkis wie im Bild
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                        )
                    }
                    .padding(.horizontal)

                    // Beginndatum Header
                    HStack {
                        Text("Beginndatum")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0.03, green: 0.26, blue: 0.33))
                        Spacer()
                    }
                    .padding(.horizontal)

                    // Start date capsule button
                    Button {
                        showingStartDateSheet = true
                    } label: {
                        HStack {
                            Text(startDateCapsuleText())
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.0, green: 0.6, blue: 0.75))
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                        )
                    }
                    .padding(.horizontal)

                    // Enddatum Header
                    HStack {
                        Text("Enddatum")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0.03, green: 0.26, blue: 0.33))
                        Spacer()
                    }
                    .padding(.horizontal)

                    // End date capsule button
                    Button {
                        showingEndDateSheet = true
                    } label: {
                        HStack {
                            Text(endDate != nil ? endDate!.formatted(date: .long, time: .omitted) : "Kein Enddatum")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.0, green: 0.6, blue: 0.75))
                                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                        )
                    }
                    .contextMenu {
                        if endDate != nil {
                            Button(role: .destructive) { endDate = nil } label: {
                                Label("Enddatum entfernen", systemImage: "trash")
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Time picker inline styled similar to the screenshot context
                    VStack(spacing: 8) {
                        HStack {
                            Text("Uhrzeit")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: time) { _ in timeEdited = true }
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(red: 0.88, green: 0.96, blue: 0.97))
                        )
                    }
                    .padding(.horizontal)
                    
                    // Zweite Hinweis-/Notiz-Zeile im selben Stil
                    HStack(spacing: 8) {
                        TextField("Hinweis (optional)", text: $note)
                            .textInputAutocapitalization(.sentences)
                            .autocorrectionDisabled(false)
                            .padding(.vertical, 12)
                            .padding(.leading, 16)

                        Button {
                            // Optional: Info für Notizfeld
                        } label: {
                            Image(systemName: "info.circle")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.trailing, 12)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(red: 0.88, green: 0.96, blue: 0.97))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.clear, lineWidth: 2)
                    )
                    .padding(.horizontal)

                    if frequency == "weekdays" {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Wochentage")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            WeekdaysLiquidGlassSelection(selectedWeekdays: $selectedWeekdays)
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 0)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.88, green: 0.96, blue: 0.97))
                        .frame(height: 8)
                        .padding(.horizontal)
                }
            }
        }
        .environment(\.locale, Locale(identifier: "de_DE"))
        .navigationTitle("Neues Medikament")
        .toolbarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { goHome = true }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color(red: 0.0, green: 0.6, blue: 0.75))
                    
                }
            }
        }
        .sheet(isPresented: $showingFrequencySheet) {
            NavigationStack {
                List {
                    Section(footer: Text("Wähle, wie oft du erinnert werden möchtest.")) {
                        Button("Jeden Tag") { frequency = "daily"; frequencyEdited = true; selectedWeekdays.removeAll(); showingFrequencySheet = false }
                        Button("Alle 2 Tage") { frequency = "every2Days"; frequencyEdited = true; selectedWeekdays.removeAll(); showingFrequencySheet = false }
                        Button("Nur einmal") { frequency = "once"; frequencyEdited = true; selectedWeekdays.removeAll(); showingFrequencySheet = false }
                        Button("An bestimmten Wochentagen") { frequency = "weekdays"; frequencyEdited = true; showingFrequencySheet = false }
                    }
                }
                .navigationTitle("Häufigkeit wählen")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingStartDateSheet) {
            NavigationStack {
                DatePicker("Beginn", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .onChange(of: startDate) { _ in startDateEdited = true }
                    .padding(.horizontal)
                    .navigationTitle("Beginn wählen")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingEndDateSheet) {
            NavigationStack {
                VStack {
                    DatePicker("Ende", selection: Binding(
                        get: { endDate ?? Date() },
                        set: { endDate = $0 }
                    ), displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .padding(.horizontal)

                    if endDate != nil {
                        Button(role: .destructive) { endDate = nil } label: {
                            Label("Enddatum entfernen", systemImage: "trash")
                        }
                        .padding(.top)
                    }
                }
                .navigationTitle("Ende wählen")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium, .large])
        }
        .navigationDestination(isPresented: $showSummary) {
            if let summary = lastSummary {
                MedicationSummaryView(summary: summary)
            }
        }
        .navigationDestination(item: $savedMedication) { med in
            MedicationSummaryView(
                summary: HinzufügenView.MedicationSummary(
                    name: med.name,
                    note: med.note,
                    startDate: med.startDate,
                    time: time,
                    frequency: frequency,
                    weekdays: selectedWeekdays
                )
            )
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                nameEdited = true
                startDateEdited = true
                timeEdited = true
                if frequency.isEmpty { frequencyEdited = true }

                guard !name.isEmpty, startDateEdited, timeEdited, !frequency.isEmpty else { return }

                let med = saveMedication()
                savedMedication = med
            }) {
                Text("Weiter")
                    .bold()
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .background(.clear)
        }
    }
    
    private func saveMedication() -> Medication {
        let med = Medication(
            name: name.trimmingCharacters(in: .whitespaces),
            note: note.isEmpty ? nil : note,
            startDate: startDate
        )
        
        let comps = Calendar.current.dateComponents([.hour, .minute], from: time)
        let schedule = MedicationSchedule(
            medication: med,
            timeHour: comps.hour ?? 8,
            timeMinute: comps.minute ?? 0,
            frequency: frequency,
            startDate: startDate
        )
        med.schedules.append(schedule)
        
        context.insert(med)
        try? context.save()
        
        return med
    }
}

struct MedicationSummary: Identifiable {
    let id = UUID()
    let name: String
    let note: String?
    let startDate: Date
    let time: Date
    let frequency: String
    let weekdays: Set<Int>
}

struct WeekdaysLiquidGlassSelection: View {
    @Binding var selectedWeekdays: Set<Int>
    // Manuell definierte Wochentagsinitialen in deutscher Reihenfolge Montag=0 ... Sonntag=6
    private let weekdayInitials: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<weekdayInitials.count, id: \.self) { idx in
                Button(action: {
                    if selectedWeekdays.contains(idx) {
                        selectedWeekdays.remove(idx)
                    } else {
                        selectedWeekdays.insert(idx)
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.clear)
                            .frame(width: 36, height: 36)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(selectedWeekdays.contains(idx) ? Color.accentColor : .clear, lineWidth: 2)
                            )
                        Text(weekdayInitials[idx])
                            .font(.headline)
                            .foregroundColor(selectedWeekdays.contains(idx) ? .accentColor : .primary)
                    }
                }
                .buttonStyle(.plain)
                .shadow(radius: 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 8)
    }
}

struct MedicationSummaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var goHome = false
    
    let summary: HinzufügenView.MedicationSummary
    
    // Manuell definierte Wochentagsinitialen in deutscher Reihenfolge Montag=0 ... Sonntag=6
    private let weekdayInitials: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    private func displayFrequency(_ freq: String) -> String {
        switch freq {
        case "daily": return "Täglich"
        case "every2Days": return "Alle 2 Tage"
        case "once": return "Nur einmal"
        case "weekdays": return "An bestimmten Wochentagen"
        default: return freq
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.82, green: 0.95, blue: 0.97)
                .ignoresSafeArea()

            VStack {
                NavigationLink(destination: Startseite(), isActive: $goHome) { EmptyView() }

                Spacer(minLength: 24)

                // Karte
                VStack(spacing: 0) {
                    // Header in Türkis mit weißem Titel
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Medikamentenerinnerung")
                            .font(.title2.weight(.bold))
                            .foregroundColor(.white)
                        Text("Medikament")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                        Text(summary.name)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(red: 0.0, green: 0.6, blue: 0.75))

                    // Inhalt auf hellem Hintergrund
                    VStack(alignment: .leading, spacing: 16) {
                        // Hinweis
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "text.bubble")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hinweis")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(summary.note?.isEmpty == false ? summary.note! : "-")
                                    .font(.body)
                            }
                            Spacer()
                            Image(systemName: summary.note?.isEmpty == false ? "checkmark.circle" : "exclamationmark.circle")
                                .foregroundColor(summary.note?.isEmpty == false ? .green : .red)
                        }

                        // Häufigkeit
                        HStack(spacing: 12) {
                            Image(systemName: "repeat")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Häufigkeit")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(displayFrequency(summary.frequency))
                                    .font(.body)
                            }
                            Spacer()
                        }

                        // Beginndatum
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Beginndatum")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(summary.startDate.formatted(date: .long, time: .omitted))
                                    .font(.body)
                            }
                            Spacer()
                        }

                        // Enddatum (im Bild: "nie")
                        HStack(spacing: 12) {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Enddatum")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("nie")
                                    .font(.body)
                            }
                            Spacer()
                        }

                        // Uhrzeit
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Uhrzeit")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(summary.time.formatted(date: .omitted, time: .shortened))
                                    .font(.body)
                            }
                            Spacer()
                        }

                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.92, green: 0.96, blue: 0.97))
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.horizontal)

                Spacer(minLength: 24)

                // Unterer orangener Button
                Button(action: {
                    goHome = true
                }) {
                    Text("Erinnerung hinzufügen")
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal)

                Spacer(minLength: 16)
            }
        }
    }
}

struct RequiredFieldModifier: ViewModifier {
    let isInvalid: Bool
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isInvalid ? Color.red : Color.clear, lineWidth: 2)
            )
    }
}

#Preview {
    NavigationStack {
        HinzufügenView()
    }
}

