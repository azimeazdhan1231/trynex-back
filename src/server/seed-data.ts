import { storage } from './storage';

const sampleProducts = [
  {
    name: "Customizable T-Shirt",
    namebn: "কাস্টমাইজেবল টি-শার্ট",
    description: "High-quality cotton t-shirt perfect for custom designs",
    descriptionbn: "কাস্টম ডিজাইনের জন্য উপযুক্ত উচ্চমানের কটন টি-শার্ট",
    price: "599",
    category: "T-Shirts",
    image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500",
    gallery: [
      "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500",
      "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500"
    ],
    is_featured: true,
    is_active: true,
    stock: 50
  },
  {
    name: "Custom Mug",
    namebn: "কাস্টম মগ",
    description: "Ceramic mug perfect for personalized gifts",
    descriptionbn: "ব্যক্তিগতকৃত উপহারের জন্য উপযুক্ত সিরামিক মগ",
    price: "299",
    category: "Mugs",
    image: "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500",
    gallery: [
      "https://images.unsplash.com/photo-1544787219-7f47ccb76574?w=500"
    ],
    is_featured: true,
    is_active: true,
    stock: 30
  },
  {
    name: "Custom Phone Case",
    namebn: "কাস্টম ফোন কেস",
    description: "Protective phone case with custom design options",
    descriptionbn: "কাস্টম ডিজাইন অপশন সহ সুরক্ষামূলক ফোন কেস",
    price: "399",
    category: "Phone Cases",
    image: "https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500",
    gallery: [
      "https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500"
    ],
    is_featured: false,
    is_active: true,
    stock: 25
  }
];

const sampleCategories = [
  {
    name: "T-Shirts",
    namebn: "টি-শার্ট",
    slug: "t-shirts",
    description: "Custom printed t-shirts",
    icon: "👕",
    isActive: true,
    sortOrder: 1
  },
  {
    name: "Mugs",
    namebn: "মগ",
    slug: "mugs",
    description: "Custom printed mugs",
    icon: "☕",
    isActive: true,
    sortOrder: 2
  },
  {
    name: "Phone Cases",
    namebn: "ফোন কেস",
    slug: "phone-cases",
    description: "Custom phone cases",
    icon: "📱",
    isActive: true,
    sortOrder: 3
  }
];

export async function seedDatabase() {
  try {
    console.log("🌱 Starting database seeding...");

    // Seed categories first
    console.log("📁 Creating categories...");
    for (const category of sampleCategories) {
      try {
        await storage.createCategory(category);
        console.log(`✅ Created category: ${category.name}`);
      } catch (error) {
        console.log(`⚠️ Category ${category.name} might already exist`);
      }
    }

    // Seed products
    console.log("📦 Creating products...");
    for (const product of sampleProducts) {
      try {
        await storage.createProduct(product);
        console.log(`✅ Created product: ${product.name}`);
      } catch (error) {
        console.log(`⚠️ Product ${product.name} might already exist`);
      }
    }

    console.log("🎉 Database seeding completed successfully!");
  } catch (error) {
    console.error("❌ Error seeding database:", error);
    throw error;
  }
}