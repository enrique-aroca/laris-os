import SwiftUI

/// Vista de Inicio / Panel de Control al estilo STEL Order
public struct DashboardView: View {
    @State private var seleccionPresupuestos = false
    @State private var mostrarCrearPresupuesto = false
    @State private var mostrarCrearParte = false
    @State private var mostrarCrearCliente = false
    
    private let mock = MockData.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Cabecera de Bienvenida
                    headerView
                    
                    // Cuadrícula de 4 Métricas Clave (STEL Order KPI Cards)
                    metricasGrid
                    
                    // Sección: Acciones Rápidas
                    accionesRapidasSection
                    
                    // Sección: Trabajos e Intervenciones de Hoy
                    trabajosHoySection
                    
                    // Sección: Presupuestos Pendientes Recientes
                    presupuestosRecientesSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(STELTheme.background.ignoresSafeArea())
            .navigationTitle("LARIS OS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Perfil / Ajustes rápidos
                    }) {
                        Image(systemName: "bell.badge")
                            .foregroundColor(STELTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $mostrarCrearPresupuesto) {
                Text("Crear Nuevo Presupuesto")
            }
            .sheet(isPresented: $mostrarCrearParte) {
                Text("Crear Nuevo Parte de Trabajo")
            }
            .sheet(isPresented: $mostrarCrearCliente) {
                Text("Crear Nuevo Cliente")
            }
        }
    }
    
    // MARK: - Subvistas
    
    private var headerView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Bienvenido, Enrique")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text(Date().formatoCorto)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            // Badge de conexión en la nube
            HStack(spacing: 5) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("En línea")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.green.opacity(0.1))
            .clipShape(Capsule())
        }
        .padding(.top, 4)
    }
    
    private var metricasGrid: some View {
        let pendientes = mock.presupuestos.filter { $0.estado == .pendiente }
        let totalPendiente = pendientes.reduce(0) { $0 + $1.total }
        let pendientesCobro = mock.facturas.filter { $0.estadoCobro == .pendienteCobro }
        let totalPorCobrar = pendientesCobro.reduce(0) { $0 + $1.totalFactura }
        
        return LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            StatCard(
                titulo: "Presupuestos Pend.",
                valor: totalPendiente.formatoMoneda,
                subtitulo: "\(pendientes.count) activos",
                icono: "doc.text.fill",
                colorIcono: STELTheme.statusPending
            )
            
            StatCard(
                titulo: "Trabajos Activos",
                valor: "\(mock.partesTrabajo.filter { $0.estado != .finalizado }.count)",
                subtitulo: "En campo",
                icono: "wrench.and.screwdriver.fill",
                colorIcono: STELTheme.primary
            )
            
            StatCard(
                titulo: "Facturado este mes",
                valor: 3480.0.formatoMoneda,
                subtitulo: "+18%",
                icono: "chart.line.uptrend.xyaxis",
                colorIcono: STELTheme.statusSuccess
            )
            
            StatCard(
                titulo: "Pendiente Cobro",
                valor: totalPorCobrar.formatoMoneda,
                subtitulo: "\(pendientesCobro.count) facturas",
                icono: "eurosign.circle.fill",
                colorIcono: STELTheme.statusDanger
            )
        }
    }
    
    private var accionesRapidasSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ACCIONES RÁPIDAS")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            HStack(spacing: 10) {
                BotonAccionRapida(
                    titulo: "Presupuesto",
                    icono: "doc.badge.plus",
                    color: STELTheme.primary
                ) {
                    mostrarCrearPresupuesto = true
                }
                
                BotonAccionRapida(
                    titulo: "Parte Trabajo",
                    icono: "signature",
                    color: STELTheme.accent
                ) {
                    mostrarCrearParte = true
                }
                
                BotonAccionRapida(
                    titulo: "Nuevo Cliente",
                    icono: "person.badge.plus",
                    color: Color.indigo
                ) {
                    mostrarCrearCliente = true
                }
            }
        }
    }
    
    private var trabajosHoySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("INTERVENCIONES DE HOY")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                Spacer()
                Text("\(mock.partesTrabajo.count) en total")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            ForEach(mock.partesTrabajo) { trabajo in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trabajo.numero)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(STELTheme.primary)
                            Text(trabajo.clienteNombre)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        Spacer()
                        StatusBadge(
                            titulo: trabajo.estado.rawValue,
                            color: trabajo.estado == .finalizado ? STELTheme.statusSuccess : (trabajo.estado == .enCurso ? STELTheme.primary : STELTheme.statusPending)
                        )
                    }
                    
                    Text(trabajo.descripcion)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    Divider()
                    
                    HStack {
                        Label(trabajo.direccion, systemImage: "mappin.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Botón directo para abrir GPS
                        Button(action: {
                            abrirEnMapas(direccion: trabajo.direccion)
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                Text("Ruta")
                            }
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(STELTheme.primary.opacity(0.1))
                            .foregroundColor(STELTheme.primary)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(14)
                .background(STELTheme.cardBackground)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
            }
        }
    }
    
    private var presupuestosRecientesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("PRESUPUESTOS PENDIENTES")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                Spacer()
            }
            
            ForEach(mock.presupuestos) { pres in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pres.numero)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(STELTheme.primary)
                        Text(pres.clienteNombre)
                            .font(.system(size: 14, weight: .semibold))
                        Text("\(pres.lineas.count) partidas • Validez: \(pres.fechaValidez.formatoCorto)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(pres.total.formatoMoneda)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.primary)
                        StatusBadge(
                            titulo: pres.estado.rawValue,
                            color: pres.estado == .aceptado ? STELTheme.statusSuccess : STELTheme.statusPending
                        )
                    }
                }
                .padding(14)
                .background(STELTheme.cardBackground)
                .cornerRadius(12)
            }
        }
    }
    
    private func abrirEnMapas(direccion: String) {
        guard let encoded = direccion.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://maps.apple.com/?q=\(encoded)") else { return }
        #if canImport(UIKit)
        UIApplication.shared.open(url)
        #elseif canImport(AppKit)
        NSWorkspace.shared.open(url)
        #endif
    }
}

/// Botón estilizado de acceso rápido
public struct BotonAccionRapida: View {
    let titulo: String
    let icono: String
    let color: Color
    let accion: () -> Void
    
    public var body: some View {
        Button(action: accion) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: icono)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                Text(titulo)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(STELTheme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
        }
    }
}
