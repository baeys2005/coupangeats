import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(4, (index) => GlobalKey());
  final List<double> _sectionOffsets = [];
  int _selectedContent = 0; // 0: 정보, 1: 리뷰
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
    });

    _scrollController.addListener(_updateTabBarIndex);

    // ✅ 스크롤 값이 변경될 때 FlexibleSpaceBar의 표시 여부 확인
    _scrollController.addListener(() {
      setState(() {
        _isCollapsed = _scrollController.offset > flexibleSpace - kToolbarHeight;
        print("📌 _isCollapsed 값: $_isCollapsed"); // ✅ 디버깅 코드 추가
      });
    });
  }

  void _calculateSectionOffsets() {
    _sectionOffsets.clear();
    for (var key in _sectionKeys) {
      final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      final position =
          box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
      _sectionOffsets.add(position.dy);
    }
  }

  void _updateTabBarIndex() {
    double offset = _scrollController.offset + kToolbarHeight + 48;
    for (int i = 0; i < _sectionOffsets.length; i++) {
      if (offset < _sectionOffsets[i]) {
        _tabController.animateTo(i);
        break;
      }
    }
  }

  void _scrollToSection(int index) {
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

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                          child: Container(color: Colors.blue),
                        ),
                        const SizedBox(height: 100),
                        StoreInfo(
                          // ✅ StoreInfo 위젯으로 변경
                          selectedContent: _selectedContent,
                          onContentChange: _changeContent,
                        ),
                      ],
                    ),
                    Positioned(
                      right: 20,
                      top: 120,
                      child: IconButton(
                        onPressed: () {}, // TODO: 이미지 열람
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
                      top: 180, // 기존 60에서 조정하여 다른 요소와 겹치지 않도록 함
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
                          height: 120, //글자상자 높이
                          child: Center(
                            child: Text(
                              '두찜 성남태평점',
                              style: pagetitle1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isCollapsed ? 1.0 : 0.0, // ✅ FlexibleSpaceBar가 사라지면 title 표시
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '(가게이름) 내 메뉴를 찾아보세요',
                    border: InputBorder.none,
                  ),
                ),
              ),

            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: '인기메뉴'),
                    Tab(text: '두찜 스페셜메뉴'),
                    Tab(text: '반마리찜닭'),
                    Tab(text: '한마리찜닭'),
                  ],
                  onTap: _scrollToSection,
                ),
              ),
            ),
          ];
          },
          body: ListView(
            physics: const NeverScrollableScrollPhysics(), // ✅ NestedScrollView에서 스크롤 감지를 위해 필요,엥 이거넣으니까 안내려오는거 해결

            children: [
              _buildMenuSection(
                _sectionKeys[0],
                '인기메뉴',
                Colors.red.shade100,
                [
                  {'name': '떡국', 'price': '9000'},
                  {'name': '떡 만두국', 'price': '9000'},
                  {'name': '떡볶이', 'price': '7000'},
                ],
              ),
              _buildMenuSection(
                _sectionKeys[1],
                '두찜 스페셜메뉴',
                Colors.green.shade100,
                [
                  {'name': '매콤찜닭', 'price': '25000'},
                  {'name': '간장찜닭', 'price': '24000'},
                ],
              ),
              _buildMenuSection(
                _sectionKeys[2],
                '반마리찜닭',
                Colors.blue.shade100,
                [
                  {'name': '반마리 매운찜닭', 'price': '13000'},
                  {'name': '반마리 간장찜닭', 'price': '12500'},
                ],
              ),
              _buildMenuSection(
                _sectionKeys[3],
                '한마리찜닭',
                Colors.orange.shade100,
                [
                  {'name': '한마리 매운찜닭', 'price': '25000'},
                  {'name': '한마리 간장찜닭', 'price': '24000'},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(GlobalKey key, String title, Color color,
      List<Map<String, String>> items) {
    return Container(
      key: key,
      height: 400, // 가게 하나당 할당 공간
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title, //카테고리 제목
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "메뉴 사진은 연출된 이미지 입니다 ", //카테고리 제목
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dividerLine,
                      Text(
                        item['name']!, // ✅ 메뉴 이름
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4), // 간격 추가
                      Text(
                        '${item['price']}원', // ✅ 가격
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.blueGrey.withOpacity(0.1), // 선 색상
            thickness: 7, // 선 두께
            height: 20, // 위아래 여백
          )
        ],
      ),
    );
  }
}

// 🔹 SliverPersistentHeader를 위한 Delegate 클래스
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
