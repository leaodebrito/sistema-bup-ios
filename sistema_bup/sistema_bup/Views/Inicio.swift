//
//  Inicio.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

struct Inicio: View {
    
    @State var telaUsuario: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Text("Inicio")
            }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {telaUsuario.toggle()} label: {Image(systemName: "person")}
                    }
                }
        }
        .sheet(isPresented: $telaUsuario) {Usuario()}
    }
    
}

#Preview {
    Inicio()
}
