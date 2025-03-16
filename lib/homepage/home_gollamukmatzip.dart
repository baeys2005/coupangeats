import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import '../orderpage/storePage.dart';
import 'home_recommatzip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GollamukmatzipBar extends StatefulWidget {
  const GollamukmatzipBar({super.key});

  @override
  State<GollamukmatzipBar> createState() => _GollamukmatzipBarState();
}

class _GollamukmatzipBarState extends State<GollamukmatzipBar> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //터치 영역 최소화

                  // 텍스트랑 여백 줄이는 거
                  side: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              Text(
                'wow+즉시할인',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70,
          height: 35,
          child: OutlinedButton(
              onPressed: () {},
              child: Text(
                '추천순',
                style: TextStyle(color: Color(0xff000000), fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xffcccccc)),
                  padding: EdgeInsets.all(3))),
        ),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 70,
          height: 35,
          child: OutlinedButton(
              onPressed: () {},
              child: Text(
                '필터',
                style: TextStyle(color: Color(0xff000000), fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xffcccccc)),
                  padding: EdgeInsets.all(3))),
        ),
      ],
    );
  }
}

class HomeGollamukmatzip extends StatefulWidget {
  const HomeGollamukmatzip({super.key});

  @override
  State<HomeGollamukmatzip> createState() => _HomeGollamukmatzipState();
}

class _HomeGollamukmatzipState extends State<HomeGollamukmatzip> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('stores').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // 로딩 상태 - SliverToBoxAdapter로 감싸서 반환
            return SliverToBoxAdapter(
              child: Container(
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          // store 문서 목록
          final docs = snapshot.data!.docs;

          return SliverList(  // 여기서 ListView 대신 SliverList 사용
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                // Firestore 필드 예시:
                // 스토어 문서 ID
                final storeId = doc.id;
                // storeImages: ["url1", "url2", "url3", ...]
                final List<dynamic> dynamicList = data['storeImages'] ?? [];
                final List<String> storeImages =
                dynamicList.map((e) => e.toString()).toList();

                final storeName = data['storeName'] ?? '이름없는 가게';

                // 변경: 추가 매장 정보
                final rating = data['rating'] ?? 5.0;
                final reviewCount = data['reviewCount'] ?? 1348;
                final distance = data['distance'] ?? '0.5km';
                final deliveryTime = data['deliveryTime'] ?? '21분';
                final deliveryFee = data['deliveryFee'] ?? '0원~3,600원';
                final saveDeliveryDiscount = data['saveDeliveryDiscount'] ?? '1,000원 세이브배달 할인';

                return Padding(
                  padding: EdgeInsets.all(padding1 * 2.5),
                  child: gollaMatzipBox(
                    index: index,
                    bW: MediaQuery.of(context).size.width - (padding1 * 5),
                    bH: MediaQuery.of(context).size.width * 0.6,
                    storeName: storeName,
                    storeImages: storeImages,
                    storeId: storeId, // gollaMatzipBox에 전달
                    // 변경: 추가 데이터 전달
                    rating: rating,
                    reviewCount: reviewCount,
                    distance: distance,
                    deliveryTime: deliveryTime,
                    deliveryFee: deliveryFee,
                    saveDeliveryDiscount: saveDeliveryDiscount,
                  ),
                );
              },
              childCount: docs.length,
            ),
          );
        }
    );
  }
}

//골라먹는 맛집 부분 상자
class gollaMatzipBox extends StatefulWidget {
  final int index;
  final double bW;
  final double bH;
  final String storeName;
  final List<String> storeImages;
  final String storeId; // 추가: 스토어 문서 ID
  // 변경: 추가 매장 정보 필드
  final dynamic rating;
  final dynamic reviewCount;
  final String distance;
  final String deliveryTime;
  final String deliveryFee;
  final String saveDeliveryDiscount;

  const gollaMatzipBox({
    super.key,
    required this.index,
    required this.bH,
    required this.bW,
    required this.storeName,
    required this.storeImages,
    required this.storeId,
    // 변경: 추가 매장 정보 필드 required 설정
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.saveDeliveryDiscount,
  });

  @override
  State<gollaMatzipBox> createState() => _gollaMatzipBoxState();
}

class _gollaMatzipBoxState extends State<gollaMatzipBox> {
  final List<String> restimagePaths = List.generate(
    10,
        (index) => 'assets/rest${index + 1}.png',
  );

  @override
  Widget build(BuildContext context) {
    // 최대 3장만 사용 (첫째: 큰 이미지, 둘째셋째: 작은 이미지)
    final displayedImages = widget.storeImages.take(3).toList();
    // 혹시 이미지가 하나도 없으면 대체 이미지 사용
    final hasAtLeastOne = displayedImages.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StorePage(
              storeId: widget.storeId,
            ),
          ),
        );
      },
      child: Container(
        width: widget.bW,
        // 변경: 컨테이너 너비 제한 명시
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: hasAtLeastOne
                            ? Image.network(
                          displayedImages[0],
                          width: widget.bW * 0.73,
                          height: widget.bH * 0.75,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, error, stack) =>
                              Container(
                                width: widget.bW * 0.73,
                                height: widget.bH * 0.75,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              ),
                        )
                            : Container(
                          width: widget.bW * 0.73,
                          height: widget.bH * 0.75,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                      ),
                      Column(
                        children: [
                          if (displayedImages.length > 1)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Image.network(
                                displayedImages[1],
                                width: widget.bW * 0.25,
                                height: widget.bW * 0.25,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stack) =>
                                    Container(
                                      width: widget.bW * 0.25,
                                      height: widget.bW * 0.25,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                              ),
                            )
                          else
                          // 이미지가 1장 이하인 경우 -> 빈 컨테이너 or 대체이미지
                            Container(
                              width: widget.bW * 0.25,
                              height: widget.bW * 0.25,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                              color: Colors.grey[300],
                            ),
                          if (displayedImages.length > 2)
                            Image.network(
                              displayedImages[2],
                              width: widget.bW * 0.25,
                              height: widget.bW * 0.25,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, error, stack) =>
                                  Container(
                                    width: widget.bW * 0.25,
                                    height: widget.bW * 0.25,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                            )
                          else
                          // 이미지가 2장 이하인 경우 -> 빈 컨테이너
                            Container(
                              width: widget.bW * 0.25,
                              height: widget.bW * 0.25,
                              color: Colors.grey[300],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 변경: WOW 배너 디자인 변경 (recommatzip.dart와 동일하게)
                Positioned(
                  bottom: -13.0,
                  left: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xff1A2F65), // 네이비 색상
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 변경: WOW 텍스트 추가 (사이즈 축소)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: Color(0xff407CD2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'WOW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        // 변경: 배달 정보 텍스트 추가
                        Text(
                          '매 주문 무료배달 적용 매장',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // 변경: 매장명과 배달 시간을 같은 줄에 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 변경: 매장명 스타일 변경
                Expanded(
                  child: Text(
                    widget.storeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 변경: 배달 시간 별도 표시
                Text(
                  widget.deliveryTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // 변경: 평점, 리뷰 수, 거리, 배달비 정보 업데이트
            Row(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // 변경: 별 아이콘 색상 변경
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        // 변경: 평점 표시
                        Text(
                          '${widget.rating}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 2),
                        // 변경: 리뷰 수 표시
                        Text(
                          '(${widget.reviewCount})',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        // 변경: 거리 표시
                        Text(
                          widget.distance,
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        // 변경: 배달비 표시
                        Text(
                          '배달비 ${widget.deliveryFee}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            // 변경: 세이브 배달 할인 정보 표시
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              constraints: BoxConstraints(maxWidth: widget.bW),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 변경: 세이브 아이콘 추가
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'W',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  // 변경: 할인 정보 텍스트
                  Flexible(
                    child: Text(
                      widget.saveDeliveryDiscount,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // 변경: 'wow+즉시할인' 텍스트 제거 (이미 위에 반영됨)
          ],
        ),
      ),
    );
  }
}