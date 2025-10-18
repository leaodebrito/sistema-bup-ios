//
//  Projeto.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import Foundation
import FirebaseFirestore

struct Projeto: Identifiable, Codable {
    @DocumentID var id: String?
    let nomeProjeto: String
    let tipoProjeto: String
    let descriProjeto: String
    let nomeCliente: String
    let dataInicio: String
    let endereco: String
    let infoCriacao: InfoCriacao

    // Referências para subcoleções (IDs)
    var analiseMercadoId: String?
    var analiseViabilidadeId: String?
    var analiseEspacoSolucoesId: String?
    var analiseTerreno: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nomeProjeto = "nome_projeto"
        case tipoProjeto = "tipo_projeto"
        case descriProjeto = "descri_projeto"
        case nomeCliente = "nome_cliente"
        case dataInicio = "data_inicio"
        case endereco
        case infoCriacao = "info_criacao"
        case analiseMercadoId = "analise_mercado_id"
        case analiseViabilidadeId = "analise_viabilidade_id"
        case analiseEspacoSolucoesId = "analise_espaco_solucoes_id"
        case analiseTerreno = "analise_terreno"
    }
}

struct InfoCriacao: Codable {
    let dataCriacao: String
    let usuarioCriador: String

    enum CodingKeys: String, CodingKey {
        case dataCriacao = "data_criacao"
        case usuarioCriador = "usuario_criador"
    }
}
