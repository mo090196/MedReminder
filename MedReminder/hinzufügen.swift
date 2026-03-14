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
    @State private var time: Date = .now
    @State private var frequency: String = ""
    
    @State private var selectedWeekdays: Set<Int> = [] // 0 = Montag, 6 = Sonntag (angepasst)
    
    @State private var nameEdited: Bool = false
    @State private var startDateEdited: Bool = false
    @State private var timeEdited: Bool = false
    @State private var frequencyEdited: Bool = false
    
    @State private var showSummary = false
    @State private var lastSummary: MedicationSummary? = nil
    
    struct MedicationSummary: Identifiable {
        let id = UUID()
        let name: String
        let note: String?
        let startDate: Date
        let time: Date
        let frequency: String
        let weekdays: Set<Int>
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 33/255, green: 158/255, blue: 188/255),
                    Color(red: 170/255, green: 225/255, blue: 245/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Form {
                Section("Medikament") {
                    TextField("Name", text: $name, onEditingChanged: { editing in
                        if !editing { nameEdited = true }
                    })
                    .modifier(RequiredFieldModifier(isInvalid: name.isEmpty && nameEdited))
                    
                    TextField("Notiz (optional)", text: $note)
                    
                    DatePicker("Beginn", selection: $startDate, displayedComponents: .date)
                        .onChange(of: startDate) { _ in startDateEdited = true }
                    // entfernt RequiredFieldModifier für startDate
                }
                
                Section("Erinnerung") {
                    DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
                        .onChange(of: time) { _ in timeEdited = true }
                    // entfernt RequiredFieldModifier für time
                    
                    Picker("Häufigkeit", selection: $frequency) {
                        Text("Bitte wählen").tag("")
                        Text("Täglich").tag("daily")
                        Text("Alle 2 Tage").tag("every2Days")
                        Text("Nur einmal").tag("once")
                        Text("An bestimmten Wochentagen").tag("weekdays")
                    }
                    .onChange(of: frequency) { newValue in
                        frequencyEdited = true
                        if newValue != "weekdays" {
                            selectedWeekdays.removeAll()
                        }
                    }
                    .modifier(RequiredFieldModifier(isInvalid: frequencyEdited && frequency.isEmpty))
                }
                
                if frequency == "weekdays" {
                    Section("Wochentage") {
                        WeekdaysLiquidGlassSelection(selectedWeekdays: $selectedWeekdays)
                    }
                }
                
                Section {
                    Button(action: {
                        nameEdited = true
                        startDateEdited = true
                        timeEdited = true
                        if frequency.isEmpty { frequencyEdited = true }
                        
                        guard !name.isEmpty, startDateEdited, timeEdited, !frequency.isEmpty else { return }
                        
                        let med = saveMedication()  // Make sure this returns the Medication object
                        savedMedication = med
                    }) {
                        Text("Speichern")
                            .bold()
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }               }
            }
            .scrollContentBackground(.hidden)
            .environment(\.locale, Locale(identifier: "de_DE"))
        }
        .navigationTitle("Neues Medikament")
        .toolbarTitleDisplayMode(.automatic)
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
    let summary: HinzufügenView.MedicationSummary
    
    // Manuell definierte Wochentagsinitialen in deutscher Reihenfolge Montag=0 ... Sonntag=6
    private let weekdayInitials: [String] = ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 33/255, green: 158/255, blue: 188/255),
                    Color(red: 170/255, green: 225/255, blue: 245/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Medikamentenerinnerung")
                    .font(.title.bold())
                    .padding(.top)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Name: \(summary.name)").fontWeight(.semibold)
                    if let note = summary.note {
                        Text("Notiz: \(note)")
                    }
                    Text("Beginn: \(summary.startDate, formatter: dateFormatter)")
                    Text("Uhrzeit: \(summary.time, formatter: timeFormatter)")
                    Text("Häufigkeit: \(frequencyDisplay(for: summary.frequency))")
                    if !summary.weekdays.isEmpty {
                        // Die Indizes beziehen sich auf Montag=0 ... Sonntag=6
                        let days = summary.weekdays.sorted().map { weekdayInitials[$0] }.joined(separator: ", ")
                        Text("Wochentage: \(days)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                
                Button(action: {
                    // Hier kann die eigentliche Speicher- oder Abschlusslogik ergänzt werden
                }) {
                    Text("Speichern")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                .padding(.top, 32)

                Spacer()
            }
            .padding()
        }
    }
    // Hilfsfunktionen und Formatter
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }
    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
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

