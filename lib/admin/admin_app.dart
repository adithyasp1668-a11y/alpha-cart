import 'package:flutter/material.dart';

import 'screens/admin_pages.dart';
import 'screens/admin_shell.dart';
import 'theme/admin_theme.dart';
import 'theme/admin_theme.dart';

class AlphaCartAdminApp extends StatelessWidget {
  const AlphaCartAdminApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Alpha Cart Admin',
    debugShowCheckedModeBanner: false,
    theme: AdminTheme.dark,
    home: const AdminLoginPage(),
  );
}

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});
  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  bool _remember = true;
  bool _obscure = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 34),
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
                          color: AdminColors.orange.withValues(alpha: .15),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/alpha_cart_logo.png'),
                  ),
                ),
                const SizedBox(height: 22),
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
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Admin Console',
                    style: TextStyle(
                      color: AdminColors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to manage your business',
                  style: TextStyle(color: AdminColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 24),
                const TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    hintText: 'Email or mobile number',
                  ),
                ),
                const SizedBox(height: 13),
                TextField(
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Password',
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
                const SizedBox(height: 9),
                Row(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 34,
                      child: Checkbox(
                        value: _remember,
                        activeColor: AdminColors.orange,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Remember me',
                      style: TextStyle(fontSize: 12, color: AdminColors.muted),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password recovery will be connected with authentication.',
                              ),
                            ),
                          ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AdminColors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AdminColors.orangeLight, AdminColors.orange],
                    ),
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: AdminColors.orange.withValues(alpha: .22),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AdminShell()),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Protected admin access',
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
}
