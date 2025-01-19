import 'package:coupangeats/login/main_LoginPage.dart';
import 'package:flutter/material.dart'; //fgggggg

import 'package:coupangeats/homepage/homePage.dart';
import 'package:coupangeats/theme.dart';
import 'package:coupangeats/ownerpage/storeownerPage.dart';
import 'package:coupangeats/login/main_LoginPage.dart';

class myeatsPage extends StatefulWidget {
  const myeatsPage({super.key});

  @override
  State<myeatsPage> createState() => _myeatsPageState();
}

class _myeatsPageState extends State<myeatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 200,
            child: Column(
              children: [
                Text(
                  '이하연',
                  style: pagetitle1,
                ),
                Text("010-****-****"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [myeatsbutton, myeatsbutton2, myeatsbutton3],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(8),
                  width: 400,
                  child: Center(child: Text('자세히보기')),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                ),
                Row(children: [
                  TextButton(onPressed: ()async{

                  await memberLogin;}, child: Text('로그인')),
                  TextButton(onPressed: () async{
                    await memberRegistration();
                  }, child: Text('회원가입'))
                ],)
              ],
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: padding1*2),
              child: Icon(
                Icons.list_alt,
                size: iconsize1,
              ),
            ),
            title: Text(
              '주소관리',
              style: pagebody1,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: padding1*2),
              child: Icon(
                Icons.favorite_border,
                size: iconsize1,
              ),
            ),
            title: Text(
              '즐겨찾기',
              style: pagebody1,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: padding1*2),
              child: Icon(
                Icons.settings,
                size: iconsize1,
              ),
            ),
            title: Text(
              '설정',
              style: pagebody1,
            ),
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(left: padding1*2),
              child: IconButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (c){
                      return Storeownerpage();
                    }
                    )
                );
              }, icon: Icon(
                Icons.store_mall_directory_outlined,
                size: iconsize1,
              ),)
            ),
            title: Text(
              '사장님페이지',
              style: pagebody1,
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomBar(),
    );
  }
}

var myeatsbutton = Column(children: [
  Text(
    '1',
    style: pagetitle1,
  ),
  Text('내가남긴리뷰',)
]);
var myeatsbutton2 = Column(children: [
  Text(
    '0',
    style: pagetitle1,
  ),
  Text('도움이 됐어요')
]);
var myeatsbutton3 = Column(children: [
  Text(
    '3',
    style: pagetitle1,
  ),
  Text('즐겨찾기')
]);
