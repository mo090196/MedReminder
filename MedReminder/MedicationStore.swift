//
//  MedicationStore.swift
//  MedReminder
//
//  Created by Simav  on 25.04.26.
//

import Foundation
import SwiftUI
import Combine

final class MedicationStore: ObservableObject {
    @Published var medications: [Medication] = []

    struct Medication: Identifiable {
        let id = UUID()
        var time: Date
        var name: String
        var details: String?
        var startDate: Date
        var endDate: Date?
        var frequency: String
        var weekdays: Set<Int>
        var takenDates: [Date]
        var isTaken: Bool = false

        func isScheduled(on date: Date) -> Bool {
            let calendar = Calendar.current
            let targetDay = calendar.startOfDay(for: date)
            let startDay = calendar.startOfDay(for: startDate)

            guard targetDay >= startDay else { return false }

            if let endDate = endDate, targetDay > calendar.startOfDay(for: endDate) {
                return false
            }

            switch frequency {
            case "daily":
                return true
            case "every2Days":
                let daysDiff = calendar.dateComponents([.day], from: startDay, to: targetDay).day ?? 0
                return daysDiff % 2 == 0
            case "once":
                return calendar.isDate(date, inSameDayAs: startDate)
            case "weekdays":
                let mapped: Int
                switch calendar.component(.weekday, from: date) {
                case 1:  mapped = 6  // Sunday
                case 2:  mapped = 0  // Monday
                case 3:  mapped = 1  // Tuesday
                case 4:  mapped = 2  // Wednesday
                case 5:  mapped = 3  // Thursday
                case 6:  mapped = 4  // Friday
                case 7:  mapped = 5  // Saturday
                default: mapped = 0
                }
                return weekdays.contains(mapped)
            default:
                return false
            }
        }

        func isTaken(on date: Date) -> Bool {
            let calendar = Calendar.current
            return takenDates.contains { calendar.isDate($0, inSameDayAs: date) }
        }
    }
}
