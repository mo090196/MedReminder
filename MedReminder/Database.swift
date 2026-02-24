//
//  Database.swift
//  MedReminder
//
//  Created by uy on 19.02.26.
//

import SwiftData
import Foundation

// MARK: - Medication

@Model
final class Medication {
    var id: UUID = UUID()
    var name: String               // z.B. "Insulin"
    var note: String?              // z.B. "Vor dem Essen"
    var startDate: Date            // Beginn-Datum
    var isActive: Bool = true      // noch anzeigen?

    // 1 Medikament -> viele Pläne
    @Relationship(deleteRule: .cascade) 
    var schedules: [MedicationSchedule] = []

    init(name: String,
         note: String? = nil,
         startDate: Date = .now) {
        self.name = name
        self.note = note
        self.startDate = startDate
    }
}
// MARK: - MedicationSchedule
// Beschreibt, WANN das Medikament genommen werden soll.

@Model
final class MedicationSchedule {
    var id: UUID = UUID()
    var timeHour: Int              // 0–23
    var timeMinute: Int            // 0–59
    var frequency: String          // z.B. "daily", "every2Days", "weekdays"
    var startDate: Date            // ab wann dieser Plan gilt

    // viele Pläne gehören zu 1 Medikament
    var medication: Medication

    // 1 Plan -> viele konkrete Einnahmen (Dosen)
    @Relationship(deleteRule: .cascade)
    var doses: [MedicationDose] = []

    init(medication: Medication,
         timeHour: Int,
         timeMinute: Int,
         frequency: String,
         startDate: Date) {
        self.medication = medication
        self.timeHour = timeHour
        self.timeMinute = timeMinute
        self.frequency = frequency
        self.startDate = startDate
    }
}
// MARK: - MedicationDose
// Konkrete Einnahme an einem Datum (für Heute-Ansicht & Kalender).

enum DoseStatus: Int, Codable {
    case scheduled = 0   // geplant
    case taken    = 1    // eingenommen
    case missed   = 2    // verpasst
}

@Model
final class MedicationDose {
    var id: UUID = UUID()
    var scheduledDate: Date        // z.B. 17.01.2026 16:30
    var takenDate: Date?           // tatsächliche Zeit
    var statusRaw: Int             // Speicherung in Database

    var schedule: MedicationSchedule

    var status: DoseStatus {
        get { DoseStatus(rawValue: statusRaw) ?? .scheduled }
        set { statusRaw = newValue.rawValue }
    }

    init(schedule: MedicationSchedule,
         scheduledDate: Date,
         status: DoseStatus = .scheduled,
         takenDate: Date? = nil) {
        self.schedule = schedule
        self.scheduledDate = scheduledDate
        self.statusRaw = status.rawValue
        self.takenDate = takenDate
    }
}


