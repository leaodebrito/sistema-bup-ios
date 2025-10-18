//
//  InformacoesProjetoView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI

// MARK: - Informações do Projeto View
struct InformacoesProjetoView: View {
    let projeto: Projeto

    var body: some View {
        VStack{
            GroupBox{
                MyLabel(imagem: "building", color: .blue, dado: projeto.nomeProjeto)
                Divider()
                MyLabel(imagem: "poweroutlet.type.j", color: .blue, dado: projeto.tipoProjeto)
                Divider()
                MyLabel(imagem: "map", color: .blue, dado: projeto.endereco)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            GroupBox{
                MyLabel(imagem: "person", color: .blue, dado: projeto.nomeCliente)
            }
            
            GroupBox{MyLabel(imagem: "text.alignleft", color: .blue, dado: projeto.descriProjeto)
            }
            
            
            
            Text("Terreno")
                .font(.title3)
                .bold()
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            //TODO: - Mapa
            
            
            GroupBox{
                let areaTerrenoStr = projeto.areaTerreno.map { String(format: "%.2f m²", $0) } ?? "-"
                MyLabel(imagem: "number", color: .blue, dado: areaTerrenoStr)
                
            }
            
            
            
            Text("Parâmetros Urbanísticos")
                .font(.title3)
                .bold()
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if let zonaUrbanistica = projeto.zonaUrbanistica {
                SectionCard(title: "Indicadores urbanos") {
                    DetailRow(label: "Zona Urbanística", value: zonaUrbanistica)

                    if let caBase = projeto.caBase {
                        Divider()
                        DetailRow(label: "CA Básico", value: String(format: "%.2f", caBase))
                    }

                    if let caMax = projeto.caMax {
                        Divider()
                        DetailRow(label: "CA Máximo", value: String(format: "%.2f", caMax))
                    }

                    if let caMin = projeto.caMin {
                        Divider()
                        DetailRow(label: "CA Mínimo", value: String(format: "%.2f", caMin))
                    }

                    if let io = projeto.io {
                        Divider()
                        DetailRow(label: "Taxa de Ocupação (IO)", value: String(format: "%.2f", io))
                    }

                    if let ip = projeto.ip {
                        Divider()
                        DetailRow(label: "Taxa de Permeabilidade (IP)", value: String(format: "%.2f", ip))
                    }
                }
            }
            
            
            if let anotacoesLegislacao = projeto.anotacoesLegislacao, !anotacoesLegislacao.isEmpty {
                SectionCard(title: "Anotações de Legislação") {
                    Text(anotacoesLegislacao)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }

            
            Text("Observações")
                .font(.title3)
                .bold()
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let anotacoesGerais = projeto.anotacoesGerais, !anotacoesGerais.isEmpty {
                SectionCard(title: "Anotações Gerais") {
                    Text(anotacoesGerais)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }

            // Informações de Criação
            SectionCard(title: "Informações de Criação") {
                DetailRow(label: "Criado por", value: projeto.infoCriacao.usuarioCriador)
                Divider()
                DetailRow(label: "Data de Criação", value: projeto.dataFormatada)
            }
        
        }
        .padding(.horizontal)
        
        
    }
}


struct MyLabel: View{
    
    @State var imagem: String
    @State var color: Color
    @State var dado: String
    
    var body: some View {
        HStack{
            Image(systemName: imagem)
                .bold()
                .foregroundStyle(color)
                .frame(width: 30)
            Text(dado)
        }
        .padding(.vertical,3)
        .frame(maxWidth:.infinity, alignment: .leading)
    }
}

