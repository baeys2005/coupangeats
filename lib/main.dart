import 'dart:math';

import 'package:coupangeats/login/main_signupPage.dart';
import 'package:coupangeats/navermapAPI/navermap_API.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // firebase_options.dart 파일에서 Firebase 설정을 가져옵니다.
import 'package:coupangeats/homepage/home_page.dart';
import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'orderpage/storeproviders/store_info_provider.dart';
import 'orderpage/storeproviders/store_menus_provider.dart';



void main() async {
  await _initialize();
  runApp(const MyApp());
}
//머지할떄 메인 지우기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized(); // 이 줄은 반드시 가장 먼저 실행되어야 함
  await NaverMapSdk.instance.initialize(
    clientId: 'h66mtiuem6',
    onAuthFailed: (e) => debugPrint("네이버맵 인증오류 : $e"),
  );


  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Firebase 옵션 추가
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<StoreProvider>(
        create: (_) => StoreProvider(),
      ),
      ChangeNotifierProvider<StoreMenusProvider>(
        create: (_) => StoreMenusProvider(),
      ),
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.white)),
      title: 'coupangeats',

      initialRoute: '/navermapAPI',

      routes: {
        '/': (context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const MainLoginpage(),
        '/MainLoginpage': (context) => const MainLoginpage(),
        '/owner': (context) => const Storeownerpage(),
        '/navermapAPI' : (context) => const NavermapApi()
      },
    );
  }
}
