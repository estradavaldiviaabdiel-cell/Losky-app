const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');
const { signPayload } = require('../utils/qr');

// GET /api/rewards
router.get('/', async (req, res) => {
  try {
    const rewards = await db('rewards').where({ active: true });
    res.json({ rewards });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'list_failed' });
  }
});

// POST /api/rewards/:id/redeem { user_id, registered_by? }
router.post('/:id/redeem', async (req, res) => {
  const rewardId = req.params.id;
  const { user_id } = req.body;
  if (!user_id) return res.status(400).json({ error: 'user_id required' });

  try {
    const reward = await db('rewards').where({ id: rewardId }).first();
    if (!reward || !reward.active) return res.status(404).json({ error: 'reward_not_found' });
    if (reward.stock <= 0) return res.status(400).json({ error: 'out_of_stock' });

    // Check user balance
    const balanceRow = await db('loyalty_balances').where({ user_id }).first();
    const balance = balanceRow ? balanceRow.balance : 0;
    if (balance < reward.required_benefits) return res.status(400).json({ error: 'insufficient_benefits' });

    // Consume benefits
    await db('loyalty_balances').where({ user_id }).update({
      balance: balance - reward.required_benefits,
      last_updated: db.fn.now()
    });

    // Create redemption
    const code = uuidv4();
    const payloadObj = { redemption_id: null, code, reward_id: rewardId, issued_at: new Date().toISOString() };
    // we will insert to get id
    const [redemption] = await db('redemptions').insert({
      user_id,
      reward_id: rewardId,
      code,
      qr_payload: '' // placeholder
    }).returning('*');

    payloadObj.redemption_id = redemption.id;
    const signed = signPayload(payloadObj);
    await db('redemptions').where({ id: redemption.id }).update({ qr_payload: JSON.stringify(signed) });

    // Decrement stock
    await db('rewards').where({ id: rewardId }).update({ stock: reward.stock - 1 });

    const updated = await db('redemptions').where({ id: redemption.id }).first();
    res.json({ redemption: updated });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'redeem_failed' });
  }
});

module.exports = router;