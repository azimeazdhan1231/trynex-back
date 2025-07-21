
-- Add missing columns to promos table
ALTER TABLE promos ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT NOW();

-- Ensure all tables have the correct structure
-- This migration will be idempotent due to IF NOT EXISTS clauses
