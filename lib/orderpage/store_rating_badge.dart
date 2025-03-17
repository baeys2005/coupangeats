import 'package:flutter/material.dart';

class StoreRatingBadge extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool hasWowDiscount;

  const StoreRatingBadge({
    Key? key,
    required this.rating,
    required this.reviewCount,
    this.hasWowDiscount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // 수정: 패딩 완전 제거하여 상단 간격 최소화
      padding: const EdgeInsets.only(bottom: 5), // 상단 패딩 제거, 하단만 유지
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rating row with star icon
          GestureDetector(
            onTap: () {
              // Navigate to reviews page or show reviews
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: Color(0xFFFFD700), // Golden yellow for star
                  size: 20,
                ),
                const SizedBox(width: 2),
                Text(
                  "$rating",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  "($reviewCount)",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),
          ),

          // WOW discount badge - conditional
          if (hasWowDiscount)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF2FC), // Blue color for WOW badge
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF407CD2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "WOW",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "와우할인",
                    style: TextStyle(
                      color: Color(0xff407CD2),
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}