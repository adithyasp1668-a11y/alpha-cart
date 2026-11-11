import 'package:flutter/material.dart';

import 'models/customer_product.dart';
import 'screens/customer_shell.dart';
import 'theme/customer_theme.dart';
import 'widgets/customer_widgets.dart';

class AlphaCartCustomerApp extends StatelessWidget {
  const AlphaCartCustomerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Alpha Cart',
    debugShowCheckedModeBanner: false,
    theme: CustomerTheme.dark,
    home: const CustomerWelcome(),
  );
}

class CustomerWelcome extends StatelessWidget {
  const CustomerWelcome({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101613), CustomerColors.base, Color(0xFF1A100A)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: 95,
                    height: 95,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CustomerColors.card,
                      borderRadius: BorderRadius.circular(29),
                      boxShadow: [
                        BoxShadow(
                          color: CustomerColors.orange.withValues(alpha: .18),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/alpha_cart_logo.png'),
                  ),
                  const SizedBox(height: 17),
                  const Text(
                    'Alpha Cart',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.8,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Your everyday delivery partner',
                    style: TextStyle(color: CustomerColors.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 29),
                  const Text('🧺', style: TextStyle(fontSize: 96)),
                  const SizedBox(height: 13),
                  const Text(
                    'Everything you need\nin one app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Fresh groceries, great food and more, delivered to your door.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomerColors.muted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const CustomerClay(
                    child: Column(
                      children: [
                        WelcomeFeature(
                          emoji: '🥬',
                          title: 'Daily grocery essentials',
                        ),
                        WelcomeFeature(
                          emoji: '🍔',
                          title: 'Local restaurants and food',
                        ),
                        WelcomeFeature(
                          emoji: '🏋️',
                          title: 'Fitness and everyday needs',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  CustomerButton(
                    label: 'Get started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomerLogin()),
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

class WelcomeFeature extends StatelessWidget {
  const WelcomeFeature({super.key, required this.emoji, required this.title});
  final String emoji, title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 19)),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    ),
  );
}

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});
  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
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
                const Text(
                  'Get started',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your mobile number to continue',
                  style: TextStyle(color: CustomerColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone),
                    prefixText: '+91  ',
                    hintText: 'Mobile number',
                  ),
                ),
                const SizedBox(height: 16),
                CustomerButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
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
                        builder: (_) => CustomerOtp(phone: _phone.text.trim()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 19),
                const Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: CustomerColors.muted, fontSize: 10),
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

class CustomerOtp extends StatefulWidget {
  const CustomerOtp({super.key, required this.phone});
  final String phone;
  @override
  State<CustomerOtp> createState() => _CustomerOtpState();
}

class _CustomerOtpState extends State<CustomerOtp> {
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
                const Icon(
                  Icons.verified_user_outlined,
                  color: CustomerColors.orange,
                  size: 58,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Verify OTP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to +91 ${widget.phone}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: CustomerColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _otp,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
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
                const SizedBox(height: 16),
                CustomerButton(
                  label: 'Verify',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    if (_otp.text.trim() != '123456') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('For this preview, enter 123456.'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerLocationSetup(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('A new demo OTP is 123456.')),
                  ),
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(color: CustomerColors.orange),
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

class CustomerLocationSetup extends StatelessWidget {
  const CustomerLocationSetup({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: CustomerColors.orange,
                  size: 78,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Enable location',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 23),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Find nearby stores, restaurants and faster delivery options around you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomerColors.muted,
                    height: 1.5,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 25),
                CustomerButton(
                  label: 'Use current location',
                  icon: Icons.my_location,
                  onPressed: () => _continue(context, 'Bengaluru, Karnataka'),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _manualLocation(context),
                  icon: const Icon(Icons.edit_location_alt_outlined),
                  label: const Text('Enter manually'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: CustomerColors.line),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  void _continue(BuildContext context, String location) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => CustomerShell(location: location)),
      (_) => false,
    );
  }

  void _manualLocation(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomerColors.card,
        title: const Text('Delivery location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Area, city'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final location = controller.text.trim();
              if (location.isNotEmpty) _continue(context, location);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
