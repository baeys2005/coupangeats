import 'package:flutter/material.dart';
//하연수정중 ~

//파일 임포트
import 'home_search.dart';
import 'home_fooldtile.dart';
import 'home_wowad.dart';
import 'home_recommatzip.dart';
import 'home_gollamukmatzip.dart';
import 'package:coupangeats/theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //홈메인 앱바
        leading: Padding(
          padding: EdgeInsets.only(left: padding1),
          child: Icon(Icons.near_me, color: Colors.yellow, size: 20),
        ),
        title: Text('서울특별시 강남구 한남자이 뭐시기 ', style: title1),
        actions: [
          Icon(Icons.expand_more, color: Colors.blue, size: 30),
          Padding(
            padding: const EdgeInsets.only(right: padding1),
            child: Icon(Icons.notifications, size: 30),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //검색 상자 부분
          SliverToBoxAdapter(child: Search()),
          //음식 상자 부분
          HomeFooldtile(),
          SliverToBoxAdapter(child: adImage()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding1*2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '이츠 추천 맛집',
                    style: title1,
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.only(left: padding1*2.5),
            child: HomeRecommatzip(),
          )),
          SliverToBoxAdapter(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding1*2.5),
                child: Text(
                  '골라먹는맛집',
                  style: title1,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding1*2.5),
            child: GollamukmatzipBar(),
          )),
          HomeGollamukmatzip()
        ],
      ),
      bottomNavigationBar:
          BottomNavigationBar(type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: '즐겨찾기'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: '주문내역'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My 이츠'),
      ]),
    );
  }
}
