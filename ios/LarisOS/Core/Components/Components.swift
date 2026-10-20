import SwiftUI

/// Badge o píldora de estado estilo STEL Order (Borrador, Pendiente, Aceptado, etc.)
public struct StatusBadge: View {
    let titulo: String
    let color: Color
    var icono: String? = nil
    
    public init(titulo: String, color: Color, icono: String? = nil) {
        self.titulo = titulo
        self.color = color
        self.icono = icono
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            if let icono = icono {
                Image(systemName: icono)
                    .font(.system(size: 10, weight: .bold))
            }
            Text(titulo)
                .font(.system(size: 11, weight: .semibold))
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .clipShape(Capsule())
    }
}

/// Tarjeta de métrica para el panel principal de inicio
public struct StatCard: View {
    let titulo: String
    let valor: String
    let subtitulo: String?
    let icono: String
    let colorIcono: Color
    
    public init(
        titulo: String,
        valor: String,
        subtitulo: String? = nil,
        icono: String,
        colorIcono: Color
    ) {
        self.titulo = titulo
        self.valor = valor
        self.subtitulo = subtitulo
        self.icono = icono
        self.colorIcono = colorIcono
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle()
                        .fill(colorIcono.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icono)
                        .foregroundColor(colorIcono)
                        .font(.system(size: 16, weight: .semibold))
                }
                Spacer()
                if let sub = subtitulo {
                    Text(sub)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(valor)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(titulo)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(14)
        .background(STELTheme.cardBackground)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}
