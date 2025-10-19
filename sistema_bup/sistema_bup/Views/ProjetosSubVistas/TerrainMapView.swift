//
//  TerrainMapView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI
import MapKit

// MARK: - Terrain Map View
struct TerrainMapView: View {
    let latitude: Double?
    let longitude: Double?
    let endereco: String

    // Parâmetros opcionais para buscar a análise
    var projetoId: String? = nil
    var areaTerreno: Double? = nil

    @State private var region: MKCoordinateRegion
    @State private var mapCameraPosition: MapCameraPosition
    @State private var analiseTerreno: AnaliseTerreno?
    @State private var isLoadingAnalise = false
    @State private var hasError = false

    init(latitude: Double?, longitude: Double?, endereco: String, projetoId: String? = nil, areaTerreno: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.endereco = endereco
        self.projetoId = projetoId
        self.areaTerreno = areaTerreno

        // Define a região do mapa com base nas coordenadas
        if let lat = latitude, let lon = longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            _region = State(initialValue: region)
            _mapCameraPosition = State(initialValue: .region(region))
        } else {
            // Coordenadas padrão (São Paulo) caso não existam coordenadas
            let defaultCoordinate = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
            let defaultRegion = MKCoordinateRegion(
                center: defaultCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            _region = State(initialValue: defaultRegion)
            _mapCameraPosition = State(initialValue: .region(defaultRegion))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Mapa
            mapSection

            // Análise do Terreno (se disponível)
            if let projetoId = projetoId {
                analiseSection
            }
        }
        .task {
            if let id = projetoId {
                await carregarAnaliseTerreno(projetoId: id)
            }
        }
    }

    // MARK: - Map Section

    private var mapSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let lat = latitude, let lon = longitude {
                Map(position: $mapCameraPosition) {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.3))
                                .frame(width: 50, height: 50)

                            Circle()
                                .stroke(Color.green, lineWidth: 3)
                                .frame(width: 50, height: 50)

                            Image(systemName: "map.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 20, weight: .bold))
                        }
                    }
                }
                .frame(height: 250)
                .cornerRadius(12)
                .mapStyle(.standard(elevation: .realistic))

                // Coordenadas exibidas abaixo do mapa
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text(String(format: "%.6f, %.6f", lat, lon))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)
            } else {
                // Mensagem quando não há coordenadas
                VStack(spacing: 12) {
                    Image(systemName: "map.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))

                    Text("Localização não disponível")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("As coordenadas do terreno não foram informadas")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Análise Section

    @ViewBuilder
    private var analiseSection: some View {
        if isLoadingAnalise {
            loadingAnaliseView
        } else if let analise = analiseTerreno {
            VStack(alignment: .leading, spacing: 16) {
                sectionHeader

                // Área do Terreno
                if let area = areaTerreno {
                    areaCard(area: area)
                }

                // Precificação do Terreno
                precificacaoCard(analise: analise)

                // Dados da Amostra
                if let dadosAmostra = analise.dadosAmostra {
                    dadosAmostraCard(dados: dadosAmostra)
                }

                // Estatísticas por Bairro
                if let estatisticas = analise.estatisticasPorBairro, !estatisticas.isEmpty {
                    estatisticasBairroCard(estatisticas: estatisticas)
                }

                // Parecer do Estudo
                if let parecer = analise.parecerEstudo {
                    parecerCard(parecer: parecer)
                }

                // Metadados
                if let metadados = analise.metadados {
                    metadadosCard(metadados: metadados)
                }
            }
        } else if hasError {
            analiseIndisponivelView
        }
    }

    // MARK: - Section Header

    private var sectionHeader: some View {
        HStack {
            Image(systemName: "chart.bar.doc.horizontal.fill")
                .foregroundColor(.green)
                .font(.title3)
            Text("Análise do Terreno")
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding(.top, 8)
    }

    // MARK: - Área Card

    private func areaCard(area: Double) -> some View {
        HStack {
            Image(systemName: "square.dashed")
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text("Área do Terreno")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(String(format: "%.2f m²", area))
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }

    // MARK: - Precificação Card

    private func precificacaoCard(analise: AnaliseTerreno) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
                Text("Precificação")
                    .font(.headline)
            }

            VStack(spacing: 12) {
                // Valor Total Estimado
                if let valorTotal = analise.precificacaoTerreno.valorTotalEstimado {
                    valorRow(
                        label: "Valor Total Estimado",
                        valor: valorTotal,
                        icon: "banknote.fill",
                        destaque: true
                    )
                }

                // Valor por m²
                if let valorM2 = analise.precificacaoTerreno.valorM2Estimado {
                    Divider()
                    valorRow(
                        label: "Valor por m²",
                        valor: valorM2,
                        icon: "square.grid.3x3.fill",
                        destaque: false
                    )
                }

                // Faixa de Valores
                if let faixa = analise.precificacaoTerreno.faixaValores {
                    Divider()
                    faixaValoresView(faixa: faixa)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Valor Row

    private func valorRow(label: String, valor: Double, icon: String, destaque: Bool) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(destaque ? .green : .secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(formatarMoeda(valor))
                    .font(destaque ? .title3 : .body)
                    .fontWeight(destaque ? .bold : .semibold)
                    .foregroundColor(destaque ? .green : .primary)
            }

            Spacer()
        }
    }

    // MARK: - Faixa Valores View

    private func faixaValoresView(faixa: FaixaValoresTerreno) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.green)
                    .frame(width: 24)
                Text("Faixa de Valores")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mínimo")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(formatarMoeda(faixa.minimo))
                        .font(.caption)
                        .fontWeight(.medium)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Máximo")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(formatarMoeda(faixa.maximo))
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
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
                    Text("Terrenos Analisados:")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(dados.count)")
                        .fontWeight(.semibold)
                }

                // Lista de terrenos (primeiros 3)
                if !dados.isEmpty {
                    Divider()

                    ForEach(Array(dados.prefix(3).enumerated()), id: \.offset) { index, terreno in
                        VStack(alignment: .leading, spacing: 4) {
                            if let endereco = terreno.endereco {
                                Text(endereco)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }

                            HStack(spacing: 4) {
                                if let area = terreno.areaM2 {
                                    Text("\(Int(area)) m²")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }

                                if let valorM2 = terreno.valorM2 {
                                    Text("•")
                                        .foregroundColor(.secondary)
                                    Text(formatarMoeda(valorM2) + "/m²")
                                        .font(.caption2)
                                        .foregroundColor(.green)
                                        .fontWeight(.medium)
                                }
                            }
                        }

                        if index < 2 {
                            Divider()
                        }
                    }

                    // Indicador de mais terrenos
                    if dados.count > 3 {
                        Text("+ \(dados.count - 3) terreno(s)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 4)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Estatísticas Bairro Card

    private func estatisticasBairroCard(estatisticas: [String: EstatisticaBairro]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(.orange)
                Text("Estatísticas por Região")
                    .font(.headline)
            }

            VStack(spacing: 8) {
                ForEach(Array(estatisticas.keys.sorted()), id: \.self) { bairro in
                    if let stats = estatisticas[bairro] {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bairro)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            HStack {
                                if let valorMedio = stats.valorMedioM2 {
                                    Text("Valor médio/m²:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(formatarMoeda(valorMedio))
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.orange)
                                }

                                Spacer()

                                if let quantidade = stats.quantidadeAmostras {
                                    Text("\(quantidade) amostra(s)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        if bairro != estatisticas.keys.sorted().last {
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

    // MARK: - Parecer Card

    private func parecerCard(parecer: ParecerEstudo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.purple)
                Text("Parecer do Estudo")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 8) {
                // Confiabilidade
                if let confiabilidade = parecer.confiabilidade {
                    HStack {
                        Text("Confiabilidade:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(confiabilidade.capitalized)
                            .fontWeight(.semibold)
                            .foregroundColor(corConfiabilidade(confiabilidade))
                        Circle()
                            .fill(corConfiabilidade(confiabilidade))
                            .frame(width: 8, height: 8)
                    }
                }

                // Observações
                if let observacoes = parecer.observacoes, !observacoes.isEmpty {
                    Divider()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Observações:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(observacoes)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 4)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
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
                        Text("Fonte:")
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

    // MARK: - Loading & Error Views

    private var loadingAnaliseView: some View {
        HStack(spacing: 12) {
            ProgressView()
            Text("Carregando análise do terreno...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var analiseIndisponivelView: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.orange)

            Text("Análise de terreno não disponível")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Text("Os dados de análise ainda não foram gerados para este projeto")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }

    // MARK: - Helper Functions

    private func formatarMoeda(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = "R$"
        return formatter.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }

    private func corConfiabilidade(_ confiabilidade: String) -> Color {
        switch confiabilidade.lowercased() {
        case "alta": return .green
        case "média", "media": return .orange
        case "baixa": return .red
        default: return .secondary
        }
    }

    private func carregarAnaliseTerreno(projetoId: String) async {
        isLoadingAnalise = true
        hasError = false
        defer { isLoadingAnalise = false }

        do {
            analiseTerreno = try await AnalysisService.shared.getAnaliseTerreno(projetoId: projetoId)
            hasError = analiseTerreno == nil
        } catch {
            hasError = true
            print("⚠️ Erro ao carregar análise de terreno: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            // Com coordenadas e análise
            TerrainMapView(
                latitude: -12.9714,
                longitude: -38.5014,
                endereco: "Rua das Flores, 123 - Salvador, BA",
                projetoId: "preview-id",
                areaTerreno: 800.0
            )
            .padding()

            Divider()

            // Sem coordenadas
            TerrainMapView(
                latitude: nil,
                longitude: nil,
                endereco: "Endereço não especificado"
            )
            .padding()
        }
    }
}
