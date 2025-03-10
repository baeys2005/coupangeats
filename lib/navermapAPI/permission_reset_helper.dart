import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// 앱 권한 리셋 도우미
class PermissionResetHelper {
  final BuildContext context;

  PermissionResetHelper(this.context);

  /// 앱 데이터 초기화 및 다시 시작 가이드 표시
  void showAppResetGuide() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('위치 권한 문제 해결하기'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('위치 권한 문제를 해결하기 위해 다음 단계를 따라주세요:'),
              SizedBox(height: 16),
              Text('1. 안드로이드 설정 앱을 엽니다'),
              Text('2. 앱 > 쿠팡이츠 > 저장공간으로 이동합니다'),
              Text('3. "데이터 지우기" 버튼을 탭합니다'),
              Text('4. 앱으로 돌아와 다시 실행합니다'),
              SizedBox(height: 12),
              Text('위 방법으로도 해결되지 않으면:'),
              Text('1. 앱을 완전히 제거합니다'),
              Text('2. 기기를 재부팅합니다'),
              Text('3. 앱을 다시 설치합니다'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openAppSettings();
            },
            child: const Text('설정 열기'),
          ),
        ],
      ),
    );
  }

  /// 앱 종료하기
  void exitApp() {
    SystemNavigator.pop();
  }

  /// 플랫폼 체크 후 적절한 설정 페이지 열기
  void _openAppSettings() async {
    try {
      // 앱 설정 열기
      bool result = await openAppSettings();
      if (!result) {
        // 열기 실패한 경우 수동 가이드 표시
        _showManualSettingsGuide();
      }
    } catch (e) {
      _showManualSettingsGuide();
    }
  }

  /// 수동 설정 가이드 표시
  void _showManualSettingsGuide() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('설정 열기 실패'),
        content: const Text('설정 앱을 수동으로 열어주세요:\n\n'
            '1. 홈 화면으로 이동\n'
            '2. 설정 앱 열기\n'
            '3. 앱 > 쿠팡이츠 선택'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}