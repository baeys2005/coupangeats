import 'package:coupangeats/orderpage/store_info_delivery.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.white,
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width ,
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // 전체 배경색
              borderRadius: BorderRadius.circular(25),
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
                    _buildTabButton('정보', 0),
                    _buildTabButton('리뷰', 1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: InkWell(
        onTap: () => StoreInfoDelivery(),
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
