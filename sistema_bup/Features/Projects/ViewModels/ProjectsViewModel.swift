//
//  ProjectsViewModel.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI
import Combine

@MainActor
class ProjectsViewModel: ObservableObject {
    @Published var projetos: [Projeto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // TODO: Integrar com FirestoreService quando implementado
    func loadProjetos() async {
        isLoading = true
        errorMessage = nil

        // Simulação de carregamento
        // Em produção, usar: projetos = try await FirestoreService.shared.fetchProjetos()
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Dados mockados para teste
        projetos = []

        isLoading = false
    }
}
