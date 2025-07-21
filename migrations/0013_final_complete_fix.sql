
-- Complete database reset and fix
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS custom_designs CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS promos CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Create categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL DEFAULT '',
  slug TEXT NOT NULL UNIQUE,
  description TEXT DEFAULT '',
  icon TEXT DEFAULT '',
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Create products table with all required columns
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL,
  descriptionbn TEXT NOT NULL DEFAULT '',
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

-- Create orders table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_id TEXT NOT NULL UNIQUE,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  shipping_address TEXT NOT NULL,
  items JSON NOT NULL DEFAULT '[]',
  total_amount TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  payment_method TEXT DEFAULT 'cash_on_delivery',
  payment_status TEXT DEFAULT 'pending',
  notes TEXT DEFAULT '',
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Create cart_items table
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  custom_design TEXT DEFAULT '',
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create contact_messages table
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  status TEXT DEFAULT 'unread',
  created_at TIMESTAMP DEFAULT now()
);

-- Create custom_designs table
CREATE TABLE custom_designs (
  id SERIAL PRIMARY KEY,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  product_type TEXT NOT NULL,
  design_description TEXT NOT NULL,
  design_files JSON DEFAULT '[]',
  additional_notes TEXT DEFAULT '',
  estimated_price TEXT DEFAULT '',
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Create promos table
CREATE TABLE promos (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  titlebn TEXT NOT NULL DEFAULT '',
  description TEXT DEFAULT '',
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

-- Insert sample categories
INSERT INTO categories (name, namebn, slug, description, icon, sort_order) VALUES
('T-Shirts', 'টি-শার্ট', 't-shirts', 'Custom printed t-shirts', '👕', 1),
('Mugs', 'মগ', 'mugs', 'Personalized mugs and cups', '☕', 2),
('Phone Cases', 'ফোন কেস', 'phone-cases', 'Custom phone cases', '📱', 3),
('Bags', 'ব্যাগ', 'bags', 'Custom bags and totes', '👜', 4),
('Caps & Hats', 'ক্যাপ ও হ্যাট', 'caps-hats', 'Custom caps and hats', '🧢', 5);

-- Insert sample products
INSERT INTO products (name, namebn, description, descriptionbn, price, category, image, gallery, is_featured, is_active, stock) VALUES
('Custom T-Shirt', 'কাস্টম টি-শার্ট', 'High-quality cotton t-shirt perfect for custom designs', 'কাস্টম ডিজাইনের জন্য উচ্চমানের কটন টি-শার্ট', '599', 'T-Shirts', 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', '["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500"]', true, true, 50),
('Custom Mug', 'কাস্টম মগ', 'Ceramic mug perfect for personalized gifts', 'ব্যক্তিগতকৃত উপহারের জন্য সিরামিক মগ', '299', 'Mugs', 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500', '["https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500"]', true, true, 30),
('Custom Phone Case', 'কাস্টম ফোন কেস', 'Protective phone case with custom design options', 'কাস্টম ডিজাইন অপশন সহ সুরক্ষামূলক ফোন কেস', '399', 'Phone Cases', 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500', '["https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500"]', false, true, 25);

-- Insert sample promos
INSERT INTO promos (code, title, titlebn, description, discount_type, discount_value, min_order_amount, is_active) VALUES
('WELCOME10', 'Welcome Discount', 'স্বাগতম ছাড়', '10% off for new customers', 'percentage', '10', '500', true),
('SAVE50', 'Save 50 Taka', '৫০ টাকা সাশ্রয়', 'Flat 50 taka off', 'fixed', '50', '300', true);
