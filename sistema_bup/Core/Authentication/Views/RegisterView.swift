//
//  RegisterView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Logo e título
            VStack(spacing: 12) {
                Image(systemName: "person.badge.plus.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)

                Text("Criar Conta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            Spacer()

            // Form
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .disabled(authViewModel.isLoading)

                SecureField("Senha", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                    .disabled(authViewModel.isLoading)

                SecureField("Confirmar Senha", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)
                    .textContentType(.newPassword)
                    .disabled(authViewModel.isLoading)
            }
            .padding(.horizontal)

            // Error message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                Text("As senhas não coincidem")
                    .foregroundColor(.orange)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Register button
            Button {
                Task {
                    await authViewModel.signUp(email: email, password: password)
                    if authViewModel.isAuthenticated {
                        dismiss()
                    }
                }
            } label: {
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    Text("Cadastrar")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty || password != confirmPassword)
            .opacity((email.isEmpty || password.isEmpty || password != confirmPassword) ? 0.6 : 1.0)

            Spacer()
        }
        .padding()
        .navigationTitle("Cadastro")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}
