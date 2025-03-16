import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../orderpage/storePage.dart';
import '../orderpage/store_cart_bar.dart';
import '../theme.dart';

class HomeRecommatzip extends StatefulWidget {
  const HomeRecommatzip({Key? key}) : super(key: key);

  @override
  State<HomeRecommatzip> createState() => _HomeRecommatzipState();
}

class _HomeRecommatzipState extends State<HomeRecommatzip> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        // 변경: 고정 높이를 조금 더 크게 설정하여 overflow 방지
        height: 280, // 250에서 280으로 증가
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('stores').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                // 아직 데이터를 못 불러왔으면 로딩 표시
                return const Center(child: CircularProgressIndicator());
              }
              // store 문서 목록
              final docs = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final data = doc.data() as Map<String, dynamic>;

                  // storeName, storeImages 필드 꺼내기
                  final storeId = doc.id; // 문서 ID
                  final storeName = data['storeName'] ?? '이름없는 가게';
                  final storeImages = data['storeImages'] as List<dynamic>? ?? [];

                  // 첫 번째 이미지 (없으면 null)
                  final firstImage = storeImages.isNotEmpty
                      ? storeImages[0].toString()
                      : null;

                  // 변경: 매장 평점 정보 추가
                  final rating = data['rating'] ?? 4.9;
                  // 변경: 리뷰 수 추가
                  final reviewCount = data['reviewCount'] ?? 791;
                  // 변경: 거리 정보 추가
                  final distance = data['distance'] ?? '1.5km';
                  // 변경: 배달 시간 추가
                  final deliveryTime = data['deliveryTime'] ?? '46분';
                  // 변경: 배달비 정보 추가
                  final deliveryFee = data['deliveryFee'] ?? '0원~3,600원';
                  // 변경: 세이브 배달 할인 정보 추가
                  final saveDeliveryDiscount = data['saveDeliveryDiscount'] ?? '1,000원 세이브배달 할인';

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding1),
                    child: matzipBox(
                      index: index,
                      bW: MediaQuery.of(context).size.width * 0.7,
                      bH: MediaQuery.of(context).size.width * 0.4,
                      storeName: storeName,
                      storeImage: firstImage,
                      storeId: storeId,
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
              );
            }
        ),
      ),
    );
  }
}

class matzipBox extends StatefulWidget {
  final int index;
  final double bW;
  final double bH;
  final String storeName;
  final String? storeImage;
  final String storeId;
  // 변경: 추가 매장 정보 필드
  final dynamic rating;
  final dynamic reviewCount;
  final String distance;
  final String deliveryTime;
  final String deliveryFee;
  final String saveDeliveryDiscount;

  const matzipBox({
    super.key,
    required this.index,
    required this.bH,
    required this.bW,
    required this.storeName,
    required this.storeImage,
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
  State<matzipBox> createState() => _matzipBoxState();
}

class _matzipBoxState extends State<matzipBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CartOverlayManager.hideOverlay();
        CartOverlayManager.showOverlay(context, bottom: 0);
        // tap 시 StorePage로 이동하며 storeId 전달
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
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.storeImage != null
                      ? Image.network(
                    widget.storeImage!,
                    width: widget.bW,
                    height: widget.bH,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stack) => Container(
                      width: widget.bW,
                      height: widget.bH,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  )
                      : Container(
                    width: widget.bW,
                    height: widget.bH,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
                ),
                // 변경: WOW 무료배달 배너 디자인 변경
                Positioned(
                  bottom: -13.0,
                  left: 7,
                  right: 7,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15), // 패딩 축소
                    decoration: BoxDecoration(
                      // 변경: 배경색 네이비색으로 변경
                      color: Color(0xff1A2F65),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 변경: WOW 텍스트 추가 (사이즈 축소)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1), // 패딩 축소
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                            borderRadius: BorderRadius.circular(15), // 더 작은 radius
                          ),
                          child: Text(
                            'WOW',
                            style: TextStyle(
                              fontSize: 10, // 폰트 사이즈 축소
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
                              fontSize: 11, // 폰트 사이즈 축소
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
            // 변경: 매장명과 배달 시간 UI 변경
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 변경: 매장명 스타일 변경
                Expanded(
                  child: Text(
                    // 변경: 사진의 '돈까스 스페셜 돈가스 성남점' 처럼 표시
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
            // 변경: 평점, 리뷰 수, 거리, 배달비 정보 UI 변경
            Row(
              // 변경: Row가 너무 길어서 overflow 발생, Flexible과 SingleChildScrollView 추가
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
              // 변경: Container 너비 제한
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
                  // 변경: 할인 정보 텍스트에 Flexible 추가
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