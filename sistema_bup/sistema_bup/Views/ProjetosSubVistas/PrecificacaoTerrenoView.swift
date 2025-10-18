//
//  PrecificacaoTerrenoView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

// MARK: - Precificação do Terreno View
struct PrecificacaoTerrenoView: View {
    let projeto: Projeto

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)

                Text("Precificação do Terreno")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Análise de precificação do terreno em desenvolvimento")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}

