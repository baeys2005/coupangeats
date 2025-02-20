import 'package:flutter/material.dart';

import '../homepage/home_wowad.dart';

class StoreInfoDelivery extends StatelessWidget {
  const StoreInfoDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("도착까지 약 27분"),
          Text("최소주문 20000원"),
          Text("배달비"),
          AspectRatio(
            aspectRatio: 16 / 5,
            child: adImage(),
          ),

        ],
      ),
    );
  }
}
