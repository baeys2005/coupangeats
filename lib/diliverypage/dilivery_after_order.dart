import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../homepage/home_page.dart';
import '../orderpage/store_cart_bar.dart';
import '../providers/cart_provider.dart';

class DiliveryAfterOrder extends StatefulWidget {
  final int estimatedMinutes;
  final String distanceString;
  final String deliveryAddress;

  const DiliveryAfterOrder({
    super.key,
    required this.estimatedMinutes,
    required this.distanceString,
    required this.deliveryAddress,
  });

  @override
  State<DiliveryAfterOrder> createState() => _DiliveryAfterOrderState();
}

class _DiliveryAfterOrderState extends State<DiliveryAfterOrder> {
  int currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoStepChange();
  }

  void _startAutoStepChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentStep == 3) {
        timer.cancel();
        _onOrderCompleted();
      } else {
        setState(() {
          currentStep++;
        });
      }
    });
  }

  Future<void> _onOrderCompleted() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('배달이 완료되었습니다.')),
    );
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.clear();
    CartOverlayManager.showOverlay(context, bottom: 60);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Homepage()),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 배달원 정보 섹션
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: Icon(Icons.delivery_dining, color: Colors.blue, size: 30),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '홍길동 기사님',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '배달 진행중',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                  side: BorderSide(color: Colors.blue, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text('전화하기'),
              ),
            ],
          ),
        ),

        // 배달 예상 시간 섹션
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                widget.estimatedMinutes.toString(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '분',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '약 ${widget.distanceString} km',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 20),

        // 진행 상태 타임라인
        OrderTimeline(currentStep: currentStep),

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

class OrderTimeline extends StatelessWidget {
  final int currentStep;

  const OrderTimeline({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> steps = [
      {"title": "주문 수락됨", "time": "10:48 AM"},
      {"title": "메뉴 준비중", "time": "10:48 AM"},
      {"title": "배달 중", "time": "11:10 AM"},
      {"title": "배달 완료", "time": ""},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          bool isCompleted = index < currentStep;
          bool isCurrent = index == currentStep;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: isCurrent ? 8 : 10,
                    backgroundColor: isCompleted
                        ? Colors.blue
                        : isCurrent
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.shade300,
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  if (index != steps.length - 1)
                    Container(
                      width: 2,
                      height: 30,
                      color: isCompleted ? Colors.blue : Colors.grey.shade300,
                    ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: index != steps.length - 1 ? 24 : 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        steps[index]["title"]!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCompleted
                              ? Colors.black
                              : isCurrent
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (steps[index]["time"]!.isNotEmpty)
                        Text(
                          steps[index]["time"]!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}