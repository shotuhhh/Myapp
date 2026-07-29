//
//  AppState.swift
//  AI Life OS
//

import Foundation
import Combine
import SwiftUI

final class AppState: ObservableObject {
    static let shared = AppState()
    
    private let onboardingKey = "ailifeos_onboarding_complete"
    private let loginKey = "ailifeos_logged_in"
    
    @Published var hasCompletedOnboarding: Bool
    @Published var isLoggedIn: Bool
    @Published var selectedTab: MainTab = .home
    @Published var navigationPath: [AppRoute] = []
    @Published var presentedSheet: AppRoute?
    @Published var showSuccessToast: Bool = false
    @Published var toastMessage: String = ""
    @Published var demoContentState: ContentState = .loaded
    
    init() {
        let automation = ProcessInfo.processInfo.arguments.contains("Automation Test")
        if automation {
            hasCompletedOnboarding = true
            isLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
        } else {
            hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
            isLoggedIn = UserDefaults.standard.bool(forKey: loginKey)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    func login() {
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: loginKey)
        showToast("Welcome back!")
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: loginKey)
        navigationPath = []
        selectedTab = .home
    }
    
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func present(_ route: AppRoute) {
        presentedSheet = route
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func showToast(_ message: String) {
        toastMessage = message
        withAnimation(AppTheme.springAnimation) {
            showSuccessToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            withAnimation { self?.showSuccessToast = false }
        }
    }
    
    func simulateLoadingThenLoaded() {
        demoContentState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            self?.demoContentState = .loaded
        }
    }
}
