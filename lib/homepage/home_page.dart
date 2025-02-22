import 'package:flutter/material.dart';
import 'home_search.dart';
import 'home_fooldtile.dart';
import 'home_wowad.dart';
import 'home_recommatzip.dart';
import 'home_gollamukmatzip.dart';
import 'package:coupangeats/theme.dart';
import 'package:coupangeats/myeatspage/myeatsPage.dart';
import 'package:coupangeats/homepage/home_search.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeContent(),
    SearchPage(),
    FavoritesPage(),
    OrderHistoryPage(),
    myeatsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: '즐겨찾기'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: '주문내역'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My 이츠'),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: EdgeInsets.only(left: padding1),
          child: Icon(Icons.near_me, color: Colors.yellow, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                '경기도 성남시 수정구 성담대로1390번길',
                style: title1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.expand_more, color: Colors.blue, size: 30),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: padding1),
            child: Icon(Icons.notifications_none_outlined, size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Search()),
            HomeFooldtile(),
            SliverToBoxAdapter(
              child: AspectRatio(
                aspectRatio: 16 / 5,
                child: adImage(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: padding1 * 2.5,
                vertical: padding1,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('이츠 추천 맛집', style: title1),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: padding1 * 2.5),
                child: HomeRecommatzip(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: padding1 * 2.5,
                vertical: padding1,
              ),
              sliver: SliverToBoxAdapter(
                child: Text('골라먹는맛집', style: title1),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding1 * 2.5),
                child: GollamukmatzipBar(),
              ),
            ),
            HomeGollamukmatzip(),
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('즐겨찾기', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('즐겨찾기 페이지'),
      ),
    );
  }
}

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문내역', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('주문내역 페이지'),
      ),
    );
  }
}

