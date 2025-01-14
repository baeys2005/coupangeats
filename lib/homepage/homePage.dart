import 'package:flutter/material.dart';
//하연수정중 ~ 

//파일 임포트
import 'home_search.dart';
import 'home_fooldtile.dart';
import 'home_wowad.dart';


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
        leading: Icon(Icons.location_on_outlined,color: Colors.yellow,),
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
          SliverToBoxAdapter(child: adImage())
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

