import SwiftUI

struct SettingsView100: View {
    @State private var showLogoutConfirmation = false
    @State private var showLogoutSuccess = false
    
    // Konto löschen Schritte
    @State private var showDeleteAccountStep1 = false // Erstes Alert
    @State private var showDeleteAccountStep2 = false // Passwort-Alert
    @State private var showDeleteAccountStep3 = false // Erfolgs-Alert
    
    @State private var passwordInput = "" // Passwortfeld
    
    // Für Demo: richtiges Passwort
    private let correctPassword = "12345678"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // HEADER mit Zurück-Button
                HStack {
                    Button {
                        // später verknüpfen
                        print("Zurück gedrückt")
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(Color(UIColor.secondarySystemBackground)))
                            .overlay(Circle().stroke(Color(UIColor.separator), lineWidth: 0.5))
                    }
                    
                    Spacer()
                    Text("Einstellungen")
                        .font(.system(size: 28, weight: .semibold))
                    Spacer()
                    
                    Image(systemName: "gearshape")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 25)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                VStack(spacing: 15) {
                    NavigationLink(destination: KontoView100()) {
                        settingsRow(iconName: "person.crop.circle", iconColor: .black, text: "Konto")
                    }
                    NavigationLink(destination: HilfeView100()) {
                        settingsRow(iconName: "questionmark.circle", iconColor: .black, text: "Hilfe")
                    }
                    
                    Button {
                        showLogoutConfirmation = true
                    } label: {
                        settingsRow(iconName: "rectangle.portrait.and.arrow.right", iconColor: .red, text: "Abmelden")
                    }
                    .confirmationDialog("Möchten Sie sich wirklich abmelden?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                        Button("Abmelden", role: .destructive) {
                            showLogoutSuccess = true
                        }
                        Button("Abbrechen", role: .cancel) { }
                    }
                    .alert("Abmeldung", isPresented: $showLogoutSuccess) {
                        Button("OK") { }
                    } message: {
                        Text("Sie haben sich erfolgreich abgemeldet")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer()
                
                // Roter Button unten: Konto löschen
                Button {
                    showDeleteAccountStep1 = true
                } label: {
                    destructiveRow(iconName: "trash", text: "Konto löschen")
                        .padding(.horizontal, 20)
                }
                // Schritt 1: Hinweis-Alert
                .alert("Möchten Sie Ihr Konto wirklich löschen?", isPresented: $showDeleteAccountStep1) {
                    Button("Fortfahren", role: .destructive) {
                        showDeleteAccountStep2 = true
                    }
                    Button("Abbrechen", role: .cancel) { }
                } message: {
                    Text("""
                        Beim Löschen des Kontos werden alle Daten dauerhaft entfernt.
                        Dies kann nicht rückgängig gemacht werden.
                        Betreuer verlieren den Zugriff auf betreute Personen.
                        Einnehmer sind für Betreuer nicht mehr sichtbar.
                        Bitte bestätigen Sie den Vorgang nur, wenn Sie sicher sind.
                        """)
                }
                
                // Schritt 2: Passwort-Alert
                .sheet(isPresented: $showDeleteAccountStep2) {
                    VStack(spacing: 05) {
                        Text("Geben Sie zum Bestätigen bitte Ihr Passwort ein:")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        SecureField("Passwort", text: $passwordInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 0) {
                            Button("Abbrechen") {
                                passwordInput = ""
                                showDeleteAccountStep2 = false
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            
                            Button("Konto löschen") {
                                if !passwordInput.isEmpty {
                                    // Passwortüberprüfung
                                    if passwordInput == correctPassword {
                                        passwordInput = ""
                                        showDeleteAccountStep2 = false
                                        showDeleteAccountStep3 = true
                                    } else {
                                        passwordInput = "" // Setzt Passwort zurück, bleibt aber im Sheet
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    .presentationDetents([.fraction(0.4)]) // Bottom Sheet
                }
                
                // Schritt 3: Erfolgs-Alert
                .alert("Konto gelöscht", isPresented: $showDeleteAccountStep3) {
                    Button("OK") { }
                } message: {
                    Text("Sie haben Ihr Konto erfolgreich endgültig gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.")
                }
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private func settingsRow(iconName: String, iconColor: Color, text: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)
            Text(text)
                .font(.system(size: 18))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    @ViewBuilder
    private func destructiveRow(iconName: String, text: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.red)
                .frame(width: 28, height: 28)
            Text(text)
                .font(.system(size: 18))
                .foregroundColor(.red)
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

#Preview {
    SettingsView100()
}
