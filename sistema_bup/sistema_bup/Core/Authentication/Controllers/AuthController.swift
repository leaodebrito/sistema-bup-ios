//
//  AuthController.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI
import Combine
import FirebaseAuth

class AuthController: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?

    private let authService = AuthService.shared

    init() {
        // Verifica se já existe uma sessão ativa do Firebase
        checkAuthStatus()
    }

    func checkAuthStatus() {
        currentUser = authService.currentUser
        isAuthenticated = authService.isAuthenticated
    }

    func signIn(email: String, password: String) async throws {
        try await authService.signIn(email: email, password: password)
        await MainActor.run {
            checkAuthStatus()
        }
    }

    func signOut() throws {
        try authService.signOut()
        checkAuthStatus()
    }
}
