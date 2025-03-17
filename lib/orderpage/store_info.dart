import 'package:coupangeats/orderpage/storePage.dart';
import 'package:coupangeats/orderpage/store_appBar_delivery.dart';
import 'package:coupangeats/orderpage/store_appBar_takeout.dart';
import 'package:flutter/material.dart';

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
    // 초기값으로 상위 위젯에서 전달받은 선택 값 사용
    _selectedContent = widget.selectedContent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: flexibleSpace * 0.5,
      width: double.infinity,
      child: Column(
        children: [
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