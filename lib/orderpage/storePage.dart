import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:coupangeats/providers/store_info_provider.dart';
import 'package:coupangeats/providers/store_menus_provider.dart';
import 'package:coupangeats/orderpage/storeproviders/store_info_provider.dart';
import 'package:coupangeats/orderpage/storeproviders/store_menus_provider.dart';
import 'package:coupangeats/store_order_Page/storeorderPage.dart';
import 'package:coupangeats/store_order_Page/cart_provider.dart';
import 'package:coupangeats/store_order_Page/cart_view_page.dart';
import 'package:coupangeats/orderpage/store_image_slider.dart'; // 새로 분리된 파일
import 'package:coupangeats/orderpage/store_menu_section.dart'; // 새로 분리된 파일
import 'package:coupangeats/orderpage//store_cart_bar.dart'; // 새로 분리된 파일
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../switch_store_provider.dart';
import '../theme.dart';

class StorePage extends StatefulWidget {
  final String storeId; // storeId 받아서 가게정보 띄우기
  const StorePage({super.key,required this.storeId});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  List<GlobalKey> _sectionKeys = [];

  final ScrollController _scrollController = ScrollController();
  final List<double> _sectionOffsets = [];
  int _selectedContent = 0; // 0: 정보, 1: 리뷰
  bool _isCollapsed = false;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('Current store ID: ${widget.storeId}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();


    _scrollController.addListener(() {
      setState(() {
        final catCount = storeMenusProv.categories.length;
        if (_tabController.length != catCount && catCount > 0) {
          _tabController.dispose();
          _tabController = TabController(length: catCount, vsync: this);
          _sectionKeys = List.generate(catCount, (index) => GlobalKey());
        }
      });
    });
    // 가게정보 firebase서 불러오기
    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    // 1) 이전 데이터가 남아있지 않도록 초기화
    storeProv.resetStoreData();
    // 2) 새 storeId로 로딩
    storeProv.loadStoreData(widget.storeId);


    //메뉴정보 firebase 서 불러오기
    final storeMenusProv =
        Provider.of<StoreMenusProvider>(context, listen: false);
    storeMenusProv.loadStoreMenus(widget.storeId);
    storeMenusProv.addListener(_updateTabAndSections);


    final catCount = storeMenusProv.categories.length;
  }

  void _updateTabAndSections() {
    final storeMenusProv = Provider.of<StoreMenusProvider>(context, listen: false);

    if (storeMenusProv.isLoading) return;

    final catCount = storeMenusProv.categories.length;
    debugPrint('[_updateTabAndSections] catCount: $catCount');

    // (Issue #4 fix) 빌드 중에 setState()하지 않도록 다음 프레임에 처리
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 혹시 페이지가 dispose된 경우 방어

      // catCount가 0이면 TabBar 제거
      if (catCount == 0) {
        setState(() {
          _sectionKeys = [];
        });
        return;
      }

      // catCount > 0일 때 탭컨트롤러 재생성
      setState(() {



        // 섹션 키 재생성
        _sectionKeys = List.generate(catCount, (index) => GlobalKey());
      });

      // 섹션 위치 재계산
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _calculateSectionOffsets();
        }
      });
    });
  }

  void _calculateSectionOffsets() {
    _sectionOffsets.clear();
    for (var key in _sectionKeys) {
      // 1) key.currentContext가 아직 없으면 pass
      if (key.currentContext == null) continue;

      final renderObj = key.currentContext!.findRenderObject();
      // 2) renderObj가 아직 null이면 pass
      if (renderObj == null) continue;

      final box = renderObj as RenderBox;

      // 3) context.findRenderObject()도 null일 수 있으니 체크
      final ancestorRO = context.findRenderObject();
      if (ancestorRO == null) continue;

      final position = box.localToGlobal(Offset.zero, ancestor: ancestorRO);
      _sectionOffsets.add(position.dy);
    }
  }



  void _scrollToSection(int index) {
    if (index >= _sectionOffsets.length || _sectionOffsets.isEmpty) return;

    _scrollController.animateTo(
      _sectionOffsets[index] - kToolbarHeight - 48,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _changeContent(int index) {
    setState(() {
      _selectedContent = index;
    });
  }

  // 메뉴 항목 클릭 시 주문 페이지로 이동하는 메서드
  void _navigateToOrderPage(BuildContext context, Map<String, String> menuItem) {
    // 메뉴 정보를 인자로 전달하면서 주문 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => storeorderPage(
          menuName: menuItem['name'] ?? '메뉴 이름 없음',
          menuPrice: int.tryParse(menuItem['price'] ?? '0') ?? 0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    final storeMenusProv =
    Provider.of<StoreMenusProvider>(context, listen: false);
    storeMenusProv.removeListener(_updateTabAndSections);

    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
    final storeMenusProv = Provider.of<StoreMenusProvider>(context);
    final catCount = storeMenusProv.categories.length;
    debugPrint("catCount is"+catCount.toString());

    return DefaultTabController(
      length: catCount, // catCount
      child: Scaffold(
        // 수정: _buildCartBar 대신 StoreCartBar 위젯 사용
        bottomNavigationBar: StoreCartBar(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CartViewPage()),
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            print("innerBoxIsScrolled: $innerBoxIsScrolled");
            return [
              SliverAppBar(
                pinned: true,
                expandedHeight: flexibleSpace, //flexibleSpace의 영역할당
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 220, //배경사진 높이
                            width: double.infinity,
                            // 수정: _buildImageSlider 대신 StoreImageSlider 위젯 사용
                            child: StoreImageSlider(
                              storeProv: storeProv,
                              pageController: _pageController,
                              currentPage: _currentPage,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 100),
                          StoreInfo(
                            selectedContent: _selectedContent,
                            onContentChange: _changeContent,
                          ),
                        ],
                      ),
                      Positioned(
                        right: 20,
                        top: 120,
                        child: IconButton(
                          onPressed: () {}, // 이미지 열람
                          icon: Material(
                            elevation: 5.0,
                            shape: const CircleBorder(),
                            shadowColor: Colors.black,
                            color: Colors.transparent,
                            child: const Icon(Icons.image,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 180,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(-5, 0),
                                blurRadius: 7,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(5, 0),
                                blurRadius: 7,
                              ),
                            ],
                          ),
                          child: Container(
                            color: Colors.white,
                            width: 300,
                            height: 120,
                            child: Center(
                              child: Text(
                                storeProv.storeName,
                                style: pagetitle1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 페이지 인디케이터 위치는 StoreImageSlider 내부로 이동
                    ],
                  ),
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isCollapsed ? 1.0 : 0.0,
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '(가게이름) 내 메뉴를 찾아보세요',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              if (!storeMenusProv.isLoading)
                if (catCount == 0)
                  SliverToBoxAdapter(
                    child: Center(child: Text('카테고리가 없습니다.')),
                  )
                else
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      TabBar(
                        // controller 생략하면 DefaultTabController.of(context)를 자동 연결
                        isScrollable: true,
                        tabs: storeMenusProv.categories.map((cat) => Tab(text: cat.name)).toList(),
                      ),
                    ),
                  ),
            ];
          },
          body: storeMenusProv.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: storeMenusProv.categories.length,
            itemBuilder: (context, catIndex) {
              final category = storeMenusProv.categories[catIndex];
              final menus = category.menus;
              final sectionKey = (catIndex < _sectionKeys.length)
                  ? _sectionKeys[catIndex]
                  : null;

              // "items" 리스트로 변환
              final itemList = menus.map((m) {
                return {
                  'name': m.name,
                  'price': m.price.toString(),
                };
              }).toList();

              // 수정: _buildMenuSection 대신 StoreMenuSection 위젯 사용
              return StoreMenuSection(
                key: sectionKey,
                title: category.name,
                color: Colors.grey.shade200,
                items: itemList,
                onMenuTap: _navigateToOrderPage,
              );
            },
          ),
        ),
      ),
    );
  }
}

// SliverPersistentHeader를 위한 Delegate 클래스
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

double flexibleSpace = 600;