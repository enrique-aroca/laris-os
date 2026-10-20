import Foundation

/// Tipos de cliente
public enum TipoCliente: String, Codable, CaseIterable, Identifiable {
    case particular = "Particular"
    case empresa = "Empresa"
    case comunidad = "Comunidad de Propietarios"
    
    public var id: String { rawValue }
    
    public var icono: String {
        switch self {
        case .particular: return "person.fill"
        case .empresa: return "building.2.fill"
        case .comunidad: return "house.lodge.fill"
        }
    }
}

/// Modelo de Cliente en Laris OS (estilo STEL Order)
public struct Cliente: Identifiable, Codable, Hashable {
    public var id: String
    public var nombre: String
    public var nombreComercial: String?
    public var nifCif: String
    public var tipo: TipoCliente
    public var telefono: String
    public var email: String
    public var direccion: String
    public var codigoPostal: String
    public var ciudad: String
    public var provincia: String
    public var notas: String?
    public var fechaCreacion: Date
    
    public init(
        id: String = UUID().uuidString,
        nombre: String,
        nombreComercial: String? = nil,
        nifCif: String = "",
        tipo: TipoCliente = .particular,
        telefono: String = "",
        email: String = "",
        direccion: String = "",
        codigoPostal: String = "",
        ciudad: String = "",
        provincia: String = "",
        notas: String? = nil,
        fechaCreacion: Date = Date()
    ) {
        self.id = id
        self.nombre = nombre
        self.nombreComercial = nombreComercial
        self.nifCif = nifCif
        self.tipo = tipo
        self.telefono = telefono
        self.email = email
        self.direccion = direccion
        self.codigoPostal = codigoPostal
        self.ciudad = ciudad
        self.provincia = provincia
        self.notas = notas
        self.fechaCreacion = fechaCreacion
    }
    
    public var direccionCompleta: String {
        let partes = [direccion, codigoPostal, ciudad, provincia].filter { !$0.isEmpty }
        return partes.joined(separator: ", ")
    }
}
