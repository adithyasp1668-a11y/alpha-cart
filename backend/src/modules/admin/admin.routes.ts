import { Router, Request, Response } from 'express';
import { requireAuth, requireRole } from '../../middleware/auth.js';

export const adminRouter = Router();

// In-memory / Mock backend database for instant demo & integration
let MOCK_METRICS = {
  totalOrders: 153,
  totalSalesPaise: 25638000,
  platformRevenuePaise: 3915000,
  netProfitPaise: 2680000,
  ordersDelta: 14.8,
  salesDelta: 18.2,
  revenueDelta: 12.5,
  profitDelta: 9.4,
};

let MOCK_STORES = [
  {
    id: 'store_1',
    name: 'The Spice Haven',
    ownerName: 'Chef Rameshwar',
    phone: '+91 98765 43210',
    category: 'Food',
    address: 'Indiranagar 100ft Rd, Bengaluru',
    kycStatus: 'VERIFIED',
    commissionRate: 15.0,
    isOpen: true,
    rating: 4.8,
    totalProducts: 42,
    totalOrders: 1320,
  },
  {
    id: 'store_2',
    name: 'Fresh Mart Supermarket',
    ownerName: 'Sunita Reddy',
    phone: '+91 98450 11223',
    category: 'Grocery',
    address: 'HSR Layout Sector 2, Bengaluru',
    kycStatus: 'VERIFIED',
    commissionRate: 8.0,
    isOpen: true,
    rating: 4.6,
    totalProducts: 250,
    totalOrders: 3100,
  },
  {
    id: 'store_3',
    name: 'FitZone Nutrition & Gear',
    ownerName: 'Vikram Singh',
    phone: '+91 97400 88990',
    category: 'Gym & Fitness',
    address: 'Koramangala 5th Block, Bengaluru',
    kycStatus: 'PENDING',
    commissionRate: 12.0,
    isOpen: false,
    rating: 4.9,
    totalProducts: 64,
    totalOrders: 420,
  },
  {
    id: 'store_4',
    name: 'EcoPack Disposables',
    ownerName: 'Anand Mehta',
    phone: '+91 99001 23456',
    category: 'Use & Throw',
    address: 'Peenya Industrial Area, Bengaluru',
    kycStatus: 'VERIFIED',
    commissionRate: 10.0,
    isOpen: true,
    rating: 4.5,
    totalProducts: 38,
    totalOrders: 890,
  },
];

let MOCK_RIDERS = [
  {
    id: 'rider_1',
    name: 'Ravi Kumar',
    phone: '+91 91234 56789',
    vehicleType: 'EV Scooter',
    vehicleNumber: 'KA 01 EK 4492',
    rating: 4.9,
    totalDeliveries: 420,
    kycStatus: 'VERIFIED',
    isOnline: true,
    activeOrderId: 'AC-9082',
  },
  {
    id: 'rider_2',
    name: 'Manoj S',
    phone: '+91 92345 67890',
    vehicleType: 'Hero Splendor',
    vehicleNumber: 'KA 05 MN 1283',
    rating: 4.7,
    totalDeliveries: 285,
    kycStatus: 'VERIFIED',
    isOnline: true,
  },
  {
    id: 'rider_3',
    name: 'Abhishek R',
    phone: '+91 93456 78901',
    vehicleType: 'TVS Jupiter',
    vehicleNumber: 'KA 03 AB 9940',
    rating: 4.6,
    totalDeliveries: 190,
    kycStatus: 'PENDING',
    isOnline: false,
  },
];

let MOCK_PRODUCTS = [
  {
    id: 'prod_1',
    storeId: 'store_1',
    storeName: 'The Spice Haven',
    name: 'Royal Hyderabadi Chicken Biryani',
    category: 'Food',
    description: 'Dum-cooked aromatic basmati rice with marinated chicken & secret spices',
    pricePaise: 34900,
    discountPaise: 5000,
    isAvailable: true,
    stockCount: 50,
  },
  {
    id: 'prod_2',
    storeId: 'store_3',
    storeName: 'FitZone Nutrition & Gear',
    name: 'Gold Standard 100% Whey Protein (1kg)',
    category: 'Gym & Fitness',
    description: 'Imported isolate whey protein double rich chocolate flavour',
    pricePaise: 389900,
    discountPaise: 30000,
    isAvailable: true,
    stockCount: 18,
  },
  {
    id: 'prod_3',
    storeId: 'store_4',
    storeName: 'EcoPack Disposables',
    name: 'Biodegradable Paper Cups (Pack of 100)',
    category: 'Use & Throw',
    description: 'Eco-friendly double wall hot coffee & tea beverage cups 250ml',
    pricePaise: 18000,
    discountPaise: 0,
    isAvailable: true,
    stockCount: 120,
  },
];

let MOCK_ORDERS = [
  {
    id: 'AC-9082',
    customerName: 'Adarsh Gowda',
    customerPhone: '+91 99887 76655',
    storeName: 'The Spice Haven',
    storeAddress: 'Indiranagar 100ft Rd',
    riderName: 'Ravi Kumar',
    riderPhone: '+91 91234 56789',
    status: 'ON_THE_WAY',
    totalPaise: 74800,
    deliveryFeePaise: 4000,
    platformFeePaise: 1500,
    deliveryAddress: 'Flat 402, Green Glen Layout, Bellandur, Bengaluru',
    deliveryOtp: '5821',
    createdAt: new Date(Date.now() - 24 * 60 * 1000).toISOString(),
    items: [
      { id: 'item_1', name: 'Royal Hyderabadi Chicken Biryani', quantity: 2, pricePaise: 34900 },
    ],
  },
];

let MOCK_PAYOUTS = [
  {
    id: 'PAY-1001',
    beneficiaryName: 'The Spice Haven',
    beneficiaryType: 'STORE',
    bankOrUpi: 'HDFC Bank •••• 9102',
    amountPaise: 4860000,
    status: 'PENDING',
    dueDate: new Date(Date.now() + 86400000).toISOString(),
  },
  {
    id: 'PAY-1003',
    beneficiaryName: 'Ravi Kumar',
    beneficiaryType: 'RIDER',
    bankOrUpi: 'ravikumar@oksbi',
    amountPaise: 645000,
    status: 'PENDING',
    dueDate: new Date().toISOString(),
  },
];

let MOCK_SETTINGS = {
  foodCommission: 15.0,
  groceryCommission: 8.0,
  gymCommission: 12.0,
  disposableCommission: 10.0,
  baseDeliveryFeePaise: 3000,
  perKmDeliveryFeePaise: 1000,
  codEnabled: true,
  maintenanceMode: false,
  activeGateway: 'Razorpay Sandbox',
};

// 1. Dashboard Metrics
adminRouter.get('/metrics', (_req: Request, res: Response) => {
  res.json({ metrics: MOCK_METRICS });
});

// 2. Profit & Loss Report
adminRouter.get('/pnl', (_req: Request, res: Response) => {
  const gmv = 142500000;
  const commission = Math.round(gmv * 0.125);
  const deliveryFees = 28500000;
  const deliveryPayouts = 25200000;
  const gateway = Math.round(gmv * 0.018);
  const refunds = 1200000;
  const netProfit = (commission + (deliveryFees - deliveryPayouts)) - gateway - refunds;
  const netMarginPercent = Number(((netProfit / gmv) * 100).toFixed(2));

  res.json({
    pnl: {
      gmvPaise: gmv,
      commissionEarnedPaise: commission,
      deliveryFeesCollectedPaise: deliveryFees,
      deliveryPayoutsDisbursedPaise: deliveryPayouts,
      gatewayChargesPaise: gateway,
      refundsDeductedPaise: refunds,
      netProfitPaise: netProfit,
      netMarginPercent,
    },
  });
});

// 3. Orders Management
adminRouter.get('/orders', (req: Request, res: Response) => {
  const status = req.query.status as string | undefined;
  if (status) {
    res.json({ orders: MOCK_ORDERS.filter(o => o.status === status) });
    return;
  }
  res.json({ orders: MOCK_ORDERS });
});

adminRouter.patch('/orders/:id/status', (req: Request, res: Response) => {
  const { id } = req.params;
  const { status } = req.body;
  const order = MOCK_ORDERS.find(o => o.id === id);
  if (!order) {
    res.status(404).json({ error: 'Order not found' });
    return;
  }
  order.status = status;
  res.json({ order });
});

// 4. Products Management
adminRouter.get('/products', (_req: Request, res: Response) => {
  res.json({ products: MOCK_PRODUCTS });
});

adminRouter.post('/products', (req: Request, res: Response) => {
  const newProduct = {
    id: `prod_${Date.now()}`,
    ...req.body,
  };
  MOCK_PRODUCTS.unshift(newProduct);
  res.status(201).json({ product: newProduct });
});

adminRouter.put('/products/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  const index = MOCK_PRODUCTS.findIndex(p => p.id === id);
  if (index === -1) {
    res.status(404).json({ error: 'Product not found' });
    return;
  }
  MOCK_PRODUCTS[index] = { ...MOCK_PRODUCTS[index], ...req.body };
  res.json({ product: MOCK_PRODUCTS[index] });
});

adminRouter.delete('/products/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  MOCK_PRODUCTS = MOCK_PRODUCTS.filter(p => p.id !== id);
  res.json({ success: true });
});

// 5. Stores / Sellers
adminRouter.get('/stores', (_req: Request, res: Response) => {
  res.json({ stores: MOCK_STORES });
});

adminRouter.patch('/stores/:id/kyc', (req: Request, res: Response) => {
  const { id } = req.params;
  const { kycStatus } = req.body;
  const store = MOCK_STORES.find(s => s.id === id);
  if (!store) {
    res.status(404).json({ error: 'Store not found' });
    return;
  }
  store.kycStatus = kycStatus;
  res.json({ store });
});

adminRouter.patch('/stores/:id/commission', (req: Request, res: Response) => {
  const { id } = req.params;
  const { commissionRate } = req.body;
  const store = MOCK_STORES.find(s => s.id === id);
  if (!store) {
    res.status(404).json({ error: 'Store not found' });
    return;
  }
  store.commissionRate = Number(commissionRate);
  res.json({ store });
});

// 6. Delivery Fleet
adminRouter.get('/riders', (_req: Request, res: Response) => {
  res.json({ riders: MOCK_RIDERS });
});

adminRouter.patch('/riders/:id/kyc', (req: Request, res: Response) => {
  const { id } = req.params;
  const { kycStatus } = req.body;
  const rider = MOCK_RIDERS.find(r => r.id === id);
  if (!rider) {
    res.status(404).json({ error: 'Rider not found' });
    return;
  }
  rider.kycStatus = kycStatus;
  res.json({ rider });
});

// 7. Payouts
adminRouter.get('/payouts', (_req: Request, res: Response) => {
  res.json({ payouts: MOCK_PAYOUTS });
});

adminRouter.post('/payouts/settle', (req: Request, res: Response) => {
  const { payoutIds } = req.body || {};
  MOCK_PAYOUTS.forEach(p => {
    if (!payoutIds || payoutIds.includes(p.id)) {
      if (p.status === 'PENDING') {
        p.status = 'SETTLED';
      }
    }
  });
  res.json({ success: true, payouts: MOCK_PAYOUTS });
});

// 8. Settings
adminRouter.get('/settings', (_req: Request, res: Response) => {
  res.json({ settings: MOCK_SETTINGS });
});

adminRouter.put('/settings', (req: Request, res: Response) => {
  MOCK_SETTINGS = { ...MOCK_SETTINGS, ...req.body };
  res.json({ settings: MOCK_SETTINGS });
});
