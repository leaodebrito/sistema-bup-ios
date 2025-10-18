//
//  LoginView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
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
                        .disabled(authViewModel.isLoading)

                    SecureField("Senha", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
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
                }

                // Login button
                Button {
                    Task {
                        await authViewModel.signIn(email: email, password: password)
                    }
                } label: {
                    if authViewModel.isLoading {
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
                .disabled(authViewModel.isLoading || email.isEmpty || password.isEmpty)
                .opacity((email.isEmpty || password.isEmpty) ? 0.6 : 1.0)

                // Register link
                NavigationLink {
                    RegisterView()
                } label: {
                    Text("Não tem conta? Cadastre-se")
                        .font(.footnote)
                }
                .disabled(authViewModel.isLoading)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
