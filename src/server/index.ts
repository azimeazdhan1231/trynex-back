typescript ``` code blocks, creating errors. The edited code provides a cleaned and functional version of the server setup, addressing the syntax and logical issues. My task is to replace the entire original content with the corrected and complete code from the edited snippet.

```typescript
import express from "express";
import cors from "cors";
import { registerRoutes } from "./routes";

async function startServer() {
  const app = express();

  // Set frontend URL for production
  const frontendUrl = process.env.NODE_ENV === 'production' 
    ? "https://trynex-lifestyle-v1.netlify.app"
    : "http://localhost:3000";

  // CORS configuration
  app.use(cors({
    origin: [frontendUrl, "https://trynex-lifestyle-v1.netlify.app"],
    credentials: true
  }));

  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: true, limit: "10mb" }));

  // Setup API routes
  await registerRoutes(app);

  // Health check endpoint
  app.get('/health', (req, res) => {
    res.json({ 
      status: 'healthy', 
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'development'
    });
  });

  // Start server on 0.0.0.0 for external access
  const PORT = parseInt(process.env.PORT || "10000", 10);
  const HOST = '0.0.0.0';

  const server = app.listen(PORT, HOST, () => {
    console.log(`🚀 Server running on ${HOST}:${PORT}`);
    console.log(`📡 Environment: ${process.env.NODE_ENV || 'development'}`);
    console.log(`🌐 Frontend URL: ${frontendUrl}`);
    console.log(`📊 Database URL: ${process.env.DATABASE_URL ? 'Connected' : 'Not configured'}`);
  });

  // Graceful shutdown
  process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    server.close(() => {
      console.log('Process terminated');
    });
  });

  process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully');
    server.close(() => {
      console.log('Process terminated');
    });
  });
}

startServer().catch(console.error);