// Generated-style Firebase options backed by --dart-define values.
// Keep actual values in the git-ignored .environment file.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Firebase is not configured for this platform.');
    }
  }

  static String get googleWebClientId => const String.fromEnvironment(
    'FIREBASE_ADMIN_WEB_CLIENT_ID',
  );

  static const web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ADMIN_WEB_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ADMIN_WEB_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_ADMIN_WEB_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_ADMIN_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_ADMIN_WEB_AUTH_DOMAIN'),
  );
  static const android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ADMIN_ANDROID_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ADMIN_ANDROID_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_ADMIN_ANDROID_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_ADMIN_PROJECT_ID'),
  );
  static const ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ADMIN_IOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ADMIN_IOS_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_ADMIN_IOS_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_ADMIN_PROJECT_ID'),
    iosBundleId: 'com.alphacart.alphacart',
  );
}
