import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';

class DiliveryBeforeOrder extends StatefulWidget {
  final String deliveryAddress;
  const DiliveryBeforeOrder({super.key, required this.deliveryAddress});

  @override
  State<DiliveryBeforeOrder> createState() => _DiliveryBeforeOrderState();
}

class _DiliveryBeforeOrderState extends State<DiliveryBeforeOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 배달 상태 표시 섹션
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                '매장에서 주문을 확인하고 있습니다.',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),

        // 주문 취소 버튼
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              '주문 취소',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 12),

        // 취소 안내 메시지
        Center(
          child: Text(
            '매장이 조리를 시작하면 취소할 수 없습니다.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),

        SizedBox(height: 30),

        // 구분선
        Container(
          height: 8,
          color: Colors.grey.shade100,
          // 에러의 원인: 음수 마진 제거
          // margin: EdgeInsets.symmetric(horizontal: -30),
        ),

        SizedBox(height: 20),

        // 배달 주소 섹션
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 20),
            SizedBox(width: 8),
            Text(
              '배달 주소',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(height: 10),

        // 주소 텍스트
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            widget.deliveryAddress,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),

        SizedBox(height: 20),

        // WOW 배달 표시
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'WOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '무료배달',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}