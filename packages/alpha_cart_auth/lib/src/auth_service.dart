import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Centralized service handling Firebase Authentication across all Alpha Cart apps.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth? get _auth =>
      Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null;

  bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

  User? get currentUser => _auth?.currentUser;

  Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? Stream.value(null);

  /// Signs in with Email and Password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Firebase is not initialized.',
      );
    }
    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getReadableErrorMessage(e),
      );
    }
  }

  /// Creates a new user account with Email and Password.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Firebase is not initialized.',
      );
    }
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getReadableErrorMessage(e),
      );
    }
  }

  /// Sends phone verification OTP.
  Future<void> sendPhoneOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
    Function(PhoneAuthCredential credential)? onAutoVerified,
  }) async {
    final auth = _auth;
    if (auth == null) {
      onError('Firebase is not initialized.');
      return;
    }
    final formattedPhone = phoneNumber.startsWith('+')
        ? phoneNumber
        : '+91${phoneNumber.replaceAll(RegExp(r'[\s-]'), '')}';

    try {
      if (kIsWeb) {
        final confirmation = await auth.signInWithPhoneNumber(formattedPhone);
        onCodeSent(confirmation.verificationId);
        return;
      }

      await auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (credential) async {
          if (onAutoVerified != null) {
            onAutoVerified(credential);
          } else {
            await auth.signInWithCredential(credential);
          }
        },
        verificationFailed: (error) {
          onError(_getReadableErrorMessage(error));
        },
        codeSent: (verificationId, _) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          onCodeSent(verificationId);
        },
      );
    } on FirebaseAuthException catch (e) {
      onError(_getReadableErrorMessage(e));
    } catch (e) {
      onError('Failed to send verification code. Please try again.');
    }
  }

  /// Verifies SMS OTP code and completes phone sign-in.
  Future<UserCredential> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Firebase is not initialized.',
      );
    }
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      );
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getReadableErrorMessage(e),
      );
    }
  }

  /// Google Sign-In authentication.
  Future<UserCredential> signInWithGoogle({String? serverClientId}) async {
    final auth = _auth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'firebase-not-configured',
        message: 'Firebase is not initialized.',
      );
    }
    try {
      if (kIsWeb) {
        return await auth.signInWithPopup(GoogleAuthProvider());
      }
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: (serverClientId != null && serverClientId.isNotEmpty)
            ? serverClientId
            : null,
      );
      final account = await googleSignIn.authenticate();
      final googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getReadableErrorMessage(e),
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google Sign-In failed or was cancelled.',
      );
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    }
  }

  String _getReadableErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-phone-number':
        return 'Invalid phone number format.';
      case 'invalid-verification-code':
        return 'Invalid 6-digit verification code.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }
}
