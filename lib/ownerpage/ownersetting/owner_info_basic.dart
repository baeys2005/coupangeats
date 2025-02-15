// owner_basic_info_tab.dart
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';

class OwnerBasicInfoTab extends StatefulWidget {
  const OwnerBasicInfoTab({Key? key}) : super(key: key);

  @override
  State<OwnerBasicInfoTab> createState() => _OwnerBasicInfoTabState();
}

class _OwnerBasicInfoTabState extends State<OwnerBasicInfoTab> {
  /// 이 탭 내부에서만 사용하는 컨트롤러들
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _bizNumberController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    // 화면(탭) 종료 시 컨트롤러 해제
    _ownerNameController.dispose();
    _bizNumberController.dispose();
    _storeNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Divider를 일정 간격으로 쓰고 싶다면, theme.dart에 정의된 dividerLine 사용
  // 적절히 import하거나, 필요 없다면 삭제하세요.
  Widget get dividerLine => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Divider(
      color: Colors.black12,
      thickness: 1,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 대표자명
          Text("대표자명", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _ownerNameController,
            decoration: const InputDecoration(
              hintText: "홍길동",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 사업자등록번호
          Text("사업자등록번호", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _bizNumberController,
            decoration: const InputDecoration(
              hintText: "1010103239",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // 상호명
          Text("상호명", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _storeNameController,
            decoration: const InputDecoration(
              hintText: "봉구통닭",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          dividerLine,

          // 주소
          Text("주소", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              hintText: "서울 어쩌고",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
          dividerLine,

          // 저장 버튼 (예시)
          Align(alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                // 이 안에서 입력값 처리...
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('기본정보가 저장되었습니다.')),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.white, // 버튼 배경색 흰색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  side: const BorderSide(color: Colors.blue), // 파란색 테두리
                ),
                // 만약 텍스트 색도 파랑으로 하길 원한다면:
                // foregroundColor: Colors.blue,
                // side: BorderSide(color: Colors.blue),
              ),
              child: const Text('저장',
                  style: TextStyle(color: Colors.blue)), // 텍스트 색을 파랑으로 설정
            ),
          ),

        ],
      ),
    );
  }
}
