//
//  AuthViewModel.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI
import Combine
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observar mudanças no estado de autenticação
        user = authService.currentUser
        isAuthenticated = authService.isAuthenticated
    }

    // Login
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signIn(email: email, password: password)
            user = authService.currentUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Registro
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signUp(email: email, password: password)
            user = authService.currentUser
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // Logout
    func signOut() {
        do {
            try authService.signOut()
            user = nil
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
