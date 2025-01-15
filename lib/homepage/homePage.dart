import 'package:flutter/material.dart';
//하연수정중 ~ 

//파일 임포트
import 'home_search.dart';
import 'home_fooldtile.dart';
import 'home_wowad.dart';
import 'home_recommatzip.dart';
import 'home_gollamukmatzip.dart';
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
        leading: Icon(Icons.near_me,color: Colors.yellow,),
          title: Text('서울특별시 강남구 한남자이 뭐시기 ',),
        actions: [
          Icon(Icons.expand_more,color: Colors.blue),
          Icon(Icons.search),
          Icon(Icons.notifications)
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '이츠 추천 맛집',
                  style: TextStyle(fontSize: 20),
                ),
                Icon(Icons.navigate_next)
              ],
            ),
          ),
          SliverToBoxAdapter(child: HomeRecommatzip()),
          SliverToBoxAdapter(child: Container(child: Text('골라먹는맛집'),),),
          HomeGollamukmatzip()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items:[
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈',),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: '즐겨찾기'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: '주문내역'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My 이츠'),
      ]
      ),
    );
  }
}

