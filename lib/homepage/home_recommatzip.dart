import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:coupangeats/homepage/resturantPage.dart';

class HomeRecommatzip extends StatefulWidget {
  const HomeRecommatzip({super.key});

  @override
  State<HomeRecommatzip> createState() => _HomeRecommatzipState();
}

class _HomeRecommatzipState extends State<HomeRecommatzip> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding1),
            child: matzipBox(
              index: index,
              bW: MediaQuery.of(context).size.width * 0.7,
              bH: 200,
            ),
          );
        },
      ),
    );
  }
}

class matzipBox extends StatefulWidget {
  final int index;
  final double bW;
  final double bH;

  const matzipBox({
    super.key,
    required this.index,
    required this.bH,
    required this.bW,
  });

  @override
  State<matzipBox> createState() => _matzipBoxState();
}

class _matzipBoxState extends State<matzipBox> {
  final List<String> restimagePaths = List.generate(
    10,
        (index) => 'assets/rest${index + 1}.png',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantPage(index: widget.index),
          ),
        );
      },
      child: Container(
        width: widget.bW,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    restimagePaths[widget.index],
                    width: widget.bW,
                    height: widget.bH,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: -13.0,
                  left: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0xff1976D2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'wow 매 주문 무료배달 적용 매장',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '네네치킨 태평복정점',
                    style: title1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'wow+즉시할인',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(width: 4),
                Text(
                  '5.0(251) · 0.8km · 30분',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
