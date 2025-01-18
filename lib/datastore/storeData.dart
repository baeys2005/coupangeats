import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 인스턴스
  User? _user;

  // 현재 사용자 정보 getter
  User? get user => _user;

  AuthProvider() {
    // 앱 시작 시 로그인된 사용자 초기화
    _user = _auth.currentUser;
  }

  // 회원가입 메서드
  Future<void> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user; // 새로 생성된 사용자 정보 저장
      notifyListeners(); // 상태 변경 알림
      print('Registration successful: ${_user?.email}');
    } catch (e) {
      print('Registration failed: $e');
      throw e; // 에러 전달
    }
  }

  // 로그인 메서드
  Future<void> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user; // 로그인된 사용자 정보 저장
      notifyListeners(); // 상태 변경 알림
      print('Login successful: ${_user?.email}');
    } catch (e) {
      print('Login failed: $e');
      throw e; // 에러 전달
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    await _auth.signOut();
    _user = null; // 사용자 정보 초기화
    notifyListeners(); // 상태 변경 알림
    print('Logged out successfully');
  }

//계정정보 사용예시______________________
//provider값 변수에 저장.
//변수명.user!.email
}




//가게정보 저장하기

//파이어베이스에서 가게정보 가져오기