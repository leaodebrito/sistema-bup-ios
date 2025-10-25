//
//  PrecificacaoTerrenoView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

// MARK: - Precificação do Terreno View
struct PrecificacaoTerrenoView: View {
    let projeto: Projeto

    @State private var analiseTerreno: AnaliseTerreno?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection

                if isLoading {
                    loadingView
                } else if let analise = analiseTerreno {
                    // Conteúdo da Análise
                    VStack(spacing: 20) {
                        // Informações Básicas do Terreno
                        informacoesBasicasCard

                        // Precificação Principal
                        precificacaoCard(analise: analise)

                        // Dados da Amostra
                        if let dadosAmostra = analise.dadosAmostra, !dadosAmostra.isEmpty {
                            dadosAmostraCard(dados: dadosAmostra)
                        }

                        // Parecer do Estudo
                        if let parecer = analise.parecerEstudo {
                            parecerCard(parecer: parecer)
                        }

                        // Descrição (se houver)
                        if let descricao = analise.descricao, !descricao.isEmpty {
                            descricaoCard(descricao: descricao)
                        }

                        // Metadados
                        if let metadados = analise.metadados {
                            metadadosCard(metadados: metadados)
                        }

                        // Informação da Versão
                        versaoCard(analise: analise)
                    }
                    .padding(.horizontal)
                } else if let error = errorMessage {
                    errorView(message: error)
                } else {
                    emptyStateView
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Precificação do Terreno")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await carregarAnalise()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)

            Text("Análise de Precificação")
                .font(.title2)
                .fontWeight(.bold)

            if let _ = analiseTerreno {
                Text("Dados baseados em análise de mercado local")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    // MARK: - Informações Básicas Card

    private var informacoesBasicasCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Informações do Terreno")
                    .font(.headline)
            }

            VStack(spacing: 8) {
                if let area = projeto.areaTerreno {
                    infoRow(label: "Área do Terreno", valor: String(format: "%.2f m²", area), icon: "square.dashed")
                }

                if let zona = projeto.zonaUrbanistica {
                    Divider()
                    infoRow(label: "Zona Urbanística", valor: zona, icon: "map.fill")
                }

                Divider()
                infoRow(label: "Endereço", valor: projeto.endereco, icon: "mappin.circle.fill")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Precificação Card

    private func precificacaoCard(analise: AnaliseTerreno) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                Text("Precificação Estimada")
                    .font(.headline)
            }

            VStack(spacing: 12) {
                // Valor Total Estimado
                if let valorTotal = analise.precificacaoTerreno.valorTotalEstimado {
                    VStack(spacing: 8) {
                        Text("Valor Total Estimado")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatarMoeda(valorTotal))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }

                // Valor por m²
                if let valorM2 = analise.precificacaoTerreno.valorM2Estimado {
                    Divider()
                    valorRow(
                        label: "Valor por m²",
                        valor: valorM2,
                        icon: "square.grid.3x3.fill"
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Info Row

    private func infoRow(label: String, valor: String, icon: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(valor)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }

            Spacer()
        }
    }

    // MARK: - Valor Row

    private func valorRow(label: String, valor: Double, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(formatarMoeda(valor))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }

            Spacer()
        }
    }



    // MARK: - Dados Amostra Card

    private func dadosAmostraCard(dados: DadosAmostraTerreno) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.blue)
                Text("Dados da Amostra")
                    .font(.headline)
            }

            VStack(spacing: 8) {
                // Quantidade de terrenos
                HStack {
                    Text("Terrenos Comparáveis Analisados:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(dados.count)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }

                // Lista de terrenos
                Divider()
                    .padding(.vertical, 4)

                VStack(spacing: 12) {
                    ForEach(Array(dados.enumerated()), id: \.offset) { index, terreno in
                        terrenoRow(terreno: terreno, numero: index + 1)

                        if index < dados.count - 1 {
                            Divider()
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Terreno Row

    private func terrenoRow(terreno: TerrenoAnalisado, numero: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("#\(numero)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(4)

                if let endereco = terreno.endereco {
                    Text(endereco)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
            }

            HStack(spacing: 16) {
                if let area = terreno.areaM2 {
                    HStack(spacing: 4) {
                        Image(systemName: "square.dashed")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(formatarNumero(area)) m²")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                if let valorM2 = terreno.valorM2 {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.caption2)
                            .foregroundColor(.green)
                        Text(formatarMoeda(valorM2) + "/m²")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }

    // MARK: - Parecer Card

    private func parecerCard(parecer: ParecerEstudo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.purple)
                Text("Parecer Técnico")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 12) {
                // Confiabilidade
                if let confiabilidade = parecer.confiabilidade {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Confiabilidade da Análise")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 8) {
                                Text(confiabilidade.capitalized)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(corConfiabilidade(confiabilidade))
                                Circle()
                                    .fill(corConfiabilidade(confiabilidade))
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(corConfiabilidade(confiabilidade).opacity(0.1))
                    .cornerRadius(8)
                }

                // Observações
                if let observacoes = parecer.observacoes, !observacoes.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Observações:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text(observacoes)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Descrição Card

    private func descricaoCard(descricao: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(.gray)
                Text("Descrição do Estudo")
                    .font(.headline)
            }

            Text(descricao)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Metadados Card

    private func metadadosCard(metadados: MetadadosTerreno) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text("Informações do Estudo")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                if let fonte = metadados.fonteDados {
                    HStack {
                        Text("Fonte dos dados:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(fonte)
                            .font(.caption2)
                            .foregroundColor(.primary)
                    }
                }

                if let dataColeta = metadados.dataColeta {
                    HStack {
                        Text("Data da coleta:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(dataColeta)
                            .font(.caption2)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }

    // MARK: - Versão Card

    private func versaoCard(analise: AnaliseTerreno) -> some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .foregroundColor(.gray)
                .font(.caption)

            VStack(alignment: .leading, spacing: 2) {
                Text("Versão da Análise")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(analise.versao)
                    .font(.caption)
                    .fontWeight(.medium)
            }

            Spacer()

            Text(analise.status.capitalized)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor(analise.status))
                .cornerRadius(4)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }

    // MARK: - Loading View

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Carregando análise de precificação...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    // MARK: - Error View

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text("Erro ao carregar análise")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    // MARK: - Empty State View

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))

            Text("Análise Não Disponível")
                .font(.headline)

            Text("A análise de precificação do terreno ainda não foi realizada para este projeto")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }

    // MARK: - Helper Functions

    private func formatarMoeda(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = "R$"
        return formatter.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }

    private func formatarNumero(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: valor)) ?? "0"
    }

    private func corConfiabilidade(_ confiabilidade: String) -> Color {
        switch confiabilidade.lowercased() {
        case "alta": return .green
        case "média", "media": return .orange
        case "baixa": return .red
        default: return .secondary
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "concluido", "concluído": return .green
        case "em_analise", "em análise": return .orange
        case "pendente": return .gray
        default: return .blue
        }
    }

    private func carregarAnalise() async {
        guard let projetoId = projeto.id else {
            errorMessage = "ID do projeto não disponível"
            return
        }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            analiseTerreno = try await AnalysisService.shared.getAnaliseTerreno(projetoId: projetoId)

            if let analise = analiseTerreno {
                print("✅ Análise carregada com sucesso!")
                print("📊 Versão: \(analise.versao)")
                print("📊 Status: \(analise.status)")

                // Debug precificação
                print("\n💰 PRECIFICAÇÃO:")
                print("  - precoAdotado: \(analise.precificacaoTerreno.precoAdotado ?? 0)")
                print("  - precoUnitarioAdotado: \(analise.precificacaoTerreno.precoUnitarioAdotado ?? 0)")
                print("  - precoTotalCalculado: \(analise.precificacaoTerreno.precoTotalCalculado ?? 0)")
                print("  - valorTotalEstimado (computed): \(analise.precificacaoTerreno.valorTotalEstimado ?? 0)")
                print("  - valorM2Estimado (computed): \(analise.precificacaoTerreno.valorM2Estimado ?? 0)")
                print("  - faixaValores: \(analise.precificacaoTerreno.faixaValores != nil ? "Sim" : "Não")")
                print("  - diferencaPercentual: \(analise.precificacaoTerreno.diferencaPercentual ?? "N/A")")

                // Debug dados amostra
                print("\n📋 DADOS AMOSTRA:")
                if let dados = analise.dadosAmostra {
                    print("  - Total de terrenos: \(dados.count)")
                    if let primeiro = dados.first {
                        print("  - Primeiro terreno:")
                        print("    • Area: \(primeiro.Area ?? 0)")
                        print("    • Bairro: \(primeiro.Bairro ?? "N/A")")
                        print("    • preco_unitario: \(primeiro.preco_unitario ?? "N/A")")
                        print("    • valorM2 (computed): \(primeiro.valorM2 ?? 0)")
                    }
                } else {
                    print("  - Nenhum dado de amostra")
                }
            } else {
                errorMessage = "Nenhuma análise encontrada"
            }
        } catch {
            errorMessage = "Não foi possível carregar a análise: \(error.localizedDescription)"
            print("⚠️ Erro ao carregar análise de terreno: \(error)")
        }
    }
}

// MARK: - Preview
// Preview removido devido ao decoder customizado do modelo Projeto
