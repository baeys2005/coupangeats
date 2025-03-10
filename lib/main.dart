import 'package:coupangeats/login/main_signupPage.dart';
import 'package:coupangeats/navermapAPI/navermap_API.dart';
import 'package:coupangeats/orderpage/order_cart/how_many_food.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';
import 'package:coupangeats/providers/user_info_provider.dart';
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
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  // Flutter 엔진 초기화 - 반드시 가장 먼저 실행
  WidgetsFlutterBinding.ensureInitialized();

  // 네이버 맵 SDK 초기화
  try {
    await NaverMapSdk.instance.initialize(
      clientId: 'h66mtiuem6',
      onAuthFailed: (e) => debugPrint("네이버맵 인증오류 : $e"),
    );
    debugPrint("[NaverMapSdk] SDK 초기화 성공!");
  } catch (e) {
    debugPrint("네이버맵 SDK 초기화 오류: $e");
  }

  // Firebase 중복 초기화 방지
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint("Firebase 초기화 성공!");
    } else {
      debugPrint("Firebase는 이미 초기화되어 있습니다.");
    }
  } catch (e) {
    debugPrint("Firebase 초기화 오류: $e");
  }

  // 앱 실행
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
            create: (_) => CartProvider()
        )
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
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.white),
              surfaceTintColor: Colors.white
          )
      ),
      title: 'coupangeats',
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const MainLoginpage(),
        '/MainLoginpage': (context) => const MainLoginpage(),
        '/owner': (context) => const Storeownerpage(),
        '/Howmanyfood': (context) => const HowManyFood(),
        '/navermapAPI' : (context) => const NavermapApi()
      },
    );
  }
}