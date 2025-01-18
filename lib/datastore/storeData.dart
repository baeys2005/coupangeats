import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

//현재 로그인 정보 변수화(아이디, 이름
class UserProvider extends ChangeNotifier{
  User? _user;

  // 현재 사용자 정보 getter
  User? get user => _user;

  UserProvider() {
    // 앱 시작 시 현재 로그인된 사용자 가져오기
    _user = auth.currentUser;
  }

  //계정정보 사용예시______________________
  //provider값 변수에 저장.
  //변수명.user!.email

}

//가게정보 저장하기

//파이어베이스에서 가게정보 가져오기