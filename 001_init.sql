-- Inicialización de tablas básicas para Losky Factory

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  email TEXT UNIQUE,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS staff (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT,
  role TEXT,
  store_id TEXT,
  staff_api_key TEXT UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS purchases (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  store_id TEXT,
  ticket_code TEXT UNIQUE,
  amount NUMERIC,
  items_summary TEXT,
  registered_by uuid REFERENCES staff(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS loyalty_balances (
  user_id uuid PRIMARY KEY REFERENCES users(id),
  balance INTEGER DEFAULT 0,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TYPE reward_type AS ENUM ('qr_coupon','physical','discount');

CREATE TABLE IF NOT EXISTS rewards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT,
  description TEXT,
  type reward_type,
  required_benefits INTEGER DEFAULT 1,
  stock INTEGER DEFAULT 0,
  value TEXT,
  expires_at TIMESTAMP WITH TIME ZONE,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TYPE redemption_status AS ENUM ('issued','redeemed','cancelled');

CREATE TABLE IF NOT EXISTS redemptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id),
  reward_id uuid REFERENCES rewards(id),
  status redemption_status DEFAULT 'issued',
  issued_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  redeemed_at TIMESTAMP WITH TIME ZONE,
  code TEXT UNIQUE,
  qr_payload TEXT
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  entity TEXT,
  action TEXT,
  actor_id uuid,
  payload JSONB,
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT now()
);