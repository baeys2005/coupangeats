import 'package:flutter/material.dart';

import '../theme.dart';

/// 메뉴 섹션 위젯
/// 카테고리별 메뉴 목록을 표시하는 위젯
class StoreMenuSection extends StatelessWidget {
  final String title;
  final Color color;
  final List<Map<String, String>> items;
  final Function(BuildContext, Map<String, String>) onMenuTap;

  const StoreMenuSection({
    Key? key,
    required this.title,
    required this.color,
    required this.items,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          // 카테고리 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          // 카테고리 부제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "메뉴 사진은 연출된 이미지 입니다",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 메뉴 아이템 목록
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.asMap().entries.map((entry) {
                final i = entry.key;       // 인덱스
                final item = entry.value;  // 메뉴 아이템

                // 메뉴 항목 버튼
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    // 클릭 이벤트 - 주문 페이지로 이동
                    onTap: () => onMenuTap(context, item),
                    // 버튼 디자인
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        // 그림자 효과
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (i > 0) dividerLine,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 메뉴 이름
                              Expanded(
                                child: Text(
                                  item['name']!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              // 장바구니 아이콘
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // 메뉴 가격
                          Text(
                            '${item['price']}원',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(
            color: Colors.blueGrey.withOpacity(0.1),
            thickness: 7,
            height: 20,
          )
        ],
      ),
    );
  }
}