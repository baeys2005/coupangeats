import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:coupangeats/orderpage/storeproviders/store_info_provider.dart';
import 'package:coupangeats/orderpage/storeproviders/store_menus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<GlobalKey> _sectionKeys = [];

  final ScrollController _scrollController = ScrollController();
  final List<double> _sectionOffsets = [];
  int _selectedContent = 0; // 0: 정보, 1: 리뷰
  bool _isCollapsed = false;

  // [추가부분] 이미지 슬라이더를 위한 PageController, 현재 페이지
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
    });

    _scrollController.addListener(_updateTabBarIndex);

    // ✅ 스크롤 값이 변경될 때 FlexibleSpaceBar의 표시 여부 확인
    _scrollController.addListener(() {
      setState(() {
        _isCollapsed =
            _scrollController.offset > flexibleSpace - kToolbarHeight;// ✅ 디버깅 코드 추가
      });
    });

    // 가게정보 firebase서 불러오기
    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    storeProv.loadStoreData("store123");
    //메뉴정보 firebase 서 불러오기
    final storeMenusProv =
        Provider.of<StoreMenusProvider>(context, listen: false);
    storeMenusProv.loadStoreMenus("store123");

    final catCount = storeMenusProv.categories.length;
    _tabController = TabController(length: catCount, vsync: this);
  }

  // [변경부분] 카테고리가 바뀔 때마다 TabController와 섹션 키 재생성
  void _updateTabAndSections() {
    final storeMenusProv =
        Provider.of<StoreMenusProvider>(context, listen: false);

    // 아직 로딩 중이면 생략
    if (storeMenusProv.isLoading) return;

    final catCount = storeMenusProv.categories.length;
    if (catCount == 0) {
      // 카테고리 없는 경우
      setState(() {
        _tabController.dispose();
        _sectionKeys = [];
      });
      return;
    }

    // tabController 재생성
    setState(() {
      _tabController.dispose();
      _tabController = TabController(length: catCount, vsync: this);

      // 섹션 키 재생성
      _sectionKeys = List.generate(catCount, (index) => GlobalKey());
    });

    // 섹션 위치 재계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
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
    // [변경부분] addListener 해제
    final storeMenusProv =
        Provider.of<StoreMenusProvider>(context, listen: false);
    storeMenusProv.removeListener(_updateTabAndSections);

    _tabController.dispose();
    _scrollController.dispose();

    _pageController.dispose(); // [추가부분] PageController dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
    final storeMenusProv = Provider.of<StoreMenusProvider>(context);

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
                            child: _buildImageSlider(storeProv),
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
                                storeProv.storeName,
                                style: pagetitle1,
                              ),
                            ),
                          ),
                        ),
                      ),
                Positioned(
                  top:150, // 슬라이더 높이가 220이므로, 적절히 조정
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      storeProv.storeImages.isNotEmpty
                          ? storeProv.storeImages.length
                          : 1,
                          (index) {
                        bool isActive = (index == _currentPage);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 10 : 8,
                          height: isActive ? 10 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),))
                    ],
                  ),
                ),
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isCollapsed ? 1.0 : 0.0,
                  // ✅ FlexibleSpaceBar가 사라지면 title 표시
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
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      isScrollable: true,
                      // 카테고리가 많으면 스크롤 가능
                      tabs: storeMenusProv.categories.map((cat) {
                        return Tab(text: cat.name);
                      }).toList(),
                      onTap: _scrollToSection,
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

                    // (1) "items" 리스트로 변환
                    //     _buildMenuSection의 4th 파라미터는
                    //     List<Map<String, String>> 형태여야 함
                    final itemList = menus.map((m) {
                      return {
                        'name': m.name,
                        'price': m.price.toString(),
                      };
                    }).toList();

                    // (2) 카테고리 이름 -> title
                    return _buildMenuSection(
                      sectionKey,
                      category.name,
                      Colors.grey.shade200, // 임의 배경색
                      itemList,
                    );
                  },
                ),
        ),
      ),
    );
  }
  /// [수정부분] 기존 파랑 배경 대신, Provider에서 가져온 이미지로 슬라이더 구성
  Widget _buildImageSlider(StoreProvider storeProv) {
    // 가정: storeProv.storeImages : List<String>
    final imageUrls = storeProv.storeImages; // 실제 가게 이미지
    return PageView.builder(
      controller: _pageController,
      itemCount: imageUrls.isNotEmpty ? imageUrls.length : 1,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      itemBuilder: (context, index) {
        if (imageUrls.isNotEmpty) {
          // 실제 저장된 이미지를 보여줌
          final imageUrl = imageUrls[index];
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // 로딩 실패 시 기본 이미지
              return Image.network(
                'https://i.ibb.co/JwCxP9br/1000007044.jpg',
                fit: BoxFit.cover,
              );
            },
          );
        } else {
          // 저장된 이미지가 없을 때 기본 이미지 1장
          return Image.network(
            'https://i.ibb.co/JwCxP9br/1000007044.jpg',
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Icon(Icons.broken_image, size: 50));
            },
          );
        }
      },
    );
  }
  //카테고리별로 블록 생성
  Widget _buildMenuSection(
      GlobalKey? key,
      String title,
      Color color,
      List<Map<String, String>> items) {
    return Container(
      key: key, // 가게 하나당 할당 공간
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title, //카테고리 제목
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "메뉴 사진은 연출된 이미지 입니다 ", //카테고리 제목
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entry) {//메뉴수 만큼 메뉴블럭 생성
                final i = entry.key;       // 인덱스
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (i > 0) dividerLine,
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
