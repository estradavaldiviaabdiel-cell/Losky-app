# Notas importantes

- Los cupones NO caducan por ahora (según tu indicación). El backend genera `issued_at` pero no aplica `exp`.
- Para validación segura del QR, la app de cajero debe extraer `payload` y `signature` del QR (en este scaffold el QR contiene ambos en JSON) y llamar a `/api/redemptions/validate`.
- La tabla `staff` espera que insertes un `staff_api_key` para un cajero (puedes insertarlo manualmente en la DB para pruebas).
- El scaffold usa verificación mínima. Antes de producción:
  - Añadir JWT y sesiones.
  - Forzar HTTPS y variables de entorno seguras.
  - Implementar rate limiting y monitoreo de fraudes.
- Colores base sugeridos (blanco + verde bajito):
  - Blanco: #FFFFFF
  - Verde bajito (tarjetas): #E6F7EA
  - Verde CTA: #A8D9B0
  - Texto oscuro: #0A0A0A
