const express = require('express');
const router = express.Router();
const db = require('../db');
const { verifyPayload } = require('../utils/qr');

// POST /api/redemptions/validate { scanned_payload, signature, staff_api_key }
router.post('/validate', async (req, res) => {
  const { scanned_payload, signature, staff_api_key } = req.body;
  if (!scanned_payload || !signature || !staff_api_key) return res.status(400).json({ error: 'missing_fields' });

  try {
    // Validate staff key
    const staff = await db('staff').where({ staff_api_key }).first();
    if (!staff) return res.status(403).json({ error: 'unauthorized_staff' });

    // Verify signature
    const ok = verifyPayload(scanned_payload, signature);
    if (!ok) return res.status(400).json({ error: 'invalid_signature' });

    const payload = JSON.parse(scanned_payload);
    const redemption = await db('redemptions').where({ id: payload.redemption_id }).first();
    if (!redemption) return res.status(404).json({ error: 'redemption_not_found' });
    if (redemption.status !== 'issued') return res.status(400).json({ error: 'already_redeemed_or_invalid' });

    // Mark redeemed
    await db('redemptions').where({ id: redemption.id }).update({
      status: 'redeemed',
      redeemed_at: db.fn.now()
    });

    res.json({ ok: true, redemption_id: redemption.id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'validation_failed' });
  }
});

module.exports = router;