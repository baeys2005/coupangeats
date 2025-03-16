import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import '../orderpage/storePage.dart';

class HomePopularRestaurants extends StatelessWidget {
  const HomePopularRestaurants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with flame icon
          Padding(
            padding: EdgeInsets.fromLTRB(padding1 * 2.5, padding1 * 2, padding1 * 2.5, padding1/8),
            child: Row(
              children: [
                const Text(
                  '지금 할인 중인 점심 메뉴',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.local_fire_department, color: Colors.red, size: 24),
              ],
            ),
          ),

          // "All discounts applied" subtitle
          Padding(
            padding: EdgeInsets.fromLTRB(padding1 * 2.5, 0, padding1 * 2.5, padding1),
            child: const Text(
              '모든 할인 혜택 적용됨',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(height: 10,),

          // Horizontal list of restaurants
          SizedBox(
            height: 220,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stores').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: padding1),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final storeId = doc.id;
                    final storeName = data['storeName'] ?? '이름없는 가게';
                    final List<dynamic> dynamicList = data['storeImages'] ?? [];
                    final List<String> storeImages = dynamicList.map((e) => e.toString()).toList();
                    final firstImage = storeImages.isNotEmpty ? storeImages[0] : null;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StorePage(
                              storeId: storeId,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Restaurant image with badge
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: firstImage != null
                                      ? Image.network(
                                    firstImage,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, error, stack) => Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                                  )
                                      : Container(
                                    width: 150,
                                    height: 150,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                                ),
                                // Sales badge for first item
                                if (index == 0)
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Text(
                                        '판매량 1등',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // Restaurant name
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                storeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Rating and delivery time
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow[700], size: 14),
                                  const SizedBox(width: 2),
                                  const Text(
                                    '5.0(251)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '·',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    '30분',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}