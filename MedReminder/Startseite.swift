import SwiftUI

struct Startseite: View {
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
                            EinnahmeKarte(name: "Ibuprofen", zeit: "13:30")
                            EinnahmeKarte(name: "Vitamine", zeit: "16:30")
                            EinnahmeKarte(name: "Insulin", zeit: "19:30")
                        }
                        .padding(15)
                    }
                    

                    // Navigation unten
                    HStack {
                        Button(action: { navigateToUebersicht = true }) {
                            VStack(spacing: 4) {
                                Image(systemName:"list.bullet.rectangle")
                                        .font(.system(size: 50))
                                Text("Übersicht")
                                        .font(.system(size: 20, weight: .bold))
                                                  }
                                              }
                                        .foregroundColor(.white.opacity(0.7))
                                              
                        Spacer()
                        VStack{
                            Image(systemName: "house.fill")
                                .font(.system(size: 60, weight: .bold))
                            Text("Startseite")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .foregroundColor(.white)

                        
                        Spacer()
                        
                        // Calendar button → navigates to CalendarView
                        Button(action: { navigateToCalendar = true }) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 50))
                                Text("Kalender")
                                    .font(.system(size: 20, weight: .bold))
                            }
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(13)
                    .background(Color(red: 35/255, green: 150/255, blue: 185/255))
                    .cornerRadius(30)
                }
            }
            // NavigationLinks für programmatische Navigation
            .navigationDestination(isPresented: $navigateToHinzufuegen) {
                HinzufügenView()
            }
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
            }
            .navigationDestination(isPresented: $navigateToUebersicht) {
                UebersichtView().environmentObject(MedicationStore())
            }
            }
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
            .cornerRadius(20)
            .shadow(radius: 4)
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

