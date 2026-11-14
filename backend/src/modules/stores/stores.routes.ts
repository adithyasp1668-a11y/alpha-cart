import { Router, Request, Response } from 'express';

export const storesRouter = Router();

const MOCK_STORES = [
  {
    id: 'store_1',
    name: 'Fresh Mart Supermarket',
    category: 'Groceries',
    address: 'Indiranagar 100ft Rd, Bengaluru',
    rating: 4.8,
    isOpen: true,
  },
  {
    id: 'store_2',
    name: 'Spice Route Kitchen',
    category: 'Restaurant',
    address: 'Koramangala 5th Block, Bengaluru',
    rating: 4.6,
    isOpen: true,
  },
];

storesRouter.get('/', (_req: Request, res: Response) => {
  res.json({ stores: MOCK_STORES });
});

storesRouter.get('/:id', (req: Request, res: Response) => {
  const store = MOCK_STORES.find(s => s.id === req.params.id);
  if (!store) {
    res.status(404).json({ error: 'Store not found' });
    return;
  }
  res.json({ store });
});

