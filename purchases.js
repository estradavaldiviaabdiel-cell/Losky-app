const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/purchases { ticket_code, amount, items_summary, user_id?, registered_by? }
router.post('/', async (req, res) => {
  const { ticket_code, amount, items_summary, user_id, registered_by } = req.body;
  if (!ticket_code) return res.status(400).json({ error: 'ticket_code required' });

  try {
    // Verify uniqueness
    const exists = await db('purchases').where({ ticket_code }).first();
    if (exists) return res.status(400).json({ error: 'duplicate_ticket' });

    const [purchase] = await db('purchases').insert({
      user_id: user_id || null,
      ticket_code,
      amount: amount || 0,
      items_summary: items_summary || null,
      registered_by: registered_by || null
    }).returning('*');

    // Award +1 benefit if user_id provided
    if (user_id) {
      const balanceRow = await db('loyalty_balances').where({ user_id }).first();
      if (balanceRow) {
        await db('loyalty_balances').where({ user_id }).update({
          balance: balanceRow.balance + 1,
          last_updated: db.fn.now()
        });
      } else {
        await db('loyalty_balances').insert({ user_id, balance: 1 });
      }
    }

    res.json({ purchase });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'purchase_failed' });
  }
});

module.exports = router;