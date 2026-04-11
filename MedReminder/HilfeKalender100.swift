import SwiftUI

struct HilfeKalender100: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                header(title: "Kalender", icon: "calendar")
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Der Kalender zeigt die Einnahme der Medikamente.")
                    Text("1. Öffnen Sie den Kalender.")
                    Text("2. Wählen Sie einen Tag aus.")
                    Text("3. Sie sehen:")
                    Text("• Eingenommen grün")
                    Text("• Nicht eingenommen rot")
                    
                    Text("Wichtig:")
                        .font(.headline)
                    
                    Text("• Sie behalten den Überblick.")
                    Text("• Auch vergangene Tage sind sichtbar.")
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
