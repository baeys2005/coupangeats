import 'package:coupangeats/orderpage/store_info.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(4, (index) => GlobalKey());
  final List<double> _sectionOffsets = [];
  int _selectedContent = 0; // 0: 정보, 1: 리뷰

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
    });

    _scrollController.addListener(_updateTabBarIndex);
  }

  void _calculateSectionOffsets() {
    _sectionOffsets.clear();
    for (var key in _sectionKeys) {
      final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
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
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 500.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: Container(color: Colors.blue),
                        ),
                        const SizedBox(height: 100),

                        StoreInfo( // ✅ StoreInfo 위젯으로 변경
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
                          child: const Icon(Icons.image, color: Colors.white, size: 30),
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
                          height: 120,
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


            )
      ,
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
          ],
          body: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              _buildMenuSection(_sectionKeys[0], '인기메뉴', Colors.red.shade100),
              _buildMenuSection(_sectionKeys[1], '두찜 스페셜메뉴', Colors.green.shade100),
              _buildMenuSection(_sectionKeys[2], '반마리찜닭', Colors.blue.shade100),
              _buildMenuSection(_sectionKeys[3], '한마리찜닭', Colors.orange.shade100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(GlobalKey key, String title, Color color) {
    return Container(
      key: key,
      height: 400,
      color: color,
      child: Center(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
