import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { canTransitionOrder, OrderStatus } from './order-state-machine.js';

export const ordersRouter = Router();

const createOrderSchema = z.object({
  storeId: z.string(),
  items: z.array(
    z.object({
      productId: z.string(),
      quantity: z.number().int().positive(),
      price: z.number().int().positive(),
    })
  ).min(1),
  deliveryAddress: z.string().min(5),
});

const transitionSchema = z.object({
  nextStatus: z.string(),
});

interface LocalOrder {
  id: string;
  storeId: string;
  items: Array<{ productId: string; quantity: number; price: number }>;
  deliveryAddress: string;
  status: OrderStatus;
  totalAmount: number;
  createdAt: string;
}

const ORDERS: LocalOrder[] = [];

ordersRouter.post('/', (req: Request, res: Response) => {
  const result = createOrderSchema.safeParse(req.body);
  if (!result.success) {
    res.status(400).json({ error: 'Invalid order data', details: result.error.errors });
    return;
  }

  const { storeId, items, deliveryAddress } = result.data;
  const totalAmount = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const newOrder: LocalOrder = {
    id: `ord_${Date.now()}`,
    storeId,
    items,
    deliveryAddress,
    status: 'PLACED',
    totalAmount,
    createdAt: new Date().toISOString(),
  };

  ORDERS.unshift(newOrder);
  res.status(201).json({ order: newOrder });
});

ordersRouter.get('/', (_req: Request, res: Response) => {
  res.json({ orders: ORDERS });
});

ordersRouter.get('/:id', (req: Request, res: Response) => {
  const order = ORDERS.find(o => o.id === req.params.id);
  if (!order) {
    res.status(404).json({ error: 'Order not found' });
    return;
  }
  res.json({ order });
});

ordersRouter.post('/:id/transition', (req: Request, res: Response) => {
  const order = ORDERS.find(o => o.id === req.params.id);
  if (!order) {
    res.status(404).json({ error: 'Order not found' });
    return;
  }

  const result = transitionSchema.safeParse(req.body);
  if (!result.success) {
    res.status(400).json({ error: 'Invalid transition payload' });
    return;
  }

  const next = result.data.nextStatus as OrderStatus;
  if (!canTransitionOrder(order.status, next)) {
    res.status(400).json({
      error: `Invalid status transition from ${order.status} to ${next}`,
    });
    return;
  }

  order.status = next;
  res.json({ order });
});

