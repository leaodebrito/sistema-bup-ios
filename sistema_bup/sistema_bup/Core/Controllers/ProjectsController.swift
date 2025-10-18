//
//  ProjectsController.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI
import Combine

@MainActor
class ProjectsController: ObservableObject {
    @Published var projetos: [Projeto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private let firestoreService = FirestoreService.shared

    // Projetos filtrados com base na busca
    var projetosFiltrados: [Projeto] {
        if searchText.isEmpty {
            return projetos
        }

        let searchLower = searchText.lowercased()
        return projetos.filter { projeto in
            projeto.nomeProjeto.lowercased().contains(searchLower) ||
            projeto.nomeCliente.lowercased().contains(searchLower) ||
            projeto.endereco.lowercased().contains(searchLower)
        }
    }

    func loadProjetos() async {
        print("🚀 ProjectsController: Iniciando carregamento de projetos")
        isLoading = true
        errorMessage = nil

        do {
            let fetchedProjetos = try await firestoreService.fetchProjetos()
            print("✅ ProjectsController: Recebeu \(fetchedProjetos.count) projetos")
            projetos = fetchedProjetos
            print("✅ ProjectsController: Projetos atribuídos ao @Published")
        } catch {
            print("❌ ProjectsController: Erro ao carregar projetos: \(error)")
            errorMessage = error.localizedDescription
        }

        isLoading = false
        print("✅ ProjectsController: isLoading = false")
    }

    func deleteProjeto(_ projeto: Projeto) async {
        guard let id = projeto.id else { return }

        do {
            try await firestoreService.deleteProjeto(id: id)
            projetos.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
