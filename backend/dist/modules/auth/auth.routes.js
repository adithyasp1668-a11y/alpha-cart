"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authRouter = void 0;
const express_1 = require("express");
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const zod_1 = require("zod");
const env_js_1 = require("../../config/env.js");
exports.authRouter = (0, express_1.Router)();
const loginSchema = zod_1.z.object({
    phone: zod_1.z.string().min(10),
    role: zod_1.z.enum(['CUSTOMER', 'SELLER', 'DELIVERY', 'ADMIN']).default('CUSTOMER'),
});
const verifyOtpSchema = zod_1.z.object({
    phone: zod_1.z.string().min(10),
    otp: zod_1.z.string().length(6),
    role: zod_1.z.enum(['CUSTOMER', 'SELLER', 'DELIVERY', 'ADMIN']).default('CUSTOMER'),
});
exports.authRouter.post('/request-otp', (req, res) => {
    const result = loginSchema.safeParse(req.body);
    if (!result.success) {
        res.status(400).json({ error: 'Invalid input', details: result.error.errors });
        return;
    }
    // In development/test mode, OTP is fixed demo code 123456
    res.json({
        message: 'OTP sent successfully',
        demoOtp: env_js_1.ENV.NODE_ENV !== 'production' ? '123456' : undefined,
    });
});
exports.authRouter.post('/verify-otp', (req, res) => {
    const result = verifyOtpSchema.safeParse(req.body);
    if (!result.success) {
        res.status(400).json({ error: 'Invalid input', details: result.error.errors });
        return;
    }
    const { phone, otp, role } = result.data;
    if (otp !== '123456' && env_js_1.ENV.NODE_ENV !== 'production') {
        res.status(400).json({ error: 'Invalid verification code' });
        return;
    }
    const user = {
        id: `user_${Date.now()}`,
        phone,
        role,
    };
    const accessToken = jsonwebtoken_1.default.sign(user, env_js_1.ENV.JWT_ACCESS_SECRET, { expiresIn: '1d' });
    const refreshToken = jsonwebtoken_1.default.sign({ id: user.id }, env_js_1.ENV.JWT_REFRESH_SECRET, { expiresIn: '7d' });
    res.json({
        user,
        accessToken,
        refreshToken,
    });
});
