//
//  AnaliseMercadoView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 25/10/25.
//

import SwiftUI

// MARK: - Análise de Mercado View
struct AnaliseMercadoView: View {
    let projeto: Projeto

    @State private var analiseMercado: AnaliseMercado?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                headerSection

                if isLoading {
                    loadingView
                } else if let analise = analiseMercado {
                    // Conteúdo da Análise
                    VStack(spacing: 20) {
                        // Precificação do Imóvel
                        precificacaoImovelCard(analise: analise)

                        // Dados de Imóveis na Região
                        if let dadosImoveis = analise.dadosImoveisRegiao {
                            dadosImoveisCard(dados: dadosImoveis)
                        }

                        // Preços na Região
                        if let precosRegiao = analise.precosImoveisRegiao {
                            precosRegiaoCard(precos: precosRegiao)
                        }

                        // Descrição dos Imóveis na Região
                        if let descricao = analise.descricaoImoveisRegiao {
                            descricaoImoveisCard(descricao: descricao)
                        }

                        // Conclusões do Estudo
                        if let conclusoes = analise.conclusoesEstudo {
                            conclusoesCard(conclusoes: conclusoes)
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
        .navigationTitle("Análise de Mercado")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await carregarAnalise()
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.green)

            Text("Análise de Mercado")
                .font(.title2)
                .fontWeight(.bold)

            if let _ = analiseMercado {
                Text("Análise de precificação de imóveis na região")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }


    // MARK: - Precificação do Imóvel Card

    private func precificacaoImovelCard(analise: AnaliseMercado) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                Text("Precificação do Imóvel")
                    .font(.headline)
            }

            VStack(spacing: 12) {
                // Valor de Referência por m² - usa o valor calculado que verifica as conclusões
                if let valorRef = analise.valorReferenciaM2Calculado {
                    VStack(spacing: 8) {
                        Text("Valor de Referência por m²")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(formatarMoeda(valorRef))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)

                    // Faixa de Preço calculada
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Faixa de Preço por m²")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        let variacao = valorRef * 0.1
                        HStack(spacing: 12) {
                            faixaPrecoItem(
                                label: "Mínimo",
                                valor: valorRef - variacao,
                                color: .orange
                            )

                            Divider()

                            faixaPrecoItem(
                                label: "Médio",
                                valor: valorRef,
                                color: .green
                            )

                            Divider()

                            faixaPrecoItem(
                                label: "Máximo",
                                valor: valorRef + variacao,
                                color: .blue
                            )
                        }
                        .frame(height: 70)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                }

                // Valor total estimado se disponível
                if let valorTotalStr = analise.conclusoesEstudo?.precoVendaAdotado,
                   let valorTotal = Double(valorTotalStr) {
                    Divider()

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Valor Total Estimado")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatarMoeda(valorTotal))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Image(systemName: "dollarsign.square.fill")
                            .font(.title)
                            .foregroundColor(.green.opacity(0.3))
                    }
                    .padding()
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Faixa Preço Item

    private func faixaPrecoItem(label: String, valor: Double, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(formatarMoeda(valor))
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Dados de Imóveis Card

    private func dadosImoveisCard(dados: DadosImoveisRegiao) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "house.fill")
                    .foregroundColor(.blue)
                Text("Imóveis na Região")
                    .font(.headline)
            }

            VStack(spacing: 8) {
                // Quantidade Total
                if let quantidade = dados.quantidadeTotal {
                    HStack {
                        Text("Imóveis Analisados:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(quantidade)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }

                // Lista de imóveis
                if let imoveis = dados.imoveisAnalisados, !imoveis.isEmpty {
                    Divider()
                        .padding(.vertical, 4)

                    VStack(spacing: 12) {
                        ForEach(Array(imoveis.enumerated()), id: \.offset) { index, imovel in
                            imovelRow(imovel: imovel, numero: index + 1)

                            if index < imoveis.count - 1 {
                                Divider()
                            }
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

    // MARK: - Imóvel Row

    private func imovelRow(imovel: ImovelAnalisado, numero: Int) -> some View {
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

                if let endereco = imovel.endereco {
                    Text(endereco)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(2)
                }
            }

            HStack(spacing: 16) {
                if let area = imovel.areaM2 {
                    HStack(spacing: 4) {
                        Image(systemName: "square.dashed")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(formatarNumero(area)) m²")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                if let quartos = imovel.quartos {
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(quartos) quartos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                if let precoM2 = imovel.precoM2 {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle")
                            .font(.caption2)
                            .foregroundColor(.green)
                        Text(formatarMoeda(precoM2) + "/m²")
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

    // MARK: - Preços na Região Card

    private func precosRegiaoCard(precos: PrecosImoveisRegiao) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                Text("Preços na Região")
                    .font(.headline)
            }

            VStack(spacing: 12) {
                // Preço Médio por m²
                if let precoMedio = precos.precoMedioM2 {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Preço Médio por m²")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatarMoeda(precoMedio))
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.purple)
                        }
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.purple.opacity(0.3))
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }

                // Distribuição de Preços
                if let distribuicao = precos.distribuicaoPrecos, !distribuicao.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Distribuição de Preços")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(Array(distribuicao.enumerated()), id: \.offset) { index, preco in
                                    VStack(spacing: 4) {
                                        Text(formatarMoeda(preco))
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .foregroundColor(.purple)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
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

    // MARK: - Descrição dos Imóveis Card

    private func descricaoImoveisCard(descricao: DescricaoImoveisRegiao) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.square.fill")
                    .foregroundColor(.orange)
                Text("Características da Região")
                    .font(.headline)
            }

            VStack(spacing: 8) {
                if let tipo = descricao.tipoPredominante {
                    infoRow(
                        label: "Tipo Predominante",
                        valor: tipo.capitalized,
                        icon: "building.2.fill"
                    )
                }

                if let areaMedia = descricao.areaMediaM2 {
                    if descricao.tipoPredominante != nil {
                        Divider()
                    }
                    infoRow(
                        label: "Área Média",
                        valor: "\(formatarNumero(areaMedia)) m²",
                        icon: "square.grid.3x3.fill"
                    )
                }

                if let quartosMedio = descricao.quartosMedio {
                    Divider()
                    infoRow(
                        label: "Média de Quartos",
                        valor: String(format: "%.1f", quartosMedio),
                        icon: "bed.double.fill"
                    )
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Conclusões Card

    private func conclusoesCard(conclusoes: ConcluxaoEstudoMercado) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("Conclusões do Estudo")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 12) {
                // Demanda
                if let demandaAlta = conclusoes.demandaAlta {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Demanda")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 8) {
                                Text(demandaAlta ? "Alta" : "Baixa")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(demandaAlta ? .green : .orange)
                                Circle()
                                    .fill(demandaAlta ? .green : .orange)
                                    .frame(width: 12, height: 12)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background((demandaAlta ? Color.green : Color.orange).opacity(0.1))
                    .cornerRadius(8)
                }

                // Competitividade
                if let competitividade = conclusoes.competitividade {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "chart.bar.doc.horizontal")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("Competitividade")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        Text(competitividade)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(8)
                }

                // Recomendação
                if let recomendacao = conclusoes.recomendacao {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text("Recomendação")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        Text(recomendacao)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
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

    // MARK: - Versão Card

    private func versaoCard(analise: AnaliseMercado) -> some View {
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
            Text("Carregando análise de mercado...")
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
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 50))
                .foregroundColor(.gray.opacity(0.5))

            Text("Análise Não Disponível")
                .font(.headline)

            Text("A análise de mercado ainda não foi realizada para este projeto")
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

    private func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "concluido", "concluído":
            return .green
        case "em_analise", "em análise":
            return .orange
        case "pendente":
            return .gray
        default:
            return .blue
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
            analiseMercado = try await AnalysisService.shared.getAnaliseMercado(projetoId: projetoId)

            if let analise = analiseMercado {
                print("✅ Análise de Mercado carregada com sucesso!")
                print("📊 Versão: \(analise.versao)")
                print("📊 Status: \(analise.status)")

                // Debug precificação
                print("\n💰 PRECIFICAÇÃO DO IMÓVEL:")
                print("  - valorReferenciaM2: \(analise.precificacaoImovel.valorReferenciaM2 ?? 0)")
                if let faixa = analise.precificacaoImovel.faixaPrecoM2 {
                    print("  - faixaPrecoM2:")
                    print("    • Mínimo: \(faixa.minimo)")
                    print("    • Médio: \(faixa.medio)")
                    print("    • Máximo: \(faixa.maximo)")
                }

                // Debug dados de imóveis
                print("\n🏠 DADOS DE IMÓVEIS NA REGIÃO:")
                if let dados = analise.dadosImoveisRegiao {
                    print("  - quantidadeTotal: \(dados.quantidadeTotal ?? 0)")
                    print("  - imoveisAnalisados: \(dados.imoveisAnalisados?.count ?? 0)")
                } else {
                    print("  - Nenhum dado de imóveis")
                }

                // Debug preços
                print("\n💵 PREÇOS NA REGIÃO:")
                if let precos = analise.precosImoveisRegiao {
                    print("  - precoMedioM2: \(precos.precoMedioM2 ?? 0)")
                    print("  - distribuicaoPrecos: \(precos.distribuicaoPrecos?.count ?? 0) valores")
                } else {
                    print("  - Nenhum dado de preços")
                }

                // Debug conclusões
                print("\n✅ CONCLUSÕES DO ESTUDO:")
                if let conclusoes = analise.conclusoesEstudo {
                    print("  - demandaAlta: \(conclusoes.demandaAlta ?? false)")
                    print("  - competitividade: \(conclusoes.competitividade ?? "N/A")")
                    print("  - recomendacao: \(conclusoes.recomendacao ?? "N/A")")
                } else {
                    print("  - Nenhuma conclusão")
                }
            } else {
                errorMessage = "Nenhuma análise encontrada"
            }
        } catch {
            errorMessage = "Não foi possível carregar a análise: \(error.localizedDescription)"
            print("⚠️ Erro ao carregar análise de mercado: \(error)")
        }
    }
}

// MARK: - Preview
// Preview removido devido ao decoder customizado do modelo Projeto
