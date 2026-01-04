const crypto = require('crypto');
const HMAC_SECRET = process.env.HMAC_SECRET || 'secret_change_me';

function signPayload(payload) {
  const json = JSON.stringify(payload);
  const hmac = crypto.createHmac('sha256', HMAC_SECRET).update(json).digest('hex');
  return { payload: json, signature: hmac };
}

function verifyPayload(payloadJson, signature) {
  const hmac = crypto.createHmac('sha256', HMAC_SECRET).update(payloadJson).digest('hex');
  return hmac === signature;
}

module.exports = { signPayload, verifyPayload };