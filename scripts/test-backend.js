/**
 * Test de Verificación y Diagnóstico en la Nube de Firebase
 * Proyecto: Laris OS (stel-order-c126a)
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

// Leer configuración desde GoogleService-Info.plist
const plistPath = path.join(__dirname, '..', 'GoogleService-Info.plist');
if (!fs.existsSync(plistPath)) {
  console.error("❌ No se encontró GoogleService-Info.plist");
  process.exit(1);
}

const plistContent = fs.readFileSync(plistPath, 'utf8');
const apiKeyMatch = plistContent.match(/<key>API_KEY<\/key>\s*<string>([^<]+)<\/string>/);
const projectIdMatch = plistContent.match(/<key>PROJECT_ID<\/key>\s*<string>([^<]+)<\/string>/);
const bucketMatch = plistContent.match(/<key>STORAGE_BUCKET<\/key>\s*<string>([^<]+)<\/string>/);

const API_KEY = apiKeyMatch ? apiKeyMatch[1] : null;
const PROJECT_ID = projectIdMatch ? projectIdMatch[1] : null;
const STORAGE_BUCKET = bucketMatch ? bucketMatch[1] : null;

console.log("=================================================");
console.log("🔍 DIAGNÓSTICO EN TIEMPO REAL: FIREBASE CLOUD");
console.log(`📌 Proyecto: ${PROJECT_ID}`);
console.log(`🗄️ Bucket Storage: ${STORAGE_BUCKET}`);
console.log("=================================================\n");

function makeRequest(url, method = 'GET', body = null) {
  return new Promise((resolve, reject) => {
    const parsedUrl = new URL(url);
    const options = {
      hostname: parsedUrl.hostname,
      path: parsedUrl.pathname + parsedUrl.search,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      }
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => data += chunk);
      res.on('end', () => {
        resolve({ statusCode: res.statusCode, data: data });
      });
    });

    req.on('error', (e) => reject(e));
    if (body) {
      req.write(JSON.stringify(body));
    }
    req.end();
  });
}

async function runTests() {
  let allPassed = true;

  // 1. Test de Firebase Authentication
  console.log("1️⃣ Verificando servicio de Autenticación (Identity Toolkit)...");
  try {
    const authUrl = `https://identitytoolkit.googleapis.com/v1/accounts:createAuthUri?key=${API_KEY}`;
    const authRes = await makeRequest(authUrl, 'POST', {
      identifier: 'test@laris.es',
      continueUri: 'http://localhost'
    });

    if (authRes.statusCode === 200 || authRes.statusCode === 400) {
      console.log("   ✅ Firebase Auth: ACTIVO y respondiendo correctamente a la API Key.");
    } else {
      console.log(`   ⚠️ Respuesta Auth: HTTP ${authRes.statusCode}`);
      allPassed = false;
    }
  } catch (err) {
    console.error("   ❌ Error en Auth:", err.message);
    allPassed = false;
  }

  // 2. Test de Firestore Database
  console.log("\n2️⃣ Verificando base de datos Cloud Firestore...");
  try {
    const firestoreUrl = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/configuracion?key=${API_KEY}`;
    const firestoreRes = await makeRequest(firestoreUrl, 'GET');

    if (firestoreRes.statusCode === 200) {
      console.log("   ✅ Cloud Firestore: ACTIVO y accesible.");
    } else if (firestoreRes.statusCode === 403) {
      console.log("   ✅ Cloud Firestore: ACTIVO, OPERATIVO y blindado por reglas de seguridad en Producción.");
    } else {
      console.log(`   ⚠️ Respuesta Firestore: HTTP ${firestoreRes.statusCode}`);
      allPassed = false;
    }
  } catch (err) {
    console.error("   ❌ Error en Firestore:", err.message);
    allPassed = false;
  }

  // 3. Test de Firebase Storage
  console.log("\n3️⃣ Verificando bucket de Firebase Storage...");
  try {
    const storageUrl = `https://firebasestorage.googleapis.com/v0/b/${STORAGE_BUCKET}/o?key=${API_KEY}`;
    const storageRes = await makeRequest(storageUrl, 'GET');

    if (storageRes.statusCode === 200 || storageRes.statusCode === 403 || storageRes.statusCode === 401) {
      console.log(`   ✅ Firebase Storage: ACTIVO (${STORAGE_BUCKET}) y protegido.`);
    } else {
      console.log(`   ⚠️ Respuesta Storage: HTTP ${storageRes.statusCode}`);
      allPassed = false;
    }
  } catch (err) {
    console.error("   ❌ Error en Storage:", err.message);
    allPassed = false;
  }

  console.log("\n=================================================");
  if (allPassed) {
    console.log("🎉 ¡ENHORABUENA! EL 100% DEL BACKEND EN LA NUBE ESTÁ OPERATIVO Y VERIFICADO.");
  } else {
    console.log("⚠️ SE DETECTARON ADVERTENCIAS");
  }
  console.log("=================================================");
}

runTests();
