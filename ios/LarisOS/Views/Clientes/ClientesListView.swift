import SwiftUI

/// Vista de Clientes y CRM estilo STEL Order con llamadas, WhatsApp y GPS en 1 toque
public struct ClientesListView: View {
    @State private var textoBusqueda = ""
    @State private var filtroTipo: TipoCliente? = nil
    @State private var mostrarCrearCliente = false
    
    private let mock = MockData.shared
    
    public init() {}
    
    public var clientesFiltrados: [Cliente] {
        mock.clientes.filter { cliente in
            let coincideTexto = textoBusqueda.isEmpty ||
                cliente.nombre.localizedCaseInsensitiveContains(textoBusqueda) ||
                (cliente.nombreComercial?.localizedCaseInsensitiveContains(textoBusqueda) ?? false) ||
                cliente.nifCif.localizedCaseInsensitiveContains(textoBusqueda) ||
                cliente.ciudad.localizedCaseInsensitiveContains(textoBusqueda)
            
            let coincideTipo = filtroTipo == nil || cliente.tipo == filtroTipo
            return coincideTexto && coincideTipo
        }
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filtro por tipo de cliente
                filtrosTipoScroll
                
                // Lista de clientes
                List {
                    ForEach(clientesFiltrados) { cliente in
                        tarjetaCliente(cliente)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .background(STELTheme.background)
            }
            .searchable(text: $textoBusqueda, prompt: "Buscar por nombre, CIF, teléfono o ciudad...")
            .navigationTitle("Clientes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { mostrarCrearCliente = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(STELTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $mostrarCrearCliente) {
                FormularioNuevoClienteView()
            }
        }
    }
    
    // MARK: - Componentes
    
    private var filtrosTipoScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filtroChip(titulo: "Todos", activo: filtroTipo == nil) {
                    filtroTipo = nil
                }
                ForEach(TipoCliente.allCases) { tipo in
                    filtroChip(titulo: tipo.rawValue, activo: filtroTipo == tipo) {
                        filtroTipo = tipo
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(STELTheme.cardBackground)
    }
    
    private func filtroChip(titulo: String, activo: Bool, accion: @escaping () -> Void) -> some View {
        Button(action: accion) {
            Text(titulo)
                .font(.system(size: 13, weight: activo ? .semibold : .regular))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(activo ? STELTheme.primary : Color(UIColor.systemGray5))
                .foregroundColor(activo ? .white : .primary)
                .clipShape(Capsule())
        }
    }
    
    private func tarjetaCliente(_ cliente: Cliente) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(cliente.nombre)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if let comercial = cliente.nombreComercial {
                        Text(comercial)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(STELTheme.primary)
                    }
                    
                    if !cliente.nifCif.isEmpty {
                        Text("CIF/NIF: \(cliente.nifCif)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                
                StatusBadge(
                    titulo: cliente.tipo.rawValue,
                    color: cliente.tipo == .empresa ? Color.indigo : (cliente.tipo == .comunidad ? Color.purple : STELTheme.primary),
                    icono: cliente.tipo.icono
                )
            }
            
            if !cliente.direccionCompleta.isEmpty {
                Label(cliente.direccionCompleta, systemImage: "mappin.and.ellipse")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Divider()
            
            // Botones de Acción Directa en 1 toque (Estilo STEL Order)
            HStack(spacing: 8) {
                // 1. Llamar por teléfono
                if !cliente.telefono.isEmpty {
                    Button(action: {
                        let limpio = cliente.telefono.filter { "+0123456789".contains($0) }
                        if let url = URL(string: "tel:\(limpio)") { UIApplication.shared.open(url) }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "phone.fill")
                            Text("Llamar")
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(Color.green.opacity(0.12))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    }
                }
                
                // 2. Chat de WhatsApp directo
                if !cliente.telefono.isEmpty {
                    Button(action: {
                        let limpio = cliente.telefono.filter { "0123456789".contains($0) }
                        if let url = URL(string: "https://wa.me/\(limpio)") { UIApplication.shared.open(url) }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "message.fill")
                            Text("WhatsApp")
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(Color(red: 0.15, green: 0.75, blue: 0.35).opacity(0.15))
                        .foregroundColor(Color(red: 0.10, green: 0.65, blue: 0.30))
                        .cornerRadius(8)
                    }
                }
                
                // 3. Ruta GPS en Mapas
                if !cliente.direccion.isEmpty {
                    Button(action: {
                        if let encoded = cliente.direccionCompleta.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                           let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                            Text("Ruta")
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(STELTheme.primary.opacity(0.12))
                        .foregroundColor(STELTheme.primary)
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
}

/// Formulario ágil para crear un nuevo cliente
public struct FormularioNuevoClienteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nombre = ""
    @State private var nombreComercial = ""
    @State private var nifCif = ""
    @State private var tipo: TipoCliente = .particular
    @State private var telefono = ""
    @State private var email = ""
    @State private var direccion = ""
    @State private var codigoPostal = ""
    @State private var ciudad = ""
    @State private var provincia = ""
    @State private var notas = ""
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Datos Principales") {
                    TextField("Nombre completo o Razón Social", text: $nombre)
                    TextField("Nombre comercial (opcional)", text: $nombreComercial)
                    TextField("NIF / CIF", text: $nifCif)
                    Picker("Tipo de Cliente", selection: $tipo) {
                        ForEach(TipoCliente.allCases) { t in
                            Text(t.rawValue).tag(t)
                        }
                    }
                }
                
                Section("Contacto") {
                    TextField("Teléfono móvil", text: $telefono)
                        .keyboardType(.phonePad)
                    TextField("Correo electrónico", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section("Dirección de la Instalación") {
                    TextField("Calle, número, portal/chalet", text: $direccion)
                    HStack {
                        TextField("Código Postal", text: $codigoPostal)
                            .keyboardType(.numberPad)
                        TextField("Ciudad", text: $ciudad)
                    }
                    TextField("Provincia", text: $provincia)
                }
                
                Section("Notas Internas") {
                    TextEditor(text: $notas)
                        .frame(minHeight: 60)
                }
            }
            .navigationTitle("Nuevo Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        // Guardar en Firestore
                        dismiss()
                    }
                    .font(.headline)
                    .disabled(nombre.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
