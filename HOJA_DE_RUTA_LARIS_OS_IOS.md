# HOJA DE RUTA Y PLAN TÉCNICO: LARIS OS (iOS NATIVO)
## Edición Especial: Instalador Autónomo / Profesional Único

**Proyecto:** LARIS OS — Gestión ágil de campo para instalaciones eléctricas, fotovoltaica, Ajax y CCTV  
**Perfil de usuario:** Profesional único (Autónomo: realiza presupuestos, compras, instalaciones y facturación)  
**Plataforma de destino:** iOS Nativo (iPhone para campo + iPad para presupuestación/oficina)  
**Infraestructura Cloud:** Google Firebase 100% (Plan Blaze activado)  
**Fecha:** Octubre 2026  
**Objetivo principal:** Eliminar burocracia innecesaria de grandes empresas y maximizar la rapidez diaria del instalador autónomo.

---

## 1. REENFOQUE ESTRATÉGICO: DE ERP EMPRESARIAL A HERRAMIENTA ÁGIL DE UN SOLO PROFESIONAL

Al tratarse de una herramienta para **un único profesional**, la aplicación no debe sobrecargarse con procesos administrativos pensados para plantillas de decenas de empleados. El autónomo necesita **velocidad, cero duplicidad de datos y automatización**.

### ¿Qué se ELIMINA por ser innecesario para un solo profesional?
- ❌ **Gestión de roles y permisos complejos:** Se eliminan los 5 perfiles (Admin, Oficina, Técnico, Almacén, Consulta). No tiene sentido ocultar márgenes o costes a un técnico que es el propio dueño del negocio.
- ❌ **Transferencias burocráticas entre flotas:** No hay aprobaciones de transferencias entre furgonetas de distintos empleados.
- ❌ **Balanceo de cargas y asignación a terceros:** El calendario no necesita gestionar la disponibilidad de múltiples operarios ni resolver solapamientos de terceros; es la agenda personal del propio instalador.
- ❌ **Flujos de aprobación interna:** No hay revisión previa ni firmas de autorización para pedidos o presupuestos. Todo se ejecuta en 1 toque.
- ❌ **Despliegues corporativos pesados (MDM / Apple Business Manager):** Instalación directa en los dispositivos propios del autónomo (iPhone y iPad) mediante TestFlight o App Store.

### ¿Qué se REFUERZA para hacer ganar tiempo y dinero al autónomo?
- ⚡ **Ciclo en 1 solo toque:** Un *Presupuesto Aceptado* se convierte en *Parte de Trabajo* con un toque, y de ahí a *Factura* sin teclear nada dos veces.
- ⚡ **Parte de campo rápido:** Tomar fotos antes/después del cuadro eléctrico o instalación solar, recoger la firma del cliente en el iPhone/iPad y enviarle el PDF por WhatsApp o email al momento.
- ⚡ **Control real de rentabilidad por obra:** Conocer al céntimo si una instalación ha sido rentable: `(Precio cobrado) - (Materiales usados + Mis horas invertidas + Gastos de gasolina/compras) = Beneficio real`.
- ⚡ **Buscador ultrarrápido del catálogo:** Acceso inmediato a los 253 productos de STEL Order con precio de venta y margen.
- ⚡ **Cámara como herramienta de trabajo:** Escanear códigos de barras de material, escanear tickets de compra en distribuidores para desgravar gastos y fotografiar placas de características técnicas.
- ⚡ **Bóveda segura de contraseñas de seguridad:** Guardar en el llavero seguro (Face ID) las contraseñas de las cámaras de videovigilancia y centrales Ajax de cada cliente para no perderlas en notas o chats.
- ⚡ **Facturación española para autónomos:** Soporte nativo para retenciones de **IRPF** (cuando factura a empresas o comunidades), tipos de **IVA** (general 21%, reducido 10% en reformas residenciales) y series correlativas sin complicaciones.

---

## 2. ARQUITECTURA TÉCNICA 100% GOOGLE FIREBASE (PLAN BLAZE)

Toda la infraestructura cloud queda unificada bajo el ecosistema de **Google Firebase**, simplificando al máximo el mantenimiento y la configuración:

```
┌────────────────────────────────────────────────────────────────────────┐
│                   APP NATIVA iOS (iPhone + iPad)                       │
│             SwiftUI / Swift Concurrency / SwiftData                    │
│                                                                        │
│  ┌───────────────────┐  ┌───────────────────┐  ┌────────────────────┐  │
│  │  Face ID / Touch  │  │  Cámara Nativa    │  │  PencilKit         │  │
│  │  (Acceso seguro)  │  │  (Fotos / Barcode)│  │  (Firma en pantalla│  │
│  └───────────────────┘  └───────────────────┘  └────────────────────┘  │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ SDK Oficial Firebase para iOS
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   PLATAFORMA FIREBASE (PLAN BLAZE)                     │
│                                                                        │
│  ┌─────────────────────────┐            ┌───────────────────────────┐  │
│  │   FIRESTORE DATABASE    │            │     FIREBASE STORAGE      │  │
│  │  - Datos en JSON        │            │  - Fotos antes/después    │  │
│  │  - Persistencia Offline │            │  - PDFs de presupuestos   │  │
│  │  - Clientes / Catálogo  │            │  - Facturas oficiales     │  │
│  │  - Partes y Facturas    │            │  - Tickets de gastos      │  │
│  └─────────────────────────┘            └───────────────────────────┘  │
│  ┌─────────────────────────┐            ┌───────────────────────────┐  │
│  │      FIREBASE AUTH      │            │      CLOUD FUNCTIONS      │  │
│  │  - Acceso seguro        │            │  - Numeración correlativa │  │
│  │  - Apple Sign-In / Pass │            │  - Triggers y backups     │  │
│  └─────────────────────────┘            └───────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

### Componentes de la Arquitectura:
1. **Frontend:** Swift con SwiftUI. Una única base de código universal adaptada a:
   - **iPhone:** Pantalla de mano para el trabajo sucio en la obra, furgoneta y escaneos rápidos.
   - **iPad:** Para sentarse con el cliente a diseñar presupuestos, ver planos y firmar en grande.
2. **Base de Datos (Cloud Firestore):**
   - **Modo sin conexión nativo:** Firestore para iOS tiene un motor de base de datos local en disco SQLite integrado. El instalador puede trabajar en sótanos sin cobertura rellenando partes y consumos de material; en cuanto recupera red, se sincroniza automáticamente con la nube y con su iPad.
   - Capacidad: 1 GB de texto gratuito (suficiente para más de 10 años de facturas y partes).
3. **Almacenamiento de Archivos (Firebase Storage):**
   - Almacena fotos antes/después, firmas y PDFs.
   - Con compresión nativa en iOS (fotos optimizadas a ~250 KB), la cuota gratuita mensual cubre más de 18.000 imágenes. Al estar en plan Blaze, si un mes se supera ligeramente, el coste adicional son céntimos (~0,02 €/GB).
4. **Seguridad y Acceso:**
   - Inicio de sesión con Apple ID / Email con biometría activada (**Face ID / Touch ID**).
   - Claves de equipos Ajax y grabadores CCTV protegidas en el dispositivo mediante **Apple Keychain (Secure Enclave)**.

---

## 3. MÓDULOS ESENCIALES PARA EL DÍA A DÍA DEL INSTALADOR

### Módulo 1: Catálogo y Tarifas (Base de Datos STEL Order)
- Importación inicial de los **253 productos de STEL Order**.
- Ajuste rápido de precio de coste y precio de venta mediante margen comercial o recargo.
- Buscador instantáneo con teclado numérico rápido para cambiar precios sobre la marcha en obra.
- Escáner con la cámara para identificar artículos por código de barras.

### Módulo 2: Clientes y CRM Personal
- Ficha unificada: Particulares, Empresas, Comunidades de Propietarios.
- Botones de acción directa: **Llamar**, **Enviar WhatsApp**, **Abrir ruta en Mapas (GPS)**.
- Historial completo del cliente: todos sus presupuestos, partes de trabajo anteriores, facturas y fotos de su instalación agrupados en un solo lugar.

### Módulo 3: Presupuestos Comerciales Ágiles
- Creación rápida de presupuestos seleccionando partidas de catálogo o líneas libres de mano de obra.
- Desglose visual inmediato: cuánto cuesta el material, cuántas horas se calculan y cuál es el beneficio neto para el autónomo.
- Generación de PDF profesional con diseño de Laris.
- Botón **"Compartir por WhatsApp"** para enviar el PDF al cliente en menos de 30 segundos.
- Estado: *Pendiente* → Al aceptarse: botón **"Convertir en Trabajo"**.

### Módulo 4: Partes de Trabajo en Campo (La Herramienta de Obra)
- Tiempos: Registro de horas reales dedicadas a la intervención.
- Materiales: Materiales consumidos en la instalación (se descuentan del stock personal).
- Fotografías: Fotos *Antes* y *Después* (imprescindibles para justificar trabajos, averías o garantías).
- **Firma digital del cliente:** El cliente firma con el dedo o el Apple Pencil sobre la pantalla.
- Cierre del trabajo y generación automática del albarán de trabajo en PDF firmado.

### Módulo 5: Stock Sencillo (Mi Almacén + Mi Furgoneta)
- Sin burocracia: Dos ubicaciones básicas: **Almacén / Taller** y **Furgoneta**.
- Vista rápida de "Qué llevo en la furgoneta" para no ir a una obra sin el material necesario.
- Ajuste rápido de stock con escáner de código de barras.
- Alerta visual de stock mínimo para pedir reposición a los distribuidores de electricidad/clima.

### Módulo 6: Facturación y Control de Gastos para Autónomos
- **Facturas de Venta:** Conversión en 1 clic de albarán a factura oficial.
  - Series correlativas legales (F-2026-001...).
  - Cálculo automático de IVA (21% o 10%) y retención de IRPF (7% o 15% según aplique si factura a empresas/comunidades).
- **Control de Gastos y Compras:**
  - Registro rápido de compras de material y tickets (gasolina, herramientas, pequeño material en almacén de suministros).
  - Foto del ticket para archivo contable.
- **Rentabilidad de la Obra:**
  - Resumen claro: `Facturado - Materiales - Gastos = Mi Ganancia`.

### Módulo 7: Módulos Específicos de Laris
- **Fotovoltaica:** Registro de paneles instalados, potencia total pico (kWp), marca/modelo del inversor, baterías, números de serie y fotos de la puesta en marcha.
- **Electricidad:** Registro del cuadro eléctrico, protecciones instaladas, secciones principales y fotos de comprobaciones reglamentarias (REBT).
- **Ajax y CCTV:** Registro de centrales, detectores y cámaras; lista de canales y **almacenamiento blindado con Face ID de las credenciales de instalador**.
- **Mantenimiento y SAT:** Avisos de revisión anual (baterías solares, mantenimiento preventivo de alarmas) con recordatorio automático en el calendario.

---

## 4. PLAN DE DESARROLLO ÁGIL Y HOJA DE RUTA (ROADMAP)

Al suprimir toda la complejidad multiusuario y administrativa, el tiempo total de desarrollo se sitúa en **8 a 10 semanas**, con entregas funcionales semanales para probar directamente en el iPhone del instalador:

```
┌────────────────────────────────────────────────────────────────────────┐
│                     CRONOGRAMA ÁGIL (8-10 SEMANAS)                     │
│                                                                        │
│  Semanas 1-2:   [FASE 1] Cimientos, Catálogo STEL Order y Clientes     │
│  Semanas 3-4:   [FASE 2] Presupuestos PDF y Partes con Firma en Campo  │
│  Semanas 5-6:   [FASE 3] Stock de Furgoneta, Facturación e IRPF        │
│  Semanas 7-8:   [FASE 4] Verticales Laris (Solar, Cuadros, CCTV) y SAT │
│  Semanas 9-10:  [FASE 5] Pruebas de Trabajo Diario y Puesta en Marcha  │
└────────────────────────────────────────────────────────────────────────┘
```

---

### FASE 1: Cimientos, Catálogo STEL Order y Clientes
**Plazo:** Semanas 1 y 2  
**Entregable:** La app funciona en el iPhone con Face ID, tiene cargados los 253 productos de STEL Order y permite gestionar clientes.

- [ ] Configuración de proyecto Xcode nativo (SwiftUI) para iPhone y iPad.
- [ ] Configuración del proyecto Firebase (Firestore + Storage + Auth) con persistencia offline.
- [ ] Script de migración y carga limpia de los 253 productos de STEL Order (resolviendo stocks negativos).
- [ ] Pantalla de Catálogo: Búsqueda rápida, edición de precio de compra, margen y precio de venta.
- [ ] Pantalla de Clientes: Fichas con llamada directa, WhatsApp y botón de navegación GPS hacia la dirección de la obra.

---

### FASE 2: Presupuestos en Movilidad y Partes con Firma
**Plazo:** Semanas 3 y 4  
**Entregable:** El instalador puede presupuestar una obra en el iPad, enviarla por WhatsApp, convertirla en trabajo, tomar fotos y recoger la firma del cliente sin cobertura.

- [ ] Creador de presupuestos rápido (con cálculo de margen en tiempo real).
- [ ] Generador de plantillas PDF con identidad visual de Laris.
- [ ] Conversión en 1 toque: *Presupuesto Aceptado* → *Parte de Trabajo*.
- [ ] Pantalla de intervención en obra:
  - Registro de horas de trabajo.
  - Cámara integrada para fotos Antes/Después (subida directa a Firebase Storage).
  - Pantalla de firma digital con `PencilKit` (firma táctil del cliente).
  - Generación del PDF del parte de trabajo firmado y compartición por WhatsApp/Mail.
- [ ] Modo offline probado en campo: la app funciona sin cobertura en sótanos y se sincroniza sola al recuperar red.

---

### FASE 3: Stock de Furgoneta, Facturación y Gastos
**Plazo:** Semanas 5 y 6  
**Entregable:** Control de material propio, facturación legal con IRPF/IVA y archivo de tickets de gasto.

- [ ] Control sencillo de stock: Almacén vs Furgoneta del instalador.
- [ ] Lector de códigos de barras con la cámara del iPhone (`Vision`) para imputar piezas usadas rápidamente.
- [ ] Módulo de Facturación para Autónomos:
  - Conversión de parte de trabajo en Factura legal.
  - Gestión de numeración correlativa inmutable.
  - Cálculo de IVA (21% / 10%) y retención de IRPF (7% / 15%).
  - Generación de PDF de factura.
- [ ] Registro rápido de tickets de gastos (material imprevisto, gasolina, suministros) con captura de foto.
- [ ] Balance de beneficio neto por instalación (Cobrado - Materiales - Gastos).

---

### FASE 4: Especialidades Laris (Solar, Electricidad, CCTV/Ajax) y SAT
**Plazo:** Semanas 7 y 8  
**Entregable:** Formularios técnicos específicos para no olvidar datos clave en obras de solar, cuadros eléctricos o alarmas, y calendario de avisos.

- [ ] Ficha técnica Fotovoltaica: Inversor, paneles, baterías, orientación, fotos de cuadro AC/DC y strings.
- [ ] Ficha técnica Electricidad: Cuadro, circuitos, protecciones y fotos para boletín/memoria técnica.
- [ ] Ficha técnica Ajax y CCTV: Canales, ubicaciones de cámaras y bóveda encriptada con Face ID para credenciales técnicas de acceso.
- [ ] Módulo SAT e incidencias: Historial de averías por cliente y avisos de mantenimiento anual preventivo.

---

### FASE 5: Pruebas de Rodaje en Furgoneta y Puesta en Producción
**Plazo:** Semanas 9 y 10  
**Entregable:** Laris OS sustituye 100% a STEL Order en la rutina diaria del instalador.

- [ ] 1 semana de uso real en obras reales (usando la app en paralelo con STEL Order para verificar que no falta nada).
- [ ] Validación de las facturas generadas con el asesor fiscal del autónomo.
- [ ] Verificación de copias de seguridad automáticas de fotos y base de datos en la nube.
- [ ] Instalación definitiva en el iPhone y iPad personal mediante enlace privado de TestFlight / App Store.

---

## 5. RECURSOS Y CONFIGURACIÓN INICIAL DE FIREBASE

1. **Ubicación de Servidores (RGPD):**
   - Configuración en región europea: `europe-west1` (Bélgica) o `europe-west3` (Frankfurt) para cumplir la normativa española y europea de protección de datos.
2. **Estructura en Firestore:**
   - `/clientes`: Colección raíz de clientes particulares, empresas y comunidades.
   - `/catalogo`: Colección de productos y servicios con referencia, coste, precio y margen.
   - `/presupuestos`: Colección de ofertas comerciales emitidas.
   - `/trabajos`: Partes de trabajo, horas, materiales y enlaces a fotos de Firebase Storage.
   - `/facturas`: Facturas oficiales con numeración protegida por Cloud Function.
   - `/gastos`: Compras y tickets desgravables.
3. **Estructura en Firebase Storage:**
   - `/fotos_obras/{trabajoId}/antes_*.jpg`
   - `/fotos_obras/{trabajoId}/despues_*.jpg`
   - `/documentos/{clienteId}/presupuesto_*.pdf`
   - `/documentos/{clienteId}/factura_*.pdf`
   - `/gastos/{gastoId}/ticket_*.jpg`
