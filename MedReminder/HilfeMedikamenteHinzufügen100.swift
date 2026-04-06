import SwiftUI

struct HilfeMedikamenteHinzufügen100: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                header(title: "Hinzufügen", icon: "pills.fill")
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Diese Funktion ist nur für den Angehörigen bzw. den Betreuer zugänglich.")
                    
                    
                    
                    Text("1. Öffnen Sie „Medikamente hinzufügen“.")
                    Text("2. Tippen Sie auf „Neues Medikament hinzufügen“.")
                    Text("3. Geben Sie Name, Uhrzeit und Menge ein.")
                    Text("4. Prüfen Sie alles in Ruhe.")
                    Text("5. Tippen Sie auf „Speichern“.")
                    
                    Text("Wichtig:")
                        .font(.headline)
                    
                    Text("• Medikamente erscheinen automatisch beim betreuten Einnehmer.")
                    Text("• Der betreute Einnehmer muss nichts eingeben.")
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
    
    private func header(title: String, icon: String) -> some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                    .overlay(Circle().stroke(Color(UIColor.separator), lineWidth: 0.5))
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 28, weight: .semibold))
            
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 25)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}
