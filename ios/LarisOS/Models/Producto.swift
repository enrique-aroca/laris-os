import Foundation

/// Categorías específicas de Laris OS
public enum CategoriaProducto: String, Codable, CaseIterable, Identifiable {
    case electricidad = "Electricidad"
    case fotovoltaica = "Fotovoltaica y Baterías"
    case seguridadCCTV = "Ajax y CCTV"
    case servicios = "Mano de Obra y Servicios"
    case climatizacion = "Climatización"
    case varios = "Varios / Consumibles"
    
    public var id: String { rawValue }
    
    public var icono: String {
        switch self {
        case .electricidad: return "bolt.fill"
        case .fotovoltaica: return "sun.max.fill"
        case .seguridadCCTV: return "video.fill"
        case .servicios: return "wrench.and.screwdriver.fill"
        case .climatizacion: return "snowflake"
        case .varios: return "cube.box.fill"
        }
    }
}

/// Modelo de Producto o Servicio del Catálogo (STEL Order compatible)
public struct Producto: Identifiable, Codable, Hashable {
    public var id: String
    public var referencia: String
    public var nombre: String
    public var descripcion: String?
    public var categoria: CategoriaProducto
    public var esServicio: Bool
    
    // Precios y Márgenes
    public var coste: Double
    public var precioVenta: Double
    public var porcentajeIva: Double // e.g. 21.0 o 10.0
    
    // Stock (Almacén vs Furgoneta)
    public var stockFurgoneta: Double
    public var stockAlmacen: Double
    public var stockMinimo: Double
    public var unidadMedida: String // "ud", "m", "h", "pack"
    public var codigoBarras: String?
    
    public init(
        id: String = UUID().uuidString,
        referencia: String,
        nombre: String,
        descripcion: String? = nil,
        categoria: CategoriaProducto = .electricidad,
        esServicio: Bool = false,
        coste: Double = 0.0,
        precioVenta: Double = 0.0,
        porcentajeIva: Double = 21.0,
        stockFurgoneta: Double = 0.0,
        stockAlmacen: Double = 0.0,
        stockMinimo: Double = 0.0,
        unidadMedida: String = "ud",
        codigoBarras: String? = nil
    ) {
        self.id = id
        self.referencia = referencia
        self.nombre = nombre
        self.descripcion = descripcion
        self.categoria = categoria
        self.esServicio = esServicio
        self.coste = coste
        self.precioVenta = precioVenta
        self.porcentajeIva = porcentajeIva
        self.stockFurgoneta = stockFurgoneta
        self.stockAlmacen = stockAlmacen
        self.stockMinimo = stockMinimo
        self.unidadMedida = unidadMedida
        self.codigoBarras = codigoBarras
    }
    
    // Cálculo de margen sobre precio de venta (%)
    public var margenSobreVenta: Double {
        guard precioVenta > 0 else { return 0 }
        return ((precioVenta - coste) / precioVenta) * 100.0
    }
    
    // Cálculo de recargo sobre el coste (%)
    public var recargoSobreCoste: Double {
        guard coste > 0 else { return 0 }
        return ((precioVenta - coste) / coste) * 100.0
    }
    
    // Beneficio bruto unitario en €
    public var beneficioUnitario: Double {
        return precioVenta - coste
    }
    
    // Stock total combinado
    public var stockTotal: Double {
        return stockFurgoneta + stockAlmacen
    }
    
    // Alerta de stock bajo
    public var estaBajoMinimo: Bool {
        guard !esServicio else { return false }
        return stockTotal <= stockMinimo
    }
}
