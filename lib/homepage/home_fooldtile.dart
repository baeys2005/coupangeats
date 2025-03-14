import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';
//editor 하연,윤선: 홈화면 음식타일
class HomeFooldtile extends StatefulWidget {
  HomeFooldtile({super.key});

  @override
  State<HomeFooldtile> createState() => _HomeFooldtileState();
}

class _HomeFooldtileState extends State<HomeFooldtile> {
  bool isExpanded = false;

  final List<String> imagePaths = [
    'assets/FT1.jpg', 'assets/FT2.jpg', 'assets/FT3.jpg', 'assets/FT4.jpg', 'assets/FT5.jpg',
    'assets/FT6.jpg', 'assets/FT7.jpg', 'assets/FT8.jpg', 'assets/FT9.jpg',
    'https://media.istockphoto.com/id/1447673516/photo/cream-caramel-pudding-with-caramel-sauce-in-plate.jpg?s=612x612&w=0&k=20&c=yaOaYnZAS9XqiLeugpsxDnjBtlg5gkLByAoB9C-K7ng=',
    'https://i.pinimg.com/736x/47/c0/fe/47c0fea43827454393149150c04f3115.jpg',
    'https://media.istockphoto.com/id/1312283557/photo/classic-thai-food-dishes.jpg?s=612x612&w=0&k=20&c=9Y0NBylnjNiNl6EkK6XabETzj3tHnHOQWwVk-6iUE_I=',
    'https://cdn.pixabay.com/photo/2020/10/05/19/55/hamburger-5630646_640.jpg'
  ];

  final List<String> imageName = [
    '피자', '찜/탕', '커피/차', '도시락', '회/해물',
    '한식', '치킨', '분식', '돈까스', '디저트',
    '야식', '아시안', '버거'
  ];

  @override
  Widget build(BuildContext context) {
    int totalItems = isExpanded ? imageName.length : 10;
    int rows = (totalItems / 5).ceil();

    return SliverToBoxAdapter(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: rows * 100.0,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.9,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: totalItems,
          itemBuilder: (context, index) {
            bool isLastPosition = !isExpanded ? index == 9 : index == totalItems - 1;

            if (isLastPosition) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1
                        )
                      ),
                      padding: EdgeInsets.all(6),
                      child: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isExpanded ? '접기' : '더보기',
                      style: body2,
                      overflow: TextOverflow.ellipsis,

                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: imagePaths[index].startsWith('assets')
                      ? Image.asset(
                    imagePaths[index],
                    fit: BoxFit.contain,
                  )
                      : Image.network(
                    imagePaths[index],
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  imageName[index],
                  style: body2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}