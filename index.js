const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
require('dotenv').config();

const db = require('./db');
const authRoutes = require('./routes/auth');
const purchasesRoutes = require('./routes/purchases');
const rewardsRoutes = require('./routes/rewards');
const redemptionsRoutes = require('./routes/redemptions');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Health
app.get('/health', (req, res) => res.json({ ok: true }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/purchases', purchasesRoutes);
app.use('/api/rewards', rewardsRoutes);
app.use('/api/redemptions', redemptionsRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend listening on ${PORT}`);
});