import 'package:flutter/material.dart';

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
    // TODO: implement dispose
    _T1.dispose();
    _T2.dispose();
    _T3.dispose();
    _T4.dispose();
    _T5.dispose();
    super.dispose();
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

