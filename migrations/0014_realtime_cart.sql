
-- Create carts table
CREATE TABLE IF NOT EXISTS carts (
  id SERIAL PRIMARY KEY,
  session_id VARCHAR(255) NOT NULL UNIQUE,
  delivery_zone VARCHAR(50) DEFAULT 'dhaka',
  payment_method VARCHAR(50) DEFAULT 'bkash',
  promo_code VARCHAR(50),
  promo_discount INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create cart_items_v2 table (new table to avoid conflicts)
CREATE TABLE IF NOT EXISTS cart_items_v2 (
  id SERIAL PRIMARY KEY,
  cart_id INTEGER REFERENCES carts(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_carts_session_id ON carts(session_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items_v2(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items_v2(product_id);

-- Enable RLS (Row Level Security) for multi-tenancy
ALTER TABLE carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items_v2 ENABLE ROW LEVEL SECURITY;

-- Create policies for carts
CREATE POLICY "Users can view own cart" ON carts FOR SELECT USING (true);
CREATE POLICY "Users can insert own cart" ON carts FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update own cart" ON carts FOR UPDATE USING (true);
CREATE POLICY "Users can delete own cart" ON carts FOR DELETE USING (true);

-- Create policies for cart_items_v2
CREATE POLICY "Users can view own cart items" ON cart_items_v2 FOR SELECT USING (true);
CREATE POLICY "Users can insert own cart items" ON cart_items_v2 FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update own cart items" ON cart_items_v2 FOR UPDATE USING (true);
CREATE POLICY "Users can delete own cart items" ON cart_items_v2 FOR DELETE USING (true);
