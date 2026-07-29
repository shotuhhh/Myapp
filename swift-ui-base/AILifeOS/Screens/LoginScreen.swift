//
//  LoginScreen.swift
//  AI Life OS — Premium Login
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    @State private var email = "alex.chen@ailifeos.app"
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showSignUp = false
    @State private var orbPulse = false
    @State private var emailFocused = false
    @State private var passwordFocused = false

    var isValid: Bool { email.contains("@") && password.count >= 6 }

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light

        ZStack {
            FuturisticBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer(minLength: 44)

                    // Logo orb
                    VStack(spacing: 16) {
                        ZStack {
                            BreathingGlow(color: theme.accent, size: 160)
                            EnergyPulseRing(color: theme.accentSecondary, size: 110)
                            Circle()
                                .fill(LinearGradient(
                                    colors: [theme.gradientStart, theme.gradientEnd],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ))
                                .frame(width: 88, height: 88)
                                .glow(theme.accent, radius: 18, intensity: 0.65)
                            Image(systemName: "sparkles")
                                .font(.system(size: 38, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(height: 180)

                        Text("AI Life OS")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundColor(theme.primaryText)
                        Text("Your Personal Intelligence Engine")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(theme.secondaryText)
                    }
                    .padding(.bottom, 36)

                    // Form card
                    VStack(spacing: 14) {
                        loginField(
                            "Email",
                            text: $email,
                            icon: "envelope.fill",
                            identifier: "EmailTextField",
                            isFocused: emailFocused,
                            theme: theme
                        )

                        loginField(
                            "Password",
                            text: $password,
                            icon: "lock.fill",
                            identifier: "PasswordTextField",
                            secure: true,
                            isFocused: passwordFocused,
                            theme: theme
                        )

                        if showError {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(theme.error)
                                Text(errorMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(theme.error)
                            }
                            .padding(10)
                            .background(theme.error.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(.horizontal, AppTheme.padding)

                    Spacer(minLength: 28)

                    VStack(spacing: 12) {
                        // Sign in button
                        Button(action: signIn) {
                            ZStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    HStack {
                                        Text("Sign In")
                                            .font(.system(size: 17, weight: .bold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                LinearGradient(
                                    colors: isValid && !isLoading
                                        ? [theme.gradientStart, theme.gradientEnd]
                                        : [theme.border, theme.border],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .glow(isValid ? theme.accent : .clear, radius: 10, intensity: 0.4)
                            .opacity(isValid && !isLoading ? 1 : 0.55)
                        }
                        .buttonStyle(PressableButtonStyle())
                        .disabled(!isValid || isLoading)
                        .accessibility(identifier: "SignInButton")
                        .padding(.horizontal, AppTheme.padding)
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isValid)

                        // Demo login
                        Button(action: demoLogin) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 13))
                                Text("Demo Login")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(theme.accent)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(theme.accent.opacity(colorScheme == .dark ? 0.08 : 0.06))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(theme.accent.opacity(0.25), lineWidth: 1))
                        }
                        .buttonStyle(PressableButtonStyle())
                        .padding(.horizontal, AppTheme.padding)

                        // Sign up link
                        Button(action: { showSignUp = true }) {
                            Text("No account? Create one")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(theme.accent)
                        }
                        .accessibility(identifier: "GoToSignUpLink")
                    }

                    Spacer(minLength: 36)
                }
            }
            .blur(radius: isLoading ? 3 : 0)
            .animation(.easeInOut(duration: 0.25), value: isLoading)
        }
        .sheet(isPresented: $showSignUp) {
            SignUpSheetView()
        }
    }

    private func loginField(
        _ placeholder: String,
        text: Binding<String>,
        icon: String,
        identifier: String,
        secure: Bool = false,
        isFocused: Bool = false,
        theme: ThemeColors
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(isFocused ? theme.accent : theme.secondaryText)
                .frame(width: 20)
            if secure {
                SecureField(placeholder, text: text)
                    .accessibility(identifier: identifier)
                    .foregroundColor(theme.primaryText)
            } else {
                TextField(placeholder, text: text)
                    .accessibility(identifier: identifier)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(theme.primaryText)
            }
        }
        .padding(15)
        .glassSurface(cornerRadius: 14)
    }

    private func signIn() {
        isLoading = true
        showError = false
        HapticFeedback.light()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if isValid {
                HapticFeedback.success()
                appState.login()
            } else {
                withAnimation {
                    errorMessage = "Please enter a valid email and password."
                    showError = true
                }
            }
        }
    }

    private func demoLogin() {
        password = "demo123"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { signIn() }
    }
}

struct SignUpSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var isValid: Bool {
        email.contains("@") && password.count >= 6 && password == confirmPassword
    }

    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        NavigationView {
            ZStack {
                FuturisticBackground()
                VStack(spacing: 14) {
                    Group {
                        TextField("Email", text: $email)
                            .accessibility(identifier: "EmailTextField")
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        SecureField("Password", text: $password)
                            .accessibility(identifier: "PasswordTextField")
                        SecureField("Confirm Password", text: $confirmPassword)
                            .accessibility(identifier: "ConfirmPasswordTextField")
                    }
                    .padding()
                    .glassSurface(cornerRadius: 14)
                    .foregroundColor(theme.primaryText)

                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Create Account")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: isValid ? [theme.gradientStart, theme.gradientEnd] : [theme.border, theme.border],
                                    startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                    }
                    .disabled(!isValid)
                    .accessibility(identifier: "SignUpButton")

                    Spacer()
                }
                .padding(AppTheme.padding)
            }
            .navigationTitle("Create Account")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(theme.accent))
        }
    }
}
