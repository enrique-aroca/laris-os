import XCTest
@testable import LarisOS

final class LarisOSTests: XCTestCase {
    
    /// Comprueba la regla matemática clave de la especificación:
    /// "Ejemplo: coste 100 € y venta 130 € = recargo del 30 %, pero margen bruto sobre venta del 23,08 %"
    func testCalculoMargenYRecargoEspecificacion() {
        let producto = Producto(
            referencia: "TEST-01",
            nombre: "Material de Prueba",
            coste: 100.0,
            precioVenta: 130.0
        )
        
        // Recargo sobre el coste: (130 - 100) / 100 = 30.0%
        XCTAssertEqual(producto.recargoSobreCoste, 30.0, accuracy: 0.01)
        
        // Margen sobre la venta: (130 - 100) / 130 = 23.0769...%
        XCTAssertEqual(producto.margenSobreVenta, 23.08, accuracy: 0.01)
        
        // Beneficio bruto en €
        XCTAssertEqual(producto.beneficioUnitario, 30.0, accuracy: 0.01)
    }
    
    /// Comprueba la alerta de stock bajo
    func testAlertaStockMinimo() {
        let productoConStock = Producto(
            referencia: "CABLE-01",
            nombre: "Manguera 3x2.5",
            stockFurgoneta: 2,
            stockAlmacen: 5,
            stockMinimo: 3
        )
        XCTAssertFalse(productoConStock.estaBajoMinimo)
        
        let productoAgotado = Producto(
            referencia: "CABLE-02",
            nombre: "Tubo corrugado",
            stockFurgoneta: 1,
            stockAlmacen: 0,
            stockMinimo: 2
        )
        XCTAssertTrue(productoAgotado.estaBajoMinimo)
    }
    
    /// Comprueba el cálculo de factura con retención de IRPF para autónomos
    func testCalculoFacturaConIRPF() {
        let factura = Factura(
            numero: "F-2026-0001",
            clienteId: "c1",
            clienteNombre: "Empresa Cliente S.L.",
            lineas: [
                LineaDocumento(concepto: "Instalación Eléctrica", cantidad: 1, precioUnitario: 1000.0, porcentajeIva: 21.0)
            ],
            porcentajeIrpf: 15.0 // 15% retención
        )
        
        // Base: 1.000 €
        XCTAssertEqual(factura.baseImponible, 1000.0, accuracy: 0.01)
        
        // IVA 21%: 210 €
        XCTAssertEqual(factura.ivaTotal, 210.0, accuracy: 0.01)
        
        // IRPF 15%: 150 €
        XCTAssertEqual(factura.importeIrpf, 150.0, accuracy: 0.01)
        
        // Total a cobrar: 1000 + 210 - 150 = 1060 €
        XCTAssertEqual(factura.totalFactura, 1060.0, accuracy: 0.01)
    }
}
