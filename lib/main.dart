import 'package:coupangeats/login/main_signupPage.dart';
import 'package:coupangeats/orderpage/order_cart/how_many_food.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';
import 'package:coupangeats/providers/user_info_provider.dart';
import 'package:coupangeats/switch_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // firebase_options.dart 파일에서 Firebase 설정을 가져옵니다.
import 'package:coupangeats/homepage/home_page.dart';
import 'package:coupangeats/login/main_LoginPage.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/store_info_provider.dart';
import 'providers/store_menus_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_info_provider.dart';


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
      // ChangeNotifierProvider(
      //   create: (_) {
      //     final userInfoProvider =UserInfoProvider();
      //     userInfoProvider.loadUserInfo();
      //     return userInfoProvider;
      //   }
      // ),
      ChangeNotifierProvider(
          create: (_) => CartProvider())
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

      initialRoute: '/',

      routes: {
        '/': (context) => const Homepage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const MainLoginpage(),
        '/MainLoginpage': (context) => const MainLoginpage(),
        '/owner': (context) => const Storeownerpage(),
        '/Howmanyfood': (context) => const HowManyFood()
      },
    );
  }
}
