import 'package:flutter/material.dart';


var theme =
ThemeData(
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      backgroundColor: Colors.white
  ),

//기본 글자 색 설정
  textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black)
  ),

//바텀바 색 설정
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      // 배경색
      selectedItemColor: Colors.black,
      // 선택된 아이템의 색상
      unselectedItemColor: Colors.black45,
      // 선택되지 않은 아이템의 색상
      selectedIconTheme: IconThemeData(size: 30),
      // 선택된 아이템 아이콘 크기
      unselectedIconTheme: IconThemeData(size: 24),
      // 선택되지 않은 아이템 아이콘 크기
//바텀바 라벨 설정
      selectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.blue, // 선택된 라벨 색상
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.grey, // 선택되지 않은 라벨 색상
      )),



  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
);

var searchButtonTheme=
ThemeData(elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white, // 버튼 배경색
    foregroundColor: Colors.black, // 버튼 텍스트 색상
    //padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // 내부 여백
    //textStyle: const TextStyle(
    //  fontSize: 16,
    //  fontWeight: FontWeight.bold,
    //), // 텍스트 스타일
    minimumSize: Size(200,50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // 버튼 모서리 곡선
    ),
    elevation: 1, // 버튼 그림자 높이
  ),
),);