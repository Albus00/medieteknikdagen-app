import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtd_app/navigation_not.dart';
import 'package:mtd_app/splash_page.dart';
import 'mainpage/firebase_options.dart';

//import 'api/firebase_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    //Firebase.initializeApp();
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(fontFamily: 'Barlow'),
      debugShowCheckedModeBanner: false,
      title: 'MTD',
      home: const SplashPage(),
    );
  }
}
