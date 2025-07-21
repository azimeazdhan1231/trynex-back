
-- Drop and recreate all tables with correct schema
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS custom_designs CASCADE;
DROP TABLE IF EXISTS promos CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- Create categories table
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  icon TEXT,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0
);

-- Create products table
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  namebn TEXT NOT NULL,
  description TEXT NOT NULL,
  descriptionbn TEXT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  original_price DECIMAL(10,2),
  category TEXT NOT NULL,
  subcategory TEXT,
  images JSONB NOT NULL DEFAULT '[]',
  tags JSONB DEFAULT '[]',
  in_stock BOOLEAN NOT NULL DEFAULT true,
  stock_quantity INTEGER DEFAULT 0,
  is_featured BOOLEAN DEFAULT false,
  is_customizable BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Create cart_items table
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL DEFAULT 1,
  custom_design JSONB,
  created_at TIMESTAMP DEFAULT now()
);

-- Create orders table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  order_id TEXT NOT NULL UNIQUE,
  customer_name TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  customer_email TEXT,
  customer_address JSONB NOT NULL,
  items JSONB NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 120,
  total DECIMAL(10,2) NOT NULL,
  payment_method TEXT NOT NULL,
  payment_status TEXT NOT NULL DEFAULT 'pending',
  order_status TEXT NOT NULL DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now()
);

-- Create contact_messages table
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  message TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'unread',
  created_at TIMESTAMP DEFAULT now()
);

-- Create custom_designs table
CREATE TABLE custom_designs (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL,
  product_id INTEGER NOT NULL REFERENCES products(id),
  design_data JSONB NOT NULL,
  preview_url TEXT,
  created_at TIMESTAMP DEFAULT now()
);

-- Create promos table
CREATE TABLE promos (
  id SERIAL PRIMARY KEY,
  code TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  titlebn TEXT NOT NULL,
  description TEXT,
  discount_type TEXT NOT NULL,
  discount_value DECIMAL(10,2) NOT NULL,
  min_order_amount DECIMAL(10,2),
  is_active BOOLEAN DEFAULT true,
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  usage_limit INTEGER,
  usage_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT now()
);

-- Insert sample categories
INSERT INTO categories (name, namebn, slug, description, icon, sort_order) VALUES
('T-Shirts', 'টি-শার্ট', 't-shirts', 'Custom printed t-shirts', '👕', 1),
('Mugs', 'মগ', 'mugs', 'Personalized mugs and cups', '☕', 2),
('Bags', 'ব্যাগ', 'bags', 'Custom bags and totes', '👜', 3),
('Caps & Hats', 'ক্যাপ ও হ্যাট', 'caps-hats', 'Custom caps and hats', '🧢', 4),
('Phone Cases', 'ফোন কেস', 'phone-cases', 'Custom phone cases', '📱', 5),
('Canvas Prints', 'ক্যানভাস প্রিন্ট', 'canvas-prints', 'Custom canvas artwork', '🖼️', 6);

-- Insert sample products
INSERT INTO products (name, namebn, description, descriptionbn, price, category, images, stock_quantity, is_featured, is_customizable) VALUES
('Custom T-Shirt', 'কাস্টম টি-শার্ট', 'High-quality cotton t-shirt with your custom design', 'আপনার কাস্টম ডিজাইন সহ উচ্চ মানের সুতির টি-শার্ট', 350.00, 'T-Shirts', '["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab"]', 100, true, true),
('Custom Mug', 'কাস্টম মগ', 'Ceramic mug with personalized print', 'ব্যক্তিগত প্রিন্ট সহ সিরামিক মগ', 250.00, 'Mugs', '["https://images.unsplash.com/photo-1544787219-7f47ccb76574"]', 50, true, true),
('Custom Tote Bag', 'কাস্টম টোট ব্যাগ', 'Eco-friendly canvas tote bag', 'পরিবেশ বান্ধব ক্যানভাস টোট ব্যাগ', 400.00, 'Bags', '["https://images.unsplash.com/photo-1553062407-98eeb64c6a62"]', 75, false, true);
