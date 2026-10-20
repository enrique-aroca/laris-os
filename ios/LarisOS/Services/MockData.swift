import Foundation

/// Datos realistas para pruebas inmediatas y previsualización de Laris OS
public class MockData {
    public static let shared = MockData()
    
    public var clientes: [Cliente] = [
        Cliente(
            nombre: "García Construcciones S.L.",
            nombreComercial: "García Obras",
            nifCif: "B-88234109",
            tipo: .empresa,
            telefono: "+34 612 345 678",
            email: "contacto@garciaobras.es",
            direccion: "Polígono Industrial La Redonda, Parcela 14",
            codigoPostal: "04700",
            ciudad: "El Ejido",
            provincia: "Almería",
            notas: "Constructor habitual. Facturación mensual acumulada."
        ),
        Cliente(
            nombre: "Comunidad Propietarios Mirador del Sol",
            nombreComercial: "Edificio Mirador",
            nifCif: "H-04592811",
            tipo: .comunidad,
            telefono: "+34 654 987 321",
            email: "admin@miradordelsol.com",
            direccion: "Avda. Juan Carlos I, 88",
            codigoPostal: "04008",
            ciudad: "Almería",
            provincia: "Almería",
            notas: "Mantenimiento preventivo anual de CCTV en garajes y videoportero."
        ),
        Cliente(
            nombre: "Antonio Martínez Ruiz",
            nifCif: "45871234X",
            tipo: .particular,
            telefono: "+34 689 112 233",
            email: "antonio.martinez@gmail.com",
            direccion: "Calle Los Almendros, 12, Chalet B",
            codigoPostal: "04720",
            ciudad: "Roquetas de Mar",
            provincia: "Almería",
            notas: "Instalación solar fotovoltaica residencial de 5 kWp con batería."
        )
    ]
    
    public var productos: [Producto] = [
        Producto(
            referencia: "SOL-INV-5K",
            nombre: "Inversor Híbrido Huawei SUN2000-5KTL-L1",
            descripcion: "Inversor monofásico 5kW compatible con batería de litio Luna2000",
            categoria: .fotovoltaica,
            coste: 820.00,
            precioVenta: 1150.00,
            porcentajeIva: 21.0,
            stockFurgoneta: 1,
            stockAlmacen: 2,
            stockMinimo: 1,
            unidadMedida: "ud",
            codigoBarras: "6901443321558"
        ),
        Producto(
            referencia: "SOL-MOD-500",
            nombre: "Panel Solar Canadian Solar 500W Monocristalino",
            descripcion: "Módulo fotovoltaico de alta eficiencia HiKu6",
            categoria: .fotovoltaica,
            coste: 85.00,
            precioVenta: 125.00,
            porcentajeIva: 21.0,
            stockFurgoneta: 0,
            stockAlmacen: 24,
            stockMinimo: 10,
            unidadMedida: "ud"
        ),
        Producto(
            referencia: "AJAX-HUB-2",
            nombre: "Central de Alarma Ajax Hub 2 Plus",
            descripcion: "Panel de control vía radio con 4 canales de comunicación (Ethernet, Wi-Fi, 2x 4G)",
            categoria: .seguridadCCTV,
            coste: 195.00,
            precioVenta: 290.00,
            porcentajeIva: 21.0,
            stockFurgoneta: 2,
            stockAlmacen: 4,
            stockMinimo: 2,
            unidadMedida: "ud"
        ),
        Producto(
            referencia: "ELEC-DIF-40A",
            nombre: "Diferencial Schneider 2P 40A 30mA Clase A",
            descripcion: "Protección diferencial superinmunizada para recarga vehículo o solar",
            categoria: .electricidad,
            coste: 42.00,
            precioVenta: 68.00,
            porcentajeIva: 21.0,
            stockFurgoneta: 3,
            stockAlmacen: 8,
            stockMinimo: 3,
            unidadMedida: "ud"
        ),
        Producto(
            referencia: "SRV-HORA-TEC",
            nombre: "Hora Técnico Especialista en Instalación",
            descripcion: "Mano de obra técnica cualificada oficial 1ª en obra o reparación",
            categoria: .servicios,
            esServicio: true,
            coste: 18.00,
            precioVenta: 35.00,
            porcentajeIva: 21.0,
            unidadMedida: "h"
        ),
        Producto(
            referencia: "SRV-DESP",
            nombre: "Desplazamiento y Diagnosis Técnica",
            descripcion: "Desplazamiento vehículo taller y primera hora de diagnóstico de avería",
            categoria: .servicios,
            esServicio: true,
            coste: 10.00,
            precioVenta: 45.00,
            porcentajeIva: 21.0,
            unidadMedida: "ud"
        )
    ]
    
    public var presupuestos: [Presupuesto] = [
        Presupuesto(
            numero: "PRE-2026-0042",
            clienteId: "c3",
            clienteNombre: "Antonio Martínez Ruiz",
            fechaCreacion: Date(),
            fechaValidez: Calendar.current.date(byAdding: .day, value: 30, to: Date())!,
            lineas: [
                LineaDocumento(concepto: "Inversor Híbrido Huawei SUN2000-5KTL-L1", cantidad: 1, precioUnitario: 1150.0, costeUnitario: 820.0),
                LineaDocumento(concepto: "Panel Solar Canadian Solar 500W Monocristalino", cantidad: 10, precioUnitario: 125.0, costeUnitario: 85.0),
                LineaDocumento(concepto: "Hora Técnico Especialista en Instalación", cantidad: 16, precioUnitario: 35.0, costeUnitario: 18.0)
            ],
            estado: .pendiente,
            notas: "Incluye tramitación y legalización en Industria de la Junta de Andalucía."
        ),
        Presupuesto(
            numero: "PRE-2026-0038",
            clienteId: "c1",
            clienteNombre: "García Construcciones S.L.",
            fechaCreacion: Calendar.current.date(byAdding: .day, value: -12, to: Date())!,
            lineas: [
                LineaDocumento(concepto: "Cuadro de obra provisional con protecciones", cantidad: 1, precioUnitario: 450.0, costeUnitario: 280.0),
                LineaDocumento(concepto: "Hora Técnico Especialista en Instalación", cantidad: 4, precioUnitario: 35.0, costeUnitario: 18.0)
            ],
            estado: .aceptado,
            notas: "Aceptado por WhatsApp. Listo para ejecutar."
        )
    ]
    
    public var partesTrabajo: [ParteTrabajo] = [
        ParteTrabajo(
            numero: "PAR-2026-0089",
            clienteId: "c3",
            clienteNombre: "Antonio Martínez Ruiz",
            direccion: "Calle Los Almendros, 12, Roquetas",
            descripcion: "Montaje de estructura sobre tejado y conexionado de 10 paneles solares",
            fecha: Date(),
            estado: .enCurso,
            horasTrabajadas: 4.5,
            materialesUsados: [
                LineaDocumento(concepto: "Panel Solar Canadian Solar 500W", cantidad: 10, precioUnitario: 125.0, costeUnitario: 85.0)
            ],
            observaciones: "Estructura anclada a forjado. Pendiente bajada de cables DC al garaje mañana."
        ),
        ParteTrabajo(
            numero: "PAR-2026-0087",
            clienteId: "c2",
            clienteNombre: "Comunidad Propietarios Mirador del Sol",
            direccion: "Avda. Juan Carlos I, 88, Almería",
            descripcion: "Sustitución de alimentador de videoportero y cámara de portal",
            fecha: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            estado: .finalizado,
            horasTrabajadas: 2.0,
            materialesUsados: [
                LineaDocumento(concepto: "Fuente de alimentación 18V DC", cantidad: 1, precioUnitario: 75.0, costeUnitario: 38.0)
            ],
            nombreFirmante: "Manuel Pérez (Presidente)",
            observaciones: "Comprobado funcionamiento en 12 viviendas. Todo correcto."
        )
    ]
    
    public var facturas: [Factura] = [
        Factura(
            numero: "F-2026-0014",
            clienteId: "c2",
            clienteNombre: "Comunidad Propietarios Mirador del Sol",
            clienteCif: "H-04592811",
            direccionFacturacion: "Avda. Juan Carlos I, 88, 04008 Almería",
            fechaEmision: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            lineas: [
                LineaDocumento(concepto: "Reparación videoportero y fuente alimentación", cantidad: 1, precioUnitario: 145.0, costeUnitario: 38.0)
            ],
            porcentajeIrpf: 0.0,
            estadoCobro: .pendienteCobro,
            parteOrigenId: "PAR-2026-0087"
        ),
        Factura(
            numero: "F-2026-0012",
            clienteId: "c1",
            clienteNombre: "García Construcciones S.L.",
            clienteCif: "B-88234109",
            direccionFacturacion: "Polígono Industrial La Redonda, 14",
            fechaEmision: Calendar.current.date(byAdding: .day, value: -18, to: Date())!,
            lineas: [
                LineaDocumento(concepto: "Acometida eléctrica provisional de obra", cantidad: 1, precioUnitario: 590.0, costeUnitario: 320.0)
            ],
            porcentajeIrpf: 15.0, // Retención IRPF a empresa
            estadoCobro: .cobrada
        )
    ]
}
