import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'home_recommatzip.dart';

class GollamukmatzipBar extends StatefulWidget {
  const GollamukmatzipBar({super.key});

  @override
  State<GollamukmatzipBar> createState() => _GollamukmatzipBarState();
}

class _GollamukmatzipBarState extends State<GollamukmatzipBar> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //터치 영역 최소화

                    // 텍스트랑 여백 줄이는 거
                    side: BorderSide(color: Colors.grey, width: 1),),
              ),
              Text(
                'wow+즉시할인',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 70,
          height: 35,
          child: OutlinedButton(
              onPressed: () {},
              child: Text(
                '추천순',
                style: TextStyle(color: Color(0xff000000), fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xffcccccc)),
                  padding: EdgeInsets.all(3))),
        ),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          width: 70,
          height: 35,
          child: OutlinedButton(
              onPressed: () {},
              child: Text(
                '필터',
                style: TextStyle(color: Color(0xff000000), fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xffcccccc)),
                  padding: EdgeInsets.all(3))),
        ),
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
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: EdgeInsets.all(padding1 * 2.5),
            child: matzipBox(
              index: index,
              bW: MediaQuery.of(context).size.width - (padding1 * 5),
              bH: MediaQuery.of(context).size.width * 0.6,
            ),
          );
        },
        childCount: 10,
      ),
    );
  }
}
