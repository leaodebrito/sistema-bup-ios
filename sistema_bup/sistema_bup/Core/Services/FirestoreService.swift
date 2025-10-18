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
}
