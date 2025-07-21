
import { storage } from './storage';

export async function healthCheck() {
  const checks = {
    timestamp: new Date().toISOString(),
    database: false,
    server: true,
    environment: process.env.NODE_ENV || 'development'
  };

  try {
    // Test database connection
    const products = await storage.getProducts();
    checks.database = Array.isArray(products);
  } catch (error) {
    console.error('Database health check failed:', error);
    checks.database = false;
  }

  return checks;
}

export function setupHealthEndpoint(app: any) {
  app.get('/health', async (req: any, res: any) => {
    try {
      const health = await healthCheck();
      const status = health.database && health.server ? 200 : 503;
      res.status(status).json(health);
    } catch (error) {
      res.status(503).json({
        timestamp: new Date().toISOString(),
        database: false,
        server: false,
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  });
}
