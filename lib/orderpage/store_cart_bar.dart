import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupangeats/store_order_Page/cart_provider.dart';

class StoreCartBar extends StatelessWidget {
  final VoidCallback onTap;

  const StoreCartBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        // 카트가 비어있으면 표시하지 않음
        if (cartProvider.totalItems == 0) {
          return SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${cartProvider.totalItems}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
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
                    Text(
                      '${cartProvider.totalPrice}원',
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
          ),
        );
      },
    );
  }
}

// 카트에 아이템이 추가되었을 때 표시할 오버레이 알림
class CartNotificationOverlay extends StatefulWidget {
  final String itemName;
  final VoidCallback onViewCart;

  const CartNotificationOverlay({
    Key? key,
    required this.itemName,
    required this.onViewCart,
  }) : super(key: key);

  @override
  State<CartNotificationOverlay> createState() => _CartNotificationOverlayState();
}

class _CartNotificationOverlayState extends State<CartNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1), // 아래에서 시작
      end: Offset.zero,    // 원래 위치로
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // 애니메이션 시작
    _controller.forward();

    // 3초 후 자동으로 닫기
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) {
          // 완료 후 위젯 제거
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              _controller.reverse().then((_) {
                Navigator.of(context).pop();
                widget.onViewCart();
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.itemName}를 카트에 담았습니다.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '카트 보기',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 오버레이를 표시하는 유틸리티 함수
void showCartNotification(BuildContext context, String itemName, VoidCallback onViewCart) {
  // OverlayEntry 변수 선언
  late OverlayEntry overlayEntry;

  // 이제 overlayEntry 정의
  overlayEntry = OverlayEntry(
    builder: (context) => CartNotificationOverlay(
      itemName: itemName,
      onViewCart: () {
        // 오버레이를 제거하고 카트 보기 콜백 실행
        overlayEntry.remove();
        onViewCart();
      },
    ),
  );

  // Overlay에 추가
  Overlay.of(context).insert(overlayEntry);

  // 3초 후 자동으로 제거 (위젯 내부에서도 처리하지만 안전하게 추가)
  Future.delayed(Duration(seconds: 3), () {
    // 이미 제거되었는지 확인 후 제거 시도
    try {
      overlayEntry.remove();
    } catch (e) {
      // 이미 제거된 경우 오류 무시
      print('오버레이 이미 제거됨: $e');
    }
  });
}