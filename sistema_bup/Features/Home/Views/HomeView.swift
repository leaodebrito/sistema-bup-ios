//
//  HomeView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bem-vindo!")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        if let email = authViewModel.user?.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)

                    // Cards de funcionalidades
                    VStack(spacing: 16) {
                        FeatureCard(
                            icon: "folder.fill",
                            title: "Projetos",
                            description: "Gerencie seus projetos imobiliários",
                            color: .blue
                        )

                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Análise de Mercado",
                            description: "Análise detalhada do mercado imobiliário",
                            color: .green
                        )

                        FeatureCard(
                            icon: "map.fill",
                            title: "Análise de Terreno",
                            description: "Avaliação e precificação de terrenos",
                            color: .orange
                        )

                        FeatureCard(
                            icon: "chart.bar.fill",
                            title: "Análise de Viabilidade",
                            description: "Estudo de viabilidade econômica",
                            color: .purple
                        )

                        FeatureCard(
                            icon: "brain.head.profile",
                            title: "Assistente IA",
                            description: "Assistente inteligente para dúvidas",
                            color: .pink
                        )
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(color)
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(12)

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            // Arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
