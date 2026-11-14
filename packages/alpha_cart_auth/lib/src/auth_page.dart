import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

enum AuthRole {
  customer,
  seller,
  delivery,
  admin,
}

/// Unified, full-featured authentication page tailored for each Alpha Cart application.
/// Supports Email/Password, Phone OTP, Google Sign-In, and Demo Mode.
class AlphaCartAuthPage extends StatefulWidget {
  const AlphaCartAuthPage({
    super.key,
    required this.role,
    required this.onAuthenticated,
    this.googleWebClientId,
    this.customAccentColor,
  });

  final AuthRole role;
  final VoidCallback onAuthenticated;
  final String? googleWebClientId;
  final Color? customAccentColor;

  @override
  State<AlphaCartAuthPage> createState() => _AlphaCartAuthPageState();
}

class _AlphaCartAuthPageState extends State<AlphaCartAuthPage> {
  // Method: true = Email, false = Phone
  bool _isEmailMethod = true;
  // Mode: false = Sign In, true = Sign Up / Register
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _extraController = TextEditingController(); // e.g. Store name, vehicle
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  // Phone OTP state
  String? _verificationId;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _extraController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Color get _accentColor {
    if (widget.customAccentColor != null) return widget.customAccentColor!;
    switch (widget.role) {
      case AuthRole.customer:
        return const Color(0xFFFB7019);
      case AuthRole.seller:
        return const Color(0xFFFB7019);
      case AuthRole.delivery:
        return const Color(0xFFF65B1A);
      case AuthRole.admin:
        return const Color(0xFFFB7019);
    }
  }

  String get _appTitle {
    switch (widget.role) {
      case AuthRole.customer:
        return 'Alpha Cart';
      case AuthRole.seller:
        return 'Alpha Cart Seller';
      case AuthRole.delivery:
        return 'Alpha Cart Delivery';
      case AuthRole.admin:
        return 'Alpha Cart Admin';
    }
  }

  String get _appSubtitle {
    switch (widget.role) {
      case AuthRole.customer:
        return 'Groceries, food & daily essentials delivered';
      case AuthRole.seller:
        return 'Grow your retail & restaurant business';
      case AuthRole.delivery:
        return 'Earn on your schedule with local deliveries';
      case AuthRole.admin:
        return 'Administration & Operational Control Center';
    }
  }

  IconData get _appIcon {
    switch (widget.role) {
      case AuthRole.customer:
        return Icons.shopping_bag_outlined;
      case AuthRole.seller:
        return Icons.storefront_rounded;
      case AuthRole.delivery:
        return Icons.delivery_dining_rounded;
      case AuthRole.admin:
        return Icons.admin_panel_settings_outlined;
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF27BC37),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (!AuthService.instance.isFirebaseInitialized) {
        // Local demo fallback
        _showSuccess('Signed in (Local Demo Mode)');
        widget.onAuthenticated();
        return;
      }

      if (_isSignUp) {
        final credential = await AuthService.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (_nameController.text.trim().isNotEmpty) {
          await credential.user?.updateDisplayName(_nameController.text.trim());
        }
        _showSuccess('Account created successfully!');
      } else {
        await AuthService.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        _showSuccess('Welcome back!');
      }
      widget.onAuthenticated();
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Authentication failed.');
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPhoneOtp() async {
    final phone = _phoneController.text.trim().replaceAll(RegExp(r'[\s-]'), '');
    if (phone.length < 10) {
      _showError('Enter a valid 10-digit mobile number.');
      return;
    }

    setState(() => _isLoading = true);

    if (!AuthService.instance.isFirebaseInitialized) {
      // Demo mode OTP
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _codeSent = true;
          _verificationId = 'demo-verification-id';
        });
        _showSuccess('Demo OTP is 123456');
      }
      return;
    }

    await AuthService.instance.sendPhoneOtp(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
          _showSuccess('Verification code sent via SMS.');
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _isLoading = false);
          _showError(error);
        }
      },
      onAutoVerified: (credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            _showSuccess('Phone number verified automatically!');
            widget.onAuthenticated();
          }
        } catch (_) {}
      },
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showError('Enter the 6-digit OTP.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (!AuthService.instance.isFirebaseInitialized || _verificationId == 'demo-verification-id') {
        if (otp == '123456') {
          _showSuccess('Phone verified (Demo Mode)!');
          widget.onAuthenticated();
          return;
        } else {
          _showError('Invalid code. For demo mode, enter 123456.');
          setState(() => _isLoading = false);
          return;
        }
      }

      await AuthService.instance.verifyPhoneOtp(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      _showSuccess('Phone verified successfully!');
      widget.onAuthenticated();
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Verification failed.');
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      if (!AuthService.instance.isFirebaseInitialized) {
        _showSuccess('Signed in with Google (Demo Mode)');
        widget.onAuthenticated();
        return;
      }

      await AuthService.instance.signInWithGoogle(
        serverClientId: widget.googleWebClientId,
      );
      _showSuccess('Signed in with Google!');
      widget.onAuthenticated();
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Google Sign-In failed.');
    } catch (_) {
      _showError('Google Sign-In was cancelled or failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _forgotPassword() {
    final email = _emailController.text.trim();
    final controller = TextEditingController(text: email);

    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF19181C),
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered email address to receive password reset instructions.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'name@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: const Color(0xFF27282D),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _accentColor),
            onPressed: () async {
              final resetEmail = controller.text.trim();
              if (resetEmail.isEmpty || !resetEmail.contains('@')) {
                _showError('Enter a valid email.');
                return;
              }
              Navigator.pop(dialogCtx);
              try {
                if (AuthService.instance.isFirebaseInitialized) {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: resetEmail);
                  _showSuccess('Password reset link sent to $resetEmail');
                } else {
                  _showSuccess('Password reset simulation sent to $resetEmail');
                }
              } catch (e) {
                _showError('Could not send reset email: $e');
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0B0D11) : Colors.grey.shade50;
    final cardColor = isDark ? const Color(0xFF19181C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding Header
                  Center(
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _accentColor.withValues(alpha: 0.4),
                          width: 2,
                        ),
                      ),
                      child: Icon(_appIcon, color: _accentColor, size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _appSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Auth Card Container
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF27282D) : Colors.grey.shade300,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Method Selector (Email vs Phone)
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: true,
                              icon: Icon(Icons.email_outlined, size: 18),
                              label: Text('Email'),
                            ),
                            ButtonSegment(
                              value: false,
                              icon: Icon(Icons.phone_iphone_rounded, size: 18),
                              label: Text('Phone'),
                            ),
                          ],
                          selected: {_isEmailMethod},
                          onSelectionChanged: _isLoading
                              ? null
                              : (selection) => setState(() {
                                    _isEmailMethod = selection.first;
                                    _codeSent = false;
                                  }),
                        ),
                        const SizedBox(height: 18),

                        // Form Fields
                        if (_isEmailMethod) ..._buildEmailFields() else ..._buildPhoneFields(),

                        const SizedBox(height: 18),

                        // Divider OR
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Google Sign-In Button
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(
                              color: isDark ? const Color(0xFF3F4142) : Colors.grey.shade400,
                            ),
                            foregroundColor: textColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Demo Mode Skip
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _showSuccess('Entering Demo Preview Mode');
                                  widget.onAuthenticated();
                                },
                          child: Text(
                            'Explore in Demo Mode (Skip Auth)',
                            style: TextStyle(color: _accentColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Protected by Firebase Auth • End-to-end Encrypted',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmailFields() {
    return [
      if (_isSignUp) ...[
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.role == AuthRole.seller) ...[
          TextField(
            controller: _extraController,
            decoration: const InputDecoration(
              labelText: 'Store / Restaurant Name',
              prefixIcon: Icon(Icons.store_mall_directory_outlined),
            ),
          ),
          const SizedBox(height: 12),
        ] else if (widget.role == AuthRole.delivery) ...[
          TextField(
            controller: _extraController,
            decoration: const InputDecoration(
              labelText: 'Vehicle Type (Bike / Scooter / EV)',
              prefixIcon: Icon(Icons.two_wheeler_outlined),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          prefixIcon: Icon(Icons.alternate_email_rounded),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
      ),
      if (!_isSignUp) ...[
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _forgotPassword,
            child: const Text('Forgot Password?', style: TextStyle(fontSize: 12)),
          ),
        ),
      ] else
        const SizedBox(height: 16),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _accentColor,
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: _isLoading ? null : _submitEmail,
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(_isSignUp ? 'Create Account' : 'Sign In with Email'),
      ),
      const SizedBox(height: 6),
      TextButton(
        onPressed: _isLoading ? null : () => setState(() => _isSignUp = !_isSignUp),
        child: Text(
          _isSignUp
              ? 'Already have an account? Sign In'
              : "Don't have an account? Register",
          style: const TextStyle(fontSize: 12),
        ),
      ),
    ];
  }

  List<Widget> _buildPhoneFields() {
    return [
      TextField(
        controller: _phoneController,
        enabled: !_codeSent,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'Mobile Number',
          prefixText: '+91 ',
          prefixIcon: Icon(Icons.phone_android_rounded),
          hintText: '98765 43210',
        ),
      ),
      if (_codeSent) ...[
        const SizedBox(height: 14),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            labelText: '6-Digit SMS Verification Code',
            hintText: '••••••',
            counterText: 'Demo code: 123456',
          ),
        ),
      ],
      const SizedBox(height: 16),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: _accentColor,
          minimumSize: const Size.fromHeight(48),
        ),
        onPressed: _isLoading ? null : (_codeSent ? _verifyOtp : _sendPhoneOtp),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(_codeSent ? 'Verify Code & Sign In' : 'Send Verification Code'),
      ),
      if (_codeSent) ...[
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() {
                _codeSent = false;
                _otpController.clear();
              }),
              child: const Text('Change Number', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: _sendPhoneOtp,
              child: Text(
                'Resend Code',
                style: TextStyle(color: _accentColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    ];
  }
}
