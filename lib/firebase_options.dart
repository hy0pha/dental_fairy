// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDr-UBTte_tHNEyvSZjfDsU3tNaFgmUkRU',
    appId: '1:588035959773:web:f33c2d0b74eef9dbe2a434',
    messagingSenderId: '588035959773',
    projectId: 'capstonedesign2-d8752',
    authDomain: 'capstonedesign2-d8752.firebaseapp.com',
    databaseURL: 'https://capstonedesign2-d8752-default-rtdb.firebaseio.com',
    storageBucket: 'capstonedesign2-d8752.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA09og9yKzWN-gE8nivIs6Kq65cV7oxdVY',
    appId: '1:588035959773:android:c546232071924a92e2a434',
    messagingSenderId: '588035959773',
    projectId: 'capstonedesign2-d8752',
    databaseURL: 'https://capstonedesign2-d8752-default-rtdb.firebaseio.com',
    storageBucket: 'capstonedesign2-d8752.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDE9X5600B7CiVT6CAqScuASxZJHmoUtE8',
    appId: '1:588035959773:ios:091db2693f36df78e2a434',
    messagingSenderId: '588035959773',
    projectId: 'capstonedesign2-d8752',
    databaseURL: 'https://capstonedesign2-d8752-default-rtdb.firebaseio.com',
    storageBucket: 'capstonedesign2-d8752.appspot.com',
    androidClientId: '588035959773-am0645gnsknm1g1qqhfvde9a3ijpi9si.apps.googleusercontent.com',
    iosClientId: '588035959773-scjikqbhnt09lhqksrkfiilkieoggq9t.apps.googleusercontent.com',
    iosBundleId: 'com.example.capstone2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDE9X5600B7CiVT6CAqScuASxZJHmoUtE8',
    appId: '1:588035959773:ios:091db2693f36df78e2a434',
    messagingSenderId: '588035959773',
    projectId: 'capstonedesign2-d8752',
    databaseURL: 'https://capstonedesign2-d8752-default-rtdb.firebaseio.com',
    storageBucket: 'capstonedesign2-d8752.appspot.com',
    androidClientId: '588035959773-am0645gnsknm1g1qqhfvde9a3ijpi9si.apps.googleusercontent.com',
    iosClientId: '588035959773-scjikqbhnt09lhqksrkfiilkieoggq9t.apps.googleusercontent.com',
    iosBundleId: 'com.example.capstone2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDr-UBTte_tHNEyvSZjfDsU3tNaFgmUkRU',
    appId: '1:588035959773:web:b414619448ea2c87e2a434',
    messagingSenderId: '588035959773',
    projectId: 'capstonedesign2-d8752',
    authDomain: 'capstonedesign2-d8752.firebaseapp.com',
    databaseURL: 'https://capstonedesign2-d8752-default-rtdb.firebaseio.com',
    storageBucket: 'capstonedesign2-d8752.appspot.com',
  );

}