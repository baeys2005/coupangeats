import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

import 'home_gollamukmatzip.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // 예시: 인기 검색어와 최근 검색어 (하드코딩)
  final List<String> _popularSearches = [
    '맘스터치',
    '치킨',
    '마라탕',
    '엽기떡볶이',
    '교촌',
    '떡볶이',
    'bhc',
    '요하정',
    '김밥',
    '닭강정',
  ];

  List<Map<String, String>> _recentSearches = [
    {'keyword': '연어초밥', 'date': '03.18'},
    {'keyword': '곱창', 'date': '03.16'},
    {'keyword': '덮밥', 'date': '03.16'},
    {'keyword': '겐코', 'date': '03.16'},
    {'keyword': '피자', 'date': '03.15'},
    {'keyword': '국밥국밥', 'date': '03.15'},
    {'keyword': '국밥', 'date': '03.15'},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // 1) 검색 박스
          buildSearchBox(context),
          // 2) 검색 박스 아래에 인기 검색어 + 최근 검색어
          _buildInitialBody(),
        ],
      ),
    );
  }

  /// 검색 박스만 따로 빼둔 메서드
  Widget buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.black87),
              SizedBox(width: 12),
              Text(
                '음식, 가게를 검색해보세요',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 인기 검색어 및 최근 검색어 목록을 보여주는 메서드
  Widget _buildInitialBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인기 검색어 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '인기 검색어',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '오후 8:37 업데이트', // 예시
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 10개의 인기 검색어 (1~5, 6~10 으로 2열 배치)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 5개
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rank = index + 1;
                    final keyword = _popularSearches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '$rank  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(text: keyword),
                            if (index == 0)
                              const TextSpan(
                                text: '   N',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 20),
              // 오른쪽 5개
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rank = index + 6; // 6~10
                    final keyword = _popularSearches[rank - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '$rank  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(text: keyword),
                            // N, ▼5 같은 표시 예시
                            if (index == 2)
                              const TextSpan(
                                text: '   N',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 최근 검색어 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 검색어',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // 전체삭제
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: Text(
                  '전체삭제',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 최근 검색어 목록
          Column(
            children: List.generate(_recentSearches.length, (index) {
              final item = _recentSearches[index];
              return _buildRecentSearchItem(item, index);
            }),
          ),
        ],
      ),
    );
  }

  /// 최근 검색어 아이템 개별 위젯
  Widget _buildRecentSearchItem(Map<String, String> item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            item['keyword'] ?? '',
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          Text(
            item['date'] ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // 특정 검색어만 삭제
              setState(() {
                _recentSearches.removeAt(index);
              });
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  /// 예시: 인기 검색어 리스트 (상위 10개)
  final List<String> _popularSearches = [
    '맘스터치',
    '치킨',
    '마라탕',
    '엽기떡볶이',
    '교촌',
    '떡볶이',
    'bhc',
    '요하정',
    '김밥',
    '닭강정',
  ];

  /// 예시: 최근 검색어 (날짜와 함께)
  /// 실제 구현 시 SharedPreferences 등에 저장 가능
  List<Map<String, String>> _recentSearches = [
    {'keyword': '연어초밥', 'date': '03.18'},
    {'keyword': '곱창', 'date': '03.16'},
    {'keyword': '덮밥', 'date': '03.16'},
    {'keyword': '겐코', 'date': '03.16'},
    {'keyword': '피자', 'date': '03.15'},
    {'keyword': '국밥국밥', 'date': '03.15'},
    {'keyword': '국밥', 'date': '03.15'},
  ];

  @override
  void initState() {
    super.initState();
    // 검색창 변화 감지
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.trim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '검색어를 입력해주세요',
            border: InputBorder.none,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 검색 아이콘 클릭 시, 검색어 초기화
              setState(() {
                _searchController.clear();
                _searchText = '';
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      // Body
      body: _searchText.isEmpty
          ? _buildInitialBody() // 아직 검색어를 입력하지 않았을 때
          : _buildSearchResultBody(), // 검색어가 있을 때(이전 StreamBuilder 등으로 사용)
    );
  }

  /// 1) 검색어가 비어있을 때 보여줄 화면
  Widget _buildInitialBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 인기 검색어 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '인기 검색어',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '오후 8:37 업데이트',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 10개의 인기 검색어를 1~5, 6~10으로 나누어 2열로 보여주는 예시
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 5개
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rank = index + 1;
                    final keyword = _popularSearches[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '$rank  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(text: keyword),
                            // N 표시는 임의로 'N'만 넣었음(신규 표시)
                            if (index % 2 == 0) // 예시로 짝수번째만 N 표시
                              const TextSpan(
                                text: '   N',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(width: 20),

              // 오른쪽 5개
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(5, (index) {
                    final rank = index + 6; // 6~10
                    final keyword = _popularSearches[rank - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: [
                            TextSpan(
                              text: '$rank  ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(text: keyword),
                            // 예시: N 표시 or ↑숫자 등등
                            if (index == 2) // 임의로 조건
                              const TextSpan(
                                text: '   N',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            if (index == 0)
                              const TextSpan(
                                text: '   ▼5', // 예시: 5단계 하락
                                style: TextStyle(
                                    color: Colors.green, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 최근 검색어 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '최근 검색어',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  // 전체삭제
                  setState(() {
                    _recentSearches.clear();
                  });
                },
                child: Text(
                  '전체삭제',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 최근 검색어 목록
          Column(
            children: List.generate(_recentSearches.length, (index) {
              final item = _recentSearches[index];
              return _buildRecentSearchItem(item, index);
            }),
          ),
        ],
      ),
    );
  }

  /// 최근 검색어 아이템
  Widget _buildRecentSearchItem(Map<String, String> item, int index) {
    // 예: item['keyword'] = '연어초밥', item['date'] = '03.18'
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.access_time,
            size: 20,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            item['keyword'] ?? '',
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          Text(
            item['date'] ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          // X 버튼
          GestureDetector(
            onTap: () {
              setState(() {
                _recentSearches.removeAt(index);
              });
            },
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// 2) 검색어가 있을 때: (기존처럼 Firestore 검색 결과 표시)
  Widget _buildSearchResultBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stores')
          .orderBy('storeName')
          .startAt([_searchText]).endAt([_searchText + '\uf8ff']).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('검색 결과가 없습니다.'));
        }

        // ★gollaMatzipBox로 UI를 구성하기 위해 ListView.builder에서 각 문서를 gollaMatzipBox에 매핑
        return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              // Firestore 필드 정보
              final storeId = doc.id; // 문서 ID
              final List<dynamic> dynamicList = data['storeImages'] ?? [];
              final List<String> storeImages =
                  dynamicList.map((e) => e.toString()).toList();

              final storeName = data['storeName'] ?? '이름없는 가게';
              final rating = data['rating'] ?? 5.0;
              final reviewCount = data['reviewCount'] ?? 0;
              final distance = data['distance'] ?? '0.5km';
              final deliveryTime = data['deliveryTime'] ?? '20분';
              final deliveryFee = data['deliveryFee'] ?? '0원~3,000원';
              final saveDeliveryDiscount =
                  data['saveDeliveryDiscount'] ?? '세이브배달 할인';

              return Padding(
                // theme.dart에 padding1이 정의되어 있다면 사용
                // 없으면 적절히 여백을 적용 (예: EdgeInsets.all(12))
                padding: EdgeInsets.all(padding1 * 2.5), // ★수정점
                child: gollaMatzipBox(
                  // ★여기서 HomeGollamukmatzip과 동일하게 gollaMatzipBox에 데이터 전달
                  index: index,
                  bW: MediaQuery.of(context).size.width - (padding1 * 5),
                  bH: MediaQuery.of(context).size.width * 0.6,
                  storeName: storeName,
                  storeImages: storeImages,
                  storeId: storeId,
                  rating: rating,
                  reviewCount: reviewCount,
                  distance: distance,
                  deliveryTime: deliveryTime,
                  deliveryFee: deliveryFee,
                  saveDeliveryDiscount: saveDeliveryDiscount,
                ),
              );
            });
      },
    );
  }
}
