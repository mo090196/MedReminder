//
//  Übersicht.swift
//  MedReminder
//
//  Created by Simav  on 09.04.26.
//


import SwiftUI

struct UebersichtView: View {
    @EnvironmentObject private var medicationStore: MedicationStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 227/255, green: 250/255, blue: 255/255)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 36, height: 36)
                                .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                                .overlay(Circle().stroke(Color(UIColor.separator), lineWidth: 0.5))
                        }

                        Spacer()

                        Text("Übersicht")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.primary)

                        Spacer()

                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    Divider().padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 16) {
                            if medicationStore.medications.isEmpty {
                                Text("Noch keine Medikamente vorhanden")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 40)
                            } else {
                                ForEach(medicationStore.medications) { med in
                                    MedicationOverviewCard(med: med)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

private struct MedicationOverviewCard: View {
    let med: MedicationStore.Medication

    private func frequencyText(_ freq: String) -> String {
        switch freq {
        case "daily": return "Täglich"
        case "every2Days": return "Alle 2 Tage"
        case "once": return "Nur einmal"
        case "weekdays": return "An bestimmten Wochentagen"
        default: return freq
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(med.name)
                    .font(.title3.weight(.bold))
                    .foregroundColor(Color(red: 0.03, green: 0.26, blue: 0.33))

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                    Text(med.time.formatted(date: .omitted, time: .shortened))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(red: 0.0, green: 0.6, blue: 0.75))
                .clipShape(Capsule())
            }

            if let details = med.details, !details.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "text.bubble")
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: "repeat")
                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                Text(frequencyText(med.frequency))
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                Text("Beginn: \(med.startDate.formatted(date: .long, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }

            if let endDate = med.endDate {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundColor(Color(red: 0.0, green: 0.6, blue: 0.75))
                    Text("Ende: \(endDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }

            HStack(spacing: 8) {
                Image(systemName: med.isTaken ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(med.isTaken ? .green : .orange)
                Text(med.isTaken ? "Heute eingenommen" : "Noch nicht eingenommen")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(med.isTaken ? .green : .orange)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    UebersichtView()
        .environmentObject(MedicationStore())
}
