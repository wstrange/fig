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
    apiKey: 'AIzaSyAniF2swtIkxCkIdJvnv3ih24DjcmfcPjM',
    appId: '1:932931691792:web:e6851570401988df7df195',
    messagingSenderId: '932931691792',
    projectId: 'figexample',
    authDomain: 'figexample.firebaseapp.com',
    storageBucket: 'figexample.appspot.com',
    measurementId: 'G-NVEG09QZDM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAaU5aaOPCJ29BexLmWUQLEDX4Lm6-hKkA',
    appId: '1:932931691792:android:cd0581e1b0de0a387df195',
    messagingSenderId: '932931691792',
    projectId: 'figexample',
    storageBucket: 'figexample.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcMvEcCmiXFVTysnojo8hlQPjjp8Y0d-8',
    appId: '1:932931691792:ios:aca00b47f61515c87df195',
    messagingSenderId: '932931691792',
    projectId: 'figexample',
    storageBucket: 'figexample.appspot.com',
    androidClientId: '932931691792-mqaqgg1qjugqh6m7m2ah9cgt31kug4n2.apps.googleusercontent.com',
    iosClientId: '932931691792-ncnemn2t9r7j2mgko11i2apnjn3d6q0i.apps.googleusercontent.com',
    iosBundleId: 'com.example.example',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcMvEcCmiXFVTysnojo8hlQPjjp8Y0d-8',
    appId: '1:932931691792:ios:62d5393db50447a17df195',
    messagingSenderId: '932931691792',
    projectId: 'figexample',
    storageBucket: 'figexample.appspot.com',
    androidClientId: '932931691792-mqaqgg1qjugqh6m7m2ah9cgt31kug4n2.apps.googleusercontent.com',
    iosClientId: '932931691792-k8co3sdl71i3l1tmdj7u67c2rgj41s91.apps.googleusercontent.com',
    iosBundleId: 'com.example.example.RunnerTests',
  );
}
