import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 사장님 등록을 위한 다이얼로그를 표시하는 위젯
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
        // signup 컬렉션에 현재 사용자의 role을 '사장님'으로 업데이트
        await FirebaseFirestore.instance
            .collection('signup')
            .doc(user.uid)
            .update({'role': '사장님'});
        // 상태 변경을 부모 위젯에 알림
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
