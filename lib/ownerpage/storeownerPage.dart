import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coupangeats/datastore/storeData.dart';
import 'package:coupangeats/login/main_LoginPage.dart';

//사장님페이지

class Storeownerpage extends StatefulWidget {
  const Storeownerpage({super.key});

  @override
  State<Storeownerpage> createState() => _StoreownerpageState();
}

class _StoreownerpageState extends State<Storeownerpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('이름'), //여기서 오류남 긍아ㅏ앙ㄱ
          Text('아이디'),
          Text('전번'),

          Image.asset(''),//사장이 등록한 사진
          Text('가게이름'),
          Text('메뉴 카테고리'),
          Text('식사'),
          Text('메뉴'),
          Text('카레')


        ],
      ),
    );
  }
}
