import 'package:coupangeats/orderpage/store_appBar.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/orderpage/store_info.dart';
import '../homepage/home_wowad.dart';

class StoreInfoDelivery extends StatefulWidget {
  const StoreInfoDelivery({super.key});

  @override
  State<StoreInfoDelivery> createState() => _StoreInfoDeliveryState();
}

class _StoreInfoDeliveryState extends State<StoreInfoDelivery> {
  @override
  Widget build(BuildContext context) {
    return Container(
padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(Icons.access_time_outlined),
              Text("도착까지 약 27분",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              TextButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreInfos(),
                  ),
                );//엥 여기 페이지 불러오는거 오류남.. .
              }, child: Text("매장,원산지정보 >"))
            ],
          ),
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
