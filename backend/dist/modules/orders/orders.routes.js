"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ordersRouter = void 0;
const express_1 = require("express");
const zod_1 = require("zod");
const order_state_machine_js_1 = require("./order-state-machine.js");
exports.ordersRouter = (0, express_1.Router)();
const createOrderSchema = zod_1.z.object({
    storeId: zod_1.z.string(),
    items: zod_1.z.array(zod_1.z.object({
        productId: zod_1.z.string(),
        quantity: zod_1.z.number().int().positive(),
        price: zod_1.z.number().int().positive(),
    })).min(1),
    deliveryAddress: zod_1.z.string().min(5),
});
const transitionSchema = zod_1.z.object({
    nextStatus: zod_1.z.string(),
});
const ORDERS = [];
exports.ordersRouter.post('/', (req, res) => {
    const result = createOrderSchema.safeParse(req.body);
    if (!result.success) {
        res.status(400).json({ error: 'Invalid order data', details: result.error.errors });
        return;
    }
    const { storeId, items, deliveryAddress } = result.data;
    const totalAmount = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const newOrder = {
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
exports.ordersRouter.get('/', (_req, res) => {
    res.json({ orders: ORDERS });
});
exports.ordersRouter.get('/:id', (req, res) => {
    const order = ORDERS.find(o => o.id === req.params.id);
    if (!order) {
        res.status(404).json({ error: 'Order not found' });
        return;
    }
    res.json({ order });
});
exports.ordersRouter.post('/:id/transition', (req, res) => {
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
    const next = result.data.nextStatus;
    if (!(0, order_state_machine_js_1.canTransitionOrder)(order.status, next)) {
        res.status(400).json({
            error: `Invalid status transition from ${order.status} to ${next}`,
        });
        return;
    }
    order.status = next;
    res.json({ order });
});
