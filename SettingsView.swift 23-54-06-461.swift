//
//  SettingsView.swift
//  MedReminder
//
//  Created by Simav  on 14.03.26.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                VStack(spacing: 0) {
                    
                    NavigationLink(destination: KontoView()) {
                        settingsRow(icon: "person.circle", title: "Konto", color: .black)
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.4))
                    
                    Button(action: {}) {
                        settingsRow(icon: "questionmark.circle", title: "Hilfe", color: .black)
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.4))
                    
                    Button(action: {}) {
                        settingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Abmelden", color: .red)
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.4))
                    
                    Button(action: {}) {
                        settingsRow(icon: "trash", title: "Konto löschen", color: .red)
                    }
                    
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                
                Spacer()
            }
            
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
        }
    }
    
    
    func settingsRow(icon: String, title: String, color: Color) -> some View {
        HStack {
            
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 32)
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}


#Preview {
    SettingsView()
}

