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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.pink,
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => widget.onContentChange(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.selectedContent == 0 ? Colors.blue : Colors.grey.shade300,
                ),
                child: const Text('정보'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => widget.onContentChange(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.selectedContent == 1 ? Colors.blue : Colors.grey.shade300,
                ),
                child: const Text('리뷰'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 🔹 선택된 내용 표시
          Text(
            widget.selectedContent == 0 ? '매장 정보 표시' : '리뷰 내용 표시',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
