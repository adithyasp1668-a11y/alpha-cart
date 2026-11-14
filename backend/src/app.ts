import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { authRouter } from './modules/auth/auth.routes.js';
import { storesRouter } from './modules/stores/stores.routes.js';
import { productsRouter } from './modules/products/products.routes.js';
import { ordersRouter } from './modules/orders/orders.routes.js';

export const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: 'alphacart-backend',
    timestamp: new Date().toISOString(),
  });
});

// Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/stores', storesRouter);
app.use('/api/v1/products', productsRouter);
app.use('/api/v1/orders', ordersRouter);

