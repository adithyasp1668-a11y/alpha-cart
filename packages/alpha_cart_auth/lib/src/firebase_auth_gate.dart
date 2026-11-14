import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_page.dart';
import 'auth_service.dart';

/// Authentication gate shared by all Alpha Cart Flutter applications.
///
/// Ensures a user is signed in before viewing the app.
/// Displays an app-branded authentication page (Email, Phone OTP, Google)
/// when the user is not authenticated.
class FirebaseAuthGate extends StatefulWidget {
  const FirebaseAuthGate({
    super.key,
    required this.child,
    required this.appName,
    required this.accentColor,
    this.role = AuthRole.customer,
    this.googleWebClientId,
  });

  final Widget child;
  final String appName;
  final Color accentColor;
  final AuthRole role;
  final String? googleWebClientId;

  @override
  State<FirebaseAuthGate> createState() => _FirebaseAuthGateState();
}

class _FirebaseAuthGateState extends State<FirebaseAuthGate> {
  bool _bypassAuth = false;

  @override
  Widget build(BuildContext context) {
    if (_bypassAuth) return widget.child;

    if (!AuthService.instance.isFirebaseInitialized) {
      // When Firebase is not initialized, still show full auth page in Demo mode
      return AlphaCartAuthPage(
        role: widget.role,
        customAccentColor: widget.accentColor,
        googleWebClientId: widget.googleWebClientId,
        onAuthenticated: () {
          if (mounted) setState(() => _bypassAuth = true);
        },
      );
    }

    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return widget.child;
        }
        return AlphaCartAuthPage(
          role: widget.role,
          customAccentColor: widget.accentColor,
          googleWebClientId: widget.googleWebClientId,
          onAuthenticated: () {
            if (mounted) setState(() => _bypassAuth = true);
          },
        );
      },
    );
  }
}
