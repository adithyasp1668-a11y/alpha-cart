import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'seller/seller_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final options = DefaultFirebaseOptions.currentPlatform;
  if (options.apiKey.isEmpty || options.appId.isEmpty || options.projectId.isEmpty) {
    throw StateError(
      'Firebase is not configured. Fill .environment and run with '
      '--dart-define-from-file=../../.environment.',
    );
  }
  await Firebase.initializeApp(
    options: options,
  );
  runApp(const AlphaCartSellerApp());
}
