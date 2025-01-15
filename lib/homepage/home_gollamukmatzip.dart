import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'home_recommatzip.dart';

class GollamukmatzipBar extends StatefulWidget {
  const GollamukmatzipBar({super.key});

  @override
  State<GollamukmatzipBar> createState() => _GollamukmatzipBarState();
}

class _GollamukmatzipBarState extends State<GollamukmatzipBar> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(Icons.check_box_outline_blank),
      Text('wow+즉시할인'),
        TextButton(onPressed: () {}, child: Text('추천순')),
        TextButton(onPressed: () {}, child: Text('필터'))
      ],
    );
  }
}

class HomeGollamukmatzip extends StatefulWidget {
  const HomeGollamukmatzip({super.key});

  @override
  State<HomeGollamukmatzip> createState() => _HomeGollamukmatzipState();
}

class _HomeGollamukmatzipState extends State<HomeGollamukmatzip> {

  double boxWidth=700;
  double boxHeight=250;
  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildBuilderDelegate((c, i) {
      return Padding(
        padding: const EdgeInsets.all(padding1*2.5),
        child: matzipBox(index: i,bW:boxWidth,bH:boxHeight),
      );
    },childCount: 10
    )
    );
  }
}
