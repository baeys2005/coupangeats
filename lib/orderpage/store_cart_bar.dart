import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/providers/cart_provider.dart';

import '../store_order_Page/cart_view_page.dart';

/// 장바구니 하단 바 위젯
/// 추가된 메뉴 개수와 총 금액을 표시하고, 클릭 시 장바구니 페이지로 이동
//-카트바 위젯
//-카트바 상태관리 위젯
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
        child: GestureDetector(
          onTap: () {
            CartOverlayManager.hideOverlay();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartViewPage()),
            );
          }, // 클릭 시 장바구니 페이지로 이동
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

//카트바 상태
//카트 하단바 상태관리용 파일(조건에 따라 오버레이 나타나기/숨기기)

class CartOverlayManager {
  static OverlayEntry? _overlayEntry;
  /// 오버레이가 떠 있는지 여부를 bool로 반환
  static bool get isOverlayActive => _overlayEntry != null;

  /// 오버레이 표시
  static void showOverlay(
    BuildContext context, {
    double bottom = 0.0,
  }) {
    print('[DEBUG] CartOverlayManager.showOverlay() 호출됨');

    // 이미 오버레이가 표시되어 있다면 재표시하지 않음
    if (_overlayEntry != null) {
      print('[DEBUG] _overlayEntry가 이미 존재함. 표시 스킵');
      return;
    }

    // // OverlayState 가져오기
    final overlayState = Overlay.of(context);
    // if (overlayState == null) {
    //   print('[DEBUG] overlayState가 null임. 오버레이 삽입 불가');
    //   return;
    // }

    // OverlayEntry 생성
    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        print('[DEBUG] overlayEntry.builder 실행됨 -> 오버레이 UI 생성');
        return Positioned(
          bottom: bottom,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: StoreCartBar(
              onTap: () {
                // 오버레이 클릭 시 장바구니 페이지 이동
                print('[DEBUG] 오버레이 카트바 클릭됨 -> /cart 이동');
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ),
        );
      },
    );

    // OverlayEntry 삽입
    print('[DEBUG] overlayState.insert(_overlayEntry!) 호출');
    overlayState.insert(_overlayEntry!);
    print('[DEBUG] 오버레이 삽입 완료');
  }

  /// 오버레이 제거
  static void hideOverlay() {
    print('[DEBUG] CartOverlayManager.hideOverlay() 호출됨');

    if (_overlayEntry != null) {
      print('[DEBUG] _overlayEntry 제거 중');
      _overlayEntry!.remove();
      _overlayEntry = null;
      print('[DEBUG] _overlayEntry 제거 완료');
    } else {
      print('[DEBUG] _overlayEntry가 null -> 이미 오버레이가 없음');
    }
  }
}
