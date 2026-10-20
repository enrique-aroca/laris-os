import SwiftUI

/// Vista de Catálogo de Productos y Servicios (compatible con STEL Order)
public struct CatalogoListView: View {
    @State private var textoBusqueda = ""
    @State private var categoriaSeleccionada: CategoriaProducto? = nil
    @State private var soloStockBajo = false
    @State private var mostrarCrearProducto = false
    
    private let mock = MockData.shared
    
    public init() {}
    
    public var productosFiltrados: [Producto] {
        mock.productos.filter { prod in
            let coincideTexto = textoBusqueda.isEmpty ||
                prod.nombre.localizedCaseInsensitiveContains(textoBusqueda) ||
                prod.referencia.localizedCaseInsensitiveContains(textoBusqueda) ||
                (prod.codigoBarras?.contains(textoBusqueda) ?? false)
            
            let coincideCategoria = categoriaSeleccionada == nil || prod.categoria == categoriaSeleccionada
            let coincideStock = !soloStockBajo || prod.estaBajoMinimo
            
            return coincideTexto && coincideCategoria && coincideStock
        }
    }
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filtro horizontal de categorías
                categoriasScroll
                
                // Lista de productos
                List {
                    ForEach(productosFiltrados) { producto in
                        tarjetaProducto(producto)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .background(STELTheme.background)
            }
            .searchable(text: $textoBusqueda, prompt: "Buscar referencia, nombre o código...")
            .navigationTitle("Catálogo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 12) {
                        // Botón de escáner de código de barras con la cámara
                        Button(action: {
                            // Abrir escáner de cámara
                        }) {
                            Image(systemName: "barcode.viewfinder")
                                .font(.system(size: 18))
                                .foregroundColor(STELTheme.primary)
                        }
                        
                        // Añadir producto
                        Button(action: { mostrarCrearProducto = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(STELTheme.primary)
                        }
                    }
                }
            }
        }
    }
    
    private var categoriasScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                filtroChip(titulo: "Todos", activo: categoriaSeleccionada == nil) {
                    categoriaSeleccionada = nil
                }
                ForEach(CategoriaProducto.allCases) { cat in
                    filtroChip(titulo: cat.rawValue, icono: cat.icono, activo: categoriaSeleccionada == cat) {
                        categoriaSeleccionada = cat
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(STELTheme.cardBackground)
    }
    
    private func filtroChip(titulo: String, icono: String? = nil, activo: Bool, accion: @escaping () -> Void) -> some View {
        Button(action: accion) {
            HStack(spacing: 5) {
                if let icono = icono {
                    Image(systemName: icono)
                        .font(.system(size: 11))
                }
                Text(titulo)
                    .font(.system(size: 13, weight: activo ? .semibold : .regular))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(activo ? STELTheme.primary : Color(UIColor.systemGray5))
            .foregroundColor(activo ? .white : .primary)
            .clipShape(Capsule())
        }
    }
    
    private func tarjetaProducto(_ prod: Producto) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(prod.referencia)
                            .font(.system(size: 11, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(STELTheme.primary.opacity(0.12))
                            .foregroundColor(STELTheme.primary)
                            .cornerRadius(4)
                        
                        if prod.estaBajoMinimo {
                            HStack(spacing: 3) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Stock Bajo")
                            }
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.15))
                            .foregroundColor(.red)
                            .cornerRadius(4)
                        }
                    }
                    
                    Text(prod.nombre)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Spacer()
                
                // Precio de venta destacado
                VStack(alignment: .trailing, spacing: 2) {
                    Text(prod.precioVenta.formatoMoneda)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                    Text("+ IVA (\(Int(prod.porcentajeIva))%)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            
            if let desc = prod.descripcion {
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Divider()
            
            // Fila de Márgenes y Stock para el profesional
            HStack {
                // Coste y margen
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Coste")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text(prod.coste.formatoMoneda)
                            .font(.system(size: 12, weight: .medium))
                    }
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Margen")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                        Text(prod.margenSobreVenta.formatoPorcentaje)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(STELTheme.statusSuccess)
                    }
                }
                
                Spacer()
                
                // Ubicaciones de stock (Furgoneta vs Almacén)
                if !prod.esServicio {
                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: "truck.box.fill")
                                .font(.system(size: 11))
                                .foregroundColor(STELTheme.primary)
                            Text("Furgón: \(Int(prod.stockFurgoneta)) \(prod.unidadMedida)")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                            Text("Taller: \(Int(prod.stockAlmacen))")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("Servicio / Mano de Obra")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(14)
        .background(STELTheme.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}
