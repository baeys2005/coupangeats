// owner_basic_info_tab.dart
//가게정보를 불러오는 파일입니다 .
import 'package:flutter/material.dart';
import 'package:coupangeats/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class OwnerBasicInfoTab extends StatefulWidget {
  const OwnerBasicInfoTab({Key? key}) : super(key: key);

  @override
  State<OwnerBasicInfoTab> createState() => _OwnerBasicInfoTabState();
}

class _OwnerBasicInfoTabState extends State<OwnerBasicInfoTab> {
  /// 이 탭 내부에서만 사용하는 컨트롤러들
  final TextEditingController _storeOwnerNameController = TextEditingController();
  final TextEditingController _storeBizNumberController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();

  @override
  void dispose() {
    // 화면(탭) 종료 시 컨트롤러 해제
    _storeOwnerNameController.dispose();
    _storeBizNumberController.dispose();
    _storeNameController.dispose();
    _storeAddressController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _fetchStoreData();
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

  Future<void> _saveStoreInfo() async {
    // 입력값을 가져옴
    final storeOwnerName = _storeOwnerNameController.text.trim();
    final storeBizNumber = _storeBizNumberController.text.trim();
    final storeName = _storeNameController.text.trim();
    final storeAddress = _storeAddressController.text.trim();

    if (storeOwnerName.isEmpty ||
        storeBizNumber.isEmpty ||
        storeName.isEmpty ||
        storeAddress.isEmpty) {
      // 간단한 예시로, 하나라도 비어있으면 안내만 띄우고 종료
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 정보를 입력해주세요.')),
      );
      return;
    }

    try {
      // 예시로 고정 "store123" 사용. 실제론 로그인된 점주나
      // 선택된 매장의 storeId 를 가져오셔야 합니다.
      final storeId = "store123";
      final storeRef = FirebaseFirestore.instance
          .collection("stores")
          .doc(storeId);

      // 문서가 없을 경우 생성, 있을 경우 병합
      await storeRef.set({
        'storeOwnerName': storeOwnerName,
        'storeBizNumber': storeBizNumber,
        'storeName': storeName,
        'storeAddress': storeAddress,
      }, SetOptions(merge: true));

      // 저장 성공 시 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기본정보가 저장되었습니다.')),
      );
    } catch (e) {
      // 예외 발생 시 처리
      debugPrint('Failed to save store info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }
  /// Firestore에서 store123 문서의 데이터를 불러와서,
  /// 필드가 있으면 TextField에 set, 없으면 빈 문자열(-> hintText 표시)로 둡니다.
  Future<void> _fetchStoreData() async {
    try {
      // 실제론 storeId를 로그인 정보 등에서 가져오면 됩니다.
      final storeId = 'store123';
      final storeRef = FirebaseFirestore.instance.collection('stores').doc(storeId);

      final docSnap = await storeRef.get();

      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        // 해당 필드가 없으면 빈 문자열로 fallback
        _storeOwnerNameController.text = data['storeOwnerName'] ?? '';
        _storeBizNumberController.text = data['storeBizNumber'] ?? '';
        _storeNameController.text = data['storeName'] ?? '';
        _storeAddressController.text = data['storeAddress'] ?? '';
      } else {
        // 문서 자체가 없으면 기본적으로 모든 필드 비워두기
        // (TextController는 이미 기본이 빈 문자열이므로 별도 처리 없어도 무방)
      }
      // setState()는 컨트롤러에 값을 직접 넣었으므로 굳이 호출 안 해도 되지만
      // 혹시 다른 상태 변화가 필요하면 여기서 호출하세요.
      setState(() {});
    } catch (e) {
      debugPrint('Failed to fetch store data: $e');
      // 필요시 에러 처리 로직
    }
  }

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
            controller: _storeOwnerNameController,
            decoration: const InputDecoration(
              hintText: "ex)홍길동",
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
            controller: _storeBizNumberController,
            decoration: const InputDecoration(
              hintText: "ex)1010103239",
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
              hintText: "ex)봉구통닭",
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
            controller: _storeAddressController,
            decoration: const InputDecoration(
              hintText: "ex)서울 어쩌고",
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
              onPressed: _saveStoreInfo,
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
