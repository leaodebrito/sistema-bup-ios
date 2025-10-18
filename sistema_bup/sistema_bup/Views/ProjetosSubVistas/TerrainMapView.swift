//
//  TerrainMapView.swift
//  sistema_bup
//
//  Created by Bruno Brito on 18/10/25.
//

import SwiftUI
import MapKit

// MARK: - Terrain Map View
struct TerrainMapView: View {
    let latitude: Double?
    let longitude: Double?
    let endereco: String

    @State private var region: MKCoordinateRegion
    @State private var mapCameraPosition: MapCameraPosition

    init(latitude: Double?, longitude: Double?, endereco: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.endereco = endereco

        // Define a região do mapa com base nas coordenadas
        if let lat = latitude, let lon = longitude {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            _region = State(initialValue: region)
            _mapCameraPosition = State(initialValue: .region(region))
        } else {
            // Coordenadas padrão (São Paulo) caso não existam coordenadas
            let defaultCoordinate = CLLocationCoordinate2D(latitude: -23.5505, longitude: -46.6333)
            let defaultRegion = MKCoordinateRegion(
                center: defaultCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            _region = State(initialValue: defaultRegion)
            _mapCameraPosition = State(initialValue: .region(defaultRegion))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let lat = latitude, let lon = longitude {
                Map(position: $mapCameraPosition) {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: 40, height: 40)

                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                                .frame(width: 40, height: 40)

                            Image(systemName: "mappin")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                        }
                    }
                }
                .frame(height: 250)
                .cornerRadius(12)
                .mapStyle(.standard(elevation: .realistic))

                // Coordenadas exibidas abaixo do mapa
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.gray)
                        .font(.caption)
                    Text(String(format: "%.6f, %.6f", lat, lon))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 4)
            } else {
                // Mensagem quando não há coordenadas
                VStack(spacing: 12) {
                    Image(systemName: "map.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))

                    Text("Localização não disponível")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text("As coordenadas do terreno não foram informadas")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Com coordenadas
        TerrainMapView(
            latitude: -23.5505,
            longitude: -46.6333,
            endereco: "Avenida Paulista, São Paulo"
        )
        .padding()

        // Sem coordenadas
        TerrainMapView(
            latitude: nil,
            longitude: nil,
            endereco: "Endereço não especificado"
        )
        .padding()
    }
}
