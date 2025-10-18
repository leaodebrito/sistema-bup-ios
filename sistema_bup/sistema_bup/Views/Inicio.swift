//
//  Inicio.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

struct Inicio: View {
    @EnvironmentObject var authController: AuthController
    @State var telaUsuario: Bool = false

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sistema BUP")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Um sistema desenvolvido para automatizar o desenvolvimento de analises de mercado e analises de viabilidade")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)

                    Divider()
                        .padding(.horizontal)

                    // Links Úteis Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Links Úteis")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            LinkButton(
                                title: "Dataset de imóveis",
                                icon: "folder.fill",
                                url: "https://drive.google.com/drive/folders/1TZE6-KFgvRmhWq7JR9McFTseToblYOEo?usp=drive_link"
                            )

                            LinkButton(
                                title: "Site Build Up",
                                icon: "building.2.fill",
                                url: "https://leaodebrito.github.io/site-buildup/index.html"
                            )

                            LinkButton(
                                title: "Site Norma",
                                icon: "doc.text.fill",
                                url: "https://leaodebrito.github.io/Norma-frontend-2/"
                            )
                        }
                        .padding(.horizontal)
                    }

                    Divider()
                        .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        telaUsuario.toggle()
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $telaUsuario) {
            Usuario()
                .environmentObject(authController)
        }
    }
}

struct LinkButton: View {
    let title: String
    let icon: String
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30)

                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    Inicio()
        .environmentObject(AuthController())
}
