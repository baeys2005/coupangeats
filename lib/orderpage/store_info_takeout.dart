import 'package:flutter/material.dart';

class StoreInfoTakeout extends StatelessWidget {
  const StoreInfoTakeout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("포장까지 약 15분"),
        Text("매장주소 경기도 성남시 수정구 복정로 18 1층 엉터리분식"),
        Text("배달비"),
      ],
    );
  }
}
