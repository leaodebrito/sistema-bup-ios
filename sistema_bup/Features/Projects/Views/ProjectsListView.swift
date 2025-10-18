//
//  ProjectsListView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct ProjectsListView: View {
    @StateObject private var viewModel = ProjectsViewModel()
    @State private var showingCreateProject = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Carregando projetos...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)

                        Text("Erro ao carregar projetos")
                            .font(.headline)

                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Button("Tentar Novamente") {
                            Task {
                                await viewModel.loadProjetos()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else if viewModel.projetos.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "folder.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)

                        Text("Nenhum projeto ainda")
                            .font(.headline)

                        Text("Crie seu primeiro projeto para começar")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            showingCreateProject = true
                        } label: {
                            Label("Criar Projeto", systemImage: "plus")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.projetos) { projeto in
                            NavigationLink {
                                ProjectDetailView(projeto: projeto)
                            } label: {
                                ProjectRowView(projeto: projeto)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadProjetos()
                    }
                }
            }
            .navigationTitle("Projetos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCreateProject = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(viewModel.projetos.isEmpty)
                }
            }
            .sheet(isPresented: $showingCreateProject) {
                CreateProjectView()
            }
            .task {
                await viewModel.loadProjetos()
            }
        }
    }
}

struct ProjectRowView: View {
    let projeto: Projeto

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título do projeto
            Text(projeto.nomeProjeto)
                .font(.headline)
                .fontWeight(.semibold)

            // Cliente
            HStack {
                Image(systemName: "person.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(projeto.nomeCliente)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Endereço
            HStack {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(projeto.endereco)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            // Tipo e Data
            HStack {
                // Tipo
                Text(projeto.tipoProjeto)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(4)

                Spacer()

                // Data
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

struct ProjectDetailView: View {
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
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5)

                // Análises Disponíveis
                VStack(alignment: .leading, spacing: 12) {
                    Text("Análises")
                        .font(.headline)
                        .fontWeight(.bold)

                    if projeto.analiseMercadoId != nil {
                        AnalysisCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Análise de Mercado",
                            color: .green
                        )
                    }

                    if projeto.analiseTerreno != nil {
                        AnalysisCard(
                            icon: "map.fill",
                            title: "Análise de Terreno",
                            color: .orange
                        )
                    }

                    if projeto.analiseViabilidadeId != nil {
                        AnalysisCard(
                            icon: "chart.bar.fill",
                            title: "Análise de Viabilidade",
                            color: .purple
                        )
                    }

                    if projeto.analiseMercadoId == nil && projeto.analiseTerreno == nil && projeto.analiseViabilidadeId == nil {
                        Text("Nenhuma análise disponível")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Detalhes do Projeto")
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

struct CreateProjectView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                Text("Criar Projeto")
                    .font(.headline)
                Text("Em desenvolvimento...")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Novo Projeto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectsListView()
}
