import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

// 배달 방법 옵션을 나타내는 클래스
class DeliveryMethod {
  final String id;
  final String name;
  final String timeRange;
  final int price;
  final int? originalPrice; // 원래 가격 (할인 전)
  final Widget? icon; // 아이콘 (있는 경우)

  DeliveryMethod({
    required this.id,
    required this.name,
    required this.timeRange,
    required this.price,
    this.originalPrice,
    this.icon,
  });
}

// 배달 방법 선택 위젯
class DeliveryMethodSelector extends StatelessWidget {
  // 배달 방법 옵션들
  final List<DeliveryMethod> deliveryMethods = [
    DeliveryMethod(
      id: 'standard',
      name: '한집배달',
      timeRange: '26-43분',
      price: 5800,
    ),
    DeliveryMethod(
      id: 'save',
      name: '세이브배달',
      timeRange: '35-50분',
      price: 4800,
      originalPrice: 5800,

      // 실제 앱에서는 위 이미지 경로를 실제 이미지 경로로 변경해야 합니다.
      // 또는 다음과 같이 Text 위젯으로 대체할 수 있습니다:
      // icon: Container(
      //   padding: EdgeInsets.all(2),
      //   decoration: BoxDecoration(
      //     color: Colors.amber,
      //     shape: BoxShape.circle,
      //   ),
      //   child: Text('W', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
      // ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // CartProvider에서 현재 선택된 배달 방법 가져오기
    final cartProvider = Provider.of<CartProvider>(context);
    final selectedDeliveryMethodId = cartProvider.selectedDeliveryMethodId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '배달 방법',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 배달 방법 선택 버튼들
        ...deliveryMethods.map((method) {
          final isSelected = method.id == selectedDeliveryMethodId;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8.0),
              color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
            ),
            child: InkWell(
              onTap: () {
                // 배달 방법 선택 시 CartProvider 업데이트
                cartProvider.setDeliveryMethod(method.id, method.price);
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
                  children: [
                    // 선택 표시 원
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey.shade400,
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      )
                          : null,
                    ),
                    SizedBox(width: 12),

                    // 배달 방법 정보
                    Expanded(
                      flex: 3, // 더 많은 공간 할당
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  method.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (method.icon != null) ...[
                                SizedBox(width: 4),
                                method.icon!,
                              ],
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            method.timeRange,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // 가격 정보
                    Expanded(
                      flex: 1, // 덜 많은 공간 할당
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (method.originalPrice != null)
                            Text(
                              '${method.originalPrice}원',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          Text(
                            '${method.price}원',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        // 세이브배달 설명 텍스트
        if (selectedDeliveryMethodId == 'save')
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: Text(
              '세이브배달은 가까운 주문과 함께 배달될 수 있어요',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis, // 텍스트 넘침 방지
              maxLines: 2, // 최대 2줄까지 표시
            ),
          ),
      ],
    );
  }
}