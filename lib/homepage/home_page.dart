import 'package:coupangeats/homepage/home_wow_ad.dart';
import 'package:coupangeats/homepage/home_wow_banner.dart';
import 'package:coupangeats/login/login_bottom_sheet.dart';
import 'package:coupangeats/mymappage/myaddress_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../orderpage/store_cart_bar.dart';
import '../providers/cart_provider.dart';
import '../providers/user_info_provider.dart';
import '../switch_store_provider.dart';
import 'home_fooldtile.dart';
import 'home_recommatzip.dart';
import 'home_gollamukmatzip.dart';
import 'package:coupangeats/theme.dart';
import 'package:coupangeats/myeatspage/myeatsPage.dart';
import 'package:coupangeats/homepage/home_search.dart';
import 'package:coupangeats/homepage/home_wow_promotion.dart';
import 'home_popular_restaurants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with RouteAware {
  int _currentIndex = 0;

  OverlayEntry? _overlayEntry; // 사장님 버튼 오버레이 관리

  void _showSwitchOverlay() {
    // 기존 오버레이가 있다면 제거
    _removeSwitchOverlay();

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        right: 20, // 오른쪽으로 이동
        child: Material(
          color: Colors.transparent,
          child: OwnerSwitch(), // 오버레이로 띄우고 싶은 위젯
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeSwitchOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget get _currentPage => _pages[_currentIndex];

  final List<Widget> _pages = [
    HomeContent(),
    CustomScrollView(
      slivers: [
        Search(),
      ],
    ),
    FavoritesPage(),
    OrderHistoryPage(),
    myeatsPage(),
  ];

  void _handleTabTap(int index) {
    if (index == 4) {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) {
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
  void initState() {
    super.initState();

    // 기존 오버레이 제거 (안전장치)
    _removeSwitchOverlay();

    // 위젯 트리 구성 완료 후 작업 수행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 강제로 상태 업데이트하여 UI 갱신
      setState(() {
        // 빈 setState로 UI 갱신 트리거
      });

      // 지연 시간을 두고 오버레이 표시 (UI가 완전히 렌더링된 후)
      Future.delayed(Duration(milliseconds: 100), () {
        _showSwitchOverlay();
      });

      // Provider 작업
      final userInfoProv = Provider.of<UserInfoProvider>(context, listen: false);
      userInfoProv.loadUserInfo().then((_) async {
        final uid = userInfoProv.userUid;
        if (uid.isNotEmpty) {
          final cartProv = Provider.of<CartProvider>(context, listen: false);
          // Firestore 장바구니 로드
          await cartProv.setUserId(uid);

          // 로드가 끝난 후, 아이템이 1개 이상이면 즉시 오버레이 표시
          if (cartProv.totalItemCount > 0) {
            debugPrint('오버레이 표시');
            CartOverlayManager.showOverlay(context, bottom: 60);
          } else {
            CartOverlayManager.hideOverlay();
          }
        }
      });
    });

    // 장바구니 변화 감시 → 추가/삭제/수량 변경 시에도 오버레이 갱신
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    cartProv.addListener(() {
      print('[DEBUG] HomePage - 장바구니 변경됨');
      print('  총 ${cartProv.items.length}개 아이템');
      for (int i = 0; i < cartProv.items.length; i++) {
        final item = cartProv.items[i];
        print('    #$i: ${item.menuName} (x${item.quantity}), docId=${item.id}');
      }

      if (cartProv.totalItemCount > 0) {
        debugPrint("오버레이 표시 ");
        CartOverlayManager.showOverlay(context, bottom: 60);
      } else {
        CartOverlayManager.hideOverlay();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 현재 라우트를 구독 (context에서 현재 ModalRoute를 가져옴)
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // 홈페이지가 dispose 될 때 오버레이 제거
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 다른 페이지에서 돌아왔을 때 호출됨
  @override
  void didPopNext() {
    // 예: 장바구니에 아이템이 있으면 카트 바를 다시 표시
    final cartProv = Provider.of<CartProvider>(context, listen: false);
    if (cartProv.totalItemCount > 0) {
      CartOverlayManager.showOverlay(context, bottom: 60);
    }
  }

  // 다른 라우트가 이 라우트를 덮을 때 호출됨.
  @override
  void didPushNext() {
    // 예: 다른 페이지로 이동할 때 오버레이 숨기기
    CartOverlayManager.hideOverlay();
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return[
            const PromotionalBanner(),
          ];
        },
        body: CustomScrollView(
          slivers: [
            // SliverAppBar - 위치 정보
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 10,
              leading: Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Container(
                    margin: EdgeInsets.only(left: 12),
                    child: IconButton(
                        onPressed: () {
                          CartOverlayManager.hideOverlay();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyaddressPage()
                            ),
                          );
                        },
                        icon: Icon(Icons.location_on_outlined, color: Color(0xff222B34), size: 20)
                    ),
                  ),
              ),
              titleSpacing: 20,
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      '경기도 성남시 수정구 성담대로1390번길',
                      style: title1,
                      overflow: TextOverflow.visible, // 말줄임표 제거
                      maxLines: 1, // 여러 줄로 표시 허용
                    ),
                  ),
                  SizedBox(width: 60),
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

            // 검색창
            Search(),

            // 카테고리 타일 그리드
            HomeFooldtile(),

            // WOW 광고 (이미지로 대체)
            HomeWowAd(),
            // 인기 레스토랑 섹션
            HomePopularRestaurants(),

            // 주문 하기 전 추가 혜택 받기 이미지
           HomeWowBanner(),

            // 이츠 추천 맛집 타이틀
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

            // 추천 맛집
            HomeRecommatzip(),

            SliverToBoxAdapter(
              child: Container(
                height: 12,
                color: Color(0xFFEEEEEE), // 얇은 회색
                margin: EdgeInsets.symmetric(vertical: 0),
              ),
            ),


            // 골라먹는맛집 타이틀
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: padding1 * 2.5,
                vertical: padding1*3,
              ),
              sliver: SliverToBoxAdapter(
                child: Text('골라먹는맛집', style: title1),
              ),
            ),

            // 골라먹는맛집 바
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding1 * 2.5),
                child: GollamukmatzipBar(),
              ),
            ),

            // 골라먹는맛집 목록
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