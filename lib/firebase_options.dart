// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD3sqGKEKX-VuatQmNQrEmhi6FOkVQRV7A',
    appId: '1:477058641131:web:ae4529052a39ed497c62ae',
    messagingSenderId: '477058641131',
    projectId: 'flutter-ecommerce-api',
    authDomain: 'flutter-ecommerce-api.firebaseapp.com',
    storageBucket: 'flutter-ecommerce-api.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCH-GoN3GO8XfcQ7bjOjAFiCvfiUb_6Zk',
    appId: '1:477058641131:android:30b1e767f7df46b87c62ae',
    messagingSenderId: '477058641131',
    projectId: 'flutter-ecommerce-api',
    storageBucket: 'flutter-ecommerce-api.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBkbLPLaplVcad2z3cU2huxQbNEtyYn0lc',
    appId: '1:477058641131:ios:f1bb00b41714348c7c62ae',
    messagingSenderId: '477058641131',
    projectId: 'flutter-ecommerce-api',
    storageBucket: 'flutter-ecommerce-api.appspot.com',
    iosBundleId: 'fr.imnibis.EcommerceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBkbLPLaplVcad2z3cU2huxQbNEtyYn0lc',
    appId: '1:477058641131:ios:799b6a53519a13ab7c62ae',
    messagingSenderId: '477058641131',
    projectId: 'flutter-ecommerce-api',
    storageBucket: 'flutter-ecommerce-api.appspot.com',
    iosBundleId: 'com.example.ecommerceApp.RunnerTests',
  );
}