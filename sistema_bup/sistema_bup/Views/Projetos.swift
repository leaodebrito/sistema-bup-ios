//
//  Projetos.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

struct Projetos: View {
    @StateObject private var controller = ProjectsController()

    var body: some View {
        NavigationStack {
            Group {
                if controller.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Carregando projetos...")
                            .foregroundColor(.secondary)
                    }
                } else if let errorMessage = controller.errorMessage {
                    ErrorStateView(
                        message: errorMessage,
                        onRetry: {
                            Task {
                                await controller.loadProjetos()
                            }
                        }
                    )
                } else if controller.projetos.isEmpty {
                    EmptyProjectsView()
                } else {
                    List {
                        ForEach(controller.projetos) { projeto in
                            NavigationLink {
                                ProjetoDetailView(projeto: projeto)
                            } label: {
                                ProjetoRowView(projeto: projeto)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let projeto = controller.projetos[index]
                                Task {
                                    await controller.deleteProjeto(projeto)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await controller.loadProjetos()
                    }
                }
            }
            .navigationTitle("Projetos")
            .navigationBarTitleDisplayMode(.large)
            .task {
                print("📱 Projetos View: .task chamado")
                await controller.loadProjetos()
            }
            .onChange(of: controller.isLoading) { oldValue, newValue in
                print("📱 Projetos View: isLoading mudou de \(oldValue) para \(newValue)")
            }
            .onChange(of: controller.projetos.count) { oldValue, newValue in
                print("📱 Projetos View: projetos.count mudou de \(oldValue) para \(newValue)")
            }
            .onChange(of: controller.errorMessage) { oldValue, newValue in
                print("📱 Projetos View: errorMessage mudou para: \(newValue ?? "nil")")
            }
        }
    }
}

// MARK: - Projeto Row View
struct ProjetoRowView: View {
    let projeto: Projeto

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(projeto.nomeProjeto)
                .font(.headline)
                .fontWeight(.semibold)

            HStack {
                Image(systemName: "person.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(projeto.nomeCliente)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(projeto.endereco)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            HStack {
                Text(projeto.tipoProjeto)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(projeto.dataInicio)
                        .font(.caption2)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Empty State View
struct EmptyProjectsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)

            Text("Nenhum projeto encontrado")
                .font(.headline)

            Text("Não há projetos cadastrados no sistema")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - Error State View
struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.orange)

            Text("Erro ao carregar projetos")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Tentar Novamente") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Projeto Detail View
struct ProjetoDetailView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Informações do Projeto
                VStack(alignment: .leading, spacing: 12) {
                    Text("Informações do Projeto")
                        .font(.headline)
                        .fontWeight(.bold)

                    DetailRow(label: "Nome", value: projeto.nomeProjeto)
                    DetailRow(label: "Tipo", value: projeto.tipoProjeto)
                    DetailRow(label: "Cliente", value: projeto.nomeCliente)
                    DetailRow(label: "Endereço", value: projeto.endereco)
                    DetailRow(label: "Data Início", value: projeto.dataInicio)
                    DetailRow(label: "Descrição", value: projeto.descriProjeto)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Análises Disponíveis
                VStack(alignment: .leading, spacing: 12) {
                    Text("Análises")
                        .font(.headline)
                        .fontWeight(.bold)

                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.body)
        }
    }
}

struct AnalysisCard: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    Projetos()
}
