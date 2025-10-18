//
//  LoginView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authController: AuthController
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Logo e título
            VStack(spacing: 12) {
                Image(systemName: "building.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)

                Text("BuidUp Mobile")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Sistema de Análise de Mercado Imobiliário")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            // Form
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disabled(isLoading)

                SecureField("Senha", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.password)
                    .disabled(isLoading)
            }
            .padding(.horizontal)

            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Login button
            Button {
                Task {
                    await handleLogin()
                }
            } label: {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    Text("Entrar")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(isLoading || email.isEmpty || password.isEmpty)
            .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)

            Spacer()
        }
        .padding()
    }

    private func handleLogin() async {
        isLoading = true
        errorMessage = nil

        do {
            try await authController.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthController())
}
