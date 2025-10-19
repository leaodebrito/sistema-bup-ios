//
//  FirestoreService.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import FirebaseFirestore
import FirebaseAuth

enum FirestoreError: LocalizedError {
    case projetoNaoEncontrado
    case analiseNaoEncontrada
    case idInvalido
    case usuarioNaoAutenticado
    case erroDesconhecido(String)

    var errorDescription: String? {
        switch self {
        case .projetoNaoEncontrado:
            return "Projeto não encontrado"
        case .analiseNaoEncontrada:
            return "Análise não encontrada"
        case .idInvalido:
            return "ID inválido"
        case .usuarioNaoAutenticado:
            return "Usuário não autenticado"
        case .erroDesconhecido(let message):
            return message
        }
    }
}

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    private let collectionName = "estudos_viabilidade"

    // MARK: - Projetos

    // Listar todos os projetos
    func fetchProjetos() async throws -> [Projeto] {
        print("🔍 Iniciando busca na coleção: \(collectionName)")

        do {
            let snapshot = try await db.collection(collectionName).getDocuments()
            print("📊 Total de documentos encontrados: \(snapshot.documents.count)")

            if snapshot.documents.isEmpty {
                print("⚠️ Nenhum documento encontrado na coleção!")
                return []
            }

            let projetos = snapshot.documents.compactMap { document -> Projeto? in
                print("📄 Processando documento ID: \(document.documentID)")
                print("📋 Dados brutos: \(document.data())")

                do {
                    var projeto = try document.data(as: Projeto.self)
                    // Define manualmente o ID do documento
                    projeto.id = document.documentID
                    print("✅ Projeto decodificado com sucesso: \(projeto.nomeProjeto) (ID: \(document.documentID))")
                    return projeto
                } catch {
                    print("❌ Erro ao decodificar projeto \(document.documentID):")
                    print("   Erro detalhado: \(error)")
                    print("   Dados do documento: \(document.data())")
                    return nil
                }
            }

            print("✅ Total de projetos decodificados: \(projetos.count)")
            return projetos

        } catch {
            print("❌ Erro ao buscar documentos do Firestore: \(error)")
            throw error
        }
    }

    // Buscar projeto por ID
    func fetchProjeto(id: String) async throws -> Projeto {
        let document = try await db.collection(collectionName).document(id).getDocument()
        guard var projeto = try? document.data(as: Projeto.self) else {
            throw FirestoreError.projetoNaoEncontrado
        }
        projeto.id = document.documentID
        return projeto
    }

    // Criar novo projeto
    func createProjeto(_ projeto: Projeto) async throws -> String {
        let ref = try db.collection(collectionName).addDocument(from: projeto)
        return ref.documentID
    }

    // Atualizar projeto
    func updateProjeto(_ projeto: Projeto) async throws {
        guard let id = projeto.id else {
            throw FirestoreError.idInvalido
        }
        try db.collection(collectionName).document(id).setData(from: projeto, merge: true)
    }

    // Deletar projeto
    func deleteProjeto(id: String) async throws {
        try await db.collection(collectionName).document(id).delete()
    }

    // MARK: - Subcoleções - Análise de Terreno

    /// Busca todas as versões de análise de terreno de um projeto
    func fetchAnalisesTerrenoAll(projetoId: String) async throws -> [AnaliseTerreno] {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_terreno")
            .getDocuments()

        return snapshot.documents.compactMap { document -> AnaliseTerreno? in
            do {
                var analise = try document.data(as: AnaliseTerreno.self)
                analise.id = document.documentID
                return analise
            } catch {
                print("❌ Erro ao decodificar análise de terreno \(document.documentID): \(error)")
                return nil
            }
        }
    }

    /// Busca uma versão específica de análise de terreno
    func fetchAnaliseTerreno(projetoId: String, versao: String) async throws -> AnaliseTerreno {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_terreno")
            .document(versao)
            .getDocument()

        guard var analise = try? document.data(as: AnaliseTerreno.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        analise.id = document.documentID
        return analise
    }

    /// Busca a versão mais recente de análise de terreno
    func fetchAnaliseTerreno(projetoId: String) async throws -> AnaliseTerreno? {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_terreno")
            .order(by: "data_criacao", descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let document = snapshot.documents.first else {
            return nil
        }

        // Debug: mostrar dados brutos do Firestore
        print("🔍 DEBUG - Dados brutos do documento analise_terreno:")
        let data = document.data()
        if let precificacao = data["precificacao_terreno"] {
            print("🔍 precificacao_terreno tipo: \(type(of: precificacao))")
            print("🔍 precificacao_terreno valor: \(precificacao)")
        }
        if let dadosAmostra = data["dados_amostra"] {
            print("🔍 dados_amostra tipo: \(type(of: dadosAmostra))")
            print("🔍 dados_amostra valor: \(dadosAmostra)")
        }

        var analise = try document.data(as: AnaliseTerreno.self)
        analise.id = document.documentID
        return analise
    }

    // MARK: - Subcoleções - Análise de Mercado

    /// Busca todas as versões de análise de mercado de um projeto
    func fetchAnalisesMercadoAll(projetoId: String) async throws -> [AnaliseMercado] {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_mercado")
            .getDocuments()

        return snapshot.documents.compactMap { document -> AnaliseMercado? in
            do {
                var analise = try document.data(as: AnaliseMercado.self)
                analise.id = document.documentID
                return analise
            } catch {
                print("❌ Erro ao decodificar análise de mercado \(document.documentID): \(error)")
                return nil
            }
        }
    }

    /// Busca uma versão específica de análise de mercado
    func fetchAnaliseMercado(projetoId: String, versao: String) async throws -> AnaliseMercado {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_mercado")
            .document(versao)
            .getDocument()

        guard var analise = try? document.data(as: AnaliseMercado.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        analise.id = document.documentID
        return analise
    }

    /// Busca a versão mais recente de análise de mercado
    func fetchAnaliseMercado(projetoId: String) async throws -> AnaliseMercado? {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_mercado")
            .order(by: "data_criacao", descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let document = snapshot.documents.first else {
            return nil
        }

        var analise = try document.data(as: AnaliseMercado.self)
        analise.id = document.documentID
        return analise
    }

    // MARK: - Subcoleções - Análise de Espaço de Soluções

    /// Busca todas as versões de análise de espaço de soluções de um projeto
    func fetchAnalisesEspacoSolucoesAll(projetoId: String) async throws -> [AnaliseEspacoSolucoes] {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_espaco_solucoes")
            .getDocuments()

        return snapshot.documents.compactMap { document -> AnaliseEspacoSolucoes? in
            do {
                var analise = try document.data(as: AnaliseEspacoSolucoes.self)
                analise.id = document.documentID
                return analise
            } catch {
                print("❌ Erro ao decodificar análise de espaço de soluções \(document.documentID): \(error)")
                return nil
            }
        }
    }

    /// Busca uma versão específica de análise de espaço de soluções
    func fetchAnaliseEspacoSolucoes(projetoId: String, versao: String) async throws -> AnaliseEspacoSolucoes {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_espaco_solucoes")
            .document(versao)
            .getDocument()

        guard var analise = try? document.data(as: AnaliseEspacoSolucoes.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        analise.id = document.documentID
        return analise
    }

    /// Busca a versão mais recente de análise de espaço de soluções
    func fetchAnaliseEspacoSolucoes(projetoId: String) async throws -> AnaliseEspacoSolucoes? {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_espaco_solucoes")
            .order(by: "data_criacao", descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let document = snapshot.documents.first else {
            return nil
        }

        var analise = try document.data(as: AnaliseEspacoSolucoes.self)
        analise.id = document.documentID
        return analise
    }

    // MARK: - Subcoleções - Análise de Viabilidade

    /// Busca todas as versões de análise de viabilidade de um projeto
    func fetchAnalisesViabilidadeAll(projetoId: String) async throws -> [AnaliseViabilidade] {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .getDocuments()

        return snapshot.documents.compactMap { document -> AnaliseViabilidade? in
            do {
                var analise = try document.data(as: AnaliseViabilidade.self)
                analise.id = document.documentID
                return analise
            } catch {
                print("❌ Erro ao decodificar análise de viabilidade \(document.documentID): \(error)")
                return nil
            }
        }
    }

    /// Busca uma versão específica de análise de viabilidade
    func fetchAnaliseViabilidade(projetoId: String, versao: String) async throws -> AnaliseViabilidade {
        let document = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .document(versao)
            .getDocument()

        guard var analise = try? document.data(as: AnaliseViabilidade.self) else {
            throw FirestoreError.analiseNaoEncontrada
        }
        analise.id = document.documentID
        return analise
    }

    /// Busca a versão mais recente de análise de viabilidade
    func fetchAnaliseViabilidade(projetoId: String) async throws -> AnaliseViabilidade? {
        let snapshot = try await db.collection(collectionName)
            .document(projetoId)
            .collection("analise_viabilidade")
            .order(by: "data_criacao", descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let document = snapshot.documents.first else {
            return nil
        }

        var analise = try document.data(as: AnaliseViabilidade.self)
        analise.id = document.documentID
        return analise
    }

    // MARK: - Helper - Buscar Todas as Análises de um Projeto

    /// Busca todas as subcoleções de análises de um projeto (versão mais recente de cada)
    func fetchTodasAnalises(projetoId: String) async throws -> (
        terreno: AnaliseTerreno?,
        mercado: AnaliseMercado?,
        espacoSolucoes: AnaliseEspacoSolucoes?,
        viabilidade: AnaliseViabilidade?
    ) {
        async let terreno = fetchAnaliseTerreno(projetoId: projetoId)
        async let mercado = fetchAnaliseMercado(projetoId: projetoId)
        async let espacoSolucoes = fetchAnaliseEspacoSolucoes(projetoId: projetoId)
        async let viabilidade = fetchAnaliseViabilidade(projetoId: projetoId)

        return try await (terreno, mercado, espacoSolucoes, viabilidade)
    }
}
