//
//  ContentView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Inicio()
                .tabItem{Label("Inicio", systemImage: "list.bullet")}
            Projetos()
                .tabItem{Label("Projetos", systemImage: "building.2" )}
            Assistente()
                .tabItem{Label("Assistente", systemImage: "apple.intelligence")}
            
        }
    }
}

#Preview {
    ContentView()
}
