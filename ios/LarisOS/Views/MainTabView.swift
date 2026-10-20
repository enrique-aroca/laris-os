import SwiftUI

/// Barra de navegación principal inferior al estilo de STEL Order
public struct MainTabView: View {
    @State private var tabSeleccionado: Int = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $tabSeleccionado) {
            DashboardView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            ClientesListView()
                .tabItem {
                    Label("Clientes", systemImage: "person.2.fill")
                }
                .tag(1)
            
            DocumentosHubView()
                .tabItem {
                    Label("Documentos", systemImage: "doc.text.fill")
                }
                .tag(2)
            
            CatalogoListView()
                .tabItem {
                    Label("Catálogo", systemImage: "cube.box.fill")
                }
                .tag(3)
            
            MasAjustesView()
                .tabItem {
                    Label("Más", systemImage: "ellipsis.circle.fill")
                }
                .tag(4)
        }
        .tint(STELTheme.primary)
    }
}

/// Pestaña "Más" para opciones adicionales del autónomo
public struct MasAjustesView: View {
    public var body: some View {
        NavigationStack {
            List {
                Section("Operaciones y Campo") {
                    NavigationLink(destination: Text("Inventario de mi Furgoneta")) {
                        Label("Stock de mi Furgoneta", systemImage: "truck.box.fill")
                    }
                    NavigationLink(destination: Text("Registro de Gastos y Tickets")) {
                        Label("Gastos y Tickets (Foto OCR)", systemImage: "receipt.fill")
                    }
                    NavigationLink(destination: Text("Instalaciones Técnicas (Solar/Ajax/CCTV)")) {
                        Label("Fichas Técnicas Laris (Solar/CCTV)", systemImage: "shield.lefthalf.filled")
                    }
                }
                
                Section("Configuración del Negocio") {
                    NavigationLink(destination: Text("Datos Fiscales y Series")) {
                        Label("Mis Datos Fiscales (Laris)", systemImage: "building.2.fill")
                    }
                    NavigationLink(destination: Text("Plantilla de Facturas y Presupuestos")) {
                        Label("Personalizar PDF y Logotipo", systemImage: "paintbrush.fill")
                    }
                }
                
                Section("Seguridad y Nube") {
                    HStack {
                        Label("Conectado a Firebase", systemImage: "cloud.fill")
                            .foregroundColor(STELTheme.statusSuccess)
                        Spacer()
                        Text("Blaze")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Label("Bóveda de Claves CCTV/Ajax", systemImage: "lock.shield.fill")
                        Spacer()
                        Image(systemName: "faceid")
                            .foregroundColor(STELTheme.primary)
                    }
                }
            }
            .navigationTitle("Más Opciones")
        }
    }
}
