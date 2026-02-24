//
//  Startseite.swift
//  MedReminder
//
//  Created by TA602 on 19.01.26.
//

import SwiftUI

struct Startseite: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 35/255, green: 150/255, blue: 185/255),
                    Color(red: 170/255, green: 225/255, blue: 245/255)

                ],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()

            
            VStack(spacing: 20) {
                
                // Kopfbereich
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Heute")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Montag, Dezember 8")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Oranger Plus-Button rechts
                    Button(action: { print("Neues Medikament hinzufügen")
                    }) {
                        ZStack {
                            // Orange gefüllte Kugel (größer)
                            Image(systemName: "circle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 55))
                            
                            // Weißer Kreis (etwas kleiner)
                            Image(systemName: "circle")
                                .foregroundColor(.white)
                                .font(.system(size: 49))
                            
                            // Plus-Zeichen (leicht kleiner)
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 27))
                                .fontWeight(.bold)
                        }
                        .accessibilityLabel("Medikament hinzufügen")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                
                
                //  Einnahmen
                ScrollView {
                    VStack(spacing: 15) {
                        EinnahmeKarte(name: "Ibuprofen", zeit: "13:30")
                        EinnahmeKarte(name: "Vitamine", zeit: "16:30")
                        EinnahmeKarte(name: "Insulin", zeit: "19:30")
                        
                    }
                    .padding(5)
                }
                
                //  Navigation unten
                HStack {
                    NavButton(icon:"list.bullet.rectangle",text: "Übersicht", isActive: false)
                        .font(.system(size: 55, weight:.semibold))
                    
                    Spacer()
                    
                    NavButton(icon: "house.fill", text:"Einnahmen", isActive: true)
                    
                    Spacer()
                        .font(.system(size: 55))
                    
                    NavButton(icon: "calendar", text:"Kalender",isActive: false)
                }
                .font(.system(size: 55))
                .padding(13) .background (Color(red: 35/255, green: 150/255, blue: 185/255)) .cornerRadius(16) } .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    //  Einnahme-Karte
    struct EinnahmeKarte: View {
        let name: String
        let zeit: String
        
        var body: some View {
            VStack(spacing: 10) {
                HStack {
                    Text(name)
                        .font(.system(size: 25, weight: .semibold))
                    
                    Spacer()
                    
                    HStack(spacing: 8)
                    { ZStack
                        { Image(systemName: "circle.fill")
                                .foregroundColor(.black)
                                .font(.system(size: 22))
                            
                            Image(systemName: "clock")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        
                        Text(zeit)
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .padding(25)
                
                Button(action: {
                    print("\(name) eingenommen")
                }) {
                    Text("jetzt einnehmen")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .padding(.horizontal)
                        .background(Color.orange)
                        .font(.system(size: 25, weight: .bold))
                }
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 4)
        }
    }
    
    // Button unten
    struct NavButton: View {
        let icon: String
        let text: String
        let isActive: Bool   // 👈 NEU
        
        var body: some View {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(
                        size: isActive ? 70: 58,   // 👈 Größe
                        weight: .semibold
                    ))
                
                Text(text)
                    .font(.system(
                        size: isActive ? 22:20,   // 👈 Textgröße
                        weight: .bold
                    ))
            }
            .frame(height: 90)
            .padding(3)
            .foregroundColor(
                isActive
                ? .white
                : .white.opacity(0.7)   // 👈 verblassen
            )
        }
    }
    
    
    //  Vorschau
    struct Startseite_Previews: PreviewProvider {
        static var previews: some View {
            Startseite()
        }
    }
    
}
#Preview {
    Startseite()
}

