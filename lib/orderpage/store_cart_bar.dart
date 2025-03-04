import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/providers/cart_provider.dart';

/// 장바구니 하단 바 위젯
/// 추가된 메뉴 개수와 총 금액을 표시하고, 클릭 시 장바구니 페이지로 이동
class StoreCartBar extends StatelessWidget {
  final VoidCallback onTap;

  const StoreCartBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      // 장바구니 Provider 사용
      final cartProvider = Provider.of<CartProvider>(context);

      // 장바구니가 비어있으면 표시하지 않음
      if (cartProvider.totalItemCount == 0) {
        return SizedBox.shrink();
      }

      // 장바구니 바 UI
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap, // 클릭 시 장바구니 페이지로 이동
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 장바구니 아이콘과 수량
                Row(
                  children: [
                    // 수량 표시 원형 배지
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartProvider.totalItemCount}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '카트 보기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // 총 금액
                Text(
                  '${cartProvider.totalAmount}원',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      // CartProvider가 등록되지 않았거나 오류 발생 시 빈 위젯 반환
      print("카트 바 생성 중 오류: $e");
      return SizedBox.shrink();
    }
  }
}