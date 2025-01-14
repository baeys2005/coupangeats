import 'package:flutter/material.dart';

class HomeFooldtile extends StatelessWidget {
  const HomeFooldtile({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
              (c,i) => Container(color: Colors.grey,),// c, i 넣어주기 , Container반환함 .
          childCount: 8//=itemCount랑 비슷
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      //가로에 몇칸
    );
  }
}
