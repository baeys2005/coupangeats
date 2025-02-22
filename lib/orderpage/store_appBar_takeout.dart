import 'package:flutter/material.dart';

class StoreInfoTakeout extends StatelessWidget {
  const StoreInfoTakeout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.access_time_outlined),
            Text("포장까지 약 13분"),
            TextButton(onPressed: (){}, child: Text("매장,원산지정보 >"))
          ],
        ),
        Text("매장주소 경기도 성남시 수정구 복정로 18 1층 엉터리분식"),
        Text("배달비"),
      ],
    );
  }
}
