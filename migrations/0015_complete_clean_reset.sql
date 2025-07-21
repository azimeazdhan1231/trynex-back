
-- Complete clean reset - drop everything and recreate
DROP SCHEMA IF EXISTS drizzle CASCADE;
DROP TABLE IF EXISTS cart_items_v2 CASCADE;
DROP TABLE IF EXISTS carts CASCADE;
DROP TABLE IF EXISTS custom_designs CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS promos CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Create schema
CREATE SCHEMA IF NOT EXISTS drizzle;

-- Create __drizzle_migrations table
CREATE TABLE IF NOT EXISTS drizzle.__drizzle_migrations (
  id SERIAL PRIMARY KEY,
  hash text NOT NULL,
  created_at bigint
);

-- Create products table (matches schema.ts exactly)
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  namebn VARCHAR(255),
  description TEXT,
  descriptionbn TEXT,
  price NUMERIC(10,2) NOT NULL,
  image VARCHAR(500),
  gallery JSON,
  category VARCHAR(100),
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  icon TEXT DEFAULT '',
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create orders table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_id TEXT NOT NULL UNIQUE,
  customer_name TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  customer_address TEXT NOT NULL,
  items JSON NOT NULL,
  total TEXT NOT NULL,
  payment_method TEXT NOT NULL,
  order_status TEXT DEFAULT 'pending',
  payment_status TEXT DEFAULT 'pending',
  district TEXT,
  thana TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create contact_messages table
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create custom_designs table
CREATE TABLE custom_designs (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  design_data JSON NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create promos table
CREATE TABLE promos (
  id SERIAL PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  title TEXT NOT NULL,
  titlebn TEXT NOT NULL,
  discount_type TEXT NOT NULL,
  discount_value TEXT NOT NULL,
  min_order_amount TEXT DEFAULT '0',
  max_discount TEXT DEFAULT '',
  valid_from TIMESTAMP DEFAULT NOW(),
  valid_until TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  usage_limit INTEGER DEFAULT 0,
  usage_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create carts table
CREATE TABLE carts (
  id SERIAL PRIMARY KEY,
  session_id VARCHAR(255) NOT NULL UNIQUE,
  delivery_zone VARCHAR(50) DEFAULT 'dhaka',
  payment_method VARCHAR(50) DEFAULT 'bkash',
  promo_code VARCHAR(50),
  promo_discount INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create cart_items_v2 table
CREATE TABLE cart_items_v2 (
  id SERIAL PRIMARY KEY,
  cart_id INTEGER REFERENCES carts(id) ON DELETE CASCADE,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON categories(slug);
CREATE INDEX IF NOT EXISTS idx_orders_order_id ON orders(order_id);
CREATE INDEX IF NOT EXISTS idx_carts_session_id ON carts(session_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items_v2(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items_v2(product_id);

-- Enable RLS (Row Level Security)
ALTER TABLE carts ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items_v2 ENABLE ROW LEVEL SECURITY;

-- Create policies for carts (allow all for now)
CREATE POLICY "Allow all operations on carts" ON carts FOR ALL USING (true);
CREATE POLICY "Allow all operations on cart_items" ON cart_items_v2 FOR ALL USING (true);
