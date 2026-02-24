import SwiftUI
import SwiftData

struct HinzufügenView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    // Eingaben
    @State private var name: String = ""
    @State private var note: String = ""
    @State private var startDate: Date = .now
    @State private var time: Date = .now
    @State private var frequency: String = "daily"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Medikament") {
                    TextField("Name", text: $name)
                    TextField("Notiz (optional)", text: $note)
                    DatePicker("Beginn", selection: $startDate, displayedComponents: .date)
                }

                Section("Erinnerung") {
                    DatePicker("Uhrzeit", selection: $time, displayedComponents: .hourAndMinute)
                    Picker("Häufigkeit", selection: $frequency) {
                        Text("Täglich").tag("daily")
                        Text("Alle 2 Tage").tag("every2Days")
                        Text("Nur einmal").tag("once")
                    }
                }

                Section {
                    Button("Speichern", action: saveMedication)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Medikament hinzufügen")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func saveMedication() {
        // Medikament anlegen
        let med = Medication(
            name: name.trimmingCharacters(in: .whitespaces),
            note: note.isEmpty ? nil : note,
            startDate: startDate
        )

        // Uhrzeit in Stunden/Minuten umwandeln
        let comps = Calendar.current.dateComponents([.hour, .minute], from: time)

        let schedule = MedicationSchedule(
            medication: med,
            timeHour: comps.hour ?? 8,
            timeMinute: comps.minute ?? 0,
            frequency: frequency,
            startDate: startDate
        )

        med.schedules.append(schedule)

        // in DB speichern
        context.insert(med)

        do {
            try context.save()
            dismiss()
        } catch {
            // Fehlermeldung
            print("Fehler beim Speichern: \(error)")
        }
    }
}
#Preview {
    NavigationStack {
        HinzufügenView()
    }
}

