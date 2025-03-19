import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:coupangeats/orderpage/store_cart_bar.dart';
import 'package:coupangeats/orderpage/store_menu_section.dart';
import 'package:coupangeats/orderpage/store_rating_badge.dart'; // 새로 추가
import 'package:coupangeats/providers/store_info_provider.dart';
import 'package:coupangeats/providers/store_menus_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/cart_provider.dart';
import '../store_order_Page/storeorderPage.dart';
import '../theme.dart';

class StorePage extends StatefulWidget {
  final String storeId; // storeId 받아서 가게정보 띄우기
  const StorePage({super.key, required this.storeId});

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

  OverlayEntry? _cartOverlayEntry;

  @override
  void initState() {
    super.initState();

    final cartProv = Provider.of<CartProvider>(context, listen: false);
    cartProv.addListener(() {
      if (cartProv.totalItemCount > 0) {
        // 장바구니 아이템이 하나 이상이라면 오버레이 표시
        CartOverlayManager.showOverlay(context, bottom: 0.0);
      } else {
        // 비었다면 오버레이 숨김
        CartOverlayManager.hideOverlay();
      }
    });

    debugPrint('Current store ID: ${widget.storeId}');
    // 스크롤 높이 계산
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateSectionOffsets();
    });
    // 스크롤 리스너
    _scrollController.addListener(() {
      setState(() {
        _isCollapsed = _scrollController.offset >
            flexibleSpace - kToolbarHeight; // ✅ 디버깅 코드 추가
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
    final storeMenusProv =
    Provider.of<StoreMenusProvider>(context, listen: false);
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
  void _navigateToOrderPage(
      BuildContext context, Map<String, String> menuItem) {
    CartOverlayManager.hideOverlay();
    // 메뉴 정보를 인자로 전달하면서 주문 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => storeorderPage(
          menuName: menuItem['name'] ?? '메뉴 이름 없음',
          menuPrice: int.tryParse(menuItem['price'] ?? '0') ?? 0,
          storeId: widget.storeId, // [수정] 가게 ID 추가
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

    CartOverlayManager.hideOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
    final storeMenusProv = Provider.of<StoreMenusProvider>(context);
    final catCount = storeMenusProv.categories.length;
    debugPrint("catCount is" + catCount.toString());

    return WillPopScope(
      onWillPop: () async {
        ///다시 home 으로 돌아갈때.
        // 뒤로가기 시 먼저 오버레이 해제
        CartOverlayManager.hideOverlay();
        CartOverlayManager.showOverlay(context,bottom: 60);
        // true를 리턴하면 실제 pop 진행
        return true;
      },
      child: DefaultTabController(
        length: catCount, // catCount
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
                          mainAxisSize: MainAxisSize.min, // 추가: 컬럼이 최소 공간만 사용하도록 설정
                          children: [
                            SizedBox(
                              height: 220, //배경사진 높이
                              width: double.infinity,
                              child: _buildImageSlider(storeProv),
                            ),
                            // SizedBox 높이를 줄임
                            const SizedBox(height: 80), // 기존 100에서 80으로 줄임
                            StoreInfo(
                              // ✅ StoreInfo 위젯으로 변경
                              selectedContent: _selectedContent,
                              onContentChange: _changeContent,
                            ),
                          ],
                        ),
                        Positioned(
                          right: 30,
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
                        // 수정된 부분: Column으로 변경하여 StoreRatingBadge 추가
                        // 수정된 Positioned 부분 (컨테이너의 모든 모서리에 그림자 적용)
                        Positioned(
                          top: 200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 가게 이름과 별점을 포함하는 단일 컨테이너
                              Container(
                                width: 300,
                                // 그림자 효과를 모든 방향으로 적용
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4), // 약간의 둥근 모서리 적용
                                  // 모든 방향에 그림자 적용
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2), // 그림자 색상
                                      offset: const Offset(0, 0), // 중앙에서 모든 방향으로 확산
                                      blurRadius: 6, // 약간 더 부드러운 그림자
                                      spreadRadius: 2, // 모든 방향으로 그림자 확산
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // 가게 이름 부분
                                    Container(
                                      width: 300,
                                      height: 55,
                                      padding: EdgeInsets.symmetric(horizontal: 10), // 텍스트 좌우 여백 추가
                                      color: Colors.white,
                                      child: Center(
                                        child: Text(
                                          storeProv.storeName,
                                          style: pagetitle1,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),

                                    // 별점 배지 부분
                                    StoreRatingBadge(
                                      rating: storeProv.storeRating,
                                      reviewCount: storeProv.reviewCount,
                                      hasWowDiscount: storeProv.hasWowDiscount,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),







                        Positioned(
                            top: 150, // 슬라이더 높이가 220이므로, 적절히 조정
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
                                    margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                    width: isActive ? 10 : 8,
                                    height: isActive ? 10 : 8,
                                    decoration: BoxDecoration(
                                      color:
                                      isActive ? Colors.white : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                },
                              ),
                            ))
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
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Colors.grey,
                          tabs: storeMenusProv.categories
                              .map((cat) => Tab(text: cat.name))
                              .toList(),
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

// 오버플로우가 계속 발생하면 이 값을 650으로 늘려볼 수 있습니다
double flexibleSpace = 650;