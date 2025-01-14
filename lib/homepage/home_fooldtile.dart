import 'package:flutter/material.dart';

class HomeFooldtile extends StatelessWidget {
   HomeFooldtile({super.key});

   //이미지 파일 불러오기 리스트
  final List<String> imagePaths = List.generate(
    10, // 이미지 파일 갯수
        (index) => 'assets/FT${index + 1}.jpg',
  );


  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
              (c,i) => Column(
                children: [
                  Image.asset(imagePaths[i]),
                  Text('dd')
                ],
              ),// c, i 넣어주기 , Container반환함 .
          childCount: 10//=itemCount랑 비슷
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
      //가로에 몇칸
    );
  }
}
