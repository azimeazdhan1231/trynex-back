import { Request, Response } from "express";
import { z } from "zod";
import { storage } from "./storage";
import {
  createOrderSchema,
  createContactMessageSchema,
  updateOrderStatusSchema,
  insertProductSchema,
  insertCategorySchema
} from "../shared/schema";

export async function registerRoutes(app: any) {
  // Products
  app.get("/api/products", async (req: Request, res: Response) => {
    try {
      const products = await storage.getProducts();
      res.json(products);
    } catch (error) {
      console.error("Error fetching products:", error);
      res.status(500).json({ error: "Failed to fetch products" });
    }
  });

  app.get("/api/products/:id", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id);
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid product ID" });
      }

      const product = await storage.getProductById(id);
      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }
      res.json(product);
    } catch (error) {
      console.error("Error fetching product:", error);
      res.status(500).json({ error: "Failed to fetch product" });
    }
  });

  app.post("/api/products", async (req: Request, res: Response) => {
    try {
      const validatedData = insertProductSchema.parse(req.body);
      const product = await storage.createProduct({
        name: validatedData.name!,
        price: validatedData.price!,
        namebn: validatedData.namebn,
        description: validatedData.description,
        descriptionbn: validatedData.descriptionbn,
        image: validatedData.image,
        gallery: validatedData.gallery,
        category: validatedData.category,
        is_featured: validatedData.is_featured,
        is_active: validatedData.is_active,
        stock: validatedData.stock
      });
      res.status(201).json(product);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error creating product:", error);
      res.status(500).json({ error: "Failed to create product" });
    }
  });

  app.put("/api/products/:id", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id);
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid product ID" });
      }

      const validatedData = insertProductSchema.partial().parse(req.body);
      const product = await storage.updateProduct(id, validatedData);

      if (!product) {
        return res.status(404).json({ error: "Product not found" });
      }

      res.json(product);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error updating product:", error);
      res.status(500).json({ error: "Failed to update product" });
    }
  });

  app.delete("/api/products/:id", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id);
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid product ID" });
      }

      const deleted = await storage.deleteProduct(id);
      if (!deleted) {
        return res.status(404).json({ error: "Product not found" });
      }

      res.json({ success: true });
    } catch (error) {
      console.error("Error deleting product:", error);
      res.status(500).json({ error: "Failed to delete product" });
    }
  });

  // Categories
  app.get("/api/categories", async (req: Request, res: Response) => {
    try {
      const categories = await storage.getCategories();
      res.json(categories);
    } catch (error) {
      console.error("Error fetching categories:", error);
      res.status(500).json({ error: "Failed to fetch categories" });
    }
  });

  app.post("/api/categories", async (req: Request, res: Response) => {
    try {
      const validatedData = insertCategorySchema.parse(req.body);
      const category = await storage.createCategory({
        name: validatedData.name!,
        namebn: validatedData.namebn!,
        slug: validatedData.slug!,
        description: validatedData.description,
        icon: validatedData.icon,
        isActive: validatedData.isActive,
        sortOrder: validatedData.sortOrder
      });
      res.status(201).json(category);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error creating category:", error);
      res.status(500).json({ error: "Failed to create category" });
    }
  });

  // Cart
  app.get("/api/cart/:sessionId", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      const cartItems = await storage.getCartItems(sessionId);
      res.json(cartItems);
    } catch (error) {
      console.error("Error fetching cart:", error);
      res.status(500).json({ error: "Failed to fetch cart" });
    }
  });

  app.post("/api/cart/:sessionId/add", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      const { productId, quantity = 1 } = req.body;

      if (!productId || typeof productId !== 'number') {
        return res.status(400).json({ error: "Product ID is required" });
      }

      const cartItem = await storage.addToCart(sessionId, productId, quantity);
      res.json(cartItem);
    } catch (error) {
      console.error("Error adding to cart:", error);
      res.status(500).json({ error: "Failed to add to cart" });
    }
  });

  app.put("/api/cart/:sessionId/update", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      const { productId, quantity } = req.body;

      if (!productId || typeof productId !== 'number' || !quantity || typeof quantity !== 'number') {
        return res.status(400).json({ error: "Product ID and quantity are required" });
      }

      const cartItem = await storage.updateCartItemQuantity(sessionId, productId, quantity);
      if (!cartItem) {
        return res.status(404).json({ error: "Cart item not found" });
      }

      res.json(cartItem);
    } catch (error) {
      console.error("Error updating cart:", error);
      res.status(500).json({ error: "Failed to update cart" });
    }
  });

  app.delete("/api/cart/:sessionId/remove", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      const { productId } = req.body;

      if (!productId || typeof productId !== 'number') {
        return res.status(400).json({ error: "Product ID is required" });
      }

      const removed = await storage.removeFromCart(sessionId, productId);
      if (!removed) {
        return res.status(404).json({ error: "Cart item not found" });
      }

      res.json({ success: true });
    } catch (error) {
      console.error("Error removing from cart:", error);
      res.status(500).json({ error: "Failed to remove from cart" });
    }
  });

  app.delete("/api/cart/:sessionId", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      await storage.clearCart(sessionId);
      res.json({ success: true });
    } catch (error) {
      console.error("Error clearing cart:", error);
      res.status(500).json({ error: "Failed to clear cart" });
    }
  });

  // Orders
  app.post("/api/orders", async (req: Request, res: Response) => {
    try {
      const validatedData = createOrderSchema.parse(req.body);

      // Generate order ID
      const orderId = `ORD-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

      const orderData = {
        orderId,
        customerName: validatedData.customerName,
        customerPhone: validatedData.customerPhone,
        customerAddress: validatedData.customerAddress,
        items: validatedData.items,
        total: validatedData.total,
        paymentMethod: validatedData.paymentMethod,
        orderStatus: "pending" as const,
        paymentStatus: "pending" as const,
        district: validatedData.district,
        thana: validatedData.thana
      };

      const order = await storage.createOrder(orderData);
      res.status(201).json(order);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error creating order:", error);
      res.status(500).json({ error: "Failed to create order" });
    }
  });

  app.get("/api/orders", async (req: Request, res: Response) => {
    try {
      const orders = await storage.getOrders();
      res.json(orders);
    } catch (error) {
      console.error("Error fetching orders:", error);
      res.status(500).json({ error: "Failed to fetch orders" });
    }
  });

  app.get("/api/orders/:orderId", async (req: Request, res: Response) => {
    try {
      const { orderId } = req.params;
      const order = await storage.getOrderByOrderId(orderId);

      if (!order) {
        return res.status(404).json({ error: "Order not found" });
      }

      res.json(order);
    } catch (error) {
      console.error("Error fetching order:", error);
      res.status(500).json({ error: "Failed to fetch order" });
    }
  });

  app.put("/api/orders/:id/status", async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id);
      if (isNaN(id)) {
        return res.status(400).json({ error: "Invalid order ID" });
      }

      const { orderStatus, paymentStatus } = updateOrderStatusSchema.parse(req.body);

      let order = null;
      if (orderStatus) {
        order = await storage.updateOrderStatus(id, orderStatus);
      }
      if (paymentStatus) {
        order = await storage.updatePaymentStatus(id, paymentStatus);
      }

      if (!order) {
        return res.status(404).json({ error: "Order not found" });
      }

      res.json(order);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error updating order status:", error);
      res.status(500).json({ error: "Failed to update order status" });
    }
  });

  // Contact Messages
  app.post("/api/contact", async (req: Request, res: Response) => {
    try {
      const validatedData = createContactMessageSchema.parse(req.body);
      const message = await storage.createContactMessage({
        name: validatedData.name!,
        email: validatedData.email!,
        message: validatedData.message!
      });
      res.status(201).json(message);
    } catch (error) {
      if (error instanceof z.ZodError) {
        return res.status(400).json({ error: error.errors });
      }
      console.error("Error creating contact message:", error);
      res.status(500).json({ error: "Failed to send message" });
    }
  });

  app.get("/api/contact", async (req: Request, res: Response) => {
    try {
      const messages = await storage.getContactMessages();
      res.json(messages);
    } catch (error) {
      console.error("Error fetching contact messages:", error);
      res.status(500).json({ error: "Failed to fetch messages" });
    }
  });

  // Custom Designs
  app.get("/api/custom-designs/:sessionId", async (req: Request, res: Response) => {
    try {
      const { sessionId } = req.params;
      const designs = await storage.getCustomDesignsBySession(sessionId);
      res.json(designs);
    } catch (error) {
      console.error("Error fetching custom designs:", error);
      res.status(500).json({ error: "Failed to fetch designs" });
    }
  });

  app.post("/api/custom-designs", async (req: Request, res: Response) => {
    try {
      const { sessionId, productId, designData } = req.body;

      if (!sessionId || !productId || !designData) {
        return res.status(400).json({ error: "Session ID, product ID, and design data are required" });
      }

      const design = await storage.createCustomDesign(sessionId, productId, designData);
      res.status(201).json(design);
    } catch (error) {
      console.error("Error creating custom design:", error);
      res.status(500).json({ error: "Failed to create design" });
    }
  });


}