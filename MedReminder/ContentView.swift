//
//  ContentView.swift
//  MedReminder
//
//  Created by TA622 on 17.01.26.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash: Bool = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)),
                                            removal: .opacity.combined(with: .move(edge: .bottom))))
            } else {
                NavigationStack {
                    WelcomeScreen()
                }
                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .bottom)),
                                        removal: .opacity))
            }
        }
        .task {
            // kurze Verzögerung, dann animierter Übergang zum Onboarding
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 Sekunde
            withAnimation(.easeInOut(duration: 1.0)) {
                showSplash = false
            }
        }
    }
}

private struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 33/255, green: 158/255, blue: 188/255)
            .ignoresSafeArea()

            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 10)

                Text("MedReminder")
                    .font(.custom("Poppins", size: 44))
                    .shadow(radius: 50)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

private struct WelcomeScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(red: 0.86, green: 0.97, blue: 0.99),
                Color(red: 33/255, green: 158/255, blue: 188/255)
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(radius: 10)


                Text("MedReminder")
                    .font(.custom("Poppins", size: 36))
                    .foregroundColor(.white)
                    .shadow(radius: 20)

                Text("Egal wann – immer rechtzeitig erinnert werden!")
                    .font(.system(size: 16, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink(destination: RoleSelectionScreen()) {
                        RoundedCTA(title: "Konto erstellen")
                    }

                    NavigationLink(destination: AuthChoiceScreen()) {
                        RoundedCTA(title: "Anmelden", style: .secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}

private struct AuthChoiceScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(red: 0.86, green: 0.97, blue: 0.99),
                Color(red: 33/255, green: 158/255, blue: 188/255)
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Konto erstellen")
                    .font(.custom("Poppins", size: 24))
                    .foregroundStyle(.white)
                    .padding(.top, 16)

                Spacer()

                VStack(spacing: 16) {
                    Text("Bitte wählen Sie aus.")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)

                    Text("Sind Sie die Person, die selbstständig Medikamente einnimmt?")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                }

                Spacer()

                VStack(spacing: 16) {
                    NavigationLink(destination: RoleSelectionScreen()) {
                        RoundedCTA(title: "Konto erstellen")
                    }
                    NavigationLink(destination: RoleSelectionScreen()) {
                        RoundedCTA(title: "Anmelden", style: .secondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct RoleSelectionScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [
                Color(red: 0.86, green: 0.97, blue: 0.99),
                Color(red: 33/255, green: 158/255, blue: 188/255)
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Text("Konto erstellen")
                        .font(.custom("Poppins", size: 20))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()

                VStack(spacing: 14) {
                    Text("Bitte wählen sie aus.")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)

                    RoleCard(
                        title: "selbstständiger\nEinnehmer",
                        subtitle: "Sind Sie die Person, die selbstständig Medikamente einnimmt?",
                        actionTitle: "Auswählen"
                    ) {}

                    RoleCard(
                        title: "Betreuer",
                        subtitle: "Sind Sie die Person, die jemand anderen bei der Einnahme unterstützt?",
                        actionTitle: "Auswählen"
                    ) {}
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.9))

            Button(action: action) {
                RoundedCTA(title: actionTitle)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 6)
        )
    }
}

private struct RoundedCTA: View {
    enum Style { case primary, secondary }
    var title: String
    var style: Style = .primary

    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(style == .primary ? .white : Color(red: 1.0, green: 0.48, blue: 0.0))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Group {
                    if style == .primary {
                        Capsule()
                            .fill(Color(red: 1.0, green: 0.48, blue: 0.0))
                    } else {
                        Capsule()
                            .stroke(Color(red: 1.0, green: 0.48, blue: 0.0), lineWidth: 2)
                    }
                }
            )
            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}


#Preview {
    ContentView()
}
