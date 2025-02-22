import 'package:coupangeats/login/main_signupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';// firebase_options.dart 파일에서 Firebase 설정을 가져옵니다.
import 'package:coupangeats/homepage/home_page.dart';
import 'package:coupangeats/login/main_LoginPage.dart';
import 'firebase_options.dart';

//머지할떄 메인 지우기
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 이 줄은 반드시 가장 먼저 실행되어야 합니다

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Firebase 옵션 추가
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      title: 'coupangeats',
      initialRoute: '/',
      routes: {
        '/' :(context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
        '/login' : (context) => const MainLoginpage(),
        '/MainLoginpage': (context) => const MainLoginpage(),
      },
    );
  }
}
