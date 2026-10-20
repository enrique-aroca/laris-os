import SwiftUI

public enum SeccionDocumentos: String, CaseIterable, Identifiable {
    case presupuestos = "Presupuestos"
    case partes = "Partes"
    case facturas = "Facturas"
    
    public var id: String { rawValue }
}

/// Centro de gestión documental al estilo exacto de STEL Order
public struct DocumentosHubView: View {
    @State private var seccionSeleccionada: SeccionDocumentos = .presupuestos
    @State private var textoBusqueda = ""
    @State private var mostrarCrearDocumento = false
    
    private let mock = MockData.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Selector Segmentado Estilo STEL Order
                Picker("Sección", selection: $seccionSeleccionada) {
                    ForEach(SeccionDocumentos.allCases) { seccion in
                        Text(seccion.rawValue).tag(seccion)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(STELTheme.cardBackground)
                
                // Contenido dinámico según la sección seleccionada
                switch seccionSeleccionada {
                case .presupuestos:
                    listaPresupuestos
                case .partes:
                    listaPartesTrabajo
                case .facturas:
                    listaFacturas
                }
            }
            .searchable(text: $textoBusqueda, prompt: "Buscar por número, cliente o importe...")
            .navigationTitle("Documentos")
            .background(STELTheme.background)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostrarCrearDocumento = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(STELTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $mostrarCrearDocumento) {
                switch seccionSeleccionada {
                case .presupuestos:
                    Text("Formulario Nuevo Presupuesto")
                case .partes:
                    Text("Formulario Nuevo Parte de Trabajo")
                case .facturas:
                    Text("Formulario Nueva Factura")
                }
            }
        }
    }
    
    // MARK: - 1. Lista de Presupuestos
    private var listaPresupuestos: some View {
        List {
            ForEach(mock.presupuestos) { pres in
                tarjetaPresupuesto(pres)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    private func tarjetaPresupuesto(_ pres: Presupuesto) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(pres.numero)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(STELTheme.primary)
                    Text(pres.clienteNombre)
                        .font(.system(size: 15, weight: .semibold))
                }
                Spacer()
                StatusBadge(
                    titulo: pres.estado.rawValue,
                    color: pres.estado == .aceptado ? STELTheme.statusSuccess : (pres.estado == .pendiente ? STELTheme.statusPending : STELTheme.statusDraft)
                )
            }
            
            HStack {
                Label("\(pres.lineas.count) partidas", systemImage: "list.bullet")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Validez: \(pres.fechaValidez.formatoCorto)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                // Margen estimado visible para el autónomo
                VStack(alignment: .leading, spacing: 2) {
                    Text("Margen: \(pres.margenTotalEstimado.formatoPorcentaje)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(STELTheme.statusSuccess)
                    Text("Coste: \(pres.costeTotalEstimado.formatoMoneda)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(pres.total.formatoMoneda)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            // Acciones Rápidas del Presupuesto
            HStack(spacing: 8) {
                if pres.estado == .aceptado {
                    Button(action: {
                        // Convertir a parte de trabajo
                    }) {
                        Label("Crear Parte", systemImage: "wrench.and.screwdriver.fill")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(STELTheme.primary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                Button(action: {
                    // Compartir PDF por WhatsApp
                }) {
                    Label("Enviar PDF", systemImage: "square.and.arrow.up")
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(Color(UIColor.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                }
            }
        }
        .padding(14)
        .background(STELTheme.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
    
    // MARK: - 2. Lista de Partes de Trabajo
    private var listaPartesTrabajo: some View {
        List {
            ForEach(mock.partesTrabajo) { trabajo in
                tarjetaParteTrabajo(trabajo)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    private func tarjetaParteTrabajo(_ trabajo: ParteTrabajo) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(trabajo.numero)
                        .font(.system(size: 13, weight: .bold))
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
            
            HStack {
                Label("\(String(format: "%.1f", trabajo.horasTrabajadas)) h registradas", systemImage: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Text(trabajo.fecha.formatoCorto)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack(spacing: 8) {
                if trabajo.estado != .finalizado {
                    Button(action: {
                        // Abrir pantalla de firma digital
                    }) {
                        Label("Firma Cliente", systemImage: "signature")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(STELTheme.accent)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                } else {
                    Button(action: {
                        // Facturar parte terminado
                    }) {
                        Label("Facturar Parte", systemImage: "eurosign.circle.fill")
                            .font(.system(size: 12, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(STELTheme.statusSuccess)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(14)
        .background(STELTheme.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
    
    // MARK: - 3. Lista de Facturas
    private var listaFacturas: some View {
        List {
            ForEach(mock.facturas) { factura in
                tarjetaFactura(factura)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
    
    private func tarjetaFactura(_ factura: Factura) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(factura.numero)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(STELTheme.primary)
                    Text(factura.clienteNombre)
                        .font(.system(size: 15, weight: .semibold))
                }
                Spacer()
                StatusBadge(
                    titulo: factura.estadoCobro.rawValue,
                    color: factura.estadoCobro == .cobrada ? STELTheme.statusSuccess : (factura.estadoCobro == .vencida ? STELTheme.statusDanger : STELTheme.statusPending)
                )
            }
            
            HStack {
                Text("Emisión: \(factura.fechaEmision.formatoCorto)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Text("Vence: \(factura.fechaVencimiento.formatoCorto)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            HStack {
                if factura.porcentajeIrpf > 0 {
                    Text("Ret. IRPF (\(Int(factura.porcentajeIrpf))%): -\(factura.importeIrpf.formatoMoneda)")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(factura.totalFactura.formatoMoneda)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .padding(14)
        .background(STELTheme.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}
