import SwiftUI

struct LoginScreen: View {
    @State private var showCreateAccount = false
    @State private var showSignIn = false
    var body: some View {
        NavigationStack {
            ZStack {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .white, location: 0.0),
                            .init(color: Color(white: 0.98), location: 0.15),
                            .init(color: Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    RadialGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.0)]),
                        center: .top,
                        startRadius: 0,
                        endRadius: 280
                    )
                    .ignoresSafeArea()
                }

                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 95, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 12)

                    Text("MedReminder")
                        .font(.system(size: 40, weight: .regular))
                        .foregroundStyle(Color(red: 33/255, green: 158/255, blue: 188/255))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                        .padding(.top, 20)

                    VStack(spacing: 2) {
                        Text("Egal wann - immer")
                        Text("rechtzeitig erinnert werden")
                    }
                    .font(.system(size: 20))
                    .foregroundStyle(Color(red: 34/255, green: 131/255, blue: 154/255))
                    .padding(.top, 10)

                    Spacer()

                    VStack(spacing: 8) {
                        Button(action: { showCreateAccount = true }) {
                            Text("Konto erstellen")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 280, height: 64)
                                .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                                .clipShape(Capsule())
                        }
                        Text("Sind Sie neu?")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .tracking(0.5)
                    }
                    .padding(.bottom, 24)

                    VStack(spacing: 8) {
                        Button(action: { showSignIn = true }) {
                            Text("Anmelden")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundStyle(.white)
                                .frame(width: 280, height: 64)
                                .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                                .clipShape(Capsule())
                        }
                        Text("Sie haben bereits ein Konto?")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                            .tracking(0.5)
                    }
                    .padding(.bottom, 80)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationDestination(isPresented: $showCreateAccount) {
                AccountRoleSelectionView()
            }
            .navigationDestination(isPresented: $showSignIn) {
                SignInRoleSelectionView()
            }
        }
    }
}

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isCreating: Bool = false
    @State private var selectedRole: RoleOption
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false

    enum RoleOption: String, CaseIterable, Identifiable {
        case einnehmer = "Selbstständiger Einnehmer"
        case betreuer = "Betreuer"
        case betreuterEinnehmer = "Betreuter Einnehmer"
        var id: String { rawValue }
    }
    
    init(selectedRole: RoleOption = .einnehmer) {
        _selectedRole = State(initialValue: selectedRole)
    }
    
    private var isEmailValid: Bool {
        email.contains("@")
    }

    private var isPasswordValid: Bool {
        let hasMinLength = password.count >= 8
        let hasDigit = password.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[@#!*?]", options: .regularExpression) != nil
        return hasMinLength && hasDigit && hasSpecial
    }
    
    private var doPasswordsMatch: Bool {
        confirmPassword.isEmpty ? true : (password == confirmPassword)
    }
    
    private var isFormValid: Bool {
        isEmailValid && isPasswordValid && (password == confirmPassword)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                Color(red: 0xF6/255, green: 0xF8/255, blue: 0xF9/255)
                    .ignoresSafeArea(edges: .top)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .stroke(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255), lineWidth: 2)
                            )
                    }
                    Spacer()
                    Text("Konto erstellen")
                        .font(.headline)
                        .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                    Spacer()
                    Rectangle().fill(Color.clear).frame(width: 24, height: 1)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("E-Mail")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    TextField("E-Mail Adresse eingeben", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke((!email.isEmpty && !isEmailValid) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !email.isEmpty && !isEmailValid {
                        Text("Bitte geben Sie eine gültige E-Mail-Adresse mit '@' ein.")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                    }

                    Text("Passwort")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Passwort eingeben", text: $password)
                            } else {
                                SecureField("Passwort eingeben", text: $password)
                            }
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke((!password.isEmpty && !isPasswordValid) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .textContentType(.oneTimeCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color(red: 0x77/255, green: 0x93/255, blue: 0x99/255))
                                .padding(.trailing, 24)
                        }
                    }
                    if !password.isEmpty && !isPasswordValid {
                        Text("Mindestens 8 Zeichen, eine Ziffer und eines der Zeichen @ # ! * ?")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                    }

                    Text("Passwort wiederholen")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    ZStack(alignment: .trailing) {
                        Group {
                            if showConfirmPassword {
                                TextField("Passwort wiederholen", text: $confirmPassword)
                            } else {
                                SecureField("Passwort wiederholen", text: $confirmPassword)
                            }
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke((!confirmPassword.isEmpty && password != confirmPassword) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .textContentType(.oneTimeCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color(red: 0x77/255, green: 0x93/255, blue: 0x99/255))
                                .padding(.trailing, 24)
                        }
                    }
                    if !confirmPassword.isEmpty && password != confirmPassword {
                        Text("Die Passwörter stimmen nicht überein.")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                    }

                    Text("App-Version")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    Menu {
                        Picker("App-Version", selection: $selectedRole) {
                            ForEach(RoleOption.allCases.filter { $0 != .betreuterEinnehmer }) { role in
                                Text(role.rawValue).tag(role)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedRole.rawValue)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255))
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)

                Button(action: createAccount) {
                    Text(isCreating ? "Erstelle Konto…" : "Konto erstellen")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill((isFormValid && !isCreating) ? Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255) : Color(red: 0xE9/255, green: 0xD3/255, blue: 0xB4/255))
                        )
                        .foregroundStyle(Color.white)
                }
                .disabled(!isFormValid || isCreating)
                .opacity((!isFormValid || isCreating) ? 0.6 : 1)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Color(red: 0xD4/255, green: 0xF2/255, blue: 0xF9/255)
                .ignoresSafeArea()
        )
    }

    private func createAccount() {
        guard isFormValid else { return }
        isCreating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isCreating = false
            dismiss()
        }
    }
}

struct AccountRoleSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToCreate: Bool = false
    @State private var selectedRoleToCreate: CreateAccountView.RoleOption = .einnehmer

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Color(red: 0xF6/255, green: 0xF8/255, blue: 0xF9/255)
                    .ignoresSafeArea(edges: .top)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .stroke(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255), lineWidth: 2)
                            )
                    }
                    Spacer()
                    Text("Konto erstellen")
                        .font(.headline)
                        .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                    Spacer()
                    Rectangle().fill(Color.clear).frame(width: 24, height: 1)
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)

            VStack(spacing: 52) {
                
                Text("Bitte wählen sie aus.")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255))
                    .padding(.top, 12)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 14) {
                    Button(action: {
                        selectedRoleToCreate = .einnehmer
                        navigateToCreate = true
                    }) {
                        Text("selbstständiger\nEinnehmer")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 280, height: 64)
                            .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                            .clipShape(Capsule())
                    }
                    Text("Sind Sie die Person, die\nselbständig Medikamente einnimmt?")
                        .font(.footnote)
                        .foregroundStyle(Color(red: 0x85/255, green: 0x92/255, blue: 0x99/255))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
                
                VStack(spacing: 14) {
                    Button(action: {
                        selectedRoleToCreate = .betreuer
                        navigateToCreate = true
                    }) {
                        Text("Betreuer")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 280, height: 64)
                            .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                            .clipShape(Capsule())
                    }
                    Text("Sind Sie die Person, die einen\nEinnehmer beobachtet?\nDiese App-Version verknüpft den Betreuer\nmit dem betreuten Einnehmer.")
                        .font(.footnote)
                        .foregroundStyle(Color(red: 0x85/255, green: 0x92/255, blue: 0x99/255))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Color(red: 0xD4/255, green: 0xF2/255, blue: 0xF9/255)
                .ignoresSafeArea()
        )
        .navigationDestination(isPresented: $navigateToCreate) { CreateAccountView(selectedRole: selectedRoleToCreate) }
    }
}

struct SignInRoleSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToSignIn: Bool = false
    @State private var selectedRoleToSignIn: CreateAccountView.RoleOption = .einnehmer

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Color(red: 0xF6/255, green: 0xF8/255, blue: 0xF9/255)
                    .ignoresSafeArea(edges: .top)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .stroke(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255), lineWidth: 2)
                            )
                    }
                    Spacer()
                    Text("Anmelden")
                        .font(.headline)
                        .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                    Spacer()
                    Rectangle().fill(Color.clear).frame(width: 24, height: 1)
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)

            VStack(spacing: 52) {
                Text("Bitte wählen sie aus.")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255))
                    .padding(.top, 12)
                    .padding(.horizontal, 16)

                VStack(spacing: 14) {
                    Button(action: {
                        selectedRoleToSignIn = .einnehmer
                        navigateToSignIn = true
                    }) {
                        Text("selbstständiger\nEinnehmer")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 280, height: 64)
                            .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                            .clipShape(Capsule())
                    }
                    Text("Sind Sie die Person, die\nselbständig Medikamente einnimmt?")
                        .font(.footnote)
                        .foregroundStyle(Color(red: 0x85/255, green: 0x92/255, blue: 0x99/255))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)

                VStack(spacing: 14) {
                    Button(action: {
                        selectedRoleToSignIn = .betreuer
                        navigateToSignIn = true
                    }) {
                        Text("Betreuer")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 280, height: 64)
                            .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                            .clipShape(Capsule())
                    }
                    Text("Sind Sie die Person, die einen\nEinnehmer beobachtet?\nDiese App-Version verknüpft den Betreuer\nmit dem betreuten Einnehmer.")
                        .font(.footnote)
                        .foregroundStyle(Color(red: 0x85/255, green: 0x92/255, blue: 0x99/255))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)

                VStack(spacing: 14) {
                    Button(action: {
                        // Reuse the einnehmer role for now; can be split later if needed
                        selectedRoleToSignIn = .betreuterEinnehmer
                        navigateToSignIn = true
                    }) {
                        Text("betreuter\nEinnehmer")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 280, height: 64)
                            .background(Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255))
                            .clipShape(Capsule())
                    }
                    Text("Sind Sie die Person, die von einem\nBetreuer beobachtet wird?")
                        .font(.footnote)
                        .foregroundStyle(Color(red: 0x85/255, green: 0x92/255, blue: 0x99/255))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Color(red: 0xD4/255, green: 0xF2/255, blue: 0xF9/255)
                .ignoresSafeArea()
        )
        .navigationDestination(isPresented: $navigateToSignIn) { SignInFormView(selectedRole: selectedRoleToSignIn) }
    }
}

struct SignInFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSigningIn: Bool = false
    @State private var selectedRole: CreateAccountView.RoleOption
    @State private var showPassword: Bool = false

    init(selectedRole: CreateAccountView.RoleOption = .einnehmer) {
        _selectedRole = State(initialValue: selectedRole)
    }

    private var isEmailValid: Bool { email.contains("@") }
    private var isPasswordEntered: Bool { !password.isEmpty }
    private var isPasswordValid: Bool {
        let hasMinLength = password.count >= 8
        let hasDigit = password.range(of: "\\d", options: .regularExpression) != nil
        let hasSpecial = password.range(of: "[@#!*?]", options: .regularExpression) != nil
        return hasMinLength && hasDigit && hasSpecial
    }
    private var isFormValid: Bool { isEmailValid && isPasswordValid }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(red: 0xF6/255, green: 0xF8/255, blue: 0xF9/255)
                    .ignoresSafeArea(edges: .top)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .stroke(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255), lineWidth: 2)
                            )
                    }
                    Spacer()
                    Text("Anmelden")
                        .font(.headline)
                        .foregroundStyle(Color(red: 0x00/255, green: 0x97/255, blue: 0xB2/255))
                    Spacer()
                    Rectangle().fill(Color.clear).frame(width: 24, height: 1)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("E-Mail")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    TextField("E-Mail Adresse eingeben", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke((!email.isEmpty && !isEmailValid) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if !email.isEmpty && !isEmailValid {
                        Text("Bitte geben Sie eine gültige E-Mail-Adresse mit '@' ein.")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                    }

                    Text("Passwort")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    ZStack(alignment: .trailing) {
                        Group {
                            if showPassword {
                                TextField("Passwort eingeben", text: $password)
                            } else {
                                SecureField("Passwort eingeben", text: $password)
                            }
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke((!password.isEmpty && !isPasswordValid) ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .textContentType(.oneTimeCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(Color(red: 0x77/255, green: 0x93/255, blue: 0x99/255))
                                .padding(.trailing, 24)
                        }
                    }
                    if !password.isEmpty && !isPasswordValid {
                        Text("Mindestens 8 Zeichen, eine Ziffer und eines der Zeichen @ # ! * ?")
                            .font(.footnote)
                            .foregroundStyle(Color.red)
                    }

                    Text("App-Version")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0x59/255, green: 0x5B/255, blue: 0x5C/255))
                    Menu {
                        Picker("App-Version", selection: $selectedRole) {
                            ForEach(CreateAccountView.RoleOption.allCases) { role in
                                Text(role.rawValue).tag(role)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedRole.rawValue)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255))
                        }
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(red: 0xB4/255, green: 0xE1/255, blue: 0xEB/255))
                        )
                        .frame(maxWidth: 560)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 24)

                Button(action: signIn) {
                    Text(isSigningIn ? "Melde an…" : "Anmelden")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill((isFormValid && !isSigningIn) ? Color(red: 0xFB/255, green: 0x85/255, blue: 0x00/255) : Color(red: 0xE9/255, green: 0xD3/255, blue: 0xB4/255))
                        )
                        .foregroundStyle(Color.white)
                }
                .disabled(!isFormValid || isSigningIn)
                .opacity((!isFormValid || isSigningIn) ? 0.6 : 1)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            Color(red: 0xD4/255, green: 0xF2/255, blue: 0xF9/255)
                .ignoresSafeArea()
        )
    }

    private func signIn() {
        guard isFormValid else { return }
        isSigningIn = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSigningIn = false
            dismiss()
        }
    }
}

#Preview {
    LoginScreen()
}

