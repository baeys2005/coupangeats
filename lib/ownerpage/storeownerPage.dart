import 'package:coupangeats/ownerpage/owner_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/theme.dart';

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
        margin: EdgeInsets.all(20),
        height: 500,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(height: 50,),
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
                child: Container(padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                  },
                    child: Column(children: [Icon(Icons.menu_book),
                      Text('메뉴관리'),],),
                  ),
                  GestureDetector(onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                  },
                    child: Column(children: [Icon(Icons.monetization_on_outlined),
                      Text('수익관리'),],),
                  ),GestureDetector(onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) {
                          return OwnerMenu();
                        }));
                  },
                    child: Column(children: [ Icon(Icons.store_mall_directory_outlined),
                      Text('가게설정'),],),
                  ),

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
  fixedSize: Size(60, 60), // 정사각형 크기
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5), // 모서리를 각지게 설정
  ),
);
