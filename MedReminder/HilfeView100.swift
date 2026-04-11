import SwiftUI

struct HilfeView100: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateTo: Ziel?
    
    enum Ziel: Identifiable {
        case medikamente, kalender, konto
        var id: Int { hashValue }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // HEADER
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color(UIColor.separator), lineWidth: 0.5)
                            )
                    }
                    
                    Spacer()
                    
                    Text("Hilfe")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 25)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                Divider().padding(.vertical, 10)
                
                // ✅ Buttons direkt unter dem Divider
                VStack(spacing: 16) {
                    
                    actionButton(iconName: "pills.fill", text: "Medikamente hinzufügen") {
                        navigateTo = .medikamente
                    }
                    
                    actionButton(iconName: "calendar", text: "Kalender") {
                        navigateTo = .kalender
                    }
                    
                    actionButton(iconName: "person.2.fill", text: "Konto & Rollen") {
                        navigateTo = .konto
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        
        // Navigation
        .background(
            NavigationLink(
                destination: destinationView(),
                isActive: Binding(
                    get: { navigateTo != nil },
                    set: { if !$0 { navigateTo = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    @ViewBuilder
    private func destinationView() -> some View {
        switch navigateTo {
        case .medikamente:
            HilfeMedikamenteHinzufügen100()
        case .kalender:
            HilfeKalender100()
        case .konto:
            HilfeKontoRollen100()
        case .none:
            EmptyView()
        }
    }
    
    private func actionButton(iconName: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.black)

                Text(text)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray5))
            )
        }
    }
}

#Preview {
    HilfeView100()
}
