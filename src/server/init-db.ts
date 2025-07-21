
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { storage } from "./storage";

async function initializeDatabase() {
  try {
    console.log("Initializing database connection...");
    const products = await storage.getProducts();
    console.log(`Database connected successfully. Found ${products.length} products.`);
    return true;
  } catch (error) {
    console.error("Database connection failed:", error);
    throw error;
  }
}

export { initializeDatabase };
