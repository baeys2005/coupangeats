// owner_setting.dart
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

// 분리된 파일 import
import 'ownersetting/owner_info_basic.dart';
import 'ownersetting/owner_info_location.dart';
import 'ownersetting/owner_info_others.dart';

class OwnerSetting extends StatefulWidget {
  const OwnerSetting({Key? key}) : super(key: key);

  @override
  State<OwnerSetting> createState() => _OwnerSettingState();
}

class _OwnerSettingState extends State<OwnerSetting> {
  /// 더이상 여기서 컨트롤러를 관리할 필요 없음.
  /// 각 탭은 자체적으로 컨트롤러/상태를 관리.


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // 6개 탭
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('매장 설정'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '기본정보'),
              Tab(text: '매장정보'),
              Tab(text: '매장위치 설정')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1) 기본정보 탭 → 파일로 분리된 StatefulWidget
            const OwnerBasicInfoTab(),

            // 2) 나머지 탭들
            OwnerInfoOthers(),
            OwnerInfoLocationPage(),
          ],
        ),
      ),
    );
  }
}
