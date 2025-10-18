//
//  MainTabView.swift
//  sistema_bup
//
//  Created by Claude Code on 2025-10-18.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Home
            HomeView()
                .tabItem {
                    Label("Início", systemImage: "house.fill")
                }
                .tag(0)

            // Tab 2: Projetos
            ProjectsListView()
                .tabItem {
                    Label("Projetos", systemImage: "folder.fill")
                }
                .tag(1)

            // Tab 3: Análises (placeholder)
            AnalysisPlaceholderView()
                .tabItem {
                    Label("Análises", systemImage: "chart.bar.fill")
                }
                .tag(2)

            // Tab 4: Perfil (placeholder)
            ProfilePlaceholderView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

struct AnalysisPlaceholderView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)

                Text("Análises")
                    .font(.headline)

                Text("Em desenvolvimento...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Análises")
        }
    }
}

struct ProfilePlaceholderView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    if let email = authViewModel.user?.email {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(email)
                                .foregroundColor(.secondary)
                        }
                    }

                    if let userId = authViewModel.user?.uid {
                        HStack {
                            Text("ID")
                            Spacer()
                            Text(userId)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section {
                    Button(role: .destructive) {
                        authViewModel.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sair")
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthViewModel())
}
