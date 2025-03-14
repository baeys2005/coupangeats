import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//editor 윤선: 사장님 등록을 위한 다이얼로그를 표시하는 위젯

class OwnerRegistrationDialog extends StatefulWidget {
  // 사장님 등록 상태가 변경될 때 호출되는 콜백 함수
  final Function(bool) onOwnershipChanged;

  const OwnerRegistrationDialog({
    Key? key,
    required this.onOwnershipChanged,
  }) : super(key: key);

  @override
  State<OwnerRegistrationDialog> createState() =>
      _OwnerRegistrationDialogState();
}

class _OwnerRegistrationDialogState extends State<OwnerRegistrationDialog> {
  // 두 개의 체크박스 상태를 저장하는 리스트
  List<bool> _checkboxValues = [false, false];

  // Firebase에 사장님 상태를 업데이트하는 함수
  Future<void> _updateOwnerStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;

        // 1) signup 컬렉션에서 현재 사용자 정보 가져오기
        final userDocSnap = await FirebaseFirestore.instance
            .collection('signup')
            .doc(uid)
            .get();

        if (!userDocSnap.exists) {
          throw Exception('User doc does not exist in signup collection.');
        }

        // signup/{uid} 문서에서 사용자 이름(name) 읽어옴
        final userData = userDocSnap.data() ?? {};
        final userName = userData['name'] ?? '이름없음';

        // 2) signup 컬렉션에 현재 사용자의 role을 '사장님'으로 업데이트
        await FirebaseFirestore.instance
            .collection('signup')
            .doc(uid)
            .update({'role': '사장님'});

        // 3) stores 컬렉션에 새 문서(랜덤ID) 생성
        final storeRef = FirebaseFirestore.instance
            .collection('stores')
            .doc();  // doc()에 파라미터 없이 호출하면 랜덤 ID 자동 생성

        // 4) storeRef에 매장 정보 저장 (storeOwnerName과 createdAt)
        await storeRef.set({
          'storeOwnerName': userName,
          'createdAt': FieldValue.serverTimestamp(),
          // 필요시 추가 필드를 여기서 저장 가능
        });
        print('[DEBUG] 매장 문서에 정보 저장 완료');

        // 5) signup 문서에 mystore 필드를 업데이트 (새 매장 문서의 ID 저장)
        print('[DEBUG] signup 문서의 mystore 필드 업데이트 시도 (mystore: ${storeRef.id})');
        await FirebaseFirestore.instance
            .collection('signup')
            .doc(uid)
            .update({'mystore': storeRef.id});
        print('[DEBUG] mystore 업데이트 완료');
        // storeOwnerName 필드에 사용자 이름을 저장 + createdAt 등 필요하면 추가
        await storeRef.set({
          'storeOwnerName': userName,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // [추가부분] 사용자 문서에 "mystore" 필드 업데이트:
        // 현재 사용자의 signup 문서에 새로 생성한 store 문서의 ID를 저장
        await FirebaseFirestore.instance
            .collection('signup')
            .doc(uid)
            .update({'mystore': storeRef.id});

        // 상태 변경 알림
        widget.onOwnershipChanged(true);
      }
    } catch (e) {
      print('Error updating owner status: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      // AlertDialog 대신 Dialog를 사용하면 더 유연한 크기 조절 가능
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      // 둥근 모서리 제거
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '📢사장님페이지 생성안내',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            SizedBox(height: 15),
            Text('사장님 페이지를 만들면 매장을 등록하고 주문을 관리할 수 있습니다.'),
            SizedBox(height: 20),
            Text('주의 사항:', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildCheckboxRow(0, '✅사업자 등록 정보가 필요해요.'),
            _buildCheckboxRow(1, '✅등록 후 승인 절차가 있을 수 있어요.'),
            SizedBox(height: 15),
            Text('지금 바로 사장님 페이지를 만들어 보세요🚀'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('취소', style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: _checkboxValues[0] && _checkboxValues[1]
                      ? () async {
                          await _updateOwnerStatus();
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text('확인', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 체크박스와 라벨을 포함한 행을 생성하는 헬퍼 함수
  Widget _buildCheckboxRow(int index, String label) {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.blue,
          value: _checkboxValues[index],
          onChanged: (bool? value) {
            setState(() {
              _checkboxValues[index] = value!;
            });
          },
        ),
        Expanded(child: Text(label)),
      ],
    );
  }
}
