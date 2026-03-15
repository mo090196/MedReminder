// Übersicht.swift
// Enthält die Übersicht-Ansicht und UI-Bausteine für die Medikamentenliste.
// Kommentare teilen den Code in Aufgabenblöcke auf und markieren Farbverwendungen.

import Combine
import SwiftUI

// MARK: Datenmodell (State & Synchronisation)
// Verantwortlich für die Speicherung und Synchronisation der Medikationseinträge
// zwischen Home und Übersicht (per Environment-Object injiziert).
final class MedicationStore: ObservableObject {
    struct Medication: Identifiable, Equatable {
        // Einzelner Eintrag (Zeit, Name, optionale Details, Aktiv-Status)
        let id: UUID
        var time: Date
        var name: String
        var details: String?
        var isActive: Bool
        
        init(id: UUID = UUID(), time: Date, name: String, details: String? = nil, isActive: Bool = true) {
            self.id = id
            self.time = time
            self.name = name
            self.details = details
            self.isActive = isActive
        }
    }
    
    // Beobachtete Liste aller Medikamente (UI reagiert auf Änderungen)
    @Published var medications: [Medication] = []
}
// MARK: - Übersicht View

// MARK: Hauptbildschirm "Übersicht"
// Layout: Header (Kurven-Hintergrund) + Scroll-Liste mit Karten + untere Tab-Bar
struct UebersichtView: View {
    // Zustands- und Datenabhängigkeiten
    @EnvironmentObject private var injectedStore: MedicationStore
    @StateObject private var localStore = MedicationStore()
    
    // Vereinheitlichte Referenz auf den injizierten Store
    private var store: MedicationStore { injectedStore }
    
    var body: some View {
        Group {
            VStack(spacing: 0) {
                // Oberer Bereich: Header
                Header()
                
                // Mittlerer Bereich: Scrollbare Liste der Medikamentenkarten
                ScrollView {
                    VStack(spacing: 16) { // ABSTAND: Vertikaler Abstand zwischen Karten (wirkt auf Gesamthöhe der Liste, nicht einzelne Kartenhöhe)
                        ForEach(store.medications) { med in
                            // Darstellung eines einzelnen Eintrags als Karte
                            MedicationCard(
                                time: med.time,
                                name: med.name,
                                details: med.details,
                                isActive: med.isActive
                            )
                        }
                        // Platzhalter, falls noch keine Einträge vorhanden sind (Demo-Inhalt)
                        if store.medications.isEmpty {
                            MedicationCard(
                                time: Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: Date()) ?? Date(),
                                name: "Beispielmedikament",
                                details: "Vor dem Essen",
                                isActive: true
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                
                // Unterer Bereich: Tab-Leiste (statisch/mok)
                BottomTabBar()
            }
            .background(Color(hex: 0xE3FAFF)) // FARBE: Seitenhintergrund (helles Blau) 0xE6F6F8
            .ignoresSafeArea(edges: .top)
        }
    }
}

// MARK: - Header
private struct Header: View {
    var body: some View {
        ZStack {
            // Hintergrund mit geschwungener Form
            HeaderBackground()
            
            HStack(spacing: 8) {
                Image(systemName: "pills.circle")
                    .font(.system(size: 46, weight: .regular))
                    .foregroundStyle(Color(hex: 0x229EBC)) // FARBE: Icon (Türkis) 0x229EBC
                Text("Eingetragene\nMedikamente")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x219EBC)) // FARBE: Header-Text (dunkles Blaugrün) 0x219EBC
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
            .fill(Color(hex: 0xA9E5F3)) // FARBE: Header-Hintergrund (helles Blau) 0xA9E5F3
        }
    }
}

// MARK: - Medication Card
private struct MedicationCard: View {
    var time: Date
    var name: String
    var details: String?
    var isActive: Bool
    
    // Karte: Zeit (links), Name/Details (mittig), Status/Menu (rechts)
    var body: some View {
        HStack(alignment: .top, spacing: 12) { // LAYOUT: Horizontales Layout der Karte (beeinflusst Höhe durch Inhalt)
            // Time
            VStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(time, style: .time)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x000000)) // FARBE: Zeit-Text 0x000000
            }
            
            // Name & details
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x023047)) // FARBE: Name-Text 0x023047
                if let details, !details.isEmpty {
                    Text(details)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color(hex: 0x000000)) // FARBE: Details-Text 0x000000
                }
            }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // BREITE: Mittlere Spalte dehnt sich – bestimmt Kartenbreite im HStack
            
            // Trailing menu/status icon
            VStack(alignment: .trailing) {
                Image(systemName: isActive ? "timer" : "exclamationmark.circle")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(isActive ? Color(hex: 0x0B6B7A) : Color.red) // FARBE: Status-Icon aktiv 0x0B6B7A / inaktiv rot
                Spacer(minLength: 0)
            }
        }
        .padding(16) // GRÖSSE: Innenabstand der Karte (erhöht effektive Höhe)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous) // FORM: Eckenradius, keine feste Höhe/Breite
                .fill(.white) // FARBE: Karten-Hintergrund weiß
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4) // FARBE: Schatten schwarz 8%
        )
        // GRÖSSE: Keine feste Höhe gesetzt – passt sich Inhalt + Padding an
        .overlay(
            HStack(spacing: 12) {
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color(hex: 0x7A8A90)) // FARBE: Ellipsis-Icon (Grau-Blau) 0x7A8A90
            }
            .padding(.trailing, 12)
            .padding(.top, 8), alignment: .top
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Medikament: \(name), Zeit: \(time.formatted(date: .omitted, time: .shortened))")
    }
}

// MARK: - Bottom Tab Bar (mock to match screenshot)
// Statische/visuelle Tab-Leiste (ohne Navigation)
private struct BottomTabBar: View {
    var body: some View {
        HStack(spacing: 32) {
            TabItem(title: "Übersicht", systemImage: "list.bullet.rectangle")
            TabItem(title: "Einnahmen", systemImage: "pills")
            TabItem(title: "Einstellungen", systemImage: "gearshape")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color(hex: 0x219EBC)) // FARBE: Tab-Bar Hintergrund dunkelTürkis
        .frame(maxWidth: .infinity, alignment: .bottom) // volle Breite
        .ignoresSafeArea(edges: .bottom)                // bis zum unteren Bildschirmrand
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24,
                //bottomLeadingRadius: 0,
                //bottomTrailingRadius: 0,
                style: .continuous
            )
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: -2) // FARBE: Schatten schwarz 6%
        //.padding(.horizontal, 16)
        //.padding(.bottom, 8)
    }
}

// Einzelner Tab-Eintrag (Icon + Titel)
private struct TabItem: View {
    var title: String
    var systemImage: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: 0x0B6B7A)) // FARBE: Tab-Icon 0x0B6B7A
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: 0x0B6B7A)) // FARBE: Tab-Titel 0x0B6B7A
        }
        .frame(maxWidth: .infinity) // BREITE: füllt verfügbare Breite (nicht relevant für Karten)
    }
}

// MARK: Farb-Helfer
// Erlaubt das Erstellen von SwiftUI Color aus hexadezimalen RGB-Werten.
private extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self = Color(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// Vorschau mit Beispiel-Daten
#Preview {
    let store = MedicationStore()
    store.medications = [
        .init(time: Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: Date())!, name: "Ibuprofen", details: nil, isActive: true),
        .init(time: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!, name: "Vitamine", details: nil, isActive: true),
        .init(time: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!, name: "Insulin", details: "Vor dem Essen", isActive: false)
    ]
    return UebersichtView()
        .environmentObject(store)
}

