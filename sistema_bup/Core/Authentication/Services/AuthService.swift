//
//  AuthService.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import FirebaseAuth
import Combine

enum AuthError: LocalizedError {
    case invalidCredentials
    case userNotFound
    case weakPassword
    case emailAlreadyInUse
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email ou senha inválidos"
        case .userNotFound:
            return "Usuário não encontrado"
        case .weakPassword:
            return "Senha muito fraca. Use no mínimo 6 caracteres"
        case .emailAlreadyInUse:
            return "Este email já está em uso"
        case .unknown(let message):
            return message
        }
    }
}

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()

    var currentUser: User? {
        auth.currentUser
    }

    var isAuthenticated: Bool {
        currentUser != nil
    }

    // Login
    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    // Registro
    func signUp(email: String, password: String) async throws {
        do {
            try await auth.createUser(withEmail: email, password: password)
        } catch let error as NSError {
            throw mapAuthError(error)
        }
    }

    // Logout
    func signOut() throws {
        try auth.signOut()
    }

    // Mapear erros Firebase para erros customizados
    private func mapAuthError(_ error: NSError) -> AuthError {
        guard let errorCode = AuthErrorCode.Code(rawValue: error.code) else {
            return .unknown(error.localizedDescription)
        }

        switch errorCode {
        case .invalidCredential, .wrongPassword:
            return .invalidCredentials
        case .userNotFound:
            return .userNotFound
        case .weakPassword:
            return .weakPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
