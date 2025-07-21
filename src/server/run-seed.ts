
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { products, categories } from "../shared/schema.js";

async function runSeed() {
  const connectionString = process.env.DATABASE_URL || "postgresql://postgres.wifsqonbnfmwtqvupqbk:usernameamit333@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true";

  console.log("🔄 Connecting to database...");
  console.log("Connection string:", connectionString.replace(/:[^:@]*@/, ':****@'));

  const seedClient = postgres(connectionString, { 
    max: 1,
    ssl: 'require',
    connect_timeout: 10,
    idle_timeout: 20
  });

  const db = drizzle(seedClient);

  console.log("🔄 Seeding database...");

  try {
    // Insert categories first (using correct column names from migration)
    await db.insert(categories).values([
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
        description: "Beautiful frames for your memories",
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
    ]).onConflictDoNothing();

    console.log("✅ Categories inserted successfully!");

    // Insert products (using correct column names from migration)
    await db.insert(products).values([
      {
        name: "Custom T-Shirt",
        namebn: "কাস্টম টি-শার্ট",
        description: "High quality custom printed t-shirt",
        descriptionbn: "উচ্চ মানের কাস্টম প্রিন্টেড টি-শার্ট",
        price: "500.00",
        category: "custom-t-shirts",
        image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400",
        gallery: ["https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400"],
        is_featured: true,
        is_active: true,
        stock: 100
      },
      {
        name: "Photo Frame",
        namebn: "ফটো ফ্রেম",
        description: "Beautiful custom photo frame",
        descriptionbn: "সুন্দর কাস্টম ফটো ফ্রেম",
        price: "300.00",
        category: "photo-frames",
        image: "https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400",
        gallery: ["https://images.unsplash.com/photo-1582053433976-25c00369fc93?w=400"],
        is_featured: true,
        is_active: true,
        stock: 50
      },
      {
        name: "Custom Mug",
        namebn: "কাস্টম মগ",
        description: "Personalized ceramic mug",
        descriptionbn: "ব্যক্তিগতকৃত সিরামিক মগ",
        price: "250.00",
        category: "mugs",
        image: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400",
        gallery: ["https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=400"],
        is_featured: false,
        is_active: true,
        stock: 75
      }
    ]).onConflictDoNothing();

    console.log("✅ Products inserted successfully!");
    console.log("🎉 Database seeded successfully!");
  } catch (error) {
    console.error("❌ Seeding failed:", error);
    process.exit(1);
  } finally {
    await seedClient.end();
  }
}

// Run seed directly
runSeed().catch(error => {
  console.error("Seed error:", error);
  process.exit(1);
});
