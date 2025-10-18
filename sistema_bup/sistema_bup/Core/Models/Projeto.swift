//
//  Projeto.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import Foundation
import FirebaseFirestore

// MARK: - Projeto (Documento Principal)
struct Projeto: Identifiable, Codable {
    var id: String?
    let nomeProjeto: String
    let tipoProjeto: String
    let descriProjeto: String
    let nomeCliente: String
    let dataInicio: String
    let endereco: String
    let infoCriacao: InfoCriacao

    // Campos opcionais de informação do projeto
    let anotacoesGerais: String?
    let anotacoesLegislacao: String?
    let areaTerreno: Double?
    let caBase: Double?
    let caMax: Double?
    let caMin: Double?
    let io: Double?
    let ip: Double?
    let latitude: Double?
    let longitude: Double?
    let zonaUrbanistica: String?
    let recuo_frontal: Double?
    let recuo_lateral: Double?
    let recuo_fundos: Double?

    enum CodingKeys: String, CodingKey {
        case informacaoProjeto = "informacao_projeto"
    }

    // Codificação customizada para lidar com estrutura aninhada
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decodifica o campo aninhado informacao_projeto
        let infoContainer = try container.nestedContainer(keyedBy: InfoProjetoKeys.self, forKey: .informacaoProjeto)

        nomeProjeto = try infoContainer.decode(String.self, forKey: .nomeProjeto)
        tipoProjeto = try infoContainer.decode(String.self, forKey: .tipoProjeto)
        descriProjeto = try infoContainer.decode(String.self, forKey: .descriProjeto)
        nomeCliente = try infoContainer.decode(String.self, forKey: .nomeCliente)
        dataInicio = try infoContainer.decode(String.self, forKey: .dataInicio)
        endereco = try infoContainer.decode(String.self, forKey: .endereco)
        infoCriacao = try infoContainer.decode(InfoCriacao.self, forKey: .infoCriacao)

        // Campos opcionais
        anotacoesGerais = try? infoContainer.decode(String.self, forKey: .anotacoesGerais)
        anotacoesLegislacao = try? infoContainer.decode(String.self, forKey: .anotacoesLegislacao)
        areaTerreno = try? infoContainer.decode(Double.self, forKey: .areaTerreno)
        caBase = try? infoContainer.decode(Double.self, forKey: .caBase)
        caMax = try? infoContainer.decode(Double.self, forKey: .caMax)
        caMin = try? infoContainer.decodeFlexibleDouble(forKey: .caMin)
        io = try? infoContainer.decodeFlexibleDouble(forKey: .io)
        ip = try? infoContainer.decodeFlexibleDouble(forKey: .ip)
        latitude = try? infoContainer.decodeFlexibleDouble(forKey: .latitude)
        longitude = try? infoContainer.decodeFlexibleDouble(forKey: .longitude)
        zonaUrbanistica = try? infoContainer.decode(String.self, forKey: .zonaUrbanistica)
        recuo_frontal = try? infoContainer.decodeFlexibleDouble(forKey: .recuo_frontal)
        recuo_lateral = try? infoContainer.decodeFlexibleDouble(forKey: .recuo_lateral)
        recuo_fundos = try? infoContainer.decodeFlexibleDouble(forKey: .recuo_fundos)

        // O ID será definido pelo FirestoreService após decodificação
        id = nil
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var infoContainer = container.nestedContainer(keyedBy: InfoProjetoKeys.self, forKey: .informacaoProjeto)

        try infoContainer.encode(nomeProjeto, forKey: .nomeProjeto)
        try infoContainer.encode(tipoProjeto, forKey: .tipoProjeto)
        try infoContainer.encode(descriProjeto, forKey: .descriProjeto)
        try infoContainer.encode(nomeCliente, forKey: .nomeCliente)
        try infoContainer.encode(dataInicio, forKey: .dataInicio)
        try infoContainer.encode(endereco, forKey: .endereco)
        try infoContainer.encode(infoCriacao, forKey: .infoCriacao)

        try infoContainer.encodeIfPresent(anotacoesGerais, forKey: .anotacoesGerais)
        try infoContainer.encodeIfPresent(anotacoesLegislacao, forKey: .anotacoesLegislacao)
        try infoContainer.encodeIfPresent(areaTerreno, forKey: .areaTerreno)
        try infoContainer.encodeIfPresent(caBase, forKey: .caBase)
        try infoContainer.encodeIfPresent(caMax, forKey: .caMax)
        try infoContainer.encodeIfPresent(caMin, forKey: .caMin)
        try infoContainer.encodeIfPresent(io, forKey: .io)
        try infoContainer.encodeIfPresent(ip, forKey: .ip)
        try infoContainer.encodeIfPresent(latitude, forKey: .latitude)
        try infoContainer.encodeIfPresent(longitude, forKey: .longitude)
        try infoContainer.encodeIfPresent(zonaUrbanistica, forKey: .zonaUrbanistica)
    }

    // Helper para formatar data de criação
    var dataFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "pt_BR")

        if let date = formatter.date(from: infoCriacao.dataCriacao) {
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }

        return infoCriacao.dataCriacao
    }
}

private extension KeyedDecodingContainer {
    func decodeFlexibleDouble(forKey key: Key) throws -> Double? {
        // Try decoding as Double directly
        if let value = try? self.decode(Double.self, forKey: key) {
            return value
        }
        // Try decoding as String and convert
        if let stringValue = try? self.decode(String.self, forKey: key) {
            return Double(stringValue.replacingOccurrences(of: ",", with: "."))
        }
        // Try decoding as Int and convert
        if let intValue = try? self.decode(Int.self, forKey: key) {
            return Double(intValue)
        }
        return nil
    }
}

// MARK: - Info Projeto Keys (para decodificação aninhada)
private enum InfoProjetoKeys: String, CodingKey {
    case nomeProjeto = "nome_projeto"
    case tipoProjeto = "tipo_projeto"
    case descriProjeto = "descri_projeto"
    case nomeCliente = "nome_cliente"
    case dataInicio = "data_inicio"
    case endereco
    case infoCriacao = "info_criacao"
    case anotacoesGerais = "anotacoes_gerais"
    case anotacoesLegislacao = "anotacoes_legislacao"
    case areaTerreno = "area_terreno"
    case caBase = "ca_bas"
    case caMax = "ca_max"
    case caMin = "ca_min"
    case io
    case ip
    case latitude
    case longitude
    case zonaUrbanistica = "zona_urbanistica"
    case recuo_frontal
    case recuo_lateral
    case recuo_fundos
}

// MARK: - Info Criação
struct InfoCriacao: Codable {
    let dataCriacao: String
    let usuarioCriador: String

    enum CodingKeys: String, CodingKey {
        case dataCriacao = "data_criacao"
        case usuarioCriador = "usuario_criador"
    }
}

// MARK: - Análise de Espaço de Soluções
struct AnaliseEspacoSolucoes: Identifiable, Codable {
    @DocumentID var id: String? // versão: "1.0", "2.0", etc
    let dataCriacao: Date
    let metricasViabilidade: MetricasViabilidade
    let estatisticasLucros: EstatisticasNumericas
    let estatisticasMargens: EstatisticasNumericas
    let metricasCriterios: MetricasCriterios
    let infoCriacao: InfoCriacaoAnalise

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case metricasViabilidade = "metricas_viabilidade"
        case estatisticasLucros = "estatisticas_lucros"
        case estatisticasMargens = "estatisticas_margens"
        case metricasCriterios = "metricas_criterios"
        case infoCriacao = "info_criacao"
    }
}

struct MetricasViabilidade: Codable {
    let solucoesViaveis: Int
    let solucoesInviaveis: Int
    let percentualViavel: Double
    let lucroMedio: Double

    enum CodingKeys: String, CodingKey {
        case solucoesViaveis = "solucoes_viaveis"
        case solucoesInviaveis = "solucoes_inviaveis"
        case percentualViavel = "percentual_viavel"
        case lucroMedio = "lucro_medio"
    }
}

struct EstatisticasNumericas: Codable {
    let max: Double
    let min: Double
    let media: Double
    let mediana: Double
}

struct MetricasCriterios: Codable {
    let margemMaior16: CriterioMetrica
    let vagasSuficientes: CriterioMetrica
    let areaPositiva: CriterioMetrica
    let todosCriterios: CriterioMetrica

    enum CodingKeys: String, CodingKey {
        case margemMaior16 = "margem_maior_16"
        case vagasSuficientes = "vagas_suficientes"
        case areaPositiva = "area_positiva"
        case todosCriterios = "todos_criterios"
    }
}

struct CriterioMetrica: Codable {
    let quantidade: Int
    let percentual: Double
}

struct InfoCriacaoAnalise: Codable {
    let data: String
    let usuario: String
    let totalSolucoes: Int

    enum CodingKeys: String, CodingKey {
        case data
        case usuario
        case totalSolucoes = "total_solucoes"
    }
}

// MARK: - Análise de Mercado
struct AnaliseMercado: Identifiable, Codable {
    @DocumentID var id: String? // versão
    let dataCriacao: Date
    let precosImoveisRegiao: PrecosImoveisRegiao
    let descricaoImoveisRegiao: DescricaoImoveisRegiao
    let precificacaoImovel: PrecificacaoImovel

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case precosImoveisRegiao = "precos_imoveis_regiao"
        case descricaoImoveisRegiao = "descricao_imoveis_regiao"
        case precificacaoImovel = "precificacao_imovel"
    }
}

struct PrecosImoveisRegiao: Codable {
    let valorMediaBairro: Double
    let valorMediaCidade: Double
    let htmlMapaCalor: String?

    enum CodingKeys: String, CodingKey {
        case valorMediaBairro = "valor_media_bairro"
        case valorMediaCidade = "valor_media_cidade"
        case htmlMapaCalor = "html_mapa_calor"
    }
}

struct DescricaoImoveisRegiao: Codable {
    // Distribuições (pode ser expandido conforme necessário)
}

struct PrecificacaoImovel: Codable {
    let valorUnitarioEstimado: Double
    let valorVendaEstimado: Double

    enum CodingKeys: String, CodingKey {
        case valorUnitarioEstimado = "valor_unitario_estimado"
        case valorVendaEstimado = "valor_venda_estimado"
    }
}

// MARK: - Análise de Terreno
struct AnaliseTerreno: Identifiable, Codable {
    @DocumentID var id: String? // versão
    let dataCriacao: Date
    let descricao: String
    let parecerEstudo: String
    let precificacaoTerreno: PrecificacaoTerreno

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case descricao
        case parecerEstudo = "parecer_estudo"
        case precificacaoTerreno = "precificacao_terreno"
    }
}

struct PrecificacaoTerreno: Codable {
    let areaTerreno: Double
    let precoAdotado: Double
    let precoUnitarioAdotado: Double

    enum CodingKeys: String, CodingKey {
        case areaTerreno = "area_terreno"
        case precoAdotado = "preco_adotado"
        case precoUnitarioAdotado = "preco_unitario_adotado"
    }
}

// MARK: - Análise de Viabilidade
struct AnaliseViabilidade: Identifiable, Codable {
    @DocumentID var id: String? // versão
    let dataCriacao: String
    let parecerViabilidade: ParecerViabilidade
    let parecerInfo: ParecerInfo
    let solucoesViaveis: [String: SolucaoViavel]? // Top 100 soluções

    enum CodingKeys: String, CodingKey {
        case id
        case dataCriacao = "data_criacao"
        case parecerViabilidade = "parecer_viabilidade"
        case parecerInfo = "parecer_info"
        case solucoesViaveis = "solucoes_viaveis"
    }
}

struct ParecerViabilidade: Codable {
    let parecer: String
}

struct ParecerInfo: Codable {
    let solucaoEscolhida: String
    let quantidadeSolucoesViaveis: Int

    enum CodingKeys: String, CodingKey {
        case solucaoEscolhida = "solucao_escolhida"
        case quantidadeSolucoesViaveis = "quantidade_solucoes_viaveis"
    }
}

struct SolucaoViavel: Codable {
    // ~100 campos conforme documentação
    // Pode ser expandido conforme necessário
    let receita: Double?
    let custoTotalEmpreendimento: Double?
    let lucroIncorporacao: Double?

    enum CodingKeys: String, CodingKey {
        case receita
        case custoTotalEmpreendimento = "custo_total_empreendimento"
        case lucroIncorporacao = "lucro_incorporacao"
    }
}

