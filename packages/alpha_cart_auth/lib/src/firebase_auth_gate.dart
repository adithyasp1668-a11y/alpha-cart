import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication gate shared by all Alpha Cart Flutter applications.
///
/// It supports Firebase email/password, Google and phone-number sign-in,
/// with an automatic demo/preview fallback when Firebase is not yet configured.
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
  FirebaseAuth? get _auth =>
      Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null;
  final _googleSignIn = GoogleSignIn.instance;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  bool _emailMode = true;
  bool _createAccount = false;
  bool _busy = false;
  bool _bypassAuth = false;
  String? _verificationId;
  ConfirmationResult? _webConfirmation;
  late final Future<void> _googleInitialisation;

  @override
  void initState() {
    super.initState();
    _googleInitialisation = kIsWeb || Firebase.apps.isEmpty
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
      _showMessage(
          'Authentication failed. Please check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitEmail() => _run(() async {
    final auth = _auth;
    if (auth == null) {
      setState(() => _bypassAuth = true);
      return;
    }
    final email = _email.text.trim();
    if (email.isEmpty || _password.text.length < 6) {
      throw FirebaseAuthException(
        code: 'invalid-input',
        message: 'Enter a valid email and a password of at least 6 characters.',
      );
    }
    if (_createAccount) {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: _password.text,
      );
    } else {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: _password.text,
      );
    }
  });

  Future<void> _signInWithGoogle() => _run(() async {
    final auth = _auth;
    if (auth == null) {
      setState(() => _bypassAuth = true);
      return;
    }
    if (kIsWeb) {
      await auth.signInWithPopup(GoogleAuthProvider());
      return;
    }
    await _googleInitialisation;
    final account = await _googleSignIn.authenticate();
    final googleAuth = account.authentication;
    final credential =
        GoogleAuthProvider.credential(idToken: googleAuth.idToken);
    await auth.signInWithCredential(credential);
  });

  Future<void> _sendPhoneCode() => _run(() async {
    final auth = _auth;
    if (auth == null) {
      setState(() => _bypassAuth = true);
      return;
    }
    final phoneNumber = _normalisedPhone();
    if (phoneNumber.length < 10) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'Enter a valid mobile number including its country code.',
      );
    }
    if (kIsWeb) {
      _webConfirmation = await auth.signInWithPhoneNumber(phoneNumber);
      if (mounted) setState(() {});
      return;
    }
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await auth.signInWithCredential(credential);
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
    final auth = _auth;
    if (auth == null) {
      setState(() => _bypassAuth = true);
      return;
    }
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
    await auth.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      ),
    );
  });

  bool get _codeRequested =>
      kIsWeb ? _webConfirmation != null : _verificationId != null;

  @override
  Widget build(BuildContext context) {
    if (_bypassAuth) return widget.child;

    final auth = _auth;
    if (auth == null) {
      return _buildDemoModePage(context);
    }

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) return widget.child;
        return _buildSignInPage(context);
      },
    );
  }

  Widget _buildDemoModePage(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.shopping_bag_outlined,
                    color: widget.accentColor, size: 64),
                const SizedBox(height: 18),
                Text(
                  widget.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: widget.accentColor),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Demo / Local Mode active (Firebase not configured)',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => setState(() => _bypassAuth = true),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Continue in Demo Mode'),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'To enable live Firebase Auth, fill your credentials in .environment and pass --dart-define-from-file=.environment',
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
                Icon(Icons.shopping_bag_outlined,
                    color: widget.accentColor, size: 56),
                const SizedBox(height: 16),
                Text(
                  widget.appName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 27, fontWeight: FontWeight.w800),
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
                      : (selection) =>
                          setState(() => _emailMode = selection.first),
                ),
                const SizedBox(height: 18),
                if (_emailMode) ..._emailFields() else ..._phoneFields(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR',
                          style: Theme.of(context).textTheme.labelSmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _signInWithGoogle,
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continue with Google'),
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _bypassAuth = true),
                  child: const Text('Continue in Demo Mode (Skip Auth)'),
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
      decoration:
          const InputDecoration(labelText: 'Password (minimum 6 characters)'),
    ),
    const SizedBox(height: 16),
    FilledButton(
      onPressed: _busy ? null : _submitEmail,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(_createAccount ? 'Create account' : 'Sign in'),
    ),
    TextButton(
      onPressed: _busy
          ? null
          : () => setState(() => _createAccount = !_createAccount),
      child: Text(
          _createAccount ? 'I already have an account' : 'Create an account'),
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
      onPressed: _busy
          ? null
          : (_codeRequested ? _confirmPhoneCode : _sendPhoneCode),
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(_codeRequested ? 'Verify code' : 'Send verification code'),
    ),
  ];
}
