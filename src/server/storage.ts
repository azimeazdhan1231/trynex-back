import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import { 
  products, 
  categories, 
  orders, 
  contactMessages, 
  cartItems, 
  customDesigns,
  promos,
  type Product,
  type NewProduct,
  type Category,
  type NewCategory,
  type Order,
  type NewOrder,
  type ContactMessage,
  type NewContactMessage,
  type CartItem,
  type NewCartItem
} from '../shared/schema';
import { eq, desc, and } from 'drizzle-orm';

const connectionString = process.env.DATABASE_URL!;

if (!connectionString) {
  throw new Error('DATABASE_URL environment variable is required');
}

const client = postgres(connectionString, {
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

export const db = drizzle(client);

export const storage = {
  // Products
  async getProducts(): Promise<Product[]> {
    try {
      return await db.select().from(products).orderBy(desc(products.created_at));
    } catch (error) {
      console.error('Error fetching products:', error);
      throw error;
    }
  },

  async getProductById(id: number): Promise<Product | undefined> {
    try {
      const result = await db.select().from(products).where(eq(products.id, id));
      return result[0];
    } catch (error) {
      console.error('Error fetching product by id:', error);
      throw error;
    }
  },

  async createProduct(productData: Omit<NewProduct, 'id' | 'created_at' | 'updated_at'>): Promise<Product> {
    try {
      const result = await db.insert(products).values({
        ...productData,
        created_at: new Date(),
        updated_at: new Date(),
      }).returning();
      return result[0];
    } catch (error) {
      console.error('Error creating product:', error);
      throw error;
    }
  },

  async updateProduct(id: number, updates: Partial<Omit<NewProduct, 'id' | 'created_at'>>): Promise<Product | undefined> {
    try {
      const result = await db.update(products)
        .set({ ...updates, updated_at: new Date() })
        .where(eq(products.id, id))
        .returning();
      return result[0];
    } catch (error) {
      console.error('Error updating product:', error);
      throw error;
    }
  },

  async deleteProduct(id: number): Promise<boolean> {
    try {
      const result = await db.delete(products).where(eq(products.id, id));
      return result.length > 0;
    } catch (error) {
      console.error('Error deleting product:', error);
      throw error;
    }
  },

  // Categories
  async getCategories(): Promise<Category[]> {
    try {
      return await db.select().from(categories).orderBy(categories.sortOrder);
    } catch (error) {
      console.error('Error fetching categories:', error);
      throw error;
    }
  },

  async createCategory(categoryData: Omit<NewCategory, 'id' | 'createdAt' | 'updatedAt'>): Promise<Category> {
    try {
      const result = await db.insert(categories).values({
        ...categoryData,
        createdAt: new Date(),
        updatedAt: new Date(),
      }).returning();
      return result[0];
    } catch (error) {
      console.error('Error creating category:', error);
      throw error;
    }
  },

  // Cart
  async getCartItems(sessionId: string): Promise<any[]> {
    try {
      const result = await db
        .select({
          id: cartItems.id,
          sessionId: cartItems.sessionId,
          productId: cartItems.productId,
          quantity: cartItems.quantity,
          product: products
        })
        .from(cartItems)
        .leftJoin(products, eq(cartItems.productId, products.id))
        .where(eq(cartItems.sessionId, sessionId));

      return result.map(item => ({
        ...item,
        product: item.product
      }));
    } catch (error) {
      console.error('Error fetching cart items:', error);
      throw error;
    }
  },

  async addToCart(sessionId: string, productId: number, quantity: number = 1): Promise<CartItem> {
    try {
      // Check if item already exists
      const existing = await db
        .select()
        .from(cartItems)
        .where(and(eq(cartItems.sessionId, sessionId), eq(cartItems.productId, productId)));

      if (existing.length > 0) {
        // Update quantity
        const result = await db
          .update(cartItems)
          .set({ 
            quantity: existing[0].quantity! + quantity,
            updatedAt: new Date()
          })
          .where(eq(cartItems.id, existing[0].id))
          .returning();
        return result[0];
      } else {
        // Insert new item
        const result = await db.insert(cartItems).values({
          sessionId,
          productId,
          quantity,
          price: "0", // Add required price field
          createdAt: new Date(),
          updatedAt: new Date(),
        }).returning();
        return result[0];
      }
    } catch (error) {
      console.error('Error adding to cart:', error);
      throw error;
    }
  },

  async updateCartItemQuantity(sessionId: string, productId: number, quantity: number): Promise<CartItem | undefined> {
    try {
      const result = await db
        .update(cartItems)
        .set({ quantity, updatedAt: new Date() })
        .where(and(eq(cartItems.sessionId, sessionId), eq(cartItems.productId, productId)))
        .returning();
      return result[0];
    } catch (error) {
      console.error('Error updating cart item:', error);
      throw error;
    }
  },

  async removeFromCart(sessionId: string, productId: number): Promise<boolean> {
    try {
      await db
        .delete(cartItems)
        .where(and(eq(cartItems.sessionId, sessionId), eq(cartItems.productId, productId)));
      return true;
    } catch (error) {
      console.error('Error removing from cart:', error);
      throw error;
    }
  },

  async clearCart(sessionId: string): Promise<void> {
    try {
      await db.delete(cartItems).where(eq(cartItems.sessionId, sessionId));
    } catch (error) {
      console.error('Error clearing cart:', error);
      throw error;
    }
  },

  // Orders
  async createOrder(orderData: Omit<NewOrder, 'id' | 'createdAt' | 'updatedAt'>): Promise<Order> {
    try {
      const result = await db.insert(orders).values({
        ...orderData,
        createdAt: new Date(),
        updatedAt: new Date(),
      }).returning();
      return result[0];
    } catch (error) {
      console.error('Error creating order:', error);
      throw error;
    }
  },

  async getOrders(): Promise<Order[]> {
    try {
      return await db.select().from(orders).orderBy(desc(orders.createdAt));
    } catch (error) {
      console.error('Error fetching orders:', error);
      throw error;
    }
  },

  async getOrderByOrderId(orderId: string): Promise<Order | undefined> {
    try {
      const result = await db.select().from(orders).where(eq(orders.orderId, orderId));
      return result[0];
    } catch (error) {
      console.error('Error fetching order by orderId:', error);
      throw error;
    }
  },

  async updateOrderStatus(id: number, status: string): Promise<Order | undefined> {
    try {
      const result = await db
        .update(orders)
        .set({ orderStatus: status, updatedAt: new Date() })
        .where(eq(orders.id, id))
        .returning();
      return result[0];
    } catch (error) {
      console.error('Error updating order status:', error);
      throw error;
    }
  },

  async updatePaymentStatus(id: number, status: string): Promise<Order | undefined> {
    try {
      const result = await db
        .update(orders)
        .set({ paymentStatus: status, updatedAt: new Date() })
        .where(eq(orders.id, id))
        .returning();
      return result[0];
    } catch (error) {
      console.error('Error updating payment status:', error);
      throw error;
    }
  },

  // Contact Messages
  async createContactMessage(messageData: Omit<NewContactMessage, 'id' | 'createdAt'>): Promise<ContactMessage> {
    try {
      const result = await db.insert(contactMessages).values({
        ...messageData,
        createdAt: new Date(),
      }).returning();
      return result[0];
    } catch (error) {
      console.error('Error creating contact message:', error);
      throw error;
    }
  },

  async getContactMessages(): Promise<ContactMessage[]> {
    try {
      return await db.select().from(contactMessages).orderBy(desc(contactMessages.createdAt));
    } catch (error) {
      console.error('Error fetching contact messages:', error);
      throw error;
    }
  },

  // Custom Designs
  async createCustomDesign(sessionId: string, productId: number, designData: any): Promise<any> {
    try {
      const result = await db.insert(customDesigns).values({
        sessionId,
        productId,
        designData,
        createdAt: new Date(),
        updatedAt: new Date(),
      }).returning();
      return result[0];
    } catch (error) {
      console.error('Error creating custom design:', error);
      throw error;
    }
  },

  async getCustomDesignsBySession(sessionId: string): Promise<any[]> {
    try {
      return await db.select().from(customDesigns).where(eq(customDesigns.sessionId, sessionId));
    } catch (error) {
      console.error('Error fetching custom designs:', error);
      throw error;
    }
  }
};