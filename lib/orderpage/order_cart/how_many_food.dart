import 'package:flutter/material.dart';
//editor 윤선: 카트 음식 관리
class HowManyFood extends StatefulWidget {
  const HowManyFood({super.key});

  @override
  State<HowManyFood> createState() => _HowManyFoodState();
}

class _HowManyFoodState extends State<HowManyFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://street-h.com/wp-content/uploads/2023/05/sth110_main.png',
              ),
              fit: BoxFit.cover, // 이미지 크기 조정
            ),
          ),
        ),
      ),
    );
  }
}
