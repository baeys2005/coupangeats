import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';

class HomeRecommatzip extends StatefulWidget {
  const HomeRecommatzip({super.key});

  @override
  State<HomeRecommatzip> createState() => _HomeRecommatzipState();
}

class _HomeRecommatzipState extends State<HomeRecommatzip> {
  double boxWidth = 300;
  double boxHeight = 200;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (c, i) {
            return
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: padding1),
                child: matzipBox(index: i, bW: boxWidth, bH: boxHeight),
              );
          }),
    );
  }
}

//맛집정보 표시 부분 위젯화 해야하는데 i 인덱스를 어떻게 전달하지? 이따가 정리 ㄱㄱ
class matzipBox extends StatefulWidget {
  final int index;
  final double bW;
  final double bH;

  const matzipBox(
      {super.key, required this.index, required this.bH, required this.bW});

  @override
  State<matzipBox> createState() => _matzipBoxState();
}

class _matzipBoxState extends State<matzipBox> {
  final List<String> restimagePaths = List.generate(
      10, // 이미지 파일 갯수
      (index) => 'assets/rest${index + 1}.png');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.bW,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              restimagePaths[widget.index],
              width: widget.bW,
              height: widget.bH,
                fit: BoxFit.cover
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('네네치킨 태평복정점',style: title1), Text('wow+즉시할인',style: TextStyle(color: Colors.blue),)],
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Text('5.0(251) · 0.8km · 30분'),
            ],
          )
        ],
      ),
    );
  }
}
