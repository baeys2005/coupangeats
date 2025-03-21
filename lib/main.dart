import 'dart:developer';

import 'package:coupangeats/floatingpage/splashscreen.dart';
import 'package:coupangeats/login/main_signupPage.dart';
import 'package:coupangeats/orderpage/order_cart/how_many_food.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';
import 'package:coupangeats/providers/user_info_provider.dart';
import 'package:coupangeats/floatingpage/splashscreen.dart'; // 스플래시 스크린 import 추가
import 'package:coupangeats/switch_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:coupangeats/homepage/home_page.dart';
import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/store_info_provider.dart';
import 'providers/store_menus_provider.dart';
import 'providers/cart_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 이 줄은 반드시 가장 먼저 실행되어야 합니다

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Firebase 옵션 추가
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }
  await _initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StoreProvider>(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider<StoreMenusProvider>(
          create: (_) => StoreMenusProvider(),
        ),
        ChangeNotifierProvider<SwitchState>(
          create: (_) => SwitchState(),
        ),
        ChangeNotifierProvider<UserInfoProvider>(
          create: (_) => UserInfoProvider(),
        ),
        ChangeNotifierProvider(
            create: (_) => CartProvider())
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'r74ixivxx7',
      onAuthFailed: (e) => log("네이버 맵 인증오류: $e", name: "onAuthFaild")
  );
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final switchState = Provider.of<SwitchState>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              surfaceTintColor: Colors.white
          ),
          fontFamily: 'Neo Sans Pro'
      ),
      title: 'coupangeats',
      home: const SplashScreen(nextScreen: Homepage()), // 스플래시 스크린을 첫 화면으로 설정
      navigatorObservers: [routeObserver],
      routes: {
        '/home': (context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const MainLoginpage(),
        '/MainLoginpage': (context) => const MainLoginpage(),
        '/owner': (context) => const Storeownerpage(),
        '/Howmanyfood': (context) => const HowManyFood()

      },
    );
  }
}