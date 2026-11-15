import 'package:flutter/material.dart';
import 'package:alpha_cart_auth/alpha_cart_auth.dart';

import '../firebase_options.dart';
import 'screens/admin_shell.dart';
import 'screens/splash_screen.dart';
import 'theme/admin_theme.dart';

class AlphaCartAdminApp extends StatelessWidget {
  const AlphaCartAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Alpha Cart Admin',
    debugShowCheckedModeBanner: false,
    theme: AdminTheme.dark,
    home: FirebaseAuthGate(
      appName: 'Alpha Cart Admin',
      accentColor: AdminColors.orange,
      role: AuthRole.admin,
      googleWebClientId: DefaultFirebaseOptions.googleWebClientId,
      child: const AdminSplashScreen(),
    ),
  );
}

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  int _loginMode = 0; // 0 = Password, 1 = Phone OTP
  bool _remember = true;
  bool _obscure = true;
  bool _otpSent = false;

  final _identity = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _signInWithPassword() {
    if (_identity.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your admin email/ID and password.'),
        ),
      );
      return;
    }
    _grantAccess();
  }

  void _sendOtp() {
    final phone = _phone.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 10-digit mobile number.'),
        ),
      );
      return;
    }
    setState(() => _otpSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP sent to your mobile. For testing, use code: 123456'),
      ),
    );
  }

  void _verifyOtp() {
    final code = _otp.text.trim();
    if (code.isEmpty || code.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter the verification OTP code sent to your mobile.'),
        ),
      );
      return;
    }
    _grantAccess();
  }

  void _grantAccess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const AdminShell()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 92,
                    height: 92,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AdminColors.card,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AdminColors.orange.withValues(alpha: .2),
                          blurRadius: 36,
                        ),
                      ],
                      border: Border.all(
                        color: AdminColors.orange.withValues(alpha: .3),
                      ),
                    ),
                    child: Image.asset('assets/images/alpha_cart_logo.png'),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Alpha Cart',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Admin Console',
                    style: TextStyle(
                      color: AdminColors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Method Selector: Password vs Phone OTP
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AdminColors.raised,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _modeTab(
                          label: 'Password',
                          icon: Icons.lock_outline,
                          active: _loginMode == 0,
                          onTap: () => setState(() => _loginMode = 0),
                        ),
                      ),
                      Expanded(
                        child: _modeTab(
                          label: 'Phone OTP',
                          icon: Icons.sms_outlined,
                          active: _loginMode == 1,
                          onTap: () => setState(() => _loginMode = 1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                if (_loginMode == 0) ...[
                  // Password Login Form
                  const Text(
                    'Sign in with Credentials',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter your administrator credentials to access',
                    style: TextStyle(color: AdminColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _identity,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'admin@alphacart.local',
                      labelText: 'Admin Email / ID',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Password',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 32,
                        child: Checkbox(
                          value: _remember,
                          activeColor: AdminColors.orange,
                          onChanged: (value) =>
                              setState(() => _remember = value ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember me',
                        style: TextStyle(fontSize: 12, color: AdminColors.muted),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact platform super-admin to reset password.')),
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: AdminColors.orange, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _submitButton(label: 'Sign In with Password', onTap: _signInWithPassword),
                ] else ...[
                  // Phone OTP Login Form
                  const Text(
                    'Sign in with Phone OTP',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Receive a 6-digit login OTP on your registered phone',
                    style: TextStyle(color: AdminColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.phone_iphone_outlined),
                      prefixText: '+91 ',
                      hintText: '98765 43210',
                      labelText: 'Registered Mobile Number',
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (!_otpSent)
                    _submitButton(label: 'Send OTP Verification Code', onTap: _sendOtp)
                  else ...[
                    TextField(
                      controller: _otp,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.pin_outlined),
                        hintText: '123456',
                        labelText: 'Enter 6-Digit OTP',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Test OTP: 123456',
                          style: TextStyle(color: AdminColors.green, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: _sendOtp,
                          child: const Text('Resend OTP', style: TextStyle(color: AdminColors.orange, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _submitButton(label: 'Verify OTP & Access Console', onTap: _verifyOtp),
                  ],
                ],

                const SizedBox(height: 24),
                // One-tap quick demo bypass
                OutlinedButton.icon(
                  onPressed: _grantAccess,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AdminColors.line),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.flash_on_rounded, size: 18, color: AdminColors.orange),
                  label: const Text(
                    'Instant Demo Admin Access',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'End-to-end encrypted administrative console',
                    style: TextStyle(color: AdminColors.muted, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _modeTab({
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AdminColors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: active ? Colors.white : AdminColors.muted),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? Colors.white : AdminColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton({required String label, required VoidCallback onTap}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AdminColors.orangeLight, AdminColors.orange],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AdminColors.orange.withValues(alpha: .24),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ),
    );
  }
}
