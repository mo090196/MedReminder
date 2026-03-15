//
//  HilfeView100.swift
//  MedReminder
//
//  Created by Simav  on 15.03.26.
//

import SwiftUI

struct HilfeView100: View {
    @Environment(\.dismiss) private var dismiss
    
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
                
                // Die drei Buttons
                VStack(spacing: 16) {
                    actionButton(iconName: "pills.fill", text: "Medikamente hinzufügen") {
                        // TODO: Aktion für Medikamente hinzufügen
                    }
                    
                    actionButton(iconName: "calendar", text: "Kalender") {
                        // TODO: Aktion für Kalender
                    }
                    
                    actionButton(iconName: "person.2.fill", text: "Konto & Rollen") {
                        // TODO: Aktion für Konto & Rollen
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .navigationBarBackButtonHidden(true) // Verhindert doppelten Back-Button
    }
    
    // MARK: - Action Button
    @ViewBuilder
    private func actionButton(iconName: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.black)  // Icons schwarz

                Text(text)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)  // Text schwarz
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)  // Chevron Pfeile schwarz
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray5))  // Heller Grauton für die Buttons
            )
        }
    }
}

#Preview {
    HilfeView100()
}
