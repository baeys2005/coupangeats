import 'package:flutter/material.dart';

//UI 함수화 .

var imgAddButton = Container(
  width: 60,
  height: 60,
  child: Icon(Icons.add),
  decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.circular(10)),
);

var menuTileDecoration =  BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black12, // 그림)자 색상 및 투명도
        spreadRadius: 2, // 그림자 확산 정도
        blurRadius: 5, // 흐림 효과
        offset: Offset(2, 4), // 그림자의 위치 (x, y)
      ),
    ],

    borderRadius: BorderRadius.circular(5),
    color: Colors.white);

var FABchild = Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      '메뉴추가',
      style: TextStyle(color: Colors.white, fontSize: 10),
    ),
    Icon(Icons.add,color: Colors.white,)
  ],
);