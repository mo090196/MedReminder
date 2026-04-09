import Combine
import SwiftUI

final class MedicationStore: ObservableObject {
    struct Medication: Identifiable, Equatable {
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
    
    @Published var medications: [Medication] = []
}

struct UebersichtView: View {
    @EnvironmentObject private var store: MedicationStore
    var body: some View {
        Group {
            VStack(spacing: 0) {
                Header()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(store.medications.isEmpty ? ExampleMedications.meds : store.medications) { med in
                            MedicationCard(
                                time: med.time,
                                name: med.name,
                                details: med.details,
                                isActive: med.isActive
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                
                BottomTabBar()
            }
            .background(Color(hex: 0xE3FAFF))
            .ignoresSafeArea(edges: .top)
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

private struct BottomTabBar: View {
    var body: some View {
        HStack(spacing: 32) {
            TabItem(title: "Übersicht", systemImage: "list.bullet.rectangle")
            TabItem(title: "Einnahmen", systemImage: "pills")
            TabItem(title: "Einstellungen", systemImage: "gearshape")
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Color(hex: 0x219EBC))
        .frame(maxWidth: .infinity, alignment: .bottom)
        .ignoresSafeArea(edges: .bottom)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 24,
                topTrailingRadius: 24,
                style: .continuous
            )
        )
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: -2)
    }
}

private struct TabItem: View {
    var title: String
    var systemImage: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color(hex: 0x0B6B7A))
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(hex: 0x0B6B7A))
        }
        .frame(maxWidth: .infinity)
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

struct ExampleMedications {
    
    static let meds: [MedicationStore.Medication] = [
        MedicationStore.Medication(
            time: Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: Date())!,
            name: "Ibuprofen",
            details: nil,
            isActive: true
        ),
        
        MedicationStore.Medication(
            time: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!,
            name: "Vitamine",
            details: nil,
            isActive: true
        ),
        
        MedicationStore.Medication(
            time: Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!,
            name: "Insulin",
            details: "Vor dem Essen",
            isActive: false
        )
    ]
}


#Preview {
    UebersichtView()
        .environmentObject(MedicationStore())
}

