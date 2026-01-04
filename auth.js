const express = require('express');
const router = express.Router();
const db = require('../db');
const { v4: uuidv4 } = require('uuid');

// POST /api/auth/register { name, email, phone }
router.post('/register', async (req, res) => {
  const { name, email, phone } = req.body;
  if (!email) return res.status(400).json({ error: 'email required' });
  try {
    const [user] = await db('users').insert({ name, email, phone }).returning('*');
    // initialize balance
    await db('loyalty_balances').insert({ user_id: user.id, balance: 0 });
    res.json({ user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'registration_failed' });
  }
});

// POST /api/auth/login { email }
router.post('/login', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: 'email required' });
  try {
    const user = await db('users').where({ email }).first();
    if (!user) return res.status(404).json({ error: 'not_found' });
    // Simplified: return user object (no tokens). In production, devuelve JWT.
    const balance = await db('loyalty_balances').where({ user_id: user.id }).first();
    res.json({ user, balance: balance ? balance.balance : 0 });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'login_failed' });
  }
});

module.exports = router;