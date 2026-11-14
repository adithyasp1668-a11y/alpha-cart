import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'clay_ui.dart';

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
    final bgColor = isDark ? const Color(0xFF0F1116) : const Color(0xFFEFF2F8);
    final cardColor = isDark ? const Color(0xFF181B22) : const Color(0xFFF7F9FC);
    final textColor = isDark ? Colors.white : const Color(0xFF1E222B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Branding Header with 3D Clay Medallion
                  Center(
                    child: ClayContainer(
                      borderRadius: 44,
                      depth: 14,
                      padding: const EdgeInsets.all(18),
                      color: isDark ? const Color(0xFF1C2029) : Colors.white,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _accentColor.withValues(alpha: 0.95),
                              _accentColor.withValues(alpha: 0.75),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(_appIcon, color: Colors.white, size: 30),
                      ),
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
                  const SizedBox(height: 6),
                  Text(
                    _appSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Clay Auth Card
                  ClayContainer(
                    borderRadius: 28,
                    depth: 16,
                    padding: const EdgeInsets.all(22),
                    color: cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Clay Method Selector Tabs
                        Row(
                          children: [
                            Expanded(
                              child: _buildClayTab(
                                title: 'Email',
                                icon: Icons.email_outlined,
                                isSelected: _isEmailMethod,
                                onTap: _isLoading
                                    ? null
                                    : () => setState(() {
                                          _isEmailMethod = true;
                                          _codeSent = false;
                                        }),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildClayTab(
                                title: 'Phone OTP',
                                icon: Icons.phone_iphone_rounded,
                                isSelected: !_isEmailMethod,
                                onTap: _isLoading
                                    ? null
                                    : () => setState(() {
                                          _isEmailMethod = false;
                                          _codeSent = false;
                                        }),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Form Fields
                        if (_isEmailMethod) ..._buildEmailFields(isDark) else ..._buildPhoneFields(isDark),

                        const SizedBox(height: 18),

                        // Divider OR
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.white12 : Colors.black12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark ? Colors.white12 : Colors.black12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Google Sign-In Button (Clay)
                        ClayButton(
                          onPressed: _isLoading ? null : _signInWithGoogle,
                          color: isDark ? const Color(0xFF222631) : Colors.white,
                          borderRadius: 18,
                          depth: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Color(0xFF4285F4),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Demo Mode Skip Pill
                        Center(
                          child: TextButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _showSuccess('Entering Demo Preview Mode');
                                    widget.onAuthenticated();
                                  },
                            icon: Icon(Icons.flash_on_rounded, size: 16, color: _accentColor),
                            label: Text(
                              'Explore in Demo Mode (Skip Auth)',
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: Colors.grey.shade500),
                      Text(
                        'Protected by Firebase Auth • End-to-end Encrypted',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClayTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback? onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _accentColor
              : (isDark ? const Color(0xFF1E222B) : const Color(0xFFE9ECF4)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.35)
                : (isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.4),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark ? Colors.black38 : const Color(0xFFC8D0E0).withValues(alpha: 0.6),
                    offset: const Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
                color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClayInputField({
    required Widget child,
    required bool isDark,
  }) {
    return ClayContainer(
      borderRadius: 16,
      depth: 4,
      isInset: true,
      color: isDark ? const Color(0xFF13151B) : const Color(0xFFEDF1F7),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: child,
    );
  }

  List<Widget> _buildEmailFields(bool isDark) {
    return [
      if (_isSignUp) ...[
        _buildClayInputField(
          isDark: isDark,
          child: TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (widget.role == AuthRole.seller) ...[
          _buildClayInputField(
            isDark: isDark,
            child: TextField(
              controller: _extraController,
              decoration: const InputDecoration(
                labelText: 'Store / Restaurant Name',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.store_mall_directory_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ] else if (widget.role == AuthRole.delivery) ...[
          _buildClayInputField(
            isDark: isDark,
            child: TextField(
              controller: _extraController,
              decoration: const InputDecoration(
                labelText: 'Vehicle Type (Bike / Scooter / EV)',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.two_wheeler_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
      _buildClayInputField(
        isDark: isDark,
        child: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.alternate_email_rounded),
          ),
        ),
      ),
      const SizedBox(height: 12),
      _buildClayInputField(
        isDark: isDark,
        child: TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
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
      ClayButton(
        color: _accentColor,
        borderRadius: 18,
        depth: 8,
        onPressed: _isLoading ? null : _submitEmail,
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                _isSignUp ? 'Create Account' : 'Sign In with Email',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _isLoading ? null : () => setState(() => _isSignUp = !_isSignUp),
        child: Text(
          _isSignUp
              ? 'Already have an account? Sign In'
              : "Don't have an account? Register",
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
        ),
      ),
    ];
  }

  List<Widget> _buildPhoneFields(bool isDark) {
    return [
      _buildClayInputField(
        isDark: isDark,
        child: TextField(
          controller: _phoneController,
          enabled: !_codeSent,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            border: InputBorder.none,
            prefixText: '+91 ',
            prefixIcon: Icon(Icons.phone_android_rounded),
            hintText: '98765 43210',
          ),
        ),
      ),
      if (_codeSent) ...[
        const SizedBox(height: 14),
        _buildClayInputField(
          isDark: isDark,
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              labelText: '6-Digit SMS Verification Code',
              border: InputBorder.none,
              hintText: '••••••',
              counterText: 'Demo code: 123456',
            ),
          ),
        ),
      ],
      const SizedBox(height: 16),
      ClayButton(
        color: _accentColor,
        borderRadius: 18,
        depth: 8,
        onPressed: _isLoading ? null : (_codeSent ? _verifyOtp : _sendPhoneOtp),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                _codeSent ? 'Verify Code & Sign In' : 'Send Verification Code',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
      ),
      if (_codeSent) ...[
        const SizedBox(height: 8),
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
                style: TextStyle(color: _accentColor, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],
    ];
  }
}
