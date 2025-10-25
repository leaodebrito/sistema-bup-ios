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
    var id: String? // versão: "1.0", "2.0", etc
    let versao: String
    let status: String
    let dataCriacao: String
    let infoCriacao: InfoCriacaoSubcollection?
    let estatisticasMargens: EstatisticasNumericas
    let estatisticasLucros: EstatisticasLucrosDetalhadas
    let metricasCriterios: MetricasCriterios
    let metricasViabilidade: MetricasViabilidade
    let distribuicoesValores: DistribuicoesValores?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case versao
        case status
        case dataCriacao = "data_criacao"
        case infoCriacao = "info_criacao"
        case estatisticasMargens = "estatisticas_margens"
        case estatisticasLucros = "estatisticas_lucros"
        case metricasCriterios = "metricas_criterios"
        case metricasViabilidade = "metricas_viabilidade"
        case distribuicoesValores = "distribuicoes_valores"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        versao = try container.decode(String.self, forKey: .versao)
        status = try container.decode(String.self, forKey: .status)

        // Tenta decodificar data_criacao como String ou Timestamp
        if let dateString = try? container.decode(String.self, forKey: .dataCriacao) {
            dataCriacao = dateString
        } else if let timestamp = try? container.decode(FirebaseFirestore.Timestamp.self, forKey: .dataCriacao) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dataCriacao = dateFormatter.string(from: timestamp.dateValue())
        } else {
            dataCriacao = ""
        }

        infoCriacao = try? container.decode(InfoCriacaoSubcollection.self, forKey: .infoCriacao)
        estatisticasMargens = try container.decode(EstatisticasNumericas.self, forKey: .estatisticasMargens)
        estatisticasLucros = try container.decode(EstatisticasLucrosDetalhadas.self, forKey: .estatisticasLucros)
        metricasCriterios = try container.decode(MetricasCriterios.self, forKey: .metricasCriterios)
        metricasViabilidade = try container.decode(MetricasViabilidade.self, forKey: .metricasViabilidade)
        distribuicoesValores = try? container.decode(DistribuicoesValores.self, forKey: .distribuicoesValores)
    }
}

struct EstatisticasNumericas: Codable {
    let media: Double?
    let mediana: Double?
    let minima: Double?
    let maxima: Double?

    // Aliases para compatibilidade
    var max: Double? { maxima }
    var min: Double? { minima }
}

struct EstatisticasLucrosDetalhadas: Codable {
    let medio: Double?
    let mediano: Double?
    let minimo: Double?
    let maximo: Double?
}

struct MetricasViabilidade: Codable {
    let solucoesViaveis: Int
    let solucoesInviaveis: Int
    let taxaViabilidade: Double?

    enum CodingKeys: String, CodingKey {
        case solucoesViaveis = "solucoes_viaveis"
        case solucoesInviaveis = "solucoes_inviaveis"
        case taxaViabilidade = "taxa_viabilidade"
    }
}

struct MetricasCriterios: Codable {
    let todosCriterios: CriterioMetrica
    let criterioMinimoUnidades: CriterioMetrica?
    let criterioMargemMinima: CriterioMetrica?

    enum CodingKeys: String, CodingKey {
        case todosCriterios = "todos_criterios"
        case criterioMinimoUnidades = "criterio_minimo_unidades"
        case criterioMargemMinima = "criterio_margem_minima"
    }
}

struct CriterioMetrica: Codable {
    let quantidade: Int
    let percentual: Double
}

struct DistribuicoesValores: Codable {
    let lucros: [Double]?
    let margens: [Double]?
    let vpls: [Double]?
    let tirs: [Double]?
}

struct InfoCriacaoSubcollection: Codable {
    let usuarioCriador: String
    let dataCriacao: String

    enum CodingKeys: String, CodingKey {
        case usuarioCriador = "usuario_criador"
        case dataCriacao = "data_criacao"
    }
}

// MARK: - Análise de Mercado
struct AnaliseMercado: Identifiable, Codable {
    var id: String? // versão
    let versao: String
    let status: String
    let dataCriacao: String
    let infoCriacao: InfoCriacaoSubcollection?
    let precificacaoImovel: PrecificacaoImovel
    let dadosImoveisRegiao: DadosImoveisRegiao?
    let precosImoveisRegiao: PrecosImoveisRegiao?
    let descricaoImoveisRegiao: DescricaoImoveisRegiao?
    let conclusoesEstudo: ConcluxaoEstudoMercado?

    // Computed property para obter o valor de referência do m² das conclusões se a precificação estiver zerada
    var valorReferenciaM2Calculado: Double? {
        if let valor = precificacaoImovel.valorReferenciaM2, valor > 0 {
            return valor
        }
        // Se não houver na precificação, tenta pegar das conclusões
        if let precoStr = conclusoesEstudo?.precoUnitarioVendaAdotado,
           let preco = Double(precoStr) {
            return preco
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case versao
        case status
        case dataCriacao = "data_criacao"
        case infoCriacao = "info_criacao"
        case precificacaoImovel = "precificacao_imovel"
        case dadosImoveisRegiao = "dados_imoveis_regiao"
        case precosImoveisRegiao = "precos_imoveis_regiao"
        case descricaoImoveisRegiao = "descricao_imoveis_regiao"
        case conclusoesEstudo = "conclusoes_estudo"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        versao = try container.decode(String.self, forKey: .versao)
        status = try container.decode(String.self, forKey: .status)

        // Tenta decodificar data_criacao como String ou Timestamp
        if let dateString = try? container.decode(String.self, forKey: .dataCriacao) {
            dataCriacao = dateString
        } else if let timestamp = try? container.decode(FirebaseFirestore.Timestamp.self, forKey: .dataCriacao) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dataCriacao = dateFormatter.string(from: timestamp.dateValue())
        } else {
            dataCriacao = ""
        }

        infoCriacao = try? container.decode(InfoCriacaoSubcollection.self, forKey: .infoCriacao)
        precificacaoImovel = try container.decode(PrecificacaoImovel.self, forKey: .precificacaoImovel)
        dadosImoveisRegiao = try? container.decode(DadosImoveisRegiao.self, forKey: .dadosImoveisRegiao)
        precosImoveisRegiao = try? container.decode(PrecosImoveisRegiao.self, forKey: .precosImoveisRegiao)
        descricaoImoveisRegiao = try? container.decode(DescricaoImoveisRegiao.self, forKey: .descricaoImoveisRegiao)
        conclusoesEstudo = try? container.decode(ConcluxaoEstudoMercado.self, forKey: .conclusoesEstudo)
    }
}

struct PrecificacaoImovel: Codable {
    let area: Double?
    let banheiros: Int?
    let cidade: String?
    let garagem: Int?
    let idadeImovel: Int?
    let latitude: String?
    let longitude: String?
    let qualidadeImovel: Int?
    let quartos: Int?
    let tipo: String?
    let valorUnitarioEstimado: Double?
    let valorVendaEstimado: Double?

    // Computed properties para compatibilidade com a UI
    var valorReferenciaM2: Double? {
        return valorUnitarioEstimado
    }

    var faixaPrecoM2: FaixaPreco? {
        // Se houver valor estimado, cria uma faixa com +/- 10%
        guard let valor = valorUnitarioEstimado, valor > 0 else { return nil }
        let variacao = valor * 0.1
        return FaixaPreco(
            minimo: valor - variacao,
            medio: valor,
            maximo: valor + variacao
        )
    }

    enum CodingKeys: String, CodingKey {
        case area
        case banheiros
        case cidade
        case garagem
        case idadeImovel = "idade_imovel"
        case latitude
        case longitude
        case qualidadeImovel = "qualidade_imovel"
        case quartos
        case tipo
        case valorUnitarioEstimado = "valor_unitario_estimado"
        case valorVendaEstimado = "valor_venda_estimado"
    }

    // Custom decoder para lidar com latitude/longitude que podem ser String ou Double
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        area = try? container.decode(Double.self, forKey: .area)
        banheiros = try? container.decode(Int.self, forKey: .banheiros)
        cidade = try? container.decode(String.self, forKey: .cidade)
        garagem = try? container.decode(Int.self, forKey: .garagem)
        idadeImovel = try? container.decode(Int.self, forKey: .idadeImovel)
        qualidadeImovel = try? container.decode(Int.self, forKey: .qualidadeImovel)
        quartos = try? container.decode(Int.self, forKey: .quartos)
        tipo = try? container.decode(String.self, forKey: .tipo)
        valorUnitarioEstimado = try? container.decode(Double.self, forKey: .valorUnitarioEstimado)
        valorVendaEstimado = try? container.decode(Double.self, forKey: .valorVendaEstimado)

        // Latitude pode ser String ou Double
        if let latStr = try? container.decode(String.self, forKey: .latitude) {
            latitude = latStr
        } else if let latNum = try? container.decode(Double.self, forKey: .latitude) {
            latitude = String(latNum)
        } else {
            latitude = nil
        }

        // Longitude pode ser String ou Double
        if let lonStr = try? container.decode(String.self, forKey: .longitude) {
            longitude = lonStr
        } else if let lonNum = try? container.decode(Double.self, forKey: .longitude) {
            longitude = String(lonNum)
        } else {
            longitude = nil
        }
    }
}

struct FaixaPreco: Codable {
    let minimo: Double
    let medio: Double
    let maximo: Double
}

struct DadosImoveisRegiao: Codable {
    let imoveis: [ImovelAnalisado]?
    let metadados: MetadadosImoveis?

    // Computed property para compatibilidade
    var quantidadeTotal: Int? {
        return metadados?.totalImoveis
    }

    var imoveisAnalisados: [ImovelAnalisado]? {
        return imoveis
    }

    enum CodingKeys: String, CodingKey {
        case imoveis
        case metadados
    }
}

struct MetadadosImoveis: Codable {
    let colunasIncluidas: [String]?
    let dataProcessamento: String?
    let totalImoveis: Int?

    enum CodingKeys: String, CodingKey {
        case colunasIncluidas = "colunas_incluidas"
        case dataProcessamento = "data_processamento"
        case totalImoveis = "total_imoveis"
    }
}

struct ImovelAnalisado: Codable {
    let Area: Double?
    let Bairro: String?
    let Banheiro: Int?
    let Cidade: String?
    let Endereco: String?
    let Idade: String? // Pode ser "nan" ou número
    let Latitude: String?
    let Longitude: String?
    let Preco_venda: Double?
    let Quartos: Int?
    let Suites: Int?
    let Vaga: Int?
    let preco_unitario: String?

    // Computed properties para compatibilidade com a UI
    var endereco: String? { Endereco }
    var areaM2: Double? { Area }
    var quartos: Int? { Quartos }
    var precoM2: Double? {
        guard let precoStr = preco_unitario else { return nil }
        return Double(precoStr)
    }

    // Custom decoder para lidar com "nan" em Idade
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        Area = try? container.decode(Double.self, forKey: .Area)
        Bairro = try? container.decode(String.self, forKey: .Bairro)
        Banheiro = try? container.decode(Int.self, forKey: .Banheiro)
        Cidade = try? container.decode(String.self, forKey: .Cidade)
        Endereco = try? container.decode(String.self, forKey: .Endereco)
        Latitude = try? container.decode(String.self, forKey: .Latitude)
        Longitude = try? container.decode(String.self, forKey: .Longitude)
        Preco_venda = try? container.decode(Double.self, forKey: .Preco_venda)
        Quartos = try? container.decode(Int.self, forKey: .Quartos)
        Suites = try? container.decode(Int.self, forKey: .Suites)
        Vaga = try? container.decode(Int.self, forKey: .Vaga)
        preco_unitario = try? container.decode(String.self, forKey: .preco_unitario)

        // Idade pode ser "nan" ou número
        if let idadeInt = try? container.decode(Int.self, forKey: .Idade) {
            Idade = String(idadeInt)
        } else if let idadeStr = try? container.decode(String.self, forKey: .Idade) {
            Idade = idadeStr
        } else {
            Idade = nil
        }
    }
}

struct PrecosImoveisRegiao: Codable {
    let bairrosAnalisados: [String]?
    // Pode ter outros campos futuramente

    // Computed property - por enquanto retorna nil pois não vem do Firestore
    var precoMedioM2: Double? {
        return nil
    }

    var distribuicaoPrecos: [Double]? {
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case bairrosAnalisados = "bairros_analisados"
    }
}

struct DescricaoImoveisRegiao: Codable {
    let tipoPredominante: String?
    let areaMediaM2: Double?
    let quartosMedio: Double?

    enum CodingKeys: String, CodingKey {
        case tipoPredominante = "tipo_predominante"
        case areaMediaM2 = "area_media_m2"
        case quartosMedio = "quartos_medio"
    }
}

struct ConcluxaoEstudoMercado: Codable {
    let dataAtualizacaoParecer: String?
    let parecerEstudo: String?
    let precoUnitarioVendaAdotado: String?
    let precoVendaAdotado: String?
    let usuarioAtualizacaoParecer: String?

    // Computed properties para compatibilidade com a UI antiga
    var demandaAlta: Bool? {
        // Analisa o parecer para determinar se menciona demanda alta
        guard let parecer = parecerEstudo?.lowercased() else { return nil }
        return parecer.contains("demanda alta") || parecer.contains("alta demanda")
    }

    var competitividade: String? {
        return parecerEstudo
    }

    var recomendacao: String? {
        return parecerEstudo
    }

    enum CodingKeys: String, CodingKey {
        case dataAtualizacaoParecer = "data_atualizacao_parecer"
        case parecerEstudo = "parecer_estudo"
        case precoUnitarioVendaAdotado = "preco_unitario_venda_adotado"
        case precoVendaAdotado = "preco_venda_adotado"
        case usuarioAtualizacaoParecer = "usuario_atualizacao_parecer"
    }
}

// MARK: - Análise de Terreno
struct AnaliseTerreno: Identifiable, Codable {
    var id: String? // versão
    let versao: String
    let status: String
    let dataCriacao: String
    let infoCriacao: InfoCriacaoSubcollection?
    let precificacaoTerreno: PrecificacaoTerreno
    let dadosAmostra: DadosAmostraTerreno?
    let estatisticasPorBairro: [String: EstatisticaBairro]?
    let parecerEstudo: ParecerEstudo?
    let metadados: MetadadosTerreno?
    let descricao: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case versao
        case status
        case dataCriacao = "data_criacao"
        case infoCriacao = "info_criacao"
        case precificacaoTerreno = "precificacao_terreno"
        case dadosAmostra = "dados_amostra"
        case estatisticasPorBairro = "estatisticas_por_bairro"
        case parecerEstudo = "parecer_estudo"
        case metadados
        case descricao
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Debug: mostrar todas as chaves disponíveis
        print("🔍 DEBUG AnaliseTerreno - Chaves disponíveis:")
        print(container.allKeys.map { $0.stringValue })

        id = try? container.decode(String.self, forKey: .id)
        versao = try container.decode(String.self, forKey: .versao)
        status = try container.decode(String.self, forKey: .status)

        // Tenta decodificar data_criacao como String ou Timestamp
        if let dateString = try? container.decode(String.self, forKey: .dataCriacao) {
            dataCriacao = dateString
        } else if let timestamp = try? container.decode(FirebaseFirestore.Timestamp.self, forKey: .dataCriacao) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dataCriacao = dateFormatter.string(from: timestamp.dateValue())
        } else {
            dataCriacao = ""
        }

        infoCriacao = try? container.decode(InfoCriacaoSubcollection.self, forKey: .infoCriacao)
        precificacaoTerreno = try container.decode(PrecificacaoTerreno.self, forKey: .precificacaoTerreno)
        dadosAmostra = try? container.decode(DadosAmostraTerreno.self, forKey: .dadosAmostra)
        estatisticasPorBairro = try? container.decode([String: EstatisticaBairro].self, forKey: .estatisticasPorBairro)
        parecerEstudo = try? container.decode(ParecerEstudo.self, forKey: .parecerEstudo)
        metadados = try? container.decode(MetadadosTerreno.self, forKey: .metadados)
        descricao = try? container.decode(String.self, forKey: .descricao)
    }
}

struct PrecificacaoTerreno: Codable {
    let areaTerreno: Double?
    let bairroTerreno: String?
    let precoAdotado: Double?
    let precoEstimado: String? // Pode vir como string ou número
    let precoTotalCalculado: Double?
    let precoUnitarioAdotado: Double?
    let precoUnitarioManual: Double?
    let precoM2BaseBairro: String? // Pode vir como string ou número
    let diferencaPercentual: String? // Pode vir como string ou número

    // Computed properties para manter compatibilidade com a UI
    var valorM2Estimado: Double? {
        return precoUnitarioAdotado ?? precoUnitarioManual
    }

    var valorTotalEstimado: Double? {
        return precoTotalCalculado ?? precoAdotado
    }

    var faixaValores: FaixaValoresTerreno? {
        // Calcula faixa baseado na diferença percentual se existir
        guard let total = valorTotalEstimado,
              let percentualStr = diferencaPercentual,
              let percentual = Double(percentualStr) else {
            return nil
        }

        let variacao = total * (percentual / 100)
        return FaixaValoresTerreno(
            minimo: total - variacao,
            maximo: total + variacao
        )
    }

    enum CodingKeys: String, CodingKey {
        case areaTerreno = "area_terreno"
        case bairroTerreno = "bairro_terreno"
        case precoAdotado = "preco_adotado"
        case precoEstimado = "preco_estimado"
        case precoTotalCalculado = "preco_total_calculado"
        case precoUnitarioAdotado = "preco_unitario_adotado"
        case precoUnitarioManual = "preco_unitario_manual"
        case precoM2BaseBairro = "preco_m2_base_bairro"
        case diferencaPercentual = "diferenca_percentual"
    }

    // Custom decoder para lidar com campos que podem ser String ou Double
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        areaTerreno = try? container.decode(Double.self, forKey: .areaTerreno)
        bairroTerreno = try? container.decode(String.self, forKey: .bairroTerreno)
        precoAdotado = try? container.decode(Double.self, forKey: .precoAdotado)
        precoTotalCalculado = try? container.decode(Double.self, forKey: .precoTotalCalculado)
        precoUnitarioAdotado = try? container.decode(Double.self, forKey: .precoUnitarioAdotado)
        precoUnitarioManual = try? container.decode(Double.self, forKey: .precoUnitarioManual)

        // precoEstimado pode ser String ou Double
        if let precoEstimadoStr = try? container.decode(String.self, forKey: .precoEstimado) {
            precoEstimado = precoEstimadoStr
        } else if let precoEstimadoNum = try? container.decode(Double.self, forKey: .precoEstimado) {
            precoEstimado = String(precoEstimadoNum)
        } else {
            precoEstimado = nil
        }

        // precoM2BaseBairro pode ser String ou Double
        if let precoM2Str = try? container.decode(String.self, forKey: .precoM2BaseBairro) {
            precoM2BaseBairro = precoM2Str
        } else if let precoM2Num = try? container.decode(Double.self, forKey: .precoM2BaseBairro) {
            precoM2BaseBairro = String(precoM2Num)
        } else {
            precoM2BaseBairro = nil
        }

        // diferencaPercentual pode ser String ou Double
        if let difStr = try? container.decode(String.self, forKey: .diferencaPercentual) {
            diferencaPercentual = difStr
        } else if let difNum = try? container.decode(Double.self, forKey: .diferencaPercentual) {
            diferencaPercentual = String(difNum)
        } else {
            diferencaPercentual = nil
        }
    }
}

struct FaixaValoresTerreno: Codable {
    let minimo: Double
    let maximo: Double
}

// dados_amostra é um array direto no Firestore
typealias DadosAmostraTerreno = [TerrenoAnalisado]

struct TerrenoAnalisado: Codable {
    let Area: Double?
    let Bairro: String?
    let Latitude: String?
    let Longitude: String?
    let Link: String?
    let Preco_venda: Double?
    let Título: String?
    let ano_consulta: Int?
    let cidade: String?
    let data_consulta: String?
    let dia_consulta: Int?
    let endereco: String?
    let mes_consulta: Int?
    let preco_unitario: String? // Vem como string
    let publicacao_dias: Int?

    // Computed properties para compatibilidade com UI antiga
    var areaM2: Double? { Area }
    var valorM2: Double? {
        if let precoStr = preco_unitario {
            return Double(precoStr)
        }
        return nil
    }
}

struct EstatisticaBairro: Codable {
    let valorMedioM2: Double?
    let quantidadeAmostras: Int?

    enum CodingKeys: String, CodingKey {
        case valorMedioM2 = "valor_medio_m2"
        case quantidadeAmostras = "quantidade_amostras"
    }
}

struct ParecerEstudo: Codable {
    let confiabilidade: String?
    let observacoes: String?
}

struct MetadadosTerreno: Codable {
    let fonteDados: String?
    let dataColeta: String?

    enum CodingKeys: String, CodingKey {
        case fonteDados = "fonte_dados"
        case dataColeta = "data_coleta"
    }
}

// MARK: - Análise de Viabilidade
struct AnaliseViabilidade: Identifiable, Codable {
    var id: String? // versão
    let versao: String
    let status: String
    let dataCriacao: String
    let infoCriacao: InfoCriacaoSubcollection?
    let quantidadeSolucoesAvaliadas: Int?
    let quantidadeSolucoesViaveis: Int?
    let visaoGeral: VisaoGeralViabilidade?
    let solucoesViaveis: [SolucaoViavel]?
    let parecerViabilidade: ParecerViabilidadeDetalhado?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case versao
        case status
        case dataCriacao = "data_criacao"
        case infoCriacao = "info_criacao"
        case quantidadeSolucoesAvaliadas = "quantidade_solucoes_avaliadas"
        case quantidadeSolucoesViaveis = "quantidade_solucoes_viaveis"
        case visaoGeral = "visao_geral"
        case solucoesViaveis = "solucoes_viaveis"
        case parecerViabilidade = "parecer_viabilidade"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try? container.decode(String.self, forKey: .id)
        versao = try container.decode(String.self, forKey: .versao)
        status = try container.decode(String.self, forKey: .status)

        // Tenta decodificar data_criacao como String ou Timestamp
        if let dateString = try? container.decode(String.self, forKey: .dataCriacao) {
            dataCriacao = dateString
        } else if let timestamp = try? container.decode(FirebaseFirestore.Timestamp.self, forKey: .dataCriacao) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dataCriacao = dateFormatter.string(from: timestamp.dateValue())
        } else {
            dataCriacao = ""
        }

        infoCriacao = try? container.decode(InfoCriacaoSubcollection.self, forKey: .infoCriacao)
        quantidadeSolucoesAvaliadas = try? container.decode(Int.self, forKey: .quantidadeSolucoesAvaliadas)
        quantidadeSolucoesViaveis = try? container.decode(Int.self, forKey: .quantidadeSolucoesViaveis)
        visaoGeral = try? container.decode(VisaoGeralViabilidade.self, forKey: .visaoGeral)
        solucoesViaveis = try? container.decode([SolucaoViavel].self, forKey: .solucoesViaveis)
        parecerViabilidade = try? container.decode(ParecerViabilidadeDetalhado.self, forKey: .parecerViabilidade)
    }
}

struct VisaoGeralViabilidade: Codable {
    let melhorSolucao: ResumoSolucao?
    let solucaoMediana: ResumoSolucao?

    enum CodingKeys: String, CodingKey {
        case melhorSolucao = "melhor_solucao"
        case solucaoMediana = "solucao_mediana"
    }
}

struct ResumoSolucao: Codable {
    let id: String
    let lucro: Double?
    let margem: Double?
    let vpl: Double?
    let tir: Double?
}

struct SolucaoViavel: Codable, Identifiable {
    let id: String
    let configuracao: ConfiguracaoSolucao?
    let metricasEconomicas: MetricasEconomicas?
    let atendeCriterios: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case configuracao
        case metricasEconomicas = "metricas_economicas"
        case atendeCriterios = "atende_criterios"
    }
}

struct ConfiguracaoSolucao: Codable {
    let numPavimentos: Int?
    let unidadesPorPavimento: Int?
    let totalUnidades: Int?
    let areaUtilUnidade: Double?
    let quartos: Int?
    let suites: Int?
    let vagasGaragem: Int?

    enum CodingKeys: String, CodingKey {
        case numPavimentos = "num_pavimentos"
        case unidadesPorPavimento = "unidades_por_pavimento"
        case totalUnidades = "total_unidades"
        case areaUtilUnidade = "area_util_unidade"
        case quartos
        case suites
        case vagasGaragem = "vagas_garagem"
    }
}

struct MetricasEconomicas: Codable {
    let vgv: Double?
    let custoTotal: Double?
    let lucro: Double?
    let margem: Double?
    let vpl: Double?
    let tir: Double?
    let paybackAnos: Double?

    enum CodingKeys: String, CodingKey {
        case vgv
        case custoTotal = "custo_total"
        case lucro
        case margem
        case vpl
        case tir
        case paybackAnos = "payback_anos"
    }
}

struct ParecerViabilidadeDetalhado: Codable {
    let viavel: Bool?
    let nivelRisco: String?
    let recomendacao: String?

    enum CodingKeys: String, CodingKey {
        case viavel
        case nivelRisco = "nivel_risco"
        case recomendacao
    }
}

