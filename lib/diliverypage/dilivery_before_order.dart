import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';

class DiliveryBeforeOrder extends StatefulWidget {
  const DiliveryBeforeOrder({super.key});

  @override
  State<DiliveryBeforeOrder> createState() => _DiliveryBeforeOrderState();
}

class _DiliveryBeforeOrderState extends State<DiliveryBeforeOrder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text('매장에서 주문을 확인하고 있습니다.', style: TextStyle(color: Colors.blue))),
        SizedBox(
          height: 30,
        ),
        Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.black, width: 1), // 테두리 검은색
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 테두리 둥글게 조정
              ),
              minimumSize: Size(70, 30), // 버튼 크기 (너비 100, 높이 30)
              maximumSize: Size(100, 30),
              padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 4), // 내부 여백 조정
            ),
            child: Center(
              child: Text(
                '주문 취소',
                style: TextStyle(color: Colors.black), // 글자색 검은색
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(child: Text('매장이 조리를 시작하면 취소할 수 없습니다.')),
        SizedBox(
          height: 20,
        ),
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
