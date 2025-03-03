import 'package:coupangeats/mappage/myaddress_location_page.dart';
import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';

class MyaddressPage extends StatefulWidget {
  const MyaddressPage({super.key});

  @override
  State<MyaddressPage> createState() => _MyaddressPageState();
}

class _MyaddressPageState extends State<MyaddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주소관리'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>MyLocationPage()),
              );
            },
            leading: Icon(
              Icons.add_circle_outline,
              size: 24,
              color: Colors.blue,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('새 주소 추가 '),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          dividerLineCategory,
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              size: 24,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('집 추가'),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          dividerLine,
          ListTile(
            leading: Icon(
              Icons.work_outline,
              size: 24,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('회사 추가 '),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
          ),
          dividerLine
        ],
      ),
    );
  }
}
