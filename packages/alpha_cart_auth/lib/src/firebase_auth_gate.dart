import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication gate shared by all Alpha Cart Flutter applications.
///
/// It supports Firebase email/password, Google and phone-number sign-in. The
/// phone flow changes to an OTP field after Firebase has sent the verification
/// code. On web Firebase shows and verifies reCAPTCHA as part of that flow.
class FirebaseAuthGate extends StatefulWidget {
  const FirebaseAuthGate({
    super.key,
    required this.child,
    required this.appName,
    required this.accentColor,
    this.googleWebClientId,
  });

  final Widget child;
  final String appName;
  final Color accentColor;
  final String? googleWebClientId;

  @override
  State<FirebaseAuthGate> createState() => _FirebaseAuthGateState();
}

class _FirebaseAuthGateState extends State<FirebaseAuthGate> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  bool _emailMode = true;
  bool _createAccount = false;
  bool _busy = false;
  String? _verificationId;
  ConfirmationResult? _webConfirmation;
  late final Future<void> _googleInitialisation;

  @override
  void initState() {
    super.initState();
    _googleInitialisation = kIsWeb
        ? Future.value()
        : _googleSignIn.initialize(
            serverClientId: _emptyToNull(widget.googleWebClientId),
          );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  String? _emptyToNull(String? value) =>
      value == null || value.isEmpty ? null : value;

  String _normalisedPhone() {
    final value = _phone.text.trim().replaceAll(RegExp(r'[\s-]'), '');
    return value.startsWith('+') ? value : '+91$value';
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on FirebaseAuthException catch (error) {
      _showMessage(error.message ?? 'Authentication failed. Please try again.');
    } catch (_) {
      _showMessage('Authentication failed. Please check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitEmail() => _run(() async {
    final email = _email.text.trim();
    if (email.isEmpty || _password.text.length < 6) {
      throw FirebaseAuthException(
        code: 'invalid-input',
        message: 'Enter a valid email and a password of at least 6 characters.',
      );
    }
    if (_createAccount) {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: _password.text,
      );
    } else {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: _password.text,
      );
    }
  });

  Future<void> _signInWithGoogle() => _run(() async {
    if (kIsWeb) {
      await _auth.signInWithPopup(GoogleAuthProvider());
      return;
    }
    await _googleInitialisation;
    final GoogleSignInAccount? account = await _googleSignIn.authenticate();
    if (account == null) return;
    final googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
    await _auth.signInWithCredential(credential);
  });

  Future<void> _sendPhoneCode() => _run(() async {
    final phoneNumber = _normalisedPhone();
    if (phoneNumber.length < 10) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'Enter a valid mobile number including its country code.',
      );
    }
    if (kIsWeb) {
      _webConfirmation = await _auth.signInWithPhoneNumber(phoneNumber);
      if (mounted) setState(() {});
      return;
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (error) => _showMessage(
        error.message ?? 'Could not send the verification code.',
      ),
      codeSent: (verificationId, _) {
        if (mounted) setState(() => _verificationId = verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (mounted && _verificationId == null) {
          setState(() => _verificationId = verificationId);
        }
      },
    );
  });

  Future<void> _confirmPhoneCode() => _run(() async {
    final code = _otp.text.trim();
    if (code.length != 6) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message: 'Enter the 6-digit verification code.',
      );
    }
    if (kIsWeb) {
      final confirmation = _webConfirmation;
      if (confirmation == null) throw StateError('Request a code first.');
      await confirmation.confirm(code);
      return;
    }
    final verificationId = _verificationId;
    if (verificationId == null) throw StateError('Request a code first.');
    await _auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      ),
    );
  });

  bool get _codeRequested => kIsWeb ? _webConfirmation != null : _verificationId != null;

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
    stream: _auth.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (snapshot.hasData) return widget.child;
      return _buildSignInPage(context);
    },
  );

  Widget _buildSignInPage(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.shopping_bag_outlined, color: widget.accentColor, size: 56),
                const SizedBox(height: 16),
                Text(
                  widget.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in securely to continue',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Email')),
                    ButtonSegment(value: false, label: Text('Phone')),
                  ],
                  selected: {_emailMode},
                  onSelectionChanged: _busy
                      ? null
                      : (selection) => setState(() => _emailMode = selection.first),
                ),
                const SizedBox(height: 18),
                if (_emailMode) ..._emailFields() else ..._phoneFields(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR', style: Theme.of(context).textTheme.labelSmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _signInWithGoogle,
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  List<Widget> _emailFields() => [
    TextField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(labelText: 'Email address'),
    ),
    const SizedBox(height: 12),
    TextField(
      controller: _password,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password (minimum 6 characters)'),
    ),
    const SizedBox(height: 16),
    FilledButton(
      onPressed: _busy ? null : _submitEmail,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(_createAccount ? 'Create account' : 'Sign in'),
    ),
    TextButton(
      onPressed: _busy ? null : () => setState(() => _createAccount = !_createAccount),
      child: Text(_createAccount ? 'I already have an account' : 'Create an account'),
    ),
  ];

  List<Widget> _phoneFields() => [
    TextField(
      controller: _phone,
      enabled: !_codeRequested,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Mobile number',
        hintText: '+91 98765 43210',
      ),
    ),
    if (_codeRequested) ...[
      const SizedBox(height: 12),
      TextField(
        controller: _otp,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: const InputDecoration(labelText: 'SMS verification code'),
      ),
    ],
    const SizedBox(height: 16),
    FilledButton(
      onPressed: _busy ? null : (_codeRequested ? _confirmPhoneCode : _sendPhoneCode),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(_codeRequested ? 'Verify code' : 'Send verification code'),
    ),
  ];
}
