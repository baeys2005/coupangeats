// switch_state.dart
import 'package:coupangeats/providers/user_info_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage/home_page.dart';
import 'package:coupangeats/myeatspage/owner_registration_dialog.dart';
import 'ownerpage/storeownerPage.dart';

class SwitchState with ChangeNotifier {
  bool _isChecked = false;

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (_isChecked != value) {
      _isChecked = value;
      notifyListeners();
    }
  }
}

class OwnerSwitch extends StatefulWidget {
  const OwnerSwitch({Key? key}) : super(key: key);

  @override
  State<OwnerSwitch> createState() => _OwnerSwitchState();
}

class _OwnerSwitchState extends State<OwnerSwitch> {
  @override
  Widget build(BuildContext context) {
    // Provider에서 전역 스위치 상태와 사용자 정보를 가져옴
    final switchState = Provider.of<SwitchState>(context);
    final userInfo = Provider.of<UserInfoProvider>(context);

    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
        value: switchState.isChecked,
        activeColor: Colors.blue,
        onChanged: (value) {
          // 스위치를 켤 때
          if (value) {
            debugPrint("역할"+userInfo.userRole);
            // role이 "사장님"이면 Storeownerpage로 이동
            if (userInfo.userRole == "사장님") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Storeownerpage()),
              );
            } else {
              // role이 "사장님"이 아니라면 OwnerRegistrationDialog를 띄우고,
              // 다이얼로그가 닫힌 후 스위치를 false로 변경
              showDialog(
                context: context,
                builder: (context) => OwnerRegistrationDialog(
                  onOwnershipChanged: (bool isOwner) {
                    // 예를 들어, 사장님 등록이 성공했을 때 추가 작업을 할 수 있음
                    debugPrint("Owner status changed: $isOwner");
                  },
                ),
              ).then((_) {
                switchState.isChecked = false;
              });
            }
          } else {
            // 스위치를 끌 때 HomePage로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homepage()),
            );
          }
          // 스위치 상태 업데이트 (이미 위에서 false로 설정하는 경우도 있음)
          switchState.isChecked = value;
        },
      ),
    );
  }
}