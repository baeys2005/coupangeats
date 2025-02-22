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

  void _changeContent(int index) {
    setState(() {
      _selectedContent = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.white,
      height: flexibleSpace*0.5,//가게정보 본문 할당공간,300이 flexible 공간 안에서 할수있는 최대...
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width ,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Stack(
              children: [
                // 🔹 애니메이션 인디케이터 (배경)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  left: widget.selectedContent == 0 ? 0 : 125, // 버튼 이동
                  right: widget.selectedContent == 0 ? 125 : 0,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.blue, // 선택된 탭 색상
                      borderRadius: BorderRadius.circular(25),
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
          _selectedContent == 0 ? const StoreInfoDelivery() : const StoreInfoTakeout(),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
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
              color: widget.selectedContent == index ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
