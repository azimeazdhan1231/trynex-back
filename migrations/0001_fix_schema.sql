
-- Fix any column naming issues
ALTER TABLE products RENAME COLUMN featured TO is_featured;

-- Ensure all required columns exist
ALTER TABLE products ADD COLUMN IF NOT EXISTS is_customizable BOOLEAN DEFAULT false;
ALTER TABLE products ADD COLUMN IF NOT EXISTS original_price DECIMAL(10,2);
ALTER TABLE products ADD COLUMN IF NOT EXISTS subcategory TEXT;
ALTER TABLE products ADD COLUMN IF NOT EXISTS tags JSONB DEFAULT '[]';
ALTER TABLE products ADD COLUMN IF NOT EXISTS stock_quantity INTEGER DEFAULT 0;

-- Fix any data type issues
ALTER TABLE products ALTER COLUMN images SET DEFAULT '[]';
ALTER TABLE products ALTER COLUMN tags SET DEFAULT '[]';
