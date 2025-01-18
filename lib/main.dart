import 'package:coupangeats/homepage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:provider/provider.dart';

import 'package:coupangeats/theme.dart';

import 'datastore/storeData.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(//엥이게 왜됨 수동 설정인데
        apiKey: "AIzaSyCPKtaK1ERoSOtEZAmJUWhzQQtH-YYi9ts",
        appId: "1:839797760219:android:73c0ea4e58ff61f165ecfe",
        messagingSenderId: "839797760219",
        projectId: "coupangeats-5897c",
        storageBucket: "coupangeats-5897c.firebasestorage.app",
      ),
    );
    runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => UserProvider())],child: const MyApp()));
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: Homepage(),
    );
  }
}
