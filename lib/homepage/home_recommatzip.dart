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
        height: 250,
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
                  // storeId, storeName, storeImages 필드 꺼내기
                  final storeId = doc.id; // 문서 ID
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
                      bW: MediaQuery
                          .of(context)
                          .size
                          .width * 0.7,
                      bH: MediaQuery
                          .of(context)
                          .size
                          .width * 0.4,
                      storeName: storeName,
                      storeImage: firstImage,
                      storeId: storeId, // matzipBox에 전달
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
    final String storeId;  // 추가: 스토어 문서 ID
  const matzipBox({super.key,
        required this.index,
    required this.bH,
    required this.bW,
    required this.storeName,
    required this.storeImage,
    required this.storeId,
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
        CartOverlayManager.showOverlay(context,bottom: 0);
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

// class matzipBox extends StatefulWidget {

//
//   const matzipBox({
//     super.key,

//   });///
//
//   @override
//   State<matzipBox> createState() => _matzipBoxState();
//   }
//
//       setState(() {
//         _data = snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList();
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("데이터 로드 오류: $e");
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _errorMessage = "데이터를 로드할 수 없습니다.";
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // tap 시 StorePage로 이동하며 storeId 전달
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => StorePage(
//               storeId: widget.storeId,
//             ),
//           ),
//         ),
//       );
//     }
//
//     if (_errorMessage.isNotEmpty) {
//       return SliverToBoxAdapter(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             _errorMessage,
//             style: TextStyle(color: Colors.red),
//           ),
//         ),
//       );
//     }
//
//     // 여기서 SliverToBoxAdapter를 반환하여 일관성 유지
//     return SliverToBoxAdapter(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               "추천 맛집",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//
//           // 데이터 목록 표시
//           _data.isEmpty
//               ? Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Center(child: Text("추천 맛집이 없습니다")),
//                 )
//               : ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: _data.length,
//                   itemBuilder: (context, index) {
//                     final item = _data[index];
//                     return ListTile(
//                       title: Text(item['name'] ?? '이름 없음'),
//                       subtitle: Text(item['description'] ?? '설명 없음'),
//                     );
//                   },
//                 ),
//         ],
//       ),
//     );
//   }

