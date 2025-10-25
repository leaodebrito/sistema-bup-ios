//
//  ProjetoDetailView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

// MARK: - Tabs do Projeto
enum ProjetoTab: String, CaseIterable, Identifiable {
    case informacoes = "Info"
    case precificacao = "Terreno"
    case mercado = "Produto"
    case viabilidade = "Viabilidade"
    case relatorios = "Relatórios"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .informacoes: return "info.circle.fill"
        case .precificacao: return "dollarsign.circle.fill"
        case .mercado: return "chart.line.uptrend.xyaxis.circle.fill"
        case .viabilidade: return "checkmark.seal.fill"
        case .relatorios: return "doc.text.fill"
        }
    }
}

// MARK: - Projeto Detail View
struct ProjetoDetailView: View {
    let projeto: Projeto
    @State private var selectedTab: ProjetoTab = .informacoes
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    // Segmented Control
                    Picker("Seção", selection: $selectedTab) {
                        ForEach(ProjetoTab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    //.background(Color(.systemBackground))
                    
                    // Tab Content
                    if selectedTab.rawValue == "Info"{
                        InformacoesProjetoView(projeto: projeto)
                    }else if selectedTab.rawValue == "Terreno"{
                        PrecificacaoTerrenoView(projeto: projeto)
                    }else if selectedTab.rawValue == "Produto"{
                        AnaliseMercadoView(projeto: projeto)
                    }else if selectedTab.rawValue == "Viabilidade"{
                        ViabilidadeView(projeto: projeto)
                    }else {
                        RelatoriosView(projeto: projeto)
                    }
                }
            }
        }
        .animation(.easeInOut, value: selectedTab)
        .navigationTitle(projeto.nomeProjeto)
        .navigationBarTitleDisplayMode(.inline)
    }
}




// MARK: - Análise de Mercado View


// MARK: - Viabilidade View
struct ViabilidadeView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "checkmark.seal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.purple)

                Text("Análise de Viabilidade")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Análise de viabilidade em desenvolvimento")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

// MARK: - Relatórios View
struct RelatoriosView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "doc.text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.orange)

                Text("Relatórios")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Geração de relatórios em desenvolvimento")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

// MARK: - Section Card
struct SectionCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Detail Row
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
