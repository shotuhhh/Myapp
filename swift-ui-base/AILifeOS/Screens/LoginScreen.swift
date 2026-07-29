//
//  LoginScreen.swift
//  AI Life OS
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
    
    var isValid: Bool {
        email.contains("@") && password.count >= 6
    }
    
    var body: some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [theme.gradientStart, theme.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 80, height: 80)
                        Image(systemName: "sparkles")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 48)
                    
                    Text("AI Life OS")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(theme.primaryText)
                    Text("Sign in to continue")
                        .font(.system(size: 15))
                        .foregroundColor(theme.secondaryText)
                }
                
                VStack(spacing: 14) {
                    loginField("Email", text: $email, icon: "envelope.fill", identifier: "EmailTextField")
                    loginField("Password", text: $password, icon: "lock.fill", identifier: "PasswordTextField", secure: true)
                }
                .padding(.horizontal, AppTheme.padding)
                
                if showError {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(theme.error)
                        .padding(.horizontal)
                }
                
                PremiumButton(isLoading ? "Signing in..." : "Sign In", icon: "arrow.right", action: signIn)
                    .padding(.horizontal, AppTheme.padding)
                    .disabled(!isValid || isLoading)
                    .accessibility(identifier: "SignInButton")
                    .opacity(isValid && !isLoading ? 1 : 0.55)
                
                Button(action: { showSignUp = true }) {
                    Text("Don't have an account? Create one")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(theme.accent)
                }
                .accessibility(identifier: "GoToSignUpLink")
                
                PremiumButton("Demo Login", icon: "play.fill", style: .secondary, action: demoLogin)
                    .padding(.horizontal, AppTheme.padding)
                
                Spacer(minLength: 40)
            }
        }
        .themedBackground()
        .blur(radius: isLoading ? 2 : 0)
        .sheet(isPresented: $showSignUp) {
            SignUpSheetView()
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Oops"), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
        }
    }
    
    private func loginField(_ placeholder: String, text: Binding<String>, icon: String, identifier: String, secure: Bool = false) -> some View {
        let theme = colorScheme == .dark ? ThemeColors.dark : ThemeColors.light
        return HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(theme.secondaryText)
            if secure {
                SecureField(placeholder, text: text)
                    .accessibility(identifier: identifier)
            } else {
                TextField(placeholder, text: text)
                    .accessibility(identifier: identifier)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 14).fill(theme.cardBackground))
    }
    
    private func signIn() {
        isLoading = true
        HapticFeedback.light()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if isValid {
                HapticFeedback.success()
                appState.login()
            } else {
                errorMessage = "Please enter a valid email and password."
                showError = true
            }
        }
    }
    
    private func demoLogin() {
        password = "demo123"
        signIn()
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
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .accessibility(identifier: "EmailTextField")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(theme.cardBackground))
                SecureField("Password", text: $password)
                    .accessibility(identifier: "PasswordTextField")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(theme.cardBackground))
                SecureField("Confirm Password", text: $confirmPassword)
                    .accessibility(identifier: "ConfirmPasswordTextField")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(theme.cardBackground))
                
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? theme.accent : theme.border)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!isValid)
                .accessibility(identifier: "SignUpButton")
                Spacer()
            }
            .padding()
            .navigationTitle("Create Account")
            .navigationBarItems(trailing: Button("Close") { presentationMode.wrappedValue.dismiss() })
        }
    }
}
