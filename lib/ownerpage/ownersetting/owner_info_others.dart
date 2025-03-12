import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info_provider.dart';
import '../../theme.dart';

class OwnerInfoOthers extends StatefulWidget {
  const OwnerInfoOthers({super.key});

  @override
  State<OwnerInfoOthers> createState() => _OwnerInfoOthersState();
}

class _OwnerInfoOthersState extends State<OwnerInfoOthers> {

  final TextEditingController _T1 = TextEditingController();
  final TextEditingController _T2 = TextEditingController();
  final TextEditingController _T3 = TextEditingController();
  final TextEditingController _T4 = TextEditingController();
  final TextEditingController _T5 = TextEditingController();
  @override
  void dispose() {
    _T1.dispose();
    _T2.dispose();
    _T3.dispose();
    _T4.dispose();
    _T5.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchStoreData(); // 화면 초기 로딩 시 Firestore에서 기존 데이터 불러오기
  }



  /// Firestore에서 기존에 저장된 정보가 있으면 TextField에 표시,
  /// 없으면 빈 칸(기본 hintText 표시)이 되도록 처리
  Future<void> _fetchStoreData() async {
    try {
      // 예시로 고정 "store123" 사용
      // 실제에선 로그인 정보나 전달받은 storeId 로 대체하세요
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      final storeRef =
      FirebaseFirestore.instance.collection('stores').doc(storeId);

      // 문서 조회
      final docSnap = await storeRef.get();
      if (docSnap.exists) {
        final data = docSnap.data() ?? {};
        // 각 필드가 없으면 null -> ?? '' 로 처리하여 빈 문자열
        _T1.text = data['storeTip'] ?? '';
        _T2.text = data['storeTime'] ?? '';
        _T3.text = data['storeIntro'] ?? '';
        _T4.text = data['storeNotice'] ?? '';
        _T5.text = data['storeOrigin'] ?? '';
      } else {
        // 문서 자체가 없으면 컨트롤러 기본값은 빈 문자열
        // -> hintText가 그대로 표시됨
      }
      setState(() {}); // 필요한 경우 화면 갱신
    } catch (e) {
      debugPrint('Failed to fetch store data: $e');
      // 에러 처리(알림 등) 필요 시 작성
    }
  }

  /// Firestore에 (존재하면 업데이트, 없으면 생성) 저장
  Future<void> _saveStoreInfo() async {
    final storeTip = _T1.text.trim();
    final storeTime = _T2.text.trim();
    final storeIntro = _T3.text.trim();
    final storeNotice = _T4.text.trim();
    final storeOrigin = _T5.text.trim();

    try {
      // 예시로 고정 "store123" 사용
      final storeId = Provider.of<UserInfoProvider>(context, listen: false).userMyStore;
      final storeRef =
      FirebaseFirestore.instance.collection('stores').doc(storeId);

      // 필드 병합 옵션 사용 -> 문서가 없으면 생성, 있으면 해당 필드만 덮어씀
      await storeRef.set({
        'storeTip': storeTip,
        'storeTime': storeTime,
        'storeIntro': storeIntro,
        'storeNotice': storeNotice,
        'storeOrigin': storeOrigin,
      }, SetOptions(merge: true));

      // 저장 완료 알림
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기본정보가 저장되었습니다.')),
      );
    } catch (e) {
      debugPrint('Failed to save store info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
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
          Text("매장찾기 팁", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _T1,
            decoration: const InputDecoration(
              hintText: "ex) 버스정류장 앞에 가게가 있습니다",
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
          Text("영업시간", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _T2,
            decoration: const InputDecoration(
              hintText: "ex) 화~일: 16:00~24:00",
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
          Text("매장소개", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _T3,
            minLines: 2,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "ex)안녕하세요! 봉국사옆 명가통닭 가천대 두산위브점 입니다!",
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
          Text("공지사항", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _T4,
            minLines: 5,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "ex) 안녕하세요! 봉국사옆 명가통닭 가천대 두산위브점 입니다!",
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
          // 주소
          Text("원산지 정보", style: title1),
          const SizedBox(height: 15),
          TextField(
            controller: _T5,
            minLines: 3,
            maxLines: 50,
            decoration: const InputDecoration(
              hintText: "ex)치킨 닭고기 국내산 하림",
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

