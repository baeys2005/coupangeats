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
    // UserInfoProvider에서 addressName, latitude, longitude를 가져옴
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: Colors.black),
        ),
        title: Text('주소 설정', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(
                    '도로명, 건물명 또는 지번으로 검색',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // 현재 위치로 주소 찾기 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyLocationPage()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gps_fixed, color: Colors.black87),
                    SizedBox(width: 10),
                    Text(
                      '현재 위치로 주소 찾기',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 집 추가
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              size: 24,
            ),
            title: Text('집 추가'),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyLocationPage()),
              );
            },
          ),
          Divider(height: 1),

          // 회사 추가
          ListTile(
            leading: Icon(
              Icons.work_outline,
              size: 24,
            ),
            title: Text('회사 추가'),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyLocationPage()),
              );
            },
          ),
          Divider(height: 1),

          // 저장된 주소 목록을 표시하는 부분
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
                  leading: Icon(Icons.location_on, color: Colors.grey.shade700),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo.addressName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'WOW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '무료배달 가능 지역',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: userInfo.addressType == '집' ?
                  Icon(Icons.check, color: Colors.blue) : null,
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
                Divider(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}