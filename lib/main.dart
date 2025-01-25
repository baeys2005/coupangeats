import 'package:coupangeats/login/main_signupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';// firebase_options.dart 파일에서 Firebase 설정을 가져옵니다.
import 'package:coupangeats/homepage/homePage.dart';
import 'package:coupangeats/login/main_LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Firebase 초기화 전에 이미 초기화된 앱이 있는지 확인
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp( // 자동 설정된 Firebase 옵션 사용
      );
    }
    runApp(const MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      title: 'coupangeats',
      initialRoute: '/signup',
      routes: {
        '/' :(context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
