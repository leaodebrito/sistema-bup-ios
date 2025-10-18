//
//  ProjetoDetailView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

// MARK: - Projeto Detail View
struct ProjetoDetailView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Informações do Projeto
                VStack(alignment: .leading, spacing: 12) {
                    Text("Informações do Projeto")
                        .font(.headline)
                        .fontWeight(.bold)

                    DetailRow(label: "Nome", value: projeto.nomeProjeto)
                    DetailRow(label: "Tipo", value: projeto.tipoProjeto)
                    DetailRow(label: "Cliente", value: projeto.nomeCliente)
                    DetailRow(label: "Endereço", value: projeto.endereco)
                    DetailRow(label: "Data Início", value: projeto.dataInicio)
                    DetailRow(label: "Descrição", value: projeto.descriProjeto)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)

                // Análises Disponíveis
                VStack(alignment: .leading, spacing: 12) {
                    Text("Análises")
                        .font(.headline)
                        .fontWeight(.bold)

                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.body)
        }
    }
}
