
-- Add missing columns to products table
ALTER TABLE "products" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();

-- Add missing columns to categories table
ALTER TABLE "categories" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();

-- Add missing columns to orders table
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "order_status" text DEFAULT 'pending';
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "payment_status" text DEFAULT 'pending';
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();

-- Add missing columns to cart_items table
ALTER TABLE "cart_items" ADD COLUMN IF NOT EXISTS "quantity" integer DEFAULT 1;
ALTER TABLE "cart_items" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();

-- Add missing columns to custom_designs table
ALTER TABLE "custom_designs" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();

-- Add missing columns to promos table
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "min_order_amount" text DEFAULT '0';
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "max_discount" text DEFAULT '';
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "valid_from" timestamp DEFAULT now();
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "valid_until" timestamp;
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "is_active" boolean DEFAULT true;
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "usage_limit" integer DEFAULT 0;
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "usage_count" integer DEFAULT 0;
ALTER TABLE "promos" ADD COLUMN IF NOT EXISTS "updated_at" timestamp DEFAULT now();
