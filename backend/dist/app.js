"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.app = void 0;
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const auth_routes_js_1 = require("./modules/auth/auth.routes.js");
const stores_routes_js_1 = require("./modules/stores/stores.routes.js");
const products_routes_js_1 = require("./modules/products/products.routes.js");
const orders_routes_js_1 = require("./modules/orders/orders.routes.js");
const admin_routes_js_1 = require("./modules/admin/admin.routes.js");
exports.app = (0, express_1.default)();
exports.app.use((0, helmet_1.default)());
exports.app.use((0, cors_1.default)());
exports.app.use(express_1.default.json());
// Health check
exports.app.get('/health', (_req, res) => {
    res.json({
        status: 'ok',
        service: 'alphacart-backend',
        timestamp: new Date().toISOString(),
    });
});
// Routes
exports.app.use('/api/v1/auth', auth_routes_js_1.authRouter);
exports.app.use('/api/v1/stores', stores_routes_js_1.storesRouter);
exports.app.use('/api/v1/products', products_routes_js_1.productsRouter);
exports.app.use('/api/v1/orders', orders_routes_js_1.ordersRouter);
exports.app.use('/api/v1/admin', admin_routes_js_1.adminRouter);
