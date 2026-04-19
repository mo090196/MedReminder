import SwiftUI

struct Startseite: View {
    
    @EnvironmentObject private var userSession: UserSession
    
    private var todaysMedications: [MedicationStore.Medication] {
        medicationStore.medications.filter { $0.isScheduled(on: Date()) }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EEEE, d. MMMM"
        return formatter.string(from: Date()).capitalized
    }
    
    @EnvironmentObject private var medicationStore: MedicationStore
    @State private var navigateToCalendar = false
    @State private var navigateToUebersicht = false
    @State private var showHinzufuegen = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 227/255, green: 250/255, blue: 255/255)
                    .ignoresSafeArea()
                    .overlay(
                Circle()
                       .fill(Color(red: 33/255, green: 158/255, blue: 188/255))
                       .frame(width: 1000, height: 1000)
                       .offset(x: -300, y: -830),
                alignment: .topLeading
                )

                VStack(spacing: 20) {
                    // Kopfbereich
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Heute")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(formattedDate)                                .font(.system(size: 30, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Spacer()

                        if userSession.role.canAddMedication {
                            Button {
                                showHinzufuegen = true
                            } label: {
                                ZStack {
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 55))

                                    Image(systemName: "circle")
                                        .foregroundColor(.white)
                                        .font(.system(size: 48))

                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                        .font(.system(size: 25))
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Einnahmen ScrollView
                    ScrollView {
                        VStack(spacing: 25) {
                            if todaysMedications.isEmpty {
                                Text("Für heute keine Medikamente eingetragen")
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .padding(.top, 40)
                            } else {
                                ForEach(todaysMedications) { med in
                                    if let index = medicationStore.medications.firstIndex(where: { $0.id == med.id }) {
                                        EinnahmeKarte(med: $medicationStore.medications[index])
                                    }
                                }
                            }
                        }
                        .padding(15)
                    }
                    

                    // Navigation unten
                    HStack(spacing: 0) {
                        // Übersicht
                        Button(action: { navigateToUebersicht = true }) {
                            VStack(spacing: 4) {
                                Image(systemName:"list.bullet.rectangle")
                                        .font(.system(size: 38))
                                Text("Übersicht")
                                        .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.white.opacity(0.7))

                        // Startseite
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 38, weight: .bold))
                            Text("Startseite")
                                .font(.system(size: 18, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)

                        // Kalender
                        Button(action: { navigateToCalendar = true }) {
                            VStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 40))
                                Text("Kalender")
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top,7)
                    .padding(.all)
                    .padding(.bottom, 10)
                    .background(Color(red: 35/255, green: 150/255, blue: 185/255))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 30, topTrailingRadius: 30))
                    .offset(y: 35)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToCalendar) {
                CalendarView()
            }
            .navigationDestination(isPresented: $navigateToUebersicht) {
                UebersichtView()
            }
            .fullScreenCover(isPresented: $showHinzufuegen) {
                if userSession.role.canAddMedication {
                    NavigationStack {
                        HinzufügenView()
                            .environmentObject(medicationStore)
                            .environmentObject(userSession)
                    }
                }
            }
        }
    }
}

struct EinnahmeKarte: View {
    @Binding var med: MedicationStore.Medication

    private var isTakenToday: Bool {
        med.isTaken(on: Date())
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(med.name)
                    .font(.system(size: 25, weight: .semibold))

                Spacer()

                HStack(spacing: 8) {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 22))

                        Image(systemName: "clock")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }

                    Text(med.time.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 20, weight: .semibold))
                }
            }
            .padding(25)

            Button(action: {
                withAnimation(.interpolatingSpring(stiffness: 220, damping: 18)) {
                    med.markTaken(on: Date())
                }
            }) {
                Text(isTakenToday ? "eingenommen" : "jetzt einnehmen")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .padding(.horizontal)
                    .background(Color.orange)
                    .font(.system(size: 25, weight: .bold))
            }
            .disabled(isTakenToday)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .scaleEffect(isTakenToday ? 0.98 : 1.0)
        .opacity(isTakenToday ? 0.5 : 1.0)
        .animation(.interpolatingSpring(stiffness: 220, damping: 18), value: isTakenToday)
    }
}

#Preview {
    Startseite()
        .environmentObject(MedicationStore())
}
