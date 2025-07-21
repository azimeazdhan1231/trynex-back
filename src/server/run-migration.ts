import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { migrate } from "drizzle-orm/postgres-js/migrator";

async function runMigration() {
  const connectionString = process.env.DATABASE_URL || "postgresql://postgres.wifsqonbnfmwtqvupqbk:usernameamit333@aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true";

  console.log("🔄 Connecting to database...");
  console.log("Connection string:", connectionString.replace(/:[^:@]*@/, ':****@'));

  const migrationClient = postgres(connectionString, { 
    max: 1,
    ssl: 'require',
    connect_timeout: 10,
    idle_timeout: 20
  });

  const db = drizzle(migrationClient);

  console.log("🔄 Running database migrations...");

  try {
    await migrate(db, { migrationsFolder: "./migrations" });
    console.log("✅ Database migrations completed successfully!");
  } catch (error) {
    console.error("❌ Migration failed:", error);
    process.exit(1);
  } finally {
    await migrationClient.end();
  }
}

// Run migration directly
runMigration().catch(error => {
  console.error("Migration error:", error);
  process.exit(1);
});