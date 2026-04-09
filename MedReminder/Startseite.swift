import SwiftUI

struct Startseite: View {
    @EnvironmentObject private var medicationStore: MedicationStore
    @State private var navigateToHinzufuegen = false
    @State private var navigateToCalendar = false
    @State private var navigateToUebersicht = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 227/255, green: 250/255, blue: 255/255)
                    .ignoresSafeArea()
                    .overlay(
                Circle()
                       .fill(Color(red: 33/255, green: 158/255, blue: 188/255))
                       .frame(width: 1000, height: 1000)
                       .offset(x: -300, y: -845),
                alignment: .topLeading
                )

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

                        // Orange Plus-Button → HinzufügenView
                        Button(action: { navigateToHinzufuegen = true }) {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.system(size:60))
                                Image(systemName: "circle")
                                    .foregroundColor(.white)
                                    .font(.system(size: 45))
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Einnahmen ScrollView
                    ScrollView {
                        VStack(spacing: 25) {
                            if medicationStore.medications.isEmpty {
                                Text("Noch keine Medikamente eingetragen")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(medicationStore.medications) { med in
                                    EinnahmeKarte(
                                        name: med.name,
                                        zeit: med.time.formatted(date: .omitted, time: .shortened)
                                    )
                                }
                            }
                        }
                        .padding(15)
                    }
                    

                    // Navigation unten
                    HStack {
                        Button(action: { navigateToUebersicht = true }) {
                            VStack(spacing: 4) {
                                Image(systemName:"list.bullet.rectangle")
                                        .font(.system(size: 55))
                                Text("Übersicht")
                                        .font(.system(size: 22, weight: .bold))
                                                  }
                                              }
                                        .foregroundColor(.white.opacity(0.7))
                                              
                        Spacer()
                        VStack{
                            Image(systemName: "house.fill")
                                .font(.system(size: 60, weight: .bold))
                            Text("Startseite")
                                .font(.system(size: 22, weight: .bold))
                        }
                        .foregroundColor(.white)

                        
                        Spacer()
                        
                        // Calendar button → navigates to CalendarView
                        Button(action: { navigateToCalendar = true }) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 55))
                                Text("Kalender")
                                    .font(.system(size: 22, weight: .bold))
                            }
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(Color(red: 35/255, green: 150/255, blue: 185/255))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30))
                    .offset(y: 35)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationBarBackButtonHidden(true)
            // NavigationLinks für programmatische Navigation
            .navigationDestination(isPresented: $navigateToHinzufuegen) {
                HinzufügenView()
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
            }
            .navigationDestination(isPresented: $navigateToUebersicht) {
                UebersichtView()
            }
            }
        }
    }
    //  Einnahme-Karte
    struct EinnahmeKarte: View {
        let name: String
        let zeit: String
        @State private var isTaken: Bool = false
        
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
                    withAnimation(.interpolatingSpring(stiffness: 220, damping: 18)) {
                        isTaken = true
                    }
                }) {
                    Text(isTaken ? "eingenommen" : "jetzt einnehmen")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .padding(.horizontal)
                        .background(Color.orange)
                        .font(.system(size: 25, weight: .bold))
                }
                .disabled(isTaken)
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 4)
            .scaleEffect(isTaken ? 0.98 : 1.0)
            .opacity(isTaken ? 0.5 : 1.0)
            .animation(.interpolatingSpring(stiffness: 220, damping: 18), value: isTaken)
        }
    }
    

    
    
    //  Vorschau
    struct Startseite_Previews: PreviewProvider {
        static var previews: some View {
            Startseite()
        }
    }
    
#Preview {
    Startseite()
}

