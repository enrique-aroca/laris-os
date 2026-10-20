import Foundation

/// Línea de partida en presupuestos, partes y facturas
public struct LineaDocumento: Identifiable, Codable, Hashable {
    public var id: String
    public var productoId: String?
    public var concepto: String
    public var cantidad: Double
    public var precioUnitario: Double
    public var descuentoPorcentaje: Double
    public var porcentajeIva: Double
    public var costeUnitario: Double
    
    public init(
        id: String = UUID().uuidString,
        productoId: String? = nil,
        concepto: String,
        cantidad: Double = 1.0,
        precioUnitario: Double = 0.0,
        descuentoPorcentaje: Double = 0.0,
        porcentajeIva: Double = 21.0,
        costeUnitario: Double = 0.0
    ) {
        self.id = id
        self.productoId = productoId
        self.concepto = concepto
        self.cantidad = cantidad
        self.precioUnitario = precioUnitario
        self.descuentoPorcentaje = descuentoPorcentaje
        self.porcentajeIva = porcentajeIva
        self.costeUnitario = costeUnitario
    }
    
    public var importeBase: Double {
        let precioConDescuento = precioUnitario * (1.0 - (descuentoPorcentaje / 100.0))
        return cantidad * precioConDescuento
    }
    
    public var importeIva: Double {
        return importeBase * (porcentajeIva / 100.0)
    }
    
    public var importeTotal: Double {
        return importeBase + importeIva
    }
    
    public var costeTotal: Double {
        return cantidad * costeUnitario
    }
    
    public var beneficioBruto: Double {
        return importeBase - costeTotal
    }
}

// ==========================================
// 1. PRESUPUESTOS (STEL Order: Quotes)
// ==========================================

public enum EstadoPresupuesto: String, Codable, CaseIterable {
    case borrador = "Borrador"
    case pendiente = "Pendiente"
    case aceptado = "Aceptado"
    case rechazado = "Rechazado"
    
    public var colorNombre: String {
        switch self {
        case .borrador: return "gray"
        case .pendiente: return "orange"
        case .aceptado: return "green"
        case .rechazado: return "red"
        }
    }
}

public struct Presupuesto: Identifiable, Codable, Hashable {
    public var id: String
    public var numero: String // ej: PRE-2026-0012
    public var clienteId: String
    public var clienteNombre: String
    public var fechaCreacion: Date
    public var fechaValidez: Date
    public var lineas: [LineaDocumento]
    public var estado: EstadoPresupuesto
    public var notas: String?
    public var pdfUrl: String?
    
    public init(
        id: String = UUID().uuidString,
        numero: String,
        clienteId: String,
        clienteNombre: String,
        fechaCreacion: Date = Date(),
        fechaValidez: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        lineas: [LineaDocumento] = [],
        estado: EstadoPresupuesto = .pendiente,
        notas: String? = nil,
        pdfUrl: String? = nil
    ) {
        self.id = id
        self.numero = numero
        self.clienteId = clienteId
        self.clienteNombre = clienteNombre
        self.fechaCreacion = fechaCreacion
        self.fechaValidez = fechaValidez
        self.lineas = lineas
        self.estado = estado
        self.notas = notas
        self.pdfUrl = pdfUrl
    }
    
    public var baseImponibleTotal: Double {
        lineas.reduce(0) { $0 + $1.importeBase }
    }
    
    public var ivaTotal: Double {
        lineas.reduce(0) { $0 + $1.importeIva }
    }
    
    public var total: Double {
        baseImponibleTotal + ivaTotal
    }
    
    public var costeTotalEstimado: Double {
        lineas.reduce(0) { $0 + $1.costeTotal }
    }
    
    public var margenTotalEstimado: Double {
        guard baseImponibleTotal > 0 else { return 0 }
        return ((baseImponibleTotal - costeTotalEstimado) / baseImponibleTotal) * 100.0
    }
}

// ==========================================
// 2. PARTES DE TRABAJO (STEL Order: Work Orders)
// ==========================================

public enum EstadoTrabajo: String, Codable, CaseIterable {
    case pendiente = "Pendiente"
    case enCurso = "En Curso"
    case finalizado = "Finalizado"
    
    public var colorNombre: String {
        switch self {
        case .pendiente: return "orange"
        case .enCurso: return "blue"
        case .finalizado: return "green"
        }
    }
}

public struct ParteTrabajo: Identifiable, Codable, Hashable {
    public var id: String
    public var numero: String // ej: PAR-2026-0034
    public var clienteId: String
    public var clienteNombre: String
    public var direccion: String
    public var descripcion: String
    public var fecha: Date
    public var estado: EstadoTrabajo
    public var horasTrabajadas: Double
    public var costeHoraManoObra: Double
    public var materialesUsados: [LineaDocumento]
    public var fotosAntesUrls: [String]
    public var fotosDespuesUrls: [String]
    public var firmaClienteData: String? // Base64 del trazo
    public var nombreFirmante: String?
    public var observaciones: String?
    public var presupuestoOrigenId: String?
    
    public init(
        id: String = UUID().uuidString,
        numero: String,
        clienteId: String,
        clienteNombre: String,
        direccion: String = "",
        descripcion: String = "",
        fecha: Date = Date(),
        estado: EstadoTrabajo = .pendiente,
        horasTrabajadas: Double = 0.0,
        costeHoraManoObra: Double = 35.0,
        materialesUsados: [LineaDocumento] = [],
        fotosAntesUrls: [String] = [],
        fotosDespuesUrls: [String] = [],
        firmaClienteData: String? = nil,
        nombreFirmante: String? = nil,
        observaciones: String? = nil,
        presupuestoOrigenId: String? = nil
    ) {
        self.id = id
        self.numero = numero
        self.clienteId = clienteId
        self.clienteNombre = clienteNombre
        self.direccion = direccion
        self.descripcion = descripcion
        self.fecha = fecha
        self.estado = estado
        self.horasTrabajadas = horasTrabajadas
        self.costeHoraManoObra = costeHoraManoObra
        self.materialesUsados = materialesUsados
        self.fotosAntesUrls = fotosAntesUrls
        self.fotosDespuesUrls = fotosDespuesUrls
        self.firmaClienteData = firmaClienteData
        self.nombreFirmante = nombreFirmante
        self.observaciones = observaciones
        self.presupuestoOrigenId = presupuestoOrigenId
    }
}

// ==========================================
// 3. FACTURAS OFICIALES (STEL Order: Invoices)
// ==========================================

public enum EstadoCobro: String, Codable, CaseIterable {
    case pendienteCobro = "Pendiente de Cobro"
    case cobrada = "Cobrada"
    case vencida = "Vencida"
    
    public var colorNombre: String {
        switch self {
        case .pendienteCobro: return "orange"
        case .cobrada: return "green"
        case .vencida: return "red"
        }
    }
}

public struct Factura: Identifiable, Codable, Hashable {
    public var id: String
    public var numero: String // ej: F-2026-0001
    public var clienteId: String
    public var clienteNombre: String
    public var clienteCif: String
    public var direccionFacturacion: String
    public var fechaEmision: Date
    public var fechaVencimiento: Date
    public var lineas: [LineaDocumento]
    public var porcentajeIrpf: Double // 0.0, 7.0 o 15.0
    public var estadoCobro: EstadoCobro
    public var presupuestoOrigenId: String?
    public var parteOrigenId: String?
    public var pdfUrl: String?
    
    public init(
        id: String = UUID().uuidString,
        numero: String,
        clienteId: String,
        clienteNombre: String,
        clienteCif: String = "",
        direccionFacturacion: String = "",
        fechaEmision: Date = Date(),
        fechaVencimiento: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
        lineas: [LineaDocumento] = [],
        porcentajeIrpf: Double = 0.0,
        estadoCobro: EstadoCobro = .pendienteCobro,
        presupuestoOrigenId: String? = nil,
        parteOrigenId: String? = nil,
        pdfUrl: String? = nil
    ) {
        self.id = id
        self.numero = numero
        self.clienteId = clienteId
        self.clienteNombre = clienteNombre
        self.clienteCif = clienteCif
        self.direccionFacturacion = direccionFacturacion
        self.fechaEmision = fechaEmision
        self.fechaVencimiento = fechaVencimiento
        self.lineas = lineas
        self.porcentajeIrpf = porcentajeIrpf
        self.estadoCobro = estadoCobro
        self.presupuestoOrigenId = presupuestoOrigenId
        self.parteOrigenId = parteOrigenId
        self.pdfUrl = pdfUrl
    }
    
    public var baseImponible: Double {
        lineas.reduce(0) { $0 + $1.importeBase }
    }
    
    public var ivaTotal: Double {
        lineas.reduce(0) { $0 + $1.importeIva }
    }
    
    public var importeIrpf: Double {
        baseImponible * (porcentajeIrpf / 100.0)
    }
    
    public var totalFactura: Double {
        baseImponible + ivaTotal - importeIrpf
    }
}
