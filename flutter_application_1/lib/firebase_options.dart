import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCPCBzjrH7x4ZYlwra0baHjHEojeFQQA64",
    authDomain: "gatito-d4535.firebaseapp.com",
    projectId: "gatito-d4535",
    storageBucket: "gatito-d4535.appspot.com",
    messagingSenderId: "1015018475440",
    appId: "1:1015018475440:web:ccddd73d927d0888e51075",
    measurementId: "G-XK3XNN3EWK"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: 'APP_ID',
    messagingSenderId: 'SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: 'APP_ID',
    messagingSenderId: 'SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    iosBundleId: 'IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: 'APP_ID',
    messagingSenderId: 'SENDER_ID',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    iosBundleId: 'IOS_BUNDLE_ID',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'API_KEY',
    appId: 'APP_ID',
    messagingSenderId: 'SENDER_ID',
    projectId: 'PROJECT_ID',
    authDomain: 'AUTH_DOMAIN',
    storageBucket: 'STORAGE_BUCKET',
    measurementId: 'MEASUREMENT_ID',
  );
}
