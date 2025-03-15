import 'package:coupangeats/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_info_provider.dart';
import 'myaddress_location_page.dart';

class MyaddressPage extends StatefulWidget {
  const MyaddressPage({super.key});

  @override
  State<MyaddressPage> createState() => _MyaddressPageState();
}

class _MyaddressPageState extends State<MyaddressPage> {
  @override
  Widget build(BuildContext context) {
// ★ UserInfoProvider에서 addressName, latitude, longitude를 가져옴
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('주소관리'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyLocationPage()),
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
          dividerLine,

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
          dividerLine,
          // ★ 저장된 주소 목록을 표시하는 부분
          Expanded(
            child: userInfo.isLoading
                ? Center(child: CircularProgressIndicator())
                : (userInfo.addressName.isEmpty ||
                userInfo.latitude == null ||
                userInfo.longitude == null)
                ? Center(child: Text('저장된 주소가 없습니다.'))
                : ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(userInfo.addressName),
                  subtitle: Text(
                      '위도: ${userInfo.latitude}, 경도: ${userInfo.longitude}'),
                  onTap: () {
                    // 탭하면 스낵바로 좌표 표시
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '위도: ${userInfo.latitude}, 경도: ${userInfo.longitude}'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}