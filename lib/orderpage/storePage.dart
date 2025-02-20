import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme.dart';

class Storepage extends StatefulWidget {
  const Storepage({super.key});

  @override
  State<Storepage> createState() => _StorepageState();
}

class _StorepageState extends State<Storepage> {

  /// PageController - PageView에 사용
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 270.0,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // 1) 배경 이미지
                Column(
                  children: [
                    // (1) 이미지 슬라이더 PageView
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: Container(color: Colors.blue,)
                    ),
                    SizedBox(height: 50,)
                  ],
                ),

                Positioned(
                  right: 20,
                  top: 120,
                  child: IconButton(
                    onPressed: () {//TODO: 이미지 열람
                    },
                    icon: Material(
                      elevation: 5.0, // 그림자 높이
                      shape: CircleBorder(), // 아이콘 버튼이 원형이라면 CircleBorder 사용
                      shadowColor: Colors.black, // 그림자 색상
                      color: Colors.transparent, // 배경을 투명하게 유지
                      child: Icon(Icons.image, color: Colors.white, size: 30),
                    ),
                  ),),
                // 2) 텍스트만큼만 폭을 차지하며, 아래쪽에 위치
                Positioned(
                  bottom: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 그림자 색상
                          offset: const Offset(-5, 0), // 왼쪽 그림자
                          blurRadius: 7,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // 그림자 색상
                          offset: const Offset(5, 0), // 오른쪽 그림자
                          blurRadius: 7,
                        ),
                      ],),
                    child: Column(
                      children: [
                        Container(

                          color: Colors.white,
                          width: 300,
                          height: 120,
                          child: Center(
                            child: Text(
                              '두찜 성남태평점',
                              style: pagetitle1,
                            ),
                          ),

                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: Text('Grid Item $index'),
              );
            },
            childCount: 20,
          ),
        )
      ],
    );
  }
}
