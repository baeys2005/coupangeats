import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/homepage/resturantPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../orderpage/storePage.dart';

class HomeRecommatzip extends StatefulWidget {
  const HomeRecommatzip({super.key});

  @override
  State<HomeRecommatzip> createState() => _HomeRecommatzipState();
}

class _HomeRecommatzipState extends State<HomeRecommatzip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
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
              final storeName = data['storeName'] ?? '이름없는 가게';
              final storeImages = data['storeImages'] as List<dynamic>? ?? [];

              // 첫 번째 이미지 (없으면 null)
              final firstImage = storeImages.isNotEmpty
                  ? storeImages[0].toString()
                  : null;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding1),
                child: matzipBox(
                  index: index,
                  bW: MediaQuery.of(context).size.width * 0.7,
                  bH: MediaQuery.of(context).size.width * 0.4,
                  storeName: storeName,
                  storeImage: firstImage,
                ),
              );
            },
          );
        }
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

  const matzipBox({
    super.key,
    required this.index,
    required this.bH,
    required this.bW,
    required this.storeName,
    required this.storeImage,
  });

  @override
  State<matzipBox> createState() => _matzipBoxState();
}

class _matzipBoxState extends State<matzipBox> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Storepage(),
          ),
        );
      },
      child: Container(
        width: widget.bW,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:  widget.storeImage != null
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
                Positioned(
                  bottom: -13.0,
                  left: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff1976D2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'wow 매 주문 무료배달 적용 매장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.storeName,
                    style: title1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'wow+즉시할인',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(width: 4),
                Text(
                  '5.0(251) · 0.8km · 30분',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
