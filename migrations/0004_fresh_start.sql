
-- Fresh start migration with correct column names
CREATE TABLE IF NOT EXISTS "products" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "namebn" text NOT NULL,
  "description" text NOT NULL,
  "descriptionbn" text NOT NULL,
  "price" numeric(10,2) NOT NULL,
  "original_price" numeric(10,2),
  "category" text NOT NULL,
  "subcategory" text,
  "images" jsonb NOT NULL DEFAULT '[]'::jsonb,
  "tags" jsonb DEFAULT '[]'::jsonb,
  "in_stock" boolean NOT NULL DEFAULT true,
  "stock_quantity" integer DEFAULT 0,
  "is_featured" boolean DEFAULT false,
  "is_customizable" boolean DEFAULT false,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "categories" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "namebn" text NOT NULL,
  "slug" text NOT NULL UNIQUE,
  "description" text,
  "descriptionbn" text,
  "icon" text,
  "is_active" boolean DEFAULT true,
  "sort_order" integer DEFAULT 0,
  "created_at" timestamp DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "cart_items" (
  "id" serial PRIMARY KEY NOT NULL,
  "session_id" text NOT NULL,
  "product_id" integer NOT NULL,
  "quantity" integer NOT NULL DEFAULT 1,
  "custom_design" jsonb,
  "created_at" timestamp DEFAULT now(),
  CONSTRAINT "cart_items_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "orders" (
  "id" serial PRIMARY KEY NOT NULL,
  "order_id" text NOT NULL UNIQUE,
  "customer_name" text NOT NULL,
  "customer_phone" text NOT NULL,
  "customer_email" text,
  "customer_address" jsonb NOT NULL,
  "items" jsonb NOT NULL,
  "subtotal" numeric(10,2) NOT NULL,
  "delivery_fee" numeric(10,2) NOT NULL DEFAULT '120',
  "total" numeric(10,2) NOT NULL,
  "payment_method" text NOT NULL,
  "payment_status" text NOT NULL DEFAULT 'pending',
  "order_status" text NOT NULL DEFAULT 'pending',
  "notes" text,
  "created_at" timestamp DEFAULT now(),
  "updated_at" timestamp DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "contact_messages" (
  "id" serial PRIMARY KEY NOT NULL,
  "name" text NOT NULL,
  "email" text NOT NULL,
  "phone" text,
  "message" text NOT NULL,
  "status" text NOT NULL DEFAULT 'unread',
  "created_at" timestamp DEFAULT now()
);

CREATE TABLE IF NOT EXISTS "custom_designs" (
  "id" serial PRIMARY KEY NOT NULL,
  "session_id" text NOT NULL,
  "product_id" integer NOT NULL,
  "design_data" jsonb NOT NULL,
  "preview_url" text,
  "created_at" timestamp DEFAULT now(),
  CONSTRAINT "custom_designs_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "promos" (
  "id" serial PRIMARY KEY NOT NULL,
  "code" text NOT NULL UNIQUE,
  "title" text NOT NULL,
  "titlebn" text NOT NULL,
  "description" text,
  "discount_type" text NOT NULL,
  "discount_value" numeric(10,2) NOT NULL,
  "min_order_amount" numeric(10,2),
  "is_active" boolean DEFAULT true,
  "start_date" timestamp,
  "end_date" timestamp,
  "usage_limit" integer,
  "usage_count" integer DEFAULT 0,
  "created_at" timestamp DEFAULT now()
);
