
-- Complete database reset with proper foreign key handling
-- Drop all tables in correct order to avoid constraint issues
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS custom_designs CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS promos CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Recreate products table first (referenced by other tables)
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL,
  description TEXT NOT NULL,
  descriptionbn TEXT NOT NULL,
  price TEXT NOT NULL,
  category TEXT NOT NULL,
  image TEXT DEFAULT '',
  gallery JSON DEFAULT '[]',
  is_featured BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  icon TEXT DEFAULT '',
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate orders table
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
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate contact_messages table
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT now()
);

-- Recreate cart_items table with proper foreign key
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER DEFAULT 1,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate custom_designs table with proper foreign key
CREATE TABLE custom_designs (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
  design_data JSON NOT NULL,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Recreate promos table
CREATE TABLE promos (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  titlebn TEXT NOT NULL,
  discount_type TEXT NOT NULL,
  discount_value TEXT NOT NULL,
  min_order_amount TEXT DEFAULT '0',
  max_discount TEXT DEFAULT '',
  valid_from TIMESTAMP DEFAULT now(),
  valid_until TIMESTAMP,
  is_active BOOLEAN DEFAULT true,
  usage_limit INTEGER DEFAULT 0,
  usage_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Insert some sample data to ensure everything works
INSERT INTO categories (name, namebn, slug, description, icon, sort_order) VALUES
('Custom T-Shirts', 'কাস্টম টি-শার্ট', 'custom-t-shirts', 'High-quality custom printed t-shirts', '👕', 1),
('Photo Frames', 'ফটো ফ্রেম', 'photo-frames', 'Custom photo frames for memories', '🖼️', 2),
('Mugs', 'মগ', 'mugs', 'Personalized coffee mugs', '☕', 3);

INSERT INTO products (name, namebn, description, descriptionbn, price, category, image, gallery, is_featured, stock) VALUES
('Custom T-Shirt', 'কাস্টম টি-শার্ট', 'High quality custom printed t-shirt', 'উচ্চ মানের কাস্টম প্রিন্টেড টি-শার্ট', '৳500', 'custom-t-shirts', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400', '["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400"]', true, 100),
('Photo Frame', 'ফটো ফ্রেম', 'Beautiful custom photo frame', 'সুন্দর কাস্টম ফটো ফ্রেম', '৳300', 'photo-frames', 'https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400', '["https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400"]', true, 50),
('Custom Mug', 'কাস্টম মগ', 'Personalized coffee mug', 'ব্যক্তিগতকৃত কফি মগ', '৳250', 'mugs', 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400', '["https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400"]', false, 75);
