import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'delivery/delivery_app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.apiKey.isNotEmpty &&
        options.appId.isNotEmpty &&
        options.projectId.isNotEmpty) {
      await Firebase.initializeApp(options: options);
    } else {
      debugPrint('AlphaCart Delivery: Firebase not configured, running in local/demo mode.');
    }
  } catch (error) {
    debugPrint('AlphaCart Delivery: Firebase initialization error: $error');
  }
  runApp(const AlphaCartDeliveryApp());
}
