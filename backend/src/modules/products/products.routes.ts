import { Router, Request, Response } from 'express';

export const productsRouter = Router();

const MOCK_PRODUCTS = [
  {
    id: 'prod_1',
    storeId: 'store_1',
    name: 'Organic Bananas (1 Dozen)',
    price: 6000, // 60.00 INR
    category: 'Fruits',
    isAvailable: true,
  },
  {
    id: 'prod_2',
    storeId: 'store_1',
    name: 'Farm Fresh Whole Milk (1L)',
    price: 3800, // 38.00 INR
    category: 'Dairy',
    isAvailable: true,
  },
  {
    id: 'prod_3',
    storeId: 'store_2',
    name: 'Hyderabadi Chicken Biryani',
    price: 28000, // 280.00 INR
    category: 'Mains',
    isAvailable: true,
  },
];

productsRouter.get('/', (req: Request, res: Response) => {
  const storeId = req.query.storeId as string | undefined;
  if (storeId) {
    res.json({ products: MOCK_PRODUCTS.filter(p => p.storeId === storeId) });
    return;
  }
  res.json({ products: MOCK_PRODUCTS });
});

productsRouter.get('/:id', (req: Request, res: Response) => {
  const product = MOCK_PRODUCTS.find(p => p.id === req.params.id);
  if (!product) {
    res.status(404).json({ error: 'Product not found' });
    return;
  }
  res.json({ product });
});

