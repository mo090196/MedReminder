//
//  KontoView100.swift
//  MedReminder
//
//  Created by Simav  on 09.04.26.
//
import SwiftUI

struct KontoView100: View {
    @Environment(\.dismiss) private var dismiss
    
    // Aktuelle Kontoinformationen
    @State private var rolle: String = "Betreuer"
    @State private var email: String = "yllidinaj07@gmail.com"
    @State private var password: String = "12345678"
    
    // Neue Werte
    @State private var neueEmail: String = ""
    @State private var neuesPasswort: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // HEADER mit eigenem Back-Button
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
                    
                    Text("Konto")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "person.circle")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 25)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                // Info Felder
                VStack(spacing: 15) {
                    infoRow(title: "Rolle", iconName: "person.crop.circle", value: rolle)
                    infoRow(title: "Email-Adresse", iconName: "envelope.fill", value: email)
                    infoRow(title: "Passwort", iconName: "lock.fill", value: String(repeating: "*", count: password.count))
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Divider().padding(.vertical, 20)
                
                // Email ändern
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email ändern")
                        .font(.system(size: 20, weight: .bold))
                    
                    TextField("Neue Email eingeben", text: $neueEmail)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    Button {
                        if !neueEmail.isEmpty {
                            email = neueEmail
                            neueEmail = ""
                        }
                    } label: {
                        Text("Email speichern")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)  // Textfarbe schwarz
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray5))  // Heller Grauton
                            )
                    }
                }
                .padding(.horizontal, 20)
                
                Divider().padding(.vertical, 20)
                
                // Passwort ändern
                VStack(alignment: .leading, spacing: 12) {
                    Text("Passwort ändern")
                        .font(.system(size: 20, weight: .bold))
                    
                    SecureField("Neues Passwort eingeben", text: $neuesPasswort)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    Button {
                        if !neuesPasswort.isEmpty {
                            password = neuesPasswort
                            neuesPasswort = ""
                        }
                    } label: {
                        Text("Passwort speichern")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)  // Textfarbe schwarz
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray5))  // Heller Grauton
                            )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true) // verhindert doppelten Back-Button
    }
    
    // MARK: - Info Row
    @ViewBuilder
    private func infoRow(title: String, iconName: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)  // Textfarbe schwarz
            
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 22))
                    .foregroundColor(.black)  // Icons schwarz
                
                Text(value)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)  // Text schwarz
                
                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.systemGray5))  // Heller Grauton für die Buttons
            )
        }
    }
}

#Preview {
    KontoView100()
}

