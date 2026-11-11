import 'package:flutter/material.dart';

import 'screens/seller_shell.dart';
import 'theme/seller_theme.dart';
import 'widgets/seller_widgets.dart';

class AlphaCartSellerApp extends StatelessWidget {
  const AlphaCartSellerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Alpha Cart Seller',
    debugShowCheckedModeBanner: false,
    theme: SellerTheme.dark,
    home: const SellerWelcome(),
  );
}

class SellerWelcome extends StatelessWidget {
  const SellerWelcome({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101713), SellerColors.base, Color(0xFF17100B)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    width: 106,
                    height: 106,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: SellerColors.card,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: SellerColors.orange.withValues(alpha: .2),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/alpha_cart_logo.png'),
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Alpha Cart',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Seller',
                    style: TextStyle(
                      color: SellerColors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Icon(
                    Icons.storefront_rounded,
                    size: 82,
                    color: SellerColors.orangeLight,
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    'Manage your business\non the go',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Orders, products and earnings, all in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SellerColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  SellerClay(
                    padding: const EdgeInsets.all(17),
                    child: const Column(
                      children: [
                        FeatureLine(
                          icon: Icons.store_mall_directory_outlined,
                          text: 'Open or close your shop',
                        ),
                        FeatureLine(
                          icon: Icons.receipt_long_outlined,
                          text: 'Receive and process orders',
                        ),
                        FeatureLine(
                          icon: Icons.inventory_2_outlined,
                          text: 'Manage products and stock',
                        ),
                        FeatureLine(
                          icon: Icons.payments_outlined,
                          text: 'Track your earnings',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SellerButton(
                    label: 'Get started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SellerLogin()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class FeatureLine extends StatelessWidget {
  const FeatureLine({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, color: SellerColors.orange, size: 19),
        const SizedBox(width: 11),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class SellerLogin extends StatefulWidget {
  const SellerLogin({super.key});
  @override
  State<SellerLogin> createState() => _SellerLoginState();
}

class _SellerLoginState extends State<SellerLogin> {
  final _phone = TextEditingController();
  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const SellerHeader(
                  title: 'Welcome, seller',
                  subtitle: 'Sign in to your seller account',
                ),
                const SizedBox(height: 29),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone),
                    prefixText: '+91  ',
                    hintText: 'Mobile number',
                  ),
                ),
                const SizedBox(height: 17),
                SellerButton(
                  label: 'Send OTP',
                  icon: Icons.sms_outlined,
                  onPressed: () {
                    if (_phone.text.trim().length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter a 10-digit mobile number.'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SellerOtp(phone: _phone.text.trim()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 19),
                const Center(
                  child: Text(
                    'or',
                    style: TextStyle(color: SellerColors.muted),
                  ),
                ),
                const SizedBox(height: 17),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Email sign-in will be connected with the backend.',
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Continue with email'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(color: SellerColors.line),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 26),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'New to Alpha Cart? ',
                        style: TextStyle(
                          color: SellerColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SellerBusinessSetup(),
                          ),
                        ),
                        child: const Text(
                          'Register your shop',
                          style: TextStyle(
                            color: SellerColors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
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

class SellerOtp extends StatefulWidget {
  const SellerOtp({super.key, required this.phone});
  final String phone;
  @override
  State<SellerOtp> createState() => _SellerOtpState();
}

class _SellerOtpState extends State<SellerOtp> {
  final _otp = TextEditingController();
  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.verified_user_rounded,
                  size: 64,
                  color: SellerColors.orange,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Verify your number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to +91 ${widget.phone}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SellerColors.muted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 26),
                TextField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 12,
                  ),
                  decoration: const InputDecoration(
                    hintText: '• • • • • •',
                    counterText: 'Demo code: 123456',
                  ),
                ),
                const SizedBox(height: 18),
                SellerButton(
                  label: 'Verify & continue',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_otp.text.trim() != '123456') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'For this frontend preview, enter 123456.',
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SellerBusinessSetup(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('A new demo OTP is 123456.')),
                  ),
                  child: const Text(
                    'Resend code',
                    style: TextStyle(color: SellerColors.orange),
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

class SellerBusinessSetup extends StatefulWidget {
  const SellerBusinessSetup({super.key});
  @override
  State<SellerBusinessSetup> createState() => _SellerBusinessSetupState();
}

class _SellerBusinessSetupState extends State<SellerBusinessSetup> {
  String _type = 'Restaurant / Food Outlet';
  final _shopName = TextEditingController(text: 'Spice Haven');
  final _types = const [
    (
      'Restaurant / Food Outlet',
      Icons.restaurant,
      'Cafe, restaurant, food stall',
    ),
    ('Grocery Store', Icons.local_grocery_store, 'Kirana, supermarket'),
    ('Gym & Fitness Store', Icons.fitness_center, 'Supplements, apparel'),
    (
      'Use & Throw Store',
      Icons.inventory_2_outlined,
      'Plates, cups, home supplies',
    ),
  ];
  @override
  void dispose() {
    _shopName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      ),
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
        children: [
          const SellerHeader(
            title: 'Set up your shop',
            subtitle: 'A few details to get your business started',
          ),
          const SizedBox(height: 22),
          const Text(
            'Shop name',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _shopName,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.storefront_outlined),
              hintText: 'Your business name',
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Choose your business type',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ..._types.map(
            (type) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _BusinessTypeTile(
                title: type.$1,
                detail: type.$3,
                icon: type.$2,
                selected: _type == type.$1,
                onTap: () => setState(() => _type = type.$1),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SellerButton(
            label: 'Continue',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              if (_shopName.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter your shop name to continue.'),
                  ),
                );
                return;
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => SellerShell(
                    shopName: _shopName.text.trim(),
                    businessType: _type,
                  ),
                ),
                (_) => false,
              );
            },
          ),
        ],
      ),
    ),
  );
}

class _BusinessTypeTile extends StatelessWidget {
  const _BusinessTypeTile({
    required this.title,
    required this.detail,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String title, detail;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(18),
    child: SellerClay(
      color: selected ? const Color(0xFF36200F) : SellerColors.card,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            icon,
            color: selected ? SellerColors.orange : SellerColors.muted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    color: SellerColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            color: selected ? SellerColors.orange : SellerColors.muted,
            size: 19,
          ),
        ],
      ),
    ),
  );
}
