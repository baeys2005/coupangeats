import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Timer를 사용하기 위해 추가
//editor 하연 : 배달중 페이지(주문완료)
//TODO: 지도에 내 집과 가게 표시. 두 좌표간의 거리로 배달시간 추적
//TODO: 주소정보 불러오기.
class DiliveryAfterOrder extends StatefulWidget {
  const DiliveryAfterOrder({super.key});

  @override
  State<DiliveryAfterOrder> createState() => _DiliveryAfterOrderState();
}

class _DiliveryAfterOrderState extends State<DiliveryAfterOrder> {
  int currentStep = 0; // 현재 진행 상태 (0: 주문 수락, 1: 메뉴 준비중, 2: 배달 중, 3: 배달 완료)
  Timer? _timer; // [추가] 타이머 변수 선언

  @override
  void initState() {
    super.initState();
    _startAutoStepChange(); // [추가] 자동 단계 변경 시작
  }
  void _startAutoStepChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentStep = (currentStep + 1) % 4; // 3초마다 단계 변경
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // [추가] 타이머 해제
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage('https://example.com/profile.jpg'), // 프로필 이미지
            radius: 24, // 크기 조정
          ),
          title: Text('홍길동', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text('자동차', style: TextStyle(fontSize: 14, color: Colors.grey)),
          trailing: TextButton(
            onPressed: () {
              print('전화하기 버튼 클릭');
            },
            style: TextButton.styleFrom(
              minimumSize: Size(80, 36), // 버튼 크기 조정
            ),
            child: Text('전화하기', style: TextStyle(color: Colors.blue)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '0', // 숫자는 크게
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '분', // "분"은 작게
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
// 수직 타임라인 추가
        OrderTimeline(currentStep: currentStep),
        // [추가] currentStep 값을 변경하는 버튼 (테스트용)

        dividerLine,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            '배달주소',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Text('주소')
      ],
    );
  }
}

class OrderTimeline extends StatelessWidget {
  final int currentStep; // (0: 주문 수락, 1: 메뉴 준비중, 2: 배달 중, 3: 배달 완료)

  const OrderTimeline({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> steps = [
      {"title": "주문 수락됨", "time": "10:48 AM"},
      {"title": "메뉴 준비중", "time": "10:48 AM"},
      {"title": "배달 중", "time": "11:10 AM"},
      {"title": "배달 완료", "time": ""},
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        bool isCompleted = index < currentStep; // [수정] 완료 단계
        bool isCurrent = index == currentStep;  // [수정] 현재 단계

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                // [수정] 단계별 동그라미 스타일
                CircleAvatar(
                  // 완료 단계: 검은색, 현재 단계: 옅은 파랑색, 나머지: 회색
                  radius: isCurrent ? 8 : 10, // 현재 단계는 작은 동그라미
                  backgroundColor: isCompleted
                      ? Colors.black
                      : isCurrent
                      ? Colors.lightBlue
                      : Colors.grey[300],
                  child: isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                if (index != steps.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    // [수정] 완료 단계는 검은 선, 나머지는 회색 선
                    color: isCompleted ? Colors.black : Colors.grey[300],
                  ),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    steps[index]["title"]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCompleted
                          ? Colors.black
                          : isCurrent
                          ? Colors.lightBlue
                          : Colors.grey,
                    ),
                  ),
                  if (steps[index]["time"]!.isNotEmpty)
                    Text(
                      steps[index]["time"]!,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}