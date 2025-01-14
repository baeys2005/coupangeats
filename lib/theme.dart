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
