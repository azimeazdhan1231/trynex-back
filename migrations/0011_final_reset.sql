
-- Drop all tables if they exist
DROP TABLE IF EXISTS custom_designs;
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS promos;
DROP TABLE IF EXISTS products;

-- Create products table with correct schema
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price NUMERIC(10,2) NOT NULL,
  image VARCHAR(500),
  category VARCHAR(100),
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create promos table
CREATE TABLE promos (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  discount_percentage INTEGER,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(255) NOT NULL,
  customer_email VARCHAR(255) NOT NULL,
  customer_phone VARCHAR(50),
  shipping_address TEXT NOT NULL,
  total_amount NUMERIC(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create cart_items table
CREATE TABLE cart_items (
  id SERIAL PRIMARY KEY,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  session_id VARCHAR(255),
  order_id INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Create contact_messages table
CREATE TABLE contact_messages (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create custom_designs table
CREATE TABLE custom_designs (
  id SERIAL PRIMARY KEY,
  session_id VARCHAR(255) NOT NULL,
  product_id INTEGER NOT NULL,
  design_data JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert sample products with correct column names
INSERT INTO products (name, description, price, image, category, is_featured) VALUES
('Premium T-Shirt', 'High-quality cotton t-shirt with custom design options', 25.99, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500', 'clothing', true),
('Custom Hoodie', 'Comfortable hoodie with personalized printing', 45.99, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500', 'clothing', true),
('Designer Mug', 'Ceramic mug perfect for custom designs', 12.99, 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500', 'accessories', false),
('Canvas Tote Bag', 'Eco-friendly canvas bag for everyday use', 18.99, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500', 'accessories', true),
('Phone Case', 'Protective phone case with custom design support', 22.99, 'https://images.unsplash.com/photo-1601593346740-925612772716?w=500', 'accessories', false),
('Sticker Pack', 'High-quality vinyl stickers set', 8.99, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500', 'accessories', false);

-- Insert sample promos
INSERT INTO promos (title, description, discount_percentage, is_active) VALUES
('Summer Sale', 'Get 20% off on all summer collection items', 20, true),
('First Purchase', 'Special 15% discount for new customers', 15, true);
