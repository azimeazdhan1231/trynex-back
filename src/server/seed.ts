import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { products, categories } from "../shared/schema";

const sampleCategories = [
  {
    name: "Custom T-Shirts",
    namebn: "কাস্টম টি-শার্ট",
    slug: "custom-t-shirts",
    description: "Personalized t-shirts with your design",
    icon: "👕",
    isActive: true,
    sortOrder: 1
  },
  {
    name: "Photo Frames",
    namebn: "ফটো ফ্রেম",
    slug: "photo-frames",
    description: "Custom photo frames for memories",
    icon: "🖼️",
    isActive: true,
    sortOrder: 2
  },
  {
    name: "Mugs",
    namebn: "মগ",
    slug: "mugs",
    description: "Personalized coffee mugs",
    icon: "☕",
    isActive: true,
    sortOrder: 3
  }
];

const sampleProducts = [
  {
    name: "Custom T-Shirt",
    namebn: "কাস্টম টি-শার্ট",
    description: "High quality custom printed t-shirt",
    descriptionbn: "উচ্চ মানের কাস্টম প্রিন্টেড টি-শার্ট",
    price: "৳500",
    category: "custom-t-shirts",
    image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
    gallery: ["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400"],
    isFeatured: true,
    isActive: true,
    stock: 100
  },
  {
    name: "Photo Frame",
    namebn: "ফটো ফ্রেম",
    description: "Beautiful custom photo frame",
    descriptionbn: "সুন্দর কাস্টম ফটো ফ্রেম",
    price: "৳300",
    category: "photo-frames",
    image: "https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400",
    gallery: ["https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400"],
    isFeatured: true,
    isActive: true,
    stock: 50
  },
  {
    name: "Custom Mug",
    namebn: "কাস্টম মগ",
    description: "Personalized coffee mug",
    descriptionbn: "ব্যক্তিগতকৃত কফি মগ",
    price: "৳250",
    category: "mugs",
    image: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400",
    gallery: ["https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400"],
    isFeatured: false,
    isActive: true,
    stock: 75
  }
];

export async function seedDatabase(db: any) {
  console.log("🗂️ Inserting categories...");
  for (const category of sampleCategories) {
    try {
      await db.insert(categories).values(category).onConflictDoNothing();
      console.log(`✅ Created category: ${category.name}`);
    } catch (error) {
      console.error(`❌ Failed to create category ${category.name}:`, error);
    }
  }

  console.log("📦 Inserting products...");
  for (const product of sampleProducts) {
    try {
      await db.insert(products).values(product).onConflictDoNothing();
      console.log(`✅ Created product: ${product.name}`);
    } catch (error) {
      console.error(`❌ Failed to create product ${product.name}:`, error);
    }
  }

  console.log("🎉 Seeding completed!");
}