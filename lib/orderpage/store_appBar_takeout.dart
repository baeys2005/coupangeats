import 'package:coupangeats/orderpage/storeproviders/store_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreInfoTakeout extends StatelessWidget {
  const StoreInfoTakeout({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProv = Provider.of<StoreProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.access_time_outlined),
            Text("포장까지 약 13분"),
            TextButton(onPressed: (){}, child: Text("매장,원산지정보 >"))
          ],
        ),
        Text("매장주소 ${storeProv.storeAddress}"),
        Text("배달비"),
      ],
    );
  }
}
