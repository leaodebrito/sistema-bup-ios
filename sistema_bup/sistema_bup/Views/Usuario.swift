//
//  Usuario.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI
import FirebaseAuth

struct Usuario: View {
    @EnvironmentObject var authController: AuthController

    var body: some View {
        NavigationView {
            List {
                // Seção de Informações Básicas
                Section(header: Text("Informações Básicas")) {
                    if let user = authController.currentUser {
                        // Email
                        HStack {
                            Label("Email", systemImage: "envelope.fill")
                                .foregroundColor(.blue)
                            Spacer()
                            Text(user.email ?? "Não informado")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }

                        // UID
                        HStack {
                            Label("ID do Usuário", systemImage: "person.text.rectangle")
                                .foregroundColor(.blue)
                            Spacer()
                            Text(user.uid)
                                .foregroundColor(.secondary)
                                .font(.caption)
                                .lineLimit(1)
                        }

                        // Data de criação
                        if let creationDate = user.metadata.creationDate {
                            HStack {
                                Label("Membro desde", systemImage: "calendar.badge.plus")
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(formatDate(creationDate))
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }

                        // Último acesso
                        if let lastSignInDate = user.metadata.lastSignInDate {
                            HStack {
                                Label("Último acesso", systemImage: "clock.fill")
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(formatDate(lastSignInDate))
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }

                        // Email verificado
                        HStack {
                            Label("Email Verificado", systemImage: user.isEmailVerified ? "checkmark.seal.fill" : "xmark.seal.fill")
                                .foregroundColor(user.isEmailVerified ? .green : .orange)
                            Spacer()
                            Text(user.isEmailVerified ? "Sim" : "Não")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                }

                // Seção de Provedor de Autenticação
                Section(header: Text("Autenticação")) {
                    if let user = authController.currentUser {
                        ForEach(user.providerData, id: \.providerID) { provider in
                            HStack {
                                Label(getProviderName(provider.providerID), systemImage: getProviderIcon(provider.providerID))
                                    .foregroundColor(.blue)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }

                // Seção de Ações
                Section {
                    // Botão de Logout
                    Button(role: .destructive) {
                        do {
                            try authController.signOut()
                        } catch {
                            print("Erro ao fazer logout: \(error.localizedDescription)")
                        }
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sair")
                        }
                    }
                }
            }
            .navigationTitle("Perfil do Usuário")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // Função para formatar data
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }

    // Função para obter nome do provedor
    private func getProviderName(_ providerID: String) -> String {
        switch providerID {
        case "password":
            return "Email/Senha"
        case "google.com":
            return "Google"
        case "apple.com":
            return "Apple"
        case "facebook.com":
            return "Facebook"
        default:
            return providerID
        }
    }

    // Função para obter ícone do provedor
    private func getProviderIcon(_ providerID: String) -> String {
        switch providerID {
        case "password":
            return "key.fill"
        case "google.com":
            return "g.circle.fill"
        case "apple.com":
            return "apple.logo"
        case "facebook.com":
            return "f.circle.fill"
        default:
            return "person.circle.fill"
        }
    }
}

#Preview {
    Usuario()
        .environmentObject(AuthController())
}
