import 'package:coupangeats/login/login_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_search.dart';
import 'home_fooldtile.dart';
import 'home_wowad.dart';
import 'home_recommatzip.dart';
import 'home_gollamukmatzip.dart';
import 'package:coupangeats/theme.dart';
import 'package:coupangeats/myeatspage/myeatsPage.dart';
import 'package:coupangeats/homepage/home_search.dart';
import 'package:coupangeats/login/login_bottom_sheet.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  Widget get _currentPage{
    if (_currentIndex == 4 && FirebaseAuth.instance.currentUser == null){
      return Homepage();
    } return _pages[_currentIndex];
  }


  final List<Widget> _pages = [
    HomeContent(),
    SearchPage(),
    FavoritesPage(),
    OrderHistoryPage(),
    myeatsPage(),
  ];

  void _handleTabTap (int index){
    if (index == 4){
      final user = FirebaseAuth.instance.currentUser;
      if(user == null){
        showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10))
            ),
            builder: (context) => LoginBottomSheet());
        return;
      }
    }
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPage,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: _handleTabTap,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: '즐겨찾기'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: '주문내역'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My 이츠'),
          ],
        ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 기존 AppBar를 SliverAppBar로 변경
            SliverAppBar(
              floating: true, // 스크롤 시 앱바가 사라졌다가 위로 스크롤하면 다시 나타남
              snap: true,     // 스크롤을 조금만 해도 앱바가 완전히 나타나거나 사라짐
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
            // 나머지 컨텐츠는 그대로 유지
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

