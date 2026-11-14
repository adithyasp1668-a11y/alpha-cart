"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.storesRouter = void 0;
const express_1 = require("express");
exports.storesRouter = (0, express_1.Router)();
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
exports.storesRouter.get('/', (_req, res) => {
    res.json({ stores: MOCK_STORES });
});
exports.storesRouter.get('/:id', (req, res) => {
    const store = MOCK_STORES.find(s => s.id === req.params.id);
    if (!store) {
        res.status(404).json({ error: 'Store not found' });
        return;
    }
    res.json({ store });
});
