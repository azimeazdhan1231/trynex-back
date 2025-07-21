
-- Add price column to cart_items table
ALTER TABLE cart_items ADD COLUMN IF NOT EXISTS price TEXT NOT NULL DEFAULT '0';
