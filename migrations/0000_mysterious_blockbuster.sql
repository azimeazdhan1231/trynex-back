
-- Create products table
CREATE TABLE IF NOT EXISTS "products" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" varchar(255) NOT NULL,
  "namebn" varchar(255) NOT NULL,
  "price" decimal(10,2) NOT NULL,
  "pricebn" varchar(50) NOT NULL,
  "description" text,
  "descriptionbn" text,
  "image" varchar(500) NOT NULL,
  "category" varchar(100) NOT NULL,
  "in_stock" boolean DEFAULT true,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

-- Create cart_items table
CREATE TABLE IF NOT EXISTS "cart_items" (
  "id" serial PRIMARY KEY NOT NULL,
  "session_id" varchar(255) NOT NULL,
  "product_id" integer NOT NULL,
  "quantity" integer NOT NULL DEFAULT 1,
  "custom_design" jsonb,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

-- Create orders table
CREATE TABLE IF NOT EXISTS "orders" (
  "id" serial PRIMARY KEY NOT NULL,
  "order_id" varchar(255) UNIQUE NOT NULL,
  "customer_name" varchar(255) NOT NULL,
  "customer_phone" varchar(20) NOT NULL,
  "customer_email" varchar(255),
  "customer_address" text NOT NULL,
  "district" varchar(100) NOT NULL,
  "thana" varchar(100) NOT NULL,
  "delivery_fee" decimal(10,2) NOT NULL,
  "total_amount" decimal(10,2) NOT NULL,
  "payment_method" varchar(50) NOT NULL,
  "payment_number" varchar(20) NOT NULL,
  "payment_amount" decimal(10,2) NOT NULL,
  "status" varchar(50) DEFAULT 'pending',
  "items" jsonb NOT NULL,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

-- Create contact_messages table
CREATE TABLE IF NOT EXISTS "contact_messages" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" varchar(255) NOT NULL,
  "email" varchar(255) NOT NULL,
  "phone" varchar(20),
  "message" text NOT NULL,
  "status" varchar(50) DEFAULT 'unread',
  "created_at" timestamp DEFAULT now()
);

-- Create custom_designs table
CREATE TABLE IF NOT EXISTS "custom_designs" (
  "id" serial PRIMARY KEY NOT NULL,
  "session_id" varchar(255) NOT NULL,
  "product_id" integer NOT NULL,
  "design_data" jsonb NOT NULL,
  "preview_url" varchar(500),
  "created_at" timestamp DEFAULT now()
);

-- Create promos table
CREATE TABLE IF NOT EXISTS "promos" (
  "id" serial PRIMARY KEY NOT NULL,
  "code" varchar(50) UNIQUE NOT NULL,
  "title" varchar(255) NOT NULL,
  "titlebn" varchar(255) NOT NULL,
  "description" text,
  "discount_type" varchar(20) NOT NULL,
  "discount_value" decimal(10,2) NOT NULL,
  "min_order_amount" decimal(10,2),
  "is_active" boolean DEFAULT true,
  "start_date" timestamp,
  "end_date" timestamp,
  "usage_limit" integer,
  "usage_count" integer DEFAULT 0,
  "created_at" timestamp DEFAULT now()
);

-- Add foreign key constraints
ALTER TABLE "cart_items" ADD CONSTRAINT "cart_items_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE cascade ON UPDATE no action;

-- Insert sample products
INSERT INTO "products" ("name", "namebn", "price", "pricebn", "description", "descriptionbn", "image", "category", "in_stock") VALUES
('Custom Coffee Mug', 'কাস্টম কফি মগ', 299.00, '২৯৯', 'Beautiful personalized coffee mug perfect for gifts', 'উপহারের জন্য নিখুঁত সুন্দর ব্যক্তিগতকৃত কফি মগ', '/api/placeholder/300/300', 'Mugs', true),
('Water Tumbler', 'ওয়াটার টাম্বলার', 399.00, '৩৯৯', 'Insulated water tumbler with custom design', 'কাস্টম ডিজাইন সহ ইনসুলেটেড ওয়াটার টাম্বলার', '/api/placeholder/300/300', 'Drinkware', true),
('Custom T-Shirt', 'কাস্টম টি-শার্ট', 599.00, '৫৯৯', 'High quality cotton t-shirt with your design', 'আপনার ডিজাইন সহ উচ্চ মানের সুতির টি-শার্ট', '/api/placeholder/300/300', 'Apparel', true),
('Photo Frame', 'ফটো ফ্রেম', 199.00, '১৯৯', 'Elegant photo frame for your memories', 'আপনার স্মৃতির জন্য মার্জিত ফটো ফ্রেম', '/api/placeholder/300/300', 'Frames', true),
('Custom Wallet', 'কাস্টম ওয়ালেট', 799.00, '৭৯৯', 'Leather wallet with personalized design', 'ব্যক্তিগতকৃত ডিজাইন সহ চামড়ার ওয়ালেট', '/api/placeholder/300/300', 'Accessories', true),
('Greeting Card', 'গ্রিটিং কার্ড', 99.00, '৯৯', 'Beautiful custom greeting card', 'সুন্দর কাস্টম গ্রিটিং কার্ড', '/api/placeholder/300/300', 'Cards', true),
('Custom Pillow', 'কাস্টম বালিশ', 499.00, '৪৯৯', 'Soft pillow with your custom design', 'আপনার কাস্টম ডিজাইন সহ নরম বালিশ', '/api/placeholder/300/300', 'Home', true),
('Phone Case', 'ফোন কেস', 349.00, '৩৪৯', 'Protective phone case with custom design', 'কাস্টম ডিজাইন সহ সুরক্ষামূলক ফোন কেস', '/api/placeholder/300/300', 'Electronics', true),
('Custom Keychain', 'কাস্টম কিচেইন', 149.00, '১৪৯', 'Personalized keychain with your photo', 'আপনার ছবি সহ ব্যক্তিগতকৃত কিচেইন', '/api/placeholder/300/300', 'Accessories', true),
('Custom Calendar', 'কাস্টম ক্যালেন্ডার', 399.00, '৩৯৯', 'Personalized calendar with your photos', 'আপনার ছবি সহ ব্যক্তিগতকৃত ক্যালেন্ডার', '/api/placeholder/300/300', 'Stationery', true),
('Custom Notebook', 'কাস্টম নোটবুক', 249.00, '২৪৯', 'High quality notebook with custom cover', 'কাস্টম কভার সহ উচ্চ মানের নোটবুক', '/api/placeholder/300/300', 'Stationery', true),
('Custom Mousepad', 'কাস্টম মাউসপ্যাড', 199.00, '১৯৯', 'Gaming mousepad with your design', 'আপনার ডিজাইন সহ গেমিং মাউসপ্যাড', '/api/placeholder/300/300', 'Electronics', true),
('Custom Hoodie', 'কাস্টম হুডি', 899.00, '৮৯৯', 'Comfortable hoodie with custom print', 'কাস্টম প্রিন্ট সহ আরামদায়ক হুডি', '/api/placeholder/300/300', 'Apparel', true),
('Custom Badge', 'কাস্টম ব্যাজ', 79.00, '৭৯', 'Professional badge with your design', 'আপনার ডিজাইন সহ পেশাদার ব্যাজ', '/api/placeholder/300/300', 'Accessories', true),
('Custom Sticker Pack', 'কাস্টম স্টিকার প্যাক', 129.00, '১২৯', 'Set of custom stickers', 'কাস্টম স্টিকারের সেট', '/api/placeholder/300/300', 'Stationery', true),
('Custom Bottle', 'কাস্টম বোতল', 449.00, '৪৪৯', 'Stainless steel bottle with custom design', 'কাস্টম ডিজাইন সহ স্টেইনলেস স্টিল বোতল', '/api/placeholder/300/300', 'Drinkware', true);

-- Insert sample promos
INSERT INTO "promos" ("code", "title", "titlebn", "description", "discount_type", "discount_value", "min_order_amount", "is_active", "usage_limit") VALUES
('WELCOME20', 'Welcome Discount', 'স্বাগত ছাড়', 'Get 20% off on your first order', 'percentage', 20.00, 500.00, true, 100),
('SAVE100', 'Save 100 Taka', '১০০ টাকা সাশ্রয়', 'Get 100 taka off on orders above 1000', 'fixed', 100.00, 1000.00, true, 50),
('FREESHIP', 'Free Shipping', 'ফ্রি শিপিং', 'Free shipping on all orders', 'shipping', 0.00, 0.00, true, 1000);
