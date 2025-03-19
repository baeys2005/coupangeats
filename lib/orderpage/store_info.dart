import 'package:coupangeats/orderpage/storePage.dart';
import 'package:coupangeats/orderpage/store_appBar_delivery.dart';
import 'package:coupangeats/orderpage/store_appBar_takeout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';


class StoreInfo extends StatefulWidget {
  final int selectedContent;
  final Function(int) onContentChange;

  const StoreInfo({
    super.key,
    required this.selectedContent,
    required this.onContentChange,
  });

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}


class _StoreInfoState extends State<StoreInfo> {
  int _selectedContent = 0; // 0: 배달, 1: 포장
  double flexibleSpace = 600;
  void _changeContent(int index) {
    setState(() {
      _selectedContent = index;
    });
  }


  @override
  void initState() {
    super.initState();
    final storeProv = Provider.of<StoreProvider>(context, listen: false);
    // 2) (선택) 기존 데이터 초기화
    storeProv.resetStoreData();
    // 3) _tempStoreId 로 불러오기
    storeProv.loadStoreData(storeProv.tempStoreId);
  }

  @override
  Widget build(BuildContext context) {

    final storeProv = Provider.of<StoreProvider>(context);
// 좌표가 null이 아닐 경우, GeoPoint를 NLatLng로 변환
    final double storeLat = storeProv.latitude ?? 37.5665;
    final double storeLon = storeProv.longitude ?? 126.9780;
    final NLatLng storeLatLng = NLatLng(storeLat, storeLon);


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('매장정보'),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 네이버 지도를 표시하는 부분
          Container(

            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // 배경색은 흰색으로 설정
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // 아래 선을 먼저 그립니다 (회색 기본선)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 1, // 얇은 선
                    color: Colors.grey.withOpacity(0.3), // 연한 회색 선
                  ),
                ),

                // 선택된 탭 아래에만 파란색 선 표시 - 수정됨: 두께 강화, 색상 명확히
                Positioned(
                  bottom: 0,
                  left: _selectedContent == 0
                      ? 0
                      : MediaQuery.of(context).size.width / 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 3, // 선택된 탭의 선은 더 굵게 수정
                    color: Colors.blue, // 파란색 선
                  ),
                ),

                // 탭 버튼
                Row(
                  children: [
                    _buildTabButton('배달', 0),
                    _buildTabButton('포장', 1),
                  ],
                ),
              ],
            ),

          ),
          _selectedContent == 0
              ? const StoreInfoDelivery()
              : const StoreInfoTakeout(),
        ],
      ),
    );
  }

  // 수정: 버튼 클릭 시 상태 변경 및 콜백 호출
  Widget _buildTabButton(String title, int index) {
    // 선택된 경우와 그렇지 않은 경우 색상 구분
    final bool isSelected = _selectedContent == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          // 버튼 클릭 시 상태 변경
          setState(() {
            _selectedContent = index;
          });
          // 상위 위젯에 변경 알림
          widget.onContentChange(index);
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          // 배경색은 항상 흰색으로 유지
          color: Colors.white,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // 선택된 경우 파란색, 선택되지 않은 경우 검은색
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}