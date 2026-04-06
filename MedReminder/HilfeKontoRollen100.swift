import SwiftUI

struct HilfeKontoRollen100: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                header(title: "Konto & Rollen", icon: "person.2.fill")
                
                Divider().padding(.vertical, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    
                    Text("Anmeldung:")
                        .font(.headline)
                    
                    Text("1. Mit einer E-Mail anmelden.")
                    Text("2. Erste Anmeldung = Angehöriger bzw. Betreuer.")
                    Text("3. Zweite Anmeldung = betreuter Einnehmer.")
                    Text("Der Betreuer bzw. der Anhgehörige und der betreute Einnehmer teilen eine E-Mail. Beim ersten Anmelden erscheint die Version des Betreuers und beim zweiten Anmelden mit der selben E-Mail erscheint die Version des betreuten Einnehmers. Somit sind beide Rollen miteinander verbunden.")
                    
                    Text("Diese beiden Rollen sind: der Betreuer bzw. der Angehörige und der betreute Einnehmer")
                    
                    Text("Rollen:")
                        .font(.headline)
                    
                    Text("Angehöriger bzw. Betreuer:")
                    Text("• Fügt Medikamente hinzu und hat somit den vollen Zugriff auf die Informationen des Einnehmers ")
                    
                    Text("betreuter Einnehmer:")
                    Text("• Wird erinnert und tippt nur auf „Einnehmen“")
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
