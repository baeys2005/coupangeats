import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({Key? key, required this.nextScreen}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 다음 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    final Size screenSize = MediaQuery.of(context).size;

    // 화면 너비의 80%로 이미지 크기 설정
    final double imageWidth = screenSize.width * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 공간을 더 확보하여 이미지를 아래로 이동
          SizedBox(height: screenSize.height * 0.2), // 화면 높이의 20%만큼 상단 여백 추가

          // 남은 공간 중앙에 이미지 배치
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/delivery_scooter.png',
                width: imageWidth, // 화면 너비의 80%
                fit: BoxFit.contain, // 비율 유지하면서 지정된 영역에 맞추기
              ),
            ),
          ),
        ],
      ),
    );
  }
}