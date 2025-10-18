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
        VStack(spacing: 0) {
            // Segmented Control
            Picker("Seção", selection: $selectedTab) {
                ForEach(ProjetoTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)

            // Tab Content
            TabView(selection: $selectedTab) {
                InformacoesProjetoView(projeto: projeto)
                    .tag(ProjetoTab.informacoes)

                PrecificacaoTerrenoView(projeto: projeto)
                    .tag(ProjetoTab.precificacao)

                AnaliseMercadoView(projeto: projeto)
                    .tag(ProjetoTab.mercado)

                ViabilidadeView(projeto: projeto)
                    .tag(ProjetoTab.viabilidade)

                RelatoriosView(projeto: projeto)
                    .tag(ProjetoTab.relatorios)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: selectedTab)
        }
        .navigationTitle(projeto.nomeProjeto)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Informações do Projeto View
struct InformacoesProjetoView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Informações Básicas
                SectionCard(title: "Informações Básicas") {
                    DetailRow(label: "Nome do Projeto", value: projeto.nomeProjeto)
                    Divider()
                    DetailRow(label: "Tipo", value: projeto.tipoProjeto)
                    Divider()
                    DetailRow(label: "Cliente", value: projeto.nomeCliente)
                    Divider()
                    DetailRow(label: "Endereço", value: projeto.endereco)
                    Divider()
                    DetailRow(label: "Data Início", value: projeto.dataInicio)
                    Divider()
                    DetailRow(label: "Descrição", value: projeto.descriProjeto)
                }

                // Informações do Terreno
                if let areaTerreno = projeto.areaTerreno {
                    SectionCard(title: "Terreno") {
                        DetailRow(label: "Área do Terreno", value: String(format: "%.2f m²", areaTerreno))

                        if let latitude = projeto.latitude, let longitude = projeto.longitude {
                            Divider()
                            DetailRow(label: "Coordenadas", value: "\(latitude), \(longitude)")
                        }
                    }
                }

                // Parâmetros Urbanísticos
                if let zonaUrbanistica = projeto.zonaUrbanistica {
                    SectionCard(title: "Parâmetros Urbanísticos") {
                        DetailRow(label: "Zona Urbanística", value: zonaUrbanistica)

                        if let caBase = projeto.caBase {
                            Divider()
                            DetailRow(label: "CA Básico", value: String(format: "%.2f", caBase))
                        }

                        if let caMax = projeto.caMax {
                            Divider()
                            DetailRow(label: "CA Máximo", value: String(format: "%.2f", caMax))
                        }

                        if let caMin = projeto.caMin {
                            Divider()
                            DetailRow(label: "CA Mínimo", value: caMin)
                        }

                        if let io = projeto.io {
                            Divider()
                            DetailRow(label: "Taxa de Ocupação (IO)", value: io)
                        }

                        if let ip = projeto.ip {
                            Divider()
                            DetailRow(label: "Taxa de Permeabilidade (IP)", value: ip)
                        }
                    }
                }

                // Anotações
                if let anotacoesLegislacao = projeto.anotacoesLegislacao, !anotacoesLegislacao.isEmpty {
                    SectionCard(title: "Anotações de Legislação") {
                        Text(anotacoesLegislacao)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }

                if let anotacoesGerais = projeto.anotacoesGerais, !anotacoesGerais.isEmpty {
                    SectionCard(title: "Anotações Gerais") {
                        Text(anotacoesGerais)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }

                // Informações de Criação
                SectionCard(title: "Informações de Criação") {
                    DetailRow(label: "Criado por", value: projeto.infoCriacao.usuarioCriador)
                    Divider()
                    DetailRow(label: "Data de Criação", value: projeto.dataFormatada)
                }
            }
            .padding()
        }
    }
}

// MARK: - Precificação do Terreno View
struct PrecificacaoTerrenoView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)

                Text("Precificação do Terreno")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Análise de precificação do terreno em desenvolvimento")
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

// MARK: - Análise de Mercado View
struct AnaliseMercadoView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)

                Text("Análise de Mercado")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Análise de mercado em desenvolvimento")
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
