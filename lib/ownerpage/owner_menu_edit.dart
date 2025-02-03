import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class OwnerMenuEdit extends StatefulWidget {
  const OwnerMenuEdit({
    super.key,
    this.menuName,
    this.menuPrice,
  });

  final menuName;
  final menuPrice;

  @override
  State<OwnerMenuEdit> createState() => _OwnerMenuEditState();
}

class _OwnerMenuEditState extends State<OwnerMenuEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("메뉴수정", style: title1),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("메뉴사진", style: title1),
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
                width: 250,
                height: 160,
                color: Colors.black12,
              ),
            ),
            dividerLine,
            Text(
              "메뉴정보",
              style: title1,
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              padding: EdgeInsets.fromLTRB(10, 0,0, 0),
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text(widget.menuName.toString()),
              decoration: BorderBox,
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                  width: 150,
                  height: 50,
                  decoration: BorderBox,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  width: 100,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(widget.menuPrice.toString()),
                      Text(
                        "원",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  decoration: BorderBox,
                ),
              ],
            ),
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [Icon(Icons.add), Text("가격추가")],
                )),
            dividerLine,
            Row(
              children: [Text("품절", style: title1)],
            ),
            dividerLine,
            Row(
              children: [Text("숨김", style: title1)],
            ),
            dividerLine,
            Text("메뉴카테고리", style: title1),
            SizedBox(height: 15),
            Container(
              height: 50,
              decoration: BorderBox,
            )
          ],
        ),
      ),
    );
  }
}

//구분선
var dividerLine = Divider(
  color: Colors.black12, // 선 색상
  thickness: 1, // 선 두께
  height: 20, // 위아래 여백
);

//테두리 있는 상자
var BorderBox =
    BoxDecoration(border: Border.all(color: Colors.black12, width: 1));
