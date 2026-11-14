import { Router, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import { ENV } from '../../config/env.js';

export const authRouter = Router();

const loginSchema = z.object({
  phone: z.string().min(10),
  role: z.enum(['CUSTOMER', 'SELLER', 'DELIVERY', 'ADMIN']).default('CUSTOMER'),
});

const verifyOtpSchema = z.object({
  phone: z.string().min(10),
  otp: z.string().length(6),
  role: z.enum(['CUSTOMER', 'SELLER', 'DELIVERY', 'ADMIN']).default('CUSTOMER'),
});

authRouter.post('/request-otp', (req: Request, res: Response) => {
  const result = loginSchema.safeParse(req.body);
  if (!result.success) {
    res.status(400).json({ error: 'Invalid input', details: result.error.errors });
    return;
  }

  // In development/test mode, OTP is fixed demo code 123456
  res.json({
    message: 'OTP sent successfully',
    demoOtp: ENV.NODE_ENV !== 'production' ? '123456' : undefined,
  });
});

authRouter.post('/verify-otp', (req: Request, res: Response) => {
  const result = verifyOtpSchema.safeParse(req.body);
  if (!result.success) {
    res.status(400).json({ error: 'Invalid input', details: result.error.errors });
    return;
  }

  const { phone, otp, role } = result.data;
  if (otp !== '123456' && ENV.NODE_ENV !== 'production') {
    res.status(400).json({ error: 'Invalid verification code' });
    return;
  }

  const user = {
    id: `user_${Date.now()}`,
    phone,
    role,
  };

  const accessToken = jwt.sign(user, ENV.JWT_ACCESS_SECRET, { expiresIn: '1d' });
  const refreshToken = jwt.sign({ id: user.id }, ENV.JWT_REFRESH_SECRET, { expiresIn: '7d' });

  res.json({
    user,
    accessToken,
    refreshToken,
  });
});

