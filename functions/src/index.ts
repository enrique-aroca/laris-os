import * as admin from "firebase-admin";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";

admin.initializeApp();
const db = admin.firestore();

/**
 * 1. Healthcheck para verificar el estado de las Cloud Functions y conexión a Firestore
 */
export const healthCheck = onCall(async (request) => {
  return {
    status: "ok",
    service: "Laris OS Cloud Backend",
    timestamp: new Date().toISOString(),
    authenticatedUser: request.auth?.uid || null,
  };
});

/**
 * 2. Generación atómica y correlativa de números de factura y presupuesto
 * Garantiza legalidad española: numeración consecutiva estricta sin saltos ni duplicados por año.
 * Formatos: F-2026-0001 (Facturas) o P-2026-0001 (Presupuestos).
 */
export const obtenerSiguienteNumero = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Debe iniciar sesión para solicitar un número de documento.");
  }

  const tipo = request.data?.tipo; // "factura" | "presupuesto"
  if (tipo !== "factura" && tipo !== "presupuesto") {
    throw new HttpsError("invalid-argument", "El tipo debe ser 'factura' o 'presupuesto'.");
  }

  const anioActual = new Date().getFullYear();
  const prefijo = tipo === "factura" ? "F" : "P";
  const docRef = db.collection("contadores").doc(`${tipo}_${anioActual}`);

  const siguienteNumero = await db.runTransaction(async (transaction) => {
    const docSnapshot = await transaction.get(docRef);
    let ultimoNumero = 0;

    if (docSnapshot.exists) {
      ultimoNumero = docSnapshot.data()?.ultimoNumero || 0;
    }

    const nuevoNumero = ultimoNumero + 1;
    transaction.set(docRef, {
      ultimoNumero: nuevoNumero,
      anio: anioActual,
      tipo: tipo,
      actualizadoEl: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    const secuencialPadded = String(nuevoNumero).padStart(4, "0");
    return `${prefijo}-${anioActual}-${secuencialPadded}`;
  });

  return { numero: siguienteNumero };
});

/**
 * 3. Automatización al cerrar un Parte de Trabajo (Trigger de Firestore)
 * Cuando un trabajo pasa a estado "finalizado":
 * - Descuenta automáticamente el stock de los materiales consumidos del catálogo.
 * - Calcula la rentabilidad real de la obra (Coste materiales + Horas invertidas).
 */
export const alFinalizarTrabajo = onDocumentUpdated("trabajos/{trabajoId}", async (event) => {
  const datosAntes = event.data?.before.data();
  const datosDespues = event.data?.after.data();

  if (!datosAntes || !datosDespues) return;

  // Solo actuar si cambia a "finalizado"
  if (datosAntes.estado !== "finalizado" && datosDespues.estado === "finalizado") {
    const trabajoId = event.params.trabajoId;
    const materiales = datosDespues.materialesUsados || []; // Array de { productoId, cantidad, costeUnitario }
    const horas = Number(datosDespues.horasTrabajadas || 0);
    const costeHoraManoObra = Number(datosDespues.costeHoraManoObra || 30); // 30 €/h base o el fijado

    let costeMaterialesTotal = 0;

    // Actualizar stock de cada producto en transacción
    await db.runTransaction(async (transaction) => {
      for (const item of materiales) {
        if (!item.productoId || !item.cantidad) continue;

        const prodRef = db.collection("catalogo").doc(item.productoId);
        const prodSnap = await transaction.get(prodRef);

        if (prodSnap.exists) {
          const prodData = prodSnap.data();
          const stockActual = Number(prodData?.stockFurgoneta || prodData?.stockReal || 0);
          const cantidadUsada = Number(item.cantidad);
          const coste = Number(prodData?.coste || item.costeUnitario || 0);

          costeMaterialesTotal += coste * cantidadUsada;

          transaction.update(prodRef, {
            stockFurgoneta: stockActual - cantidadUsada,
            ultimoMovimiento: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      }

      const costeManoObraTotal = horas * costeHoraManoObra;
      const costeTotalObra = costeMaterialesTotal + costeManoObraTotal;

      // Actualizar el trabajo con los costes finales calculados
      const trabajoRef = db.collection("trabajos").doc(trabajoId);
      transaction.update(trabajoRef, {
        rentabilidad: {
          costeMateriales: costeMaterialesTotal,
          costeManoObra: costeManoObraTotal,
          costeTotal: costeTotalObra,
          calculadoEl: admin.firestore.FieldValue.serverTimestamp(),
        },
      });
    });

    console.log(`Trabajo ${trabajoId} cerrado con éxito. Costes calculados y stock actualizado.`);
  }
});
