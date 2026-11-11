import 'package:flutter/material.dart';

import 'screens/delivery_shell.dart';
import 'theme/delivery_theme.dart';
import 'widgets/delivery_widgets.dart';

class AlphaCartDeliveryApp extends StatelessWidget {
  const AlphaCartDeliveryApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Alpha Cart Delivery',
    debugShowCheckedModeBanner: false,
    theme: DeliveryTheme.dark,
    home: const DeliveryWelcome(),
  );
}

class DeliveryWelcome extends StatelessWidget {
  const DeliveryWelcome({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF101316), DeliveryColors.base, Color(0xFF1B100A)],
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
                  const SizedBox(height: 22),
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: DeliveryColors.card,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: DeliveryColors.orange.withValues(alpha: .2),
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
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Delivery Partner',
                    style: TextStyle(
                      color: DeliveryColors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Icon(
                    Icons.delivery_dining_rounded,
                    size: 94,
                    color: DeliveryColors.orange,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Deliver · Earn · Grow',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Earn on every delivery with clear, distance-based payouts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: DeliveryColors.muted, fontSize: 13),
                  ),
                  const SizedBox(height: 27),
                  const DeliveryClay(
                    child: Column(
                      children: [
                        DeliveryFeature(
                          icon: Icons.payments_outlined,
                          title: 'Earn on every delivery',
                        ),
                        DeliveryFeature(
                          icon: Icons.location_on_outlined,
                          title: 'Distance-based payouts',
                        ),
                        DeliveryFeature(
                          icon: Icons.bolt_rounded,
                          title: 'Real-time order requests',
                        ),
                        DeliveryFeature(
                          icon: Icons.verified_user_outlined,
                          title: 'Secure and verified work',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 23),
                  DeliveryButton(
                    label: 'Get started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DeliveryLogin()),
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

class DeliveryFeature extends StatelessWidget {
  const DeliveryFeature({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, color: DeliveryColors.orange, size: 19),
        const SizedBox(width: 11),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    ),
  );
}

class DeliveryLogin extends StatefulWidget {
  const DeliveryLogin({super.key});
  @override
  State<DeliveryLogin> createState() => _DeliveryLoginState();
}

class _DeliveryLoginState extends State<DeliveryLogin> {
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
                const DeliveryHeader(
                  title: 'Welcome back',
                  subtitle: 'Login with your mobile number',
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
                const SizedBox(height: 17),
                DeliveryButton(
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
                        builder: (_) => DeliveryOtp(phone: _phone.text.trim()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),
                const Center(
                  child: Text(
                    'By continuing, you agree to our',
                    style: TextStyle(color: DeliveryColors.muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Terms of Service  ·  Privacy Policy',
                    style: TextStyle(
                      color: DeliveryColors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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

class DeliveryOtp extends StatefulWidget {
  const DeliveryOtp({super.key, required this.phone});
  final String phone;
  @override
  State<DeliveryOtp> createState() => _DeliveryOtpState();
}

class _DeliveryOtpState extends State<DeliveryOtp> {
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
                  color: DeliveryColors.orange,
                  size: 62,
                ),
                const SizedBox(height: 17),
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
                    color: DeliveryColors.muted,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _otp,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 23,
                    letterSpacing: 12,
                  ),
                  decoration: const InputDecoration(
                    hintText: '• • • • • •',
                    counterText: 'Demo code: 123456',
                  ),
                ),
                const SizedBox(height: 18),
                DeliveryButton(
                  label: 'Verify & continue',
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
                        builder: (_) => const DeliveryKycSetup(),
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
                    style: TextStyle(color: DeliveryColors.orange),
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

class DeliveryKycSetup extends StatefulWidget {
  const DeliveryKycSetup({super.key});
  @override
  State<DeliveryKycSetup> createState() => _DeliveryKycSetupState();
}

class _DeliveryKycSetupState extends State<DeliveryKycSetup> {
  final _done = <bool>[false, false, false, false];
  static const _items = [
    ('Personal details', 'Name, address and contact', Icons.person_outline),
    (
      'Upload documents',
      'Aadhaar, PAN and driving licence',
      Icons.description_outlined,
    ),
    ('Vehicle details', 'Vehicle type and registration', Icons.two_wheeler),
    (
      'Face verification',
      'Take a clear profile photo',
      Icons.face_retouching_natural,
    ),
  ];
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
          const Icon(
            Icons.verified_user_outlined,
            color: DeliveryColors.orange,
            size: 48,
          ),
          const SizedBox(height: 13),
          const DeliveryHeader(
            title: 'Complete your profile',
            subtitle: 'Finish verification to start receiving orders',
          ),
          const SizedBox(height: 23),
          ...List.generate(
            _items.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => setState(() => _done[i] = !_done[i]),
                borderRadius: BorderRadius.circular(17),
                child: DeliveryClay(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(_items[i].$3, color: DeliveryColors.orange),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[i].$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _items[i].$2,
                              style: const TextStyle(
                                color: DeliveryColors.muted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _done[i]
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _done[i]
                            ? DeliveryColors.green
                            : DeliveryColors.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          DeliveryButton(
            label: 'Submit for verification',
            icon: Icons.verified_user_outlined,
            onPressed: () {
              if (_done.any((v) => !v)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Complete each profile step to continue.'),
                  ),
                );
                return;
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DeliveryShell()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    ),
  );
}
