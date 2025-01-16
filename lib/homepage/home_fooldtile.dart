import 'package:flutter/material.dart';

import 'package:coupangeats/theme.dart';

class HomeFooldtile extends StatelessWidget {
   HomeFooldtile({super.key});

   //이미지 파일 불러오기 리스트
  final List<String> imagePaths = List.generate(
    10, // 이미지 파일 갯수
        (index) => 'assets/FT${index + 1}.jpg',
  );

  final List<String> imageName = ['피자','찜/탕','커피/차','도시락','회/해물'
  ,'한식','치킨','분식','돈까스','더보기'];//더보기 나중에 수정 필요


  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(5),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
                (c,i) =>
                    Container(
                      child: Column(
                                      children: [
                      Image.asset(imagePaths[i],width: 70,height: 70,),
                      Text(imageName[i],style: body2,)
                                      ],
                                    ),
                    ),// c, i 넣어주기 , Container반환함 .
            childCount: 10//=itemCount랑 비슷
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        //가로에 몇칸
      ),
    );
  }
}
