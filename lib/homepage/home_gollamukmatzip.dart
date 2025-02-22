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
            // 로딩 상태
            return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          // store 문서 목록
          final docs = snapshot.data!.docs;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                // Firestore 필드 예시:
                // storeImages: ["url1", "url2", "url3", ...]
                final List<dynamic> dynamicList = data['storeImages'] ?? [];
                final List<String> storeImages =
                    dynamicList.map((e) => e.toString()).toList();

                // 가게 이름
                final storeName = data['storeName'] ?? '이름없는 가게';

                return Padding(
                  padding: EdgeInsets.all(padding1 * 2.5),
                  child: gollaMatzipBox(
                    index: index,
                    bW: MediaQuery.of(context).size.width - (padding1 * 5),
                    bH: MediaQuery.of(context).size.width * 0.6,
                    storeName: storeName,
                    storeImages: storeImages,
                  ),
                );
              },
              childCount: docs.length,
            ),
          );
        });
  }
}

//골라먹는 맛집 부분 상자
class gollaMatzipBox extends StatefulWidget {
  final int index;
  final double bW;
  final double bH;
  final String storeName;
  final List<String> storeImages;

  const gollaMatzipBox({
    super.key,
    required this.index,
    required this.bH,
    required this.bW,
    required this.storeName,
    required this.storeImages,
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
            builder: (context) => StorePage(),
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
                                errorBuilder: (ctx, error, stack) => Container(
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
                                errorBuilder: (ctx, error, stack) => Container(
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
                              errorBuilder: (ctx, error, stack) => Container(
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
                          color: Colors.white),
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
