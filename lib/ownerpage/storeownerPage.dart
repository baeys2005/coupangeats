import 'package:coupangeats/ownerpage/owner_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/theme.dart';

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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '배윤선 사장님',
                  style: pagetitle1,
                ),
                //여기서 오류남 긍아ㅏ앙ㄱ
                SizedBox(
                  height: 20,
                ),
                Text(
                  '맛있는카레집',
                  style: pagetitle1,
                ),
                //여기서 오류남 긍아ㅏ앙ㄱ
                SizedBox(
                  height: 20,
                ),
                Text(
                  'beayes@naver.com',
                  style: pagebody1,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '010-****-****',
                  style: pagebody1,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Expanded(
                child: Container(
              width: double.infinity,
              color: Colors.black26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () { Navigator.push(context,
                          MaterialPageRoute(builder: (c){
                            return OwnerMenu();
                          }
                          )
                      );},
                      child: Column(
                        children: [
                          Icon(Icons.menu_book),
                          Text('메뉴관리'),
                        ],
                      ),
                      style: buttonsizefix),
                  ElevatedButton(
                    onPressed: () {},
                    child:
                    Column(
                      children: [
                        Icon(Icons.monetization_on_outlined),
                        Text('수익관리'),
                      ],
                    ),
                    style: buttonsizefix,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Column(
                      children: [
                        Icon(Icons.store_mall_directory_outlined),
                        Text('가게설정'),
                      ],
                    ),
                    style: buttonsizefix,
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

var buttonsizefix = ElevatedButton.styleFrom(
  fixedSize: Size(100, 100), // 정사각형 크기
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5), // 모서리를 각지게 설정
  ),
);
