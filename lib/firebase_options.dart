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
    apiKey: 'AIzaSyCu_tsV9FthtMTIXI9cxJHRWE19yHWvdvs',
    appId: '1:205377012599:web:96be24015700960b9bd772',
    messagingSenderId: '205377012599',
    projectId: 'medease-apb6',
    authDomain: 'medease-apb6.firebaseapp.com',
    storageBucket: 'medease-apb6.firebasestorage.app',
    measurementId: 'G-2MG49PFF4N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIypdCJAPY_fsSu3uuKdHiayJTxtp8_Gk',
    appId: '1:205377012599:android:307ef1f4b02b3dd59bd772',
    messagingSenderId: '205377012599',
    projectId: 'medease-apb6',
    storageBucket: 'medease-apb6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdwK_J1svPaXWHZiiQn2qeTuRz0avhjRs',
    appId: '1:205377012599:ios:1b17b6b0c7d8510a9bd772',
    messagingSenderId: '205377012599',
    projectId: 'medease-apb6',
    storageBucket: 'medease-apb6.firebasestorage.app',
    iosBundleId: 'com.example.medease',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAdwK_J1svPaXWHZiiQn2qeTuRz0avhjRs',
    appId: '1:205377012599:ios:1b17b6b0c7d8510a9bd772',
    messagingSenderId: '205377012599',
    projectId: 'medease-apb6',
    storageBucket: 'medease-apb6.firebasestorage.app',
    iosBundleId: 'com.example.medease',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCu_tsV9FthtMTIXI9cxJHRWE19yHWvdvs',
    appId: '1:205377012599:web:4fc9775552aa76be9bd772',
    messagingSenderId: '205377012599',
    projectId: 'medease-apb6',
    authDomain: 'medease-apb6.firebaseapp.com',
    storageBucket: 'medease-apb6.firebasestorage.app',
    measurementId: 'G-6VJ354MG1C',
  );
}