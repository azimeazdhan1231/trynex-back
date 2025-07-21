import { pgTable, text, integer, boolean, timestamp, json, serial, varchar, numeric, decimal } from "drizzle-orm/pg-core";
import { z } from "zod";

export const products = pgTable("products", {
  id: serial("id").primaryKey(),
  name: varchar("name", { length: 255 }).notNull(),
  namebn: varchar("namebn", { length: 255 }),
  description: text("description"),
  descriptionbn: text("descriptionbn"),
  price: numeric("price", { precision: 10, scale: 2 }).notNull(),
  image: varchar("image", { length: 500 }),
  gallery: json("gallery").$type<string[]>(),
  category: varchar("category", { length: 100 }),
  is_featured: boolean("is_featured").default(false),
  is_active: boolean("is_active").default(true),
  stock: integer("stock").default(0),
  created_at: timestamp("created_at").defaultNow(),
  updated_at: timestamp("updated_at").defaultNow(),
});

export const categories = pgTable("categories", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  namebn: text("namebn").notNull(),
  slug: text("slug").notNull().unique(),
  description: text("description").default(""),
  icon: text("icon").default(""),
  isActive: boolean("is_active").default(true),
  sortOrder: integer("sort_order").default(0),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow()
});

export const orders = pgTable("orders", {
  id: serial("id").primaryKey(),
  orderId: text("order_id").notNull().unique(),
  customerName: text("customer_name").notNull(),
  customerPhone: text("customer_phone").notNull(),
  customerAddress: text("customer_address").notNull(),
  items: json("items").notNull(),
  total: text("total").notNull(),
  paymentMethod: text("payment_method").notNull(),
  orderStatus: text("order_status").default("pending"),
  paymentStatus: text("payment_status").default("pending"),
  district: text("district"),
  thana: text("thana"),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow()
});

export const contactMessages = pgTable("contact_messages", {
  id: serial("id").primaryKey(),
  name: text("name").notNull(),
  email: text("email").notNull(),
  message: text("message").notNull(),
  isRead: boolean("is_read").default(false),
  createdAt: timestamp("created_at").defaultNow()
});

export const customDesigns = pgTable("custom_designs", {
  id: serial("id").primaryKey(),
  sessionId: text("session_id").notNull(),
  productId: integer("product_id").references(() => products.id, { onDelete: "cascade" }),
  designData: json("design_data").notNull(),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow()
});

export const promos = pgTable('promos', {
  id: serial('id').primaryKey(),
  code: varchar('code', { length: 50 }).notNull().unique(),
  title: text("title").notNull(),
  titlebn: text("titlebn").notNull(),
  discountType: text("discount_type").notNull(),
  discountValue: text("discount_value").notNull(),
  minOrderAmount: text("min_order_amount").default("0"),
  maxDiscount: text("max_discount").default(""),
  validFrom: timestamp("valid_from").defaultNow(),
  validUntil: timestamp("valid_until"),
  isActive: boolean("is_active").default(true),
  usageLimit: integer("usage_limit").default(0),
  usageCount: integer("usage_count").default(0),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow()
});

export const carts = pgTable('carts', {
  id: serial('id').primaryKey(),
  sessionId: varchar('session_id', { length: 255 }).notNull().unique(),
  deliveryZone: varchar('delivery_zone', { length: 50 }).default('dhaka'),
  paymentMethod: varchar('payment_method', { length: 50 }).default('bkash'),
  promoCode: varchar('promo_code', { length: 50 }),
  promoDiscount: integer('promo_discount').default(0),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const cartItems = pgTable('cart_items', {
  id: serial('id').primaryKey(),
  sessionId: text('session_id').notNull(),
  productId: integer('product_id').references(() => products.id),
  quantity: integer('quantity').default(1),
  price: text('price').notNull().default('0'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// Types
export type Product = typeof products.$inferSelect;
export type NewProduct = typeof products.$inferInsert;
export type Category = typeof categories.$inferSelect;
export type NewCategory = typeof categories.$inferInsert;
export type Order = typeof orders.$inferSelect;
export type NewOrder = typeof orders.$inferInsert;
export type ContactMessage = typeof contactMessages.$inferSelect;
export type NewContactMessage = typeof contactMessages.$inferInsert;
export type CartItem = typeof cartItems.$inferSelect;
export type NewCartItem = typeof cartItems.$inferInsert;
export type CustomDesign = typeof customDesigns.$inferSelect;
export type NewCustomDesign = typeof customDesigns.$inferInsert;
export type Promo = typeof promos.$inferSelect;
export type NewPromo = typeof promos.$inferInsert;
export type Cart = typeof carts.$inferSelect;
export type NewCart = typeof carts.$inferInsert;

// Zod schemas
export const insertProductSchema = z.object({
  name: z.string().min(1, "Name is required"),
  namebn: z.string().optional(),
  description: z.string().optional(),
  descriptionbn: z.string().optional(),
  price: z.string().min(1, "Price is required"),
  category: z.string().min(1, "Category is required"),
  image: z.string().optional(),
  gallery: z.array(z.string()).optional(),
  is_featured: z.boolean().optional(),
  is_active: z.boolean().optional(),
  stock: z.number().optional(),
});

export const selectProductSchema = z.object({
  id: z.number(),
  name: z.string(),
  namebn: z.string().optional(),
  description: z.string().optional(),
  descriptionbn: z.string().optional(),
  price: z.string(),
  category: z.string().optional(),
  image: z.string().optional(),
  gallery: z.array(z.string()).optional(),
  is_featured: z.boolean().optional(),
  is_active: z.boolean().optional(),
  stock: z.number().optional(),
  created_at: z.date().optional(),
  updated_at: z.date().optional(),
});

export const insertCategorySchema = z.object({
  name: z.string().min(1, "Name is required"),
  namebn: z.string().min(1, "Bengali name is required"),
  slug: z.string().min(1, "Slug is required"),
  description: z.string().optional(),
  icon: z.string().optional(),
  isActive: z.boolean().optional(),
  sortOrder: z.number().optional(),
});

export const insertOrderSchema = z.object({
  orderId: z.string(),
  customerName: z.string().min(1, "Customer name is required"),
  customerPhone: z.string().min(1, "Phone is required"),
  customerAddress: z.string().min(1, "Address is required"),
  items: z.array(z.any()),
  total: z.string(),
  paymentMethod: z.string(),
  orderStatus: z.string().optional(),
  paymentStatus: z.string().optional(),
  district: z.string().optional(),
  thana: z.string().optional(),
});

export const insertContactMessageSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Valid email is required"),
  message: z.string().min(1, "Message is required"),
  isRead: z.boolean().optional(),
});

export const orderStatusSchema = z.enum(["pending", "confirmed", "processing", "shipped", "delivered", "cancelled"]);
export const paymentStatusSchema = z.enum(["pending", "completed", "failed", "refunded"]);
export const paymentMethodSchema = z.enum(["cod", "bkash", "nagad", "upay"]);

export const createOrderSchema = z.object({
  customerName: z.string().min(1, "Customer name is required"),
  customerPhone: z.string().min(1, "Phone number is required"),
  customerAddress: z.string().min(1, "Address is required"),
  items: z.array(z.object({
    productId: z.number(),
    quantity: z.number().min(1),
    price: z.string(),
    name: z.string(),
    customDesign: z.any().optional()
  })),
  total: z.string(),
  paymentMethod: paymentMethodSchema,
  district: z.string().optional(),
  thana: z.string().optional()
});

export const createContactMessageSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Valid email is required"),
  message: z.string().min(1, "Message is required")
});

export const updateOrderStatusSchema = z.object({
  orderStatus: orderStatusSchema.optional(),
  paymentStatus: paymentStatusSchema.optional()
});