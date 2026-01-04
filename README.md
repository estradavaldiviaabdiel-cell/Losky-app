# Flutter app — Losky Factory (scaffold)

Este es un cliente Flutter minimal para iOS y Android. Implementa:
- Registro / login simplificado (email).
- Home con balance actual.
- Catálogo de recompensas (GET /api/rewards).
- Redimir recompensa -> la app solicita al backend y recibe la `qr_payload` (payload + signature) que muestra como QR.

Para probar:
1. Configura la URL del backend en `lib/services/api.dart` (variable `BASE_URL`).
2. Ejecuta la app: `flutter run`.

Nota: la app incluye un modo "Cajero" en el menú (ingresa `staff_api_key` en settings) para poder validar QR (en este scaffold la validación se simula enviando el payload y signature al endpoint de validación).