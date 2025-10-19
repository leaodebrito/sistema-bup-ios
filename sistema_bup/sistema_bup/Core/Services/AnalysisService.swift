//
//  AnalysisService.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-19.
//

import Foundation
import FirebaseFirestore

/// Service para gerenciar todas as análises de um projeto
class AnalysisService {
    static let shared = AnalysisService()
    private let firestoreService = FirestoreService.shared

    private init() {}

    // MARK: - Análise de Terreno

    /// Retorna a análise de terreno mais recente de um projeto
    func getAnaliseTerreno(projetoId: String) async throws -> AnaliseTerreno? {
        return try await firestoreService.fetchAnaliseTerreno(projetoId: projetoId)
    }

    /// Retorna uma versão específica da análise de terreno
    func getAnaliseTerreno(projetoId: String, versao: String) async throws -> AnaliseTerreno {
        return try await firestoreService.fetchAnaliseTerreno(projetoId: projetoId, versao: versao)
    }

    /// Retorna todas as versões da análise de terreno
    func getAllAnalisesTerrenoVersions(projetoId: String) async throws -> [AnaliseTerreno] {
        return try await firestoreService.fetchAnalisesTerrenoAll(projetoId: projetoId)
    }

    // MARK: - Análise de Mercado

    /// Retorna a análise de mercado mais recente de um projeto
    func getAnaliseMercado(projetoId: String) async throws -> AnaliseMercado? {
        return try await firestoreService.fetchAnaliseMercado(projetoId: projetoId)
    }

    /// Retorna uma versão específica da análise de mercado
    func getAnaliseMercado(projetoId: String, versao: String) async throws -> AnaliseMercado {
        return try await firestoreService.fetchAnaliseMercado(projetoId: projetoId, versao: versao)
    }

    /// Retorna todas as versões da análise de mercado
    func getAllAnalisesMercadoVersions(projetoId: String) async throws -> [AnaliseMercado] {
        return try await firestoreService.fetchAnalisesMercadoAll(projetoId: projetoId)
    }

    // MARK: - Análise de Espaço de Soluções

    /// Retorna a análise de espaço de soluções mais recente de um projeto
    func getAnaliseEspacoSolucoes(projetoId: String) async throws -> AnaliseEspacoSolucoes? {
        return try await firestoreService.fetchAnaliseEspacoSolucoes(projetoId: projetoId)
    }

    /// Retorna uma versão específica da análise de espaço de soluções
    func getAnaliseEspacoSolucoes(projetoId: String, versao: String) async throws -> AnaliseEspacoSolucoes {
        return try await firestoreService.fetchAnaliseEspacoSolucoes(projetoId: projetoId, versao: versao)
    }

    /// Retorna todas as versões da análise de espaço de soluções
    func getAllAnalisesEspacoSolucoesVersions(projetoId: String) async throws -> [AnaliseEspacoSolucoes] {
        return try await firestoreService.fetchAnalisesEspacoSolucoesAll(projetoId: projetoId)
    }

    // MARK: - Análise de Viabilidade

    /// Retorna a análise de viabilidade mais recente de um projeto
    func getAnaliseViabilidade(projetoId: String) async throws -> AnaliseViabilidade? {
        return try await firestoreService.fetchAnaliseViabilidade(projetoId: projetoId)
    }

    /// Retorna uma versão específica da análise de viabilidade
    func getAnaliseViabilidade(projetoId: String, versao: String) async throws -> AnaliseViabilidade {
        return try await firestoreService.fetchAnaliseViabilidade(projetoId: projetoId, versao: versao)
    }

    /// Retorna todas as versões da análise de viabilidade
    func getAllAnalisesViabilidadeVersions(projetoId: String) async throws -> [AnaliseViabilidade] {
        return try await firestoreService.fetchAnalisesViabilidadeAll(projetoId: projetoId)
    }

    // MARK: - Análises Completas

    /// Estrutura para armazenar todas as análises de um projeto
    struct ProjetoAnalises {
        let terreno: AnaliseTerreno?
        let mercado: AnaliseMercado?
        let espacoSolucoes: AnaliseEspacoSolucoes?
        let viabilidade: AnaliseViabilidade?

        /// Retorna true se pelo menos uma análise existe
        var hasAnalyses: Bool {
            return terreno != nil || mercado != nil || espacoSolucoes != nil || viabilidade != nil
        }

        /// Retorna true se todas as análises principais existem
        var isComplete: Bool {
            return terreno != nil && mercado != nil && espacoSolucoes != nil && viabilidade != nil
        }
    }

    /// Retorna todas as análises mais recentes de um projeto
    func getTodasAnalises(projetoId: String) async throws -> ProjetoAnalises {
        let result = try await firestoreService.fetchTodasAnalises(projetoId: projetoId)

        return ProjetoAnalises(
            terreno: result.terreno,
            mercado: result.mercado,
            espacoSolucoes: result.espacoSolucoes,
            viabilidade: result.viabilidade
        )
    }

    // MARK: - Helpers para Dados Específicos

    /// Retorna o valor estimado do terreno
    func getValorEstimadoTerreno(projetoId: String) async throws -> Double? {
        guard let analise = try await getAnaliseTerreno(projetoId: projetoId) else {
            return nil
        }
        return analise.precificacaoTerreno.valorTotalEstimado
    }

    /// Retorna o preço de referência do m² na região
    func getPrecoReferenciaM2(projetoId: String) async throws -> Double? {
        guard let analise = try await getAnaliseMercado(projetoId: projetoId) else {
            return nil
        }
        return analise.precificacaoImovel.valorReferenciaM2
    }

    /// Retorna a melhor solução viável do projeto
    func getMelhorSolucao(projetoId: String) async throws -> SolucaoViavel? {
        guard let analise = try await getAnaliseViabilidade(projetoId: projetoId),
              let melhorSolucao = analise.visaoGeral?.melhorSolucao else {
            return nil
        }

        // Busca a solução completa na lista de soluções viáveis
        return analise.solucoesViaveis?.first { $0.id == melhorSolucao.id }
    }

    /// Retorna o parecer de viabilidade do projeto
    func getParecerViabilidade(projetoId: String) async throws -> ParecerViabilidadeDetalhado? {
        guard let analise = try await getAnaliseViabilidade(projetoId: projetoId) else {
            return nil
        }
        return analise.parecerViabilidade
    }

    /// Retorna as estatísticas de viabilidade
    func getEstatisticasViabilidade(projetoId: String) async throws -> MetricasViabilidade? {
        guard let analise = try await getAnaliseEspacoSolucoes(projetoId: projetoId) else {
            return nil
        }
        return analise.metricasViabilidade
    }

    /// Retorna resumo consolidado do projeto
    func getResumoConsolidado(projetoId: String) async throws -> ResumoConsolidado? {
        let analises = try await getTodasAnalises(projetoId: projetoId)

        guard analises.hasAnalyses else {
            return nil
        }

        return ResumoConsolidado(
            valorEstimadoTerreno: analises.terreno?.precificacaoTerreno.valorTotalEstimado,
            precoReferenciaM2: analises.mercado?.precificacaoImovel.valorReferenciaM2,
            taxaViabilidade: analises.espacoSolucoes?.metricasViabilidade.taxaViabilidade,
            solucoesViaveis: analises.espacoSolucoes?.metricasViabilidade.solucoesViaveis,
            melhorLucro: analises.viabilidade?.visaoGeral?.melhorSolucao?.lucro,
            melhorMargem: analises.viabilidade?.visaoGeral?.melhorSolucao?.margem,
            parecer: analises.viabilidade?.parecerViabilidade?.recomendacao,
            isViavel: analises.viabilidade?.parecerViabilidade?.viavel,
            nivelRisco: analises.viabilidade?.parecerViabilidade?.nivelRisco
        )
    }
}

// MARK: - Resumo Consolidado

struct ResumoConsolidado {
    let valorEstimadoTerreno: Double?
    let precoReferenciaM2: Double?
    let taxaViabilidade: Double?
    let solucoesViaveis: Int?
    let melhorLucro: Double?
    let melhorMargem: Double?
    let parecer: String?
    let isViavel: Bool?
    let nivelRisco: String?
}
