import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class HomeWowBanner extends StatelessWidget {
  const HomeWowBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        child: Container(
          width: double.infinity,
          height: 130, // Increased height to accommodate bottom padding
          padding: const EdgeInsets.only(bottom: 20), // Added bottom padding
          decoration: BoxDecoration(
            color: const Color(0xFF6A3DEA), // 진한 보라색 배경
            borderRadius: BorderRadius.circular(0),
          ),
          child: Stack(
            children: [
              // 동그라미 패턴 장식 (왼쪽 상단)
              Positioned(
                top: -15,
                left: -15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 작은 동그라미 패턴 (오른쪽 위)
              Positioned(
                top: 15,
                right: 100,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 쿠팡 카드 이미지
              Positioned(
                left: 20,
                bottom: 10,
                child: Transform.rotate(
                  angle: -0.1, // 약간 회전
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B96FF), // 쿠팡 카드 파란색
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "COUPANG",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 금색 동전들
              Positioned(
                bottom: 25,
                left: 70,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 90,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD700),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 텍스트 부분
              Positioned(
                top: 25,
                left: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "쿠팡 와우회원이라면",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "주문 하기 전\n추가 혜택 받기",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // 날짜와 전체보기 버튼
              Positioned(
                bottom: 10,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "11 / 11 전체보기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}