// store_appBar.dart 파일에서 수정
// 배달, 포장 버튼 스타일 변경

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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: flexibleSpace * 0.5,
      //가게정보 본문 할당공간,300이 flexible 공간 안에서 할수있는 최대...
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              // 배경색 제거 (회색 제거)
              color: Colors.white,
            ),
            child: Stack(
              children: [
                // 🔹 애니메이션 인디케이터 (배경)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: _selectedContent == 0 ? 0 : MediaQuery.of(context).size.width / 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2, // 화면 너비의 절반
                    height: 40, // 버튼 높이와 동일하게 설정
                    decoration: BoxDecoration(
                      color: Colors.blue, // 선택된 탭 색상
                      // 경계선 제거하고 완전히 채우기
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildTabButton('배달', 0),
                    _buildTabButton('포장', 1),
                  ],
                ),

                // ✅ 선택된 내용에 따라 동적 렌더링
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

  Widget _buildTabButton(String title, int index) {
    // 선택된 경우와 그렇지 않은 경우 색상 구분
    final bool isSelected = _selectedContent == index;

    return Expanded(
      child: InkWell(
        onTap: () => _changeContent(index),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // 선택된 경우 흰색, 선택되지 않은 경우 검은색
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}