import SwiftUI

/// Sistema de Diseño inspirado en la ergonomía y claridad de STEL Order
public struct STELTheme {
    // Colores Primarios
    public static let primary = Color(red: 0.08, green: 0.40, blue: 0.75) // Azul STEL #1565C0
    public static let primaryDark = Color(red: 0.05, green: 0.28, blue: 0.55)
    public static let accent = Color(red: 0.00, green: 0.70, blue: 0.90) // Cyan enérgico #00B0E8
    
    // Estados de Documentos
    public static let statusPending = Color(red: 0.95, green: 0.55, blue: 0.10) // Naranja
    public static let statusSuccess = Color(red: 0.18, green: 0.70, blue: 0.35) // Verde
    public static let statusDanger = Color(red: 0.90, green: 0.25, blue: 0.25) // Rojo
    public static let statusDraft = Color(red: 0.55, green: 0.60, blue: 0.65) // Gris
    
    // Fondos y Superficies
    public static let background = Color(UIColor.systemGroupedBackground)
    public static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
}

public extension Double {
    /// Formato de moneda española estándar: 1.250,50 €
    var formatoMoneda: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_ES")
        formatter.currencySymbol = "€"
        return formatter.string(from: NSNumber(value: self)) ?? "\(String(format: "%.2f", self)) €"
    }
    
    /// Formato de porcentaje: 21,0%
    var formatoPorcentaje: String {
        return "\(String(format: "%.1f", self))%"
    }
}

public extension Date {
    /// Formato corto de fecha en español: 20 oct 2026
    var formatoCorto: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        formatter.dateFormat = "d MMM yyyy"
        return formatter.string(from: self)
    }
    
    /// Hora: 09:30
    var formatoHora: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
